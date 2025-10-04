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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
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
