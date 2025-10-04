# APT Detection System Using ELK Stack

## Overview

This project implements a complete Advanced Persistent Threat (APT) detection system using the ELK Stack (Elasticsearch, Logstash, Kibana) with Beats for log collection. The system detects various stages of APT attacks including:

- **Credential Dumping** (MITRE T1003)
- **Internal Reconnaissance** (MITRE T1087, T1018, T1082)
- **Lateral Movement** (MITRE T1021)
- **PowerShell Execution** (MITRE T1059.001)
- **Data Exfiltration** (MITRE T1041, T1048)

## Project Structure

```
apt-detection-elk/
├── docker-compose.yml                 # ELK Stack orchestration
├── logstash/
│   └── pipeline/
│       └── beats-input.conf          # Main Logstash pipeline with detection logic
├── beats/
│   ├── filebeat/
│   │   └── filebeat.yml              # File log collection config
│   ├── winlogbeat/
│   │   └── winlogbeat.yml            # Windows Event Log collection
│   └── packetbeat/
│       └── packetbeat.yml            # Network traffic monitoring
├── detection-rules/
│   ├── 01-credential-dumping.json    # Credential access detection
│   ├── 02-reconnaissance.json        # Discovery activities detection
│   ├── 03-lateral-movement.json      # Lateral movement detection
│   └── 04-powershell-exfiltration.json # Execution & exfiltration detection
├── kibana-dashboards/                # Dashboard configurations
├── sample-data/                      # APT sample datasets
├── scripts/
│   ├── create-kibana-dashboards.sh   # Dashboard setup script
│   └── generate-sample-apt-data.sh   # Sample data generator
└── README.md                         # This file
```

## System Architecture & Program Flow

### End-to-End Workflow

```
┌─────────────────┐
│  Log Sources    │
│ (Windows/Linux) │
│  • Sysmon       │
│  • Security     │
│  • PowerShell   │
│  • Network      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Beats Agents   │
│ • Filebeat      │
│ • Winlogbeat    │
│ • Packetbeat    │
└────────┬────────┘
         │ Port 5044
         ▼
┌─────────────────┐
│   Logstash      │
│ • Parse logs    │
│ • Apply filters │
│ • Enrich data   │
│ • Detect threats│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Elasticsearch   │
│ • Index data    │
│ • Store events  │
│ • Run queries   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Kibana       │
│ • Visualize     │
│ • Dashboard     │
│ • Alerts        │
└─────────────────┘
```

### Detection Process

1. **Log Collection**: Beats agents collect logs from endpoints, servers, and network
2. **Data Ingestion**: Logs are forwarded to Logstash via port 5044
3. **Parsing & Enrichment**: Logstash parses logs and adds threat indicators
4. **Threat Detection**: Pattern matching against APT signatures
5. **Indexing**: Events are indexed in Elasticsearch
6. **Alerting**: Threats are tagged and routed to `apt-threats-*` index
7. **Visualization**: Kibana dashboards display detected activities

## Prerequisites

- **Docker** and **Docker Compose** installed
- **4GB+ RAM** available for containers
- **10GB+ disk space**
- **Linux** (Arch/Ubuntu/Debian) or **macOS** host

## Quick Start

### Automated Setup (Recommended)

The easiest way to get started is using the automated startup script:

```bash
# Run the automated setup script
./start.sh
```

This script will:
1. ✅ Check Docker and Docker Compose installation
2. ✅ Start all ELK Stack services
3. ✅ Wait for Elasticsearch and Kibana to be ready
4. ✅ Generate sample APT attack data
5. ✅ Create Kibana dashboards and visualizations
6. ✅ Display system status and access points

**That's it!** The system will be fully operational in 2-3 minutes.

### Manual Setup (Alternative)

If you prefer manual setup:

