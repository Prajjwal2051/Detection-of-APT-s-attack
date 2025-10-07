#!/bin/bash

# APT Detection ELK Stack - Quick Start Script
# This script automates the deployment and setup process

set -e

KIBANA_URL="http://localhost:5601"
ES_URL="http://localhost:9200"

echo "======================================"
echo " APT Detection System - Quick Start"
echo "======================================"
echo ""

# Function to detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    else
        echo "unknown"
    fi
}

# Function to check system requirements
check_system_requirements() {
    echo "🔍 Checking system requirements..."
    
    # Check available RAM
    total_ram=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$total_ram" -lt 4 ]; then
        echo "⚠️  Warning: Less than 4GB RAM available. System may be slow."
        echo "   Available RAM: ${total_ram}GB (Recommended: 4GB+)"
    else
        echo "✅ RAM: ${total_ram}GB available"
    fi
    
    # Check available disk space
    available_disk=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$available_disk" -lt 10 ]; then
        echo "⚠️  Warning: Less than 10GB disk space available."
        echo "   Available: ${available_disk}GB (Recommended: 10GB+)"
    else
        echo "✅ Disk Space: ${available_disk}GB available"
    fi
    echo ""
}

# Function to install Docker
install_docker() {
    local distro=$(detect_distro)
    echo "🐳 Installing Docker..."
    
    case $distro in
        fedora)
            sudo dnf install -y docker
            ;;
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y docker.io
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm docker
            ;;
        *)
            echo "❌ Unsupported distribution. Please install Docker manually."
            exit 1
            ;;
    esac
    
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    echo "✅ Docker installed successfully"
    echo "⚠️  Note: You may need to log out and back in for group changes to take effect"
}

# Function to install Docker Compose
install_docker_compose() {
    local distro=$(detect_distro)
    echo "🐳 Installing Docker Compose..."
    
    case $distro in
        fedora)
            sudo dnf install -y docker-compose
            ;;
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y docker-compose
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm docker-compose
            ;;
        *)
            echo "❌ Unsupported distribution. Please install Docker Compose manually."
            exit 1
            ;;
    esac
    
    echo "✅ Docker Compose installed successfully"
}

# Function to install curl
install_curl() {
    local distro=$(detect_distro)
    echo "📥 Installing curl..."
    
    case $distro in
        fedora)
            sudo dnf install -y curl
            ;;
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y curl
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm curl
            ;;
        *)
            echo "⚠️  Could not install curl automatically"
            ;;
    esac
    
    echo "✅ curl installed successfully"
}

# Check system requirements
check_system_requirements

# Check and install Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    read -p "Do you want to install Docker now? (y/n): " install_choice
    if [ "$install_choice" = "y" ] || [ "$install_choice" = "Y" ]; then
        install_docker
        echo ""
        echo "⚠️  IMPORTANT: Please log out and log back in, then run this script again."
        exit 0
    else
        echo "Cannot proceed without Docker. Exiting."
        exit 1
    fi
else
    echo "✅ Docker is installed"
fi

# Check and install Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    read -p "Do you want to install Docker Compose now? (y/n): " install_choice
    if [ "$install_choice" = "y" ] || [ "$install_choice" = "Y" ]; then
        install_docker_compose
    else
        echo "Cannot proceed without Docker Compose. Exiting."
        exit 1
    fi
else
    echo "✅ Docker Compose is installed"
fi

# Check and install curl
if ! command -v curl &> /dev/null; then
    echo "⚠️  curl is not installed (needed for health checks)."
    read -p "Do you want to install curl now? (y/n): " install_choice
    if [ "$install_choice" = "y" ] || [ "$install_choice" = "Y" ]; then
        install_curl
    else
        echo "⚠️  Continuing without curl (some health checks may not work)"
    fi
else
    echo "✅ curl is installed"
fi

# Check if Docker service is running
if ! sudo systemctl is-active --quiet docker; then
    echo "🐳 Starting Docker service..."
    sudo systemctl start docker
    echo "✅ Docker service started"
fi

echo ""

# Make scripts executable
echo "📝 Setting permissions..."
chmod +x scripts/*.sh
echo "✅ Permissions set"
echo ""

# Check if services are already running
if docker-compose ps | grep -q "Up"; then
    echo "⚠️  Services are already running"
    read -p "Do you want to restart? (y/n): " restart
    if [ "$restart" = "y" ]; then
        echo "Stopping services..."
        docker-compose down
    else
        echo "Keeping existing services"
        exit 0
    fi
fi

# Start ELK Stack
echo "🚀 Starting ELK Stack..."
echo "This may take 2-3 minutes..."
docker-compose up -d

# Wait for Elasticsearch
echo ""
echo "⏳ Waiting for Elasticsearch..."
max_attempts=30
attempt=0
while ! curl -s "$ES_URL" > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "❌ Elasticsearch failed to start"
        echo "Check logs with: docker-compose logs elasticsearch"
        exit 1
    fi
    echo -n "."
    sleep 2
done
echo ""
echo "✅ Elasticsearch is ready"

# Wait for Kibana
echo ""
echo "⏳ Waiting for Kibana..."
max_attempts=60
attempt=0
while ! curl -s "$KIBANA_URL/api/status" | grep -q '"level":"available"'; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "⚠️  Kibana is taking longer than expected"
        echo "You can check status with: docker-compose logs kibana"
        break
    fi
    echo -n "."
    sleep 3
done
echo ""
echo "✅ Kibana is ready"

# Generate sample data
echo ""
echo "📊 Generating sample APT data..."
cd scripts
./generate-sample-apt-data.sh
cd ..
echo "✅ Sample data generated"

# Create Kibana dashboards
echo ""
echo "📈 Creating Kibana dashboards..."
sleep 5  # Give Kibana a moment
cd scripts
./create-kibana-dashboards.sh > /dev/null 2>&1 || echo "⚠️  Dashboard creation may need manual setup"
cd ..
echo "✅ Dashboards created"

# Show status
echo ""
echo "======================================"
echo "✅ APT Detection System is Ready!"
echo "======================================"
echo ""
echo "Services Status:"
docker-compose ps
echo ""
echo "Access Points:"
echo "  • Elasticsearch: http://localhost:9200"
echo "  • Kibana:        http://localhost:5601"
echo "  • Logstash:      http://localhost:9600"
echo ""
echo "Quick Commands:"
echo "  • View logs:     docker-compose logs -f"
echo "  • Stop system:   docker-compose down"
echo "  • Restart:       docker-compose restart"
echo ""
echo "Next Steps:"
echo "  1. Open Kibana: http://localhost:5601"
echo "  2. Go to Management → Index Patterns"
echo "  3. Create pattern: apt-detection-*"
echo "  4. Go to Discover to view detected threats"
echo ""
echo "For detailed documentation, see README.md"
echo ""