```bash
# 1. Make scripts executable
chmod +x scripts/*.sh

# 2. Start ELK Stack
docker-compose up -d

# 3. Wait for services (2-3 minutes)
docker-compose ps

# 4. Generate sample data
cd scripts
./generate-sample-apt-data.sh

# 5. Create dashboards
./create-kibana-dashboards.sh
```

### 2. Verify Services

```bash
# Check Elasticsearch
curl http://localhost:9200

# Check Kibana (wait until ready)
curl http://localhost:5601/api/status
```

Expected output: Elasticsearch cluster should return version info, Kibana should show "green" state.

### 3. Generate Sample APT Data

```bash
cd scripts
./generate-sample-apt-data.sh
```

This creates sample logs simulating:
- Mimikatz credential dumping
- Reconnaissance commands
- RDP lateral movement
- Encoded PowerShell execution
- Large data transfers

### 4. Access Kibana

Open your browser and navigate to:
```
http://localhost:5601
```

### 5. Create Index Patterns

1. Go to **Management** → **Stack Management** → **Index Patterns**
2. Create pattern: `apt-detection-*` with time field `@timestamp`
3. Create pattern: `apt-threats-*` with time field `@timestamp`

Or run the automated script:
```bash
cd scripts
./create-kibana-dashboards.sh
```

---

## 🚀 HOW TO USE THIS PROJECT

### Step 1: Access Kibana Dashboard

Once the system is running, open your web browser and navigate to:

```
http://localhost:5601
```

**No authentication required** (development mode)

### Step 2: Navigate to Discover

1. Click the **☰ Menu** button (top left corner)
2. Go to **Analytics** → **Discover**
3. You'll see the data exploration interface

### Step 3: Select Index Pattern

1. Click the dropdown at the top left (below the search bar)
2. Select: **`apt-detection-*`**
   - This shows all collected events (~3,790 documents)
3. Or select: **`apt-threats-*`**
   - This shows only detected threats

### Step 4: Explore the Data

#### View All Events
By default, you'll see all events with their timestamps. Each event contains:
- `@timestamp` - When the event occurred
- `host.name` - Source machine
- `message` - Event details
- `threat_detected` - Type of threat (if detected)
- `mitre_technique` - MITRE ATT&CK technique ID
- `severity` - Threat severity level

#### Search for Specific Threats

Use the search bar at the top to filter events. Examples:

**Find Credential Dumping:**
```
threat_detected: "credential_dumping"
```

**Find Reconnaissance Activity:**
```
threat_detected: "reconnaissance"
```

**Find Critical Threats:**
```
severity: "critical"
```

**Find Multiple Threat Types:**
```
threat_detected: ("credential_dumping" OR "lateral_movement")
```

**Find Threats on Specific Host:**
```
host.name: "VICTIM-PC" AND _exists_: threat_detected
```

### Step 5: View Threat Details

1. Click on any event to expand it
2. You'll see all fields including:
   - **threat_detected** - Attack type
   - **mitre_technique** - MITRE ATT&CK ID (e.g., T1003.001)
   - **mitre_tactic** - Attack tactic (e.g., Credential Access)
   - **severity** - critical/high/medium
   - **winlog.event_data** - Windows event details
   - **network** - Network traffic data

### Step 6: Use Time Filters

1. Click the **time picker** at the top right
2. Select a time range:
   - Last 15 minutes
   - Last 1 hour
   - Last 24 hours
   - Custom range
3. Data will refresh automatically

### Step 7: Create Visualizations

1. Go to **☰ Menu** → **Analytics** → **Dashboard**
2. Click **Create dashboard**
3. Click **Create visualization**
4. Choose visualization type:
   - Bar chart - Compare threat counts
   - Pie chart - Show threat distribution
   - Line chart - Show threats over time
   - Data table - List detailed events

### Step 8: Set Up Alerts (Optional)

1. Go to **☰ Menu** → **Stack Management** → **Rules**
2. Click **Create rule**
3. Choose **Elasticsearch query**
4. Set up alert conditions:
   - Index: `apt-threats-*`
   - Query: `severity: "critical"`
   - Threshold: Count > 0
5. Configure notifications (email, Slack, etc.)

---

## 📊 UNDERSTANDING DETECTED THREATS

### Threat Severity Levels

| Severity | Description | Examples |
|----------|-------------|----------|
| **Critical** | Immediate action required | Credential dumping, Data exfiltration |
| **High** | Potential breach in progress | Lateral movement, PowerShell execution |
| **Medium** | Suspicious activity | Reconnaissance, Port scanning |

### Detected Threat Types

#### 1. **Credential Dumping** (CRITICAL)
- **MITRE:** T1003.001
- **What:** Mimikatz, LSASS access, password dumpers
- **Indicators:**
  - Source: mimikatz.exe, procdump.exe
  - Target: lsass.exe
  - Event ID: 10 (process access)

**Search Query:**
```
threat_detected: "credential_dumping"
```

#### 2. **Reconnaissance** (MEDIUM)
- **MITRE:** T1087, T1082
- **What:** System/network enumeration
- **Indicators:**
  - Commands: whoami, net user, ipconfig, netstat
  - Active Directory queries

**Search Query:**
```
threat_detected: "reconnaissance"
```

#### 3. **Lateral Movement** (HIGH)
- **MITRE:** T1021.001, T1021.002
- **What:** Moving between systems
- **Indicators:**
  - RDP connections (LogonType 10)
  - SMB access (LogonType 3)
  - PSExec usage

**Search Query:**
```
threat_detected: "lateral_movement"
```

#### 4. **PowerShell Execution** (HIGH)
- **MITRE:** T1059.001
- **What:** Malicious PowerShell usage
- **Indicators:**
  - Base64 encoded commands
  - Download cradles (Invoke-WebRequest)
  - Invoke-Expression (IEX)

**Search Query:**
```
threat_detected: ("encoded_powershell" OR "powershell_download")
```

#### 5. **Data Exfiltration** (CRITICAL)
- **MITRE:** T1041
- **What:** Large data transfers out
- **Indicators:**
  - Transfer size > 10MB
  - Unusual destination IPs
  - High volume traffic

**Search Query:**
```
threat_detected: "data_exfiltration"
```

---

## 🔍 SEARCH EXAMPLES

### Command Line Searches (Elasticsearch API)

**Find all credential dumping attacks:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {"threat_detected": "credential_dumping"}
  },
  "size": 5
}'
```

**Find all critical threats:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "term": {"severity": "critical"}
  },
  "size": 10
}'
```

**Count threats by type:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "size": 0,
  "aggs": {
    "threat_types": {
      "terms": {"field": "threat_detected.keyword", "size": 10}
    }
  }
}'
```

**For more examples, see:** `SEARCH_EXAMPLES.md`

---

## Detection Rules Explained

### 1. Credential Dumping (T1003)

**What it detects:**
- LSASS process access (Event ID 10)
- Mimikatz execution
- SAM registry access
- NTDS.dit file access

**Example Query:**
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "winlog.event_id": 10 } },
        { "regexp": { "winlog.event_data.TargetImage": ".*lsass\\.exe" } }
      ]
    }
  }
}
```

**Why it works:** Mimikatz and similar tools must access LSASS memory to dump credentials. Sysmon Event ID 10 logs process access events.

### 2. Reconnaissance (T1087, T1082)

**What it detects:**
- `whoami`, `net user`, `net group` commands
- `ipconfig`, `netstat`, `systeminfo`
- Active Directory queries
- Network scanning

**Example Query:**
```json
GET /apt-detection-*/_search
{
  "query": {
    "regexp": {
      "message": ".*\\b(whoami|net user|net group|nltest)\\b.*"
    }
  }
}
```

**Why it works:** Attackers enumerate the environment to identify targets and privilege escalation paths.

### 3. Lateral Movement (T1021)

**What it detects:**
- RDP connections (LogonType 10)
- SMB lateral movement (LogonType 3)
- PSExec usage
- WMI remote execution
- Admin share access

**Example Query:**
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "winlog.event_id": 4624 } },
        { "term": { "winlog.event_data.LogonType": "10" } }
      ]
    }
  }
}
```

**Why it works:** Network logon types indicate remote access attempts, essential for lateral movement.

### 4. PowerShell Execution (T1059.001)

**What it detects:**
- Base64 encoded commands
- Download cradles (`Invoke-WebRequest`, `DownloadString`)
- `Invoke-Expression` (IEX)
- Reflection and assembly loading
- PowerShell remoting

**Example Query:**
```json
GET /apt-detection-*/_search
{
  "query": {
    "regexp": {
      "winlog.event_data.CommandLine": ".*-[Ee]nc.*[A-Za-z0-9+/]{50,}.*"
    }
  }
}
```

**Why it works:** Encoded PowerShell is commonly used to evade signature-based detection.

### 5. Data Exfiltration (T1041, T1048)

**What it detects:**
- Large outbound transfers (>10MB)
- Unusual ports (FTP, custom ports)
- DNS tunneling
- High volume DNS queries

**Example Query:**
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "range": { "network.bytes": { "gte": 10485760 } } },
        { "term": { "network.direction": "outbound" } }
      ]
    }
  }
}
```

**Why it works:** Large data transfers to external IPs indicate potential exfiltration.

## Example Walkthrough: Mimikatz Detection

### Scenario: Detecting Credential Dumping

1. **Attack Simulation**
   
   Sample log (already generated):
   ```json
   {
     "@timestamp": "2024-01-15T10:23:45Z",
     "host": {"name": "VICTIM-PC"},
     "winlog": {
       "event_id": 10,
       "event_data": {
         "SourceImage": "C:\\Tools\\mimikatz.exe",
         "TargetImage": "C:\\Windows\\System32\\lsass.exe",
         "GrantedAccess": "0x1FFFFF"
       }
     }
   }
   ```

2. **Logstash Detection**
   
   The Logstash pipeline detects this pattern:
   ```ruby
   if [winlog][event_data][TargetImage] =~ /(?i)lsass\.exe/ {
     mutate {
       add_field => { 
         "threat_detected" => "credential_dumping"
         "mitre_technique" => "T1003.001"
         "severity" => "critical"
       }
       add_tag => ["apt_detected", "credential_access"]
     }
   }
   ```

3. **Elasticsearch Indexing**
   
   Event is indexed to `apt-threats-*` with enriched fields.

4. **Kibana Alert**
   
   Query in Kibana Discover:
   ```
   threat_detected: "credential_dumping" AND severity: "critical"
   ```

5. **Investigation**
   
   Security analyst sees:
   - Process: `mimikatz.exe`
   - Target: `lsass.exe`
   - MITRE Technique: T1003.001
   - Recommended Action: Isolate host, reset credentials

## Viewing Detection Rules

All detection rules are in the `detection-rules/` directory. Each file contains:
- Rule description
- MITRE ATT&CK mapping
- Elasticsearch DSL queries
- Example usage

To test a rule:
```bash
# Example: Test credential dumping detection
curl -X GET "localhost:9200/apt-detection-*/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d @detection-rules/01-credential-dumping.json
```

## Kibana Dashboards

### Available Visualizations

1. **APT Threat Detection Timeline**
   - Shows threats over time by category

2. **MITRE ATT&CK Tactics**
   - Pie chart of attack tactics distribution

3. **Suspicious Processes**
   - Table of processes with threat indicators

4. **Failed Login Attempts**
   - Timeline of failed authentications

5. **Network Traffic Anomalies**
   - Outbound traffic volume over time

### Creating Custom Dashboards

1. Go to **Kibana** → **Dashboard** → **Create Dashboard**
2. Add visualizations based on your needs
3. Save and share with your team

## 🛠️ MANAGEMENT COMMANDS

### Start/Stop System

```bash
# Start all services
./start.sh
# OR
docker-compose up -d

# Stop all services
docker-compose down

# Stop and remove all data
docker-compose down -v

# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart logstash
```

### View Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f elasticsearch
docker-compose logs -f kibana
docker-compose logs -f logstash
docker-compose logs -f filebeat

# View last 100 lines
docker-compose logs --tail=100 logstash
```

### Check System Status

```bash
# View service status
docker-compose ps

# Check Elasticsearch health
curl http://localhost:9200/_cluster/health?pretty

# View Elasticsearch indices
curl 'http://localhost:9200/_cat/indices?v'

# Count indexed documents
curl 'http://localhost:9200/apt-detection-*/_count?pretty'

# Check Kibana status
curl http://localhost:5601/api/status
```

### Data Management

```bash
# Regenerate sample data
cd scripts
./generate-sample-apt-data.sh

# View sample data files
ls -la sample-data/

# Delete specific index
curl -X DELETE 'http://localhost:9200/apt-detection-2025.10.04'

# Delete all detection indices
curl -X DELETE 'http://localhost:9200/apt-detection-*'
```

### Performance Monitoring

```bash
# View container resource usage
docker stats

# View Elasticsearch stats
curl 'http://localhost:9200/_nodes/stats?pretty'

# View Logstash stats
curl 'http://localhost:9600/_node/stats?pretty'
```

---

## ⚠️ TROUBLESHOOTING

### Issue: Elasticsearch won't start

**Solution:**
```bash
# Check logs
docker-compose logs elasticsearch

# Increase virtual memory (Linux)
sudo sysctl -w vm.max_map_count=262144

# Make permanent
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

# Restart Elasticsearch
docker-compose restart elasticsearch
```

### Issue: No data in Kibana

**Check 1 - Services Running:**
```bash
docker-compose ps
# All services should show "Up"
```

**Check 2 - Indices Created:**
```bash
curl 'http://localhost:9200/_cat/indices?v'
# Should see apt-detection-* indices
```

**Check 3 - Logstash Processing:**
```bash
docker-compose logs logstash | grep "Pipeline started"
```

**Check 4 - Sample Data Exists:**
```bash
ls -la sample-data/
# Should see .log and .json files
```

**Solution:**
```bash
# Restart all services
docker-compose restart

# Wait 30 seconds, then check
curl 'http://localhost:9200/apt-detection-*/_count?pretty'
```

### Issue: Kibana shows "Kibana server is not ready yet"

**Solution:**
```bash
# Check Kibana logs
docker-compose logs kibana

# Wait for message: "Kibana is now available"
# This can take 2-3 minutes on first startup

# If stuck, restart Kibana
docker-compose restart kibana
```

### Issue: Filebeat not ingesting logs

**Solution:**
```bash
# Check Filebeat logs
docker-compose logs filebeat

# Verify configuration
docker exec -it filebeat filebeat test config

# Restart Filebeat
docker-compose restart filebeat
```

### Issue: High CPU/Memory usage

**Solution:**
```bash
# Reduce Java heap size in docker-compose.yml
# Edit these lines:
ES_JAVA_OPTS: "-Xms1g -Xmx1g"    # Reduce from 2g if needed
LS_JAVA_OPTS: "-Xms512m -Xmx512m" # Reduce from 1g if needed

# Restart services
docker-compose down
docker-compose up -d
```

### Issue: Port already in use

**Solution:**
```bash
# Check what's using the port
sudo lsof -i :5601  # Kibana
sudo lsof -i :9200  # Elasticsearch
sudo lsof -i :5044  # Logstash

# Stop conflicting service or change port in docker-compose.yml
```

### Issue: Docker disk space full

**Solution:**
```bash
# Clean up unused Docker resources
docker system prune -a

# Remove old volumes
docker volume prune

# Check disk usage
docker system df
```

## Using Real APT Datasets

To use public APT datasets:

1. **Download APT samples** from:
   - MITRE Cyber Analytics Repository
   - SecRepo.com
   - Mordor Project (https://github.com/OTRF/Security-Datasets)

2. **Convert to compatible format**:
   ```bash
   # Example for EVTX files
   python3 evtx_to_json.py input.evtx > output.json
   ```

3. **Copy to sample-data directory**:
   ```bash
   cp output.json sample-data/
   ```

4. **Restart Filebeat/Logstash**:
   ```bash
   docker-compose restart filebeat logstash
   ```

## Performance Tuning

### For Production Use

1. **Increase resources** in `docker-compose.yml`:
   ```yaml
   ES_JAVA_OPTS: "-Xms4g -Xmx4g"
   ```

2. **Enable index lifecycle management**:
   ```bash
   # Delete old indices after 30 days
   curl -X PUT "localhost:9200/_ilm/policy/apt-policy" -H 'Content-Type: application/json' -d'
   {
     "policy": {
       "phases": {
         "delete": {
           "min_age": "30d",
           "actions": {"delete": {}}
         }
       }
     }
   }'
   ```

3. **Use hot-warm-cold architecture** for large deployments

4. **Enable authentication** (X-Pack Security)

## Security Considerations

⚠️ **This is a lab/demo environment. For production:**

1. Enable Elasticsearch security (X-Pack)
2. Use HTTPS for all connections
3. Implement role-based access control
4. Encrypt data at rest
5. Set up proper firewall rules
6. Use secrets management for credentials

## MITRE ATT&CK Coverage

| Tactic | Technique | Coverage |
|--------|-----------|----------|
| Credential Access | T1003.001 (LSASS Memory) | ✅ Full |
| Credential Access | T1003.002 (SAM) | ✅ Full |
| Credential Access | T1110 (Brute Force) | ✅ Full |
| Discovery | T1087 (Account Discovery) | ✅ Full |
| Discovery | T1082 (System Information) | ✅ Full |
| Lateral Movement | T1021.001 (RDP) | ✅ Full |
| Lateral Movement | T1021.002 (SMB) | ✅ Full |
| Execution | T1059.001 (PowerShell) | ✅ Full |
| Exfiltration | T1041 (C2 Channel) | ✅ Full |
| Exfiltration | T1048 (Alternate Protocol) | ✅ Full |
| Command and Control | T1071.004 (DNS) | ✅ Full |

## References

- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Elastic Security](https://www.elastic.co/security)
- [Sysmon Documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Mordor Security Datasets](https://github.com/OTRF/Security-Datasets)

## Contributing

To add new detection rules:

1. Create a new JSON file in `detection-rules/`
2. Follow the existing format with MITRE mappings
3. Add corresponding Logstash filters in `logstash/pipeline/`
4. Test with sample data
5. Document in this README

## 📚 ADDITIONAL RESOURCES

### Documentation Files

| File | Description |
|------|-------------|
| `README.md` | Main documentation (this file) |
| `PROJECT_STATUS.md` | Current system status and access info |
| `SEARCH_EXAMPLES.md` | Comprehensive search query examples |
| `DETECTION_QUERIES.md` | Detection rule explanations |

### Sample Data Files

Located in `sample-data/` directory:
- `apt-events.json` - JSON formatted APT events
- `credential-dumping.log` - Mimikatz, LSASS access
- `reconnaissance.log` - System enumeration commands
- `lateral-movement.log` - RDP, SMB, PSExec activity
- `powershell-execution.log` - Encoded PowerShell commands
- `data-exfiltration.log` - Large data transfers

### Quick Links

- **Kibana UI:** http://localhost:5601
- **Elasticsearch API:** http://localhost:9200
- **Logstash Monitoring:** http://localhost:9600
- **MITRE ATT&CK Framework:** https://attack.mitre.org/
- **Elastic Security Docs:** https://www.elastic.co/guide/en/security/current/index.html

---

## 🔐 SECURITY CONSIDERATIONS

### Current Configuration (Development)

⚠️ **This is configured for development/testing only!**

**Current state:**
- ❌ No authentication required
- ❌ HTTP only (no HTTPS)
- ❌ Default encryption keys
- ❌ No network isolation
- ❌ Debug logging enabled

### For Production Deployment

**You MUST implement:**

1. **Enable X-Pack Security**
   ```yaml
   # In docker-compose.yml
   xpack.security.enabled: true
   ```

2. **Configure HTTPS**
   - Generate SSL certificates
   - Configure Elasticsearch, Kibana, and Logstash with TLS
   - Enable certificate validation

3. **Set Strong Encryption Keys**
   ```bash
   # Generate random keys
   openssl rand -base64 32
   
   # Add to docker-compose.yml
   xpack.security.encryptionKey: "your-random-32-byte-key"
   xpack.encryptedSavedObjects.encryptionKey: "your-random-32-byte-key"
   xpack.reporting.encryptionKey: "your-random-32-byte-key"
   ```

4. **Enable Authentication**
   - Create users with appropriate roles
   - Implement role-based access control (RBAC)
   - Use strong passwords

5. **Network Security**
   - Use firewalls to restrict access
   - Implement VPN for remote access
   - Isolate ELK stack in private network
   - Use reverse proxy for external access

6. **Data Protection**
   - Enable encryption at rest
   - Implement backup strategy
   - Set up index lifecycle management (ILM)
   - Configure data retention policies

7. **Monitoring & Auditing**
   - Enable audit logging
   - Monitor for unauthorized access
   - Set up alerting for security events
   - Regular security assessments

---

## 🛡️ CUSTOMIZATION

### Adding Custom Detection Rules

1. **Edit Logstash Configuration**
   - File: `logstash/pipeline/beats-input.conf`
   - Add detection logic in the `filter` section

   Example:
   ```ruby
   if [message] =~ /(?i)malicious_pattern/ {
     mutate {
       add_field => {
         "threat_detected" => "custom_threat"
         "mitre_technique" => "T1234"
         "severity" => "high"
       }
       add_tag => ["apt_detected", "custom"]
     }
   }
   ```

2. **Restart Logstash**
   ```bash
   docker-compose restart logstash
   ```

### Modifying Threat Severity

Edit severity levels in `logstash/pipeline/beats-input.conf`:

```ruby
# Change from "medium" to "high"
mutate {
  add_field => { "severity" => "high" }
}
```

### Adding Real Data Sources

1. **Windows Machines:**
   - Install Winlogbeat on Windows hosts
   - Configure to send to Logstash (port 5044)
   - Enable Sysmon for detailed process monitoring

2. **Linux Servers:**
   - Configure Filebeat on Linux hosts
   - Monitor /var/log files
   - Send to Logstash

3. **Network Devices:**
   - Configure syslog forwarding
   - Point to Logstash port 5000

### Adjusting Resource Limits

Edit `docker-compose.yml`:

```yaml
# Increase Elasticsearch memory
ES_JAVA_OPTS: "-Xms4g -Xmx4g"  # From 2g

# Increase Logstash memory
LS_JAVA_OPTS: "-Xms2g -Xmx2g"  # From 1g
```

---

## 📊 PERFORMANCE TUNING

### For Large-Scale Deployments

1. **Index Lifecycle Management (ILM)**
   - Automatically delete old indices
   - Move data to cold storage
   - Optimize shard allocation

2. **Cluster Scaling**
   - Add more Elasticsearch nodes
   - Distribute data across nodes
   - Use dedicated master nodes

3. **Logstash Optimization**
   - Increase pipeline workers
   - Batch size tuning
   - Use persistent queues

4. **Data Retention**
   ```bash
   # Delete indices older than 30 days
   curl -X DELETE 'http://localhost:9200/apt-detection-$(date -d "30 days ago" +%Y.%m.%d)'
   ```

---

## 🎯 PROJECT GOALS

This APT Detection System is designed to:

1. ✅ **Detect** common APT attack techniques
2. ✅ **Map** detections to MITRE ATT&CK framework
3. ✅ **Provide** real-time visibility into threats
4. ✅ **Enable** security analysts to investigate incidents
5. ✅ **Demonstrate** ELK Stack capabilities for threat detection

### MITRE ATT&CK Coverage Summary

| Tactic | Techniques Covered | Detection Rate |
|--------|-------------------|----------------|
| Credential Access | 3 | High |
| Discovery | 5 | High |
| Lateral Movement | 4 | High |
| Execution | 3 | High |
| Exfiltration | 2 | Medium |
| Command & Control | 1 | Medium |

**Total:** 18 techniques across 6 tactics

---

## 👥 CONTRIBUTING

Contributions are welcome! To add new features:

1. Fork the repository
2. Create a feature branch
3. Add detection rules or improvements
4. Test thoroughly
5. Submit a pull request

### Areas for Contribution

- 🔍 Additional detection rules
- 📈 More Kibana visualizations
- 📦 Integration with SIEM platforms
- 📚 Documentation improvements
- 🐛 Bug fixes

---

## 📝 CHANGELOG

### Version 1.0.0 (Current)
- ✅ Full ELK Stack integration
- ✅ 5 major threat detection categories
- ✅ Automated setup script
- ✅ Kibana dashboards
- ✅ Sample APT data
- ✅ Comprehensive documentation

---

## 💬 FAQ

**Q: Can this detect real APT attacks?**
A: Yes, but it requires real log data from your environment. The sample data is for demonstration.

**Q: How do I add my Windows machines?**
A: Install Winlogbeat and configure it to send logs to Logstash port 5044.

**Q: What's the minimum system requirements?**
A: 4GB RAM, 10GB disk space, Docker installed. 8GB RAM recommended for production.

**Q: Can I use this in production?**
A: Yes, but you MUST enable security features (authentication, HTTPS, encryption).

**Q: How do I add custom detection rules?**
A: Edit `logstash/pipeline/beats-input.conf` and add your patterns in the filter section.

**Q: Does this replace an enterprise SIEM?**
A: No, this is a lightweight detection system. Enterprise SIEMs have more features.

**Q: Can I integrate this with Splunk/QRadar?**
A: Yes, you can forward events from Logstash to other SIEM platforms.

**Q: How long is data retained?**
A: By default, indefinitely. Configure ILM to automatically delete old data.

---

## 🔗 REFERENCES

- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Elastic Stack Documentation](https://www.elastic.co/guide/)
- [Elastic Security](https://www.elastic.co/security)
- [Sysmon Documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Mordor Security Datasets](https://github.com/OTRF/Security-Datasets)
- [Sigma Rules](https://github.com/SigmaHQ/sigma)
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team)

---

## 📧 CONTACT & SUPPORT

**Project:** APT Detection System using ELK Stack
**Built for:** SIH CyberSec Project
**Purpose:** Advanced Persistent Threat Detection & Analysis

For questions, issues, or suggestions:
1. Check documentation files (README.md, PROJECT_STATUS.md, SEARCH_EXAMPLES.md)
2. Review troubleshooting section
3. Check logs: `docker-compose logs -f`
4. Create an issue in the repository

---

## ✨ ACKNOWLEDGMENTS

Built with:
- **Elasticsearch** - Search and analytics engine
- **Logstash** - Data processing pipeline
- **Kibana** - Data visualization
- **Beats** - Lightweight data shippers
- **Docker** - Containerization platform

Thanks to the Elastic community and security researchers for their contributions.

---

**🎉 Happy Threat Hunting!**

**Built for SIH CyberSec Project - APT Detection System**
