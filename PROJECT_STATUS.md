# 🎉 APT Detection System - FULLY OPERATIONAL

**Status:** ✅ All systems running  
**Date:** October 4, 2025  
**Location:** `/home/prajjwal25/Desktop/Coding/SIHCyberSec`

---

## ✅ ISSUES FIXED

### 1. **Logstash Configuration Syntax Error** ✅ FIXED
- **Problem:** Invalid conditional logic in output block (line 294)
- **Solution:** Restructured output to use separate conditional blocks
- **Result:** Logstash pipeline running successfully

### 2. **Docker Compose Version Warning** ✅ FIXED
- **Problem:** Obsolete `version: '3.8'` attribute
- **Solution:** Removed version attribute from docker-compose.yml
- **Result:** No more warnings

### 3. **Kibana Readiness Check** ✅ FIXED
- **Problem:** Scripts checking for wrong status field (`"state":"green"` instead of `"level":"available"`)
- **Solution:** Updated both `start.sh` and `create-kibana-dashboards.sh`
- **Result:** Scripts now detect Kibana correctly

### 4. **Kibana Encryption Keys** ✅ IMPROVED
- **Problem:** Missing encryption keys causing warnings
- **Solution:** Added all required encryption keys to docker-compose.yml
- **Result:** Cleaner logs, fewer warnings

---

## 🚀 SYSTEM STATUS

### **All Services Running:**

| Service        | Status  | Port | Health |
|----------------|---------|------|--------|
| Elasticsearch  | ✅ Up   | 9200 | Healthy |
| Kibana         | ✅ Up   | 5601 | Available |
| Logstash       | ✅ Up   | 5044, 9600 | Running |
| Filebeat       | ✅ Up   | - | Running |
| Packetbeat     | ✅ Up   | - | Running |

### **Data Indexed:**

| Index | Documents | Size |
|-------|-----------|------|
| apt-detection-2025.10.04 | 3,780 | 1.3 MB |
| apt-detection-2024.01.15 | 10 | 118 KB |
| **Total** | **3,790** | **~1.4 MB** |

### **Dashboards Created:**

✅ **5 Visualizations:**
1. APT Threat Detection Timeline
2. MITRE ATT&CK Tactics (Pie Chart)
3. Suspicious Processes (Table)
4. Failed Login Attempts (Line Chart)
5. Network Traffic Anomalies (Time Series)

✅ **2 Index Patterns:**
1. `apt-detection-*` - All events
2. `apt-threats-*` - Detected threats only

---

## 🔗 ACCESS POINTS

### **Kibana Dashboard**
```
http://localhost:5601
```
**No authentication required (development mode)**

### **Elasticsearch API**
```
http://localhost:9200
```

### **Logstash Monitoring**
```
http://localhost:9600
```

---

## 📊 HOW TO USE

### **1. View All Events**
1. Open http://localhost:5601
2. Click **☰ Menu** → **Discover**
3. Select index pattern: `apt-detection-*`
4. You'll see all 3,790 indexed events

### **2. View Detected Threats**
1. In Discover, select index pattern: `apt-threats-*`
2. Filter by: `tags: apt_detected`
3. View threat details including:
   - `threat_detected` - Type of threat
   - `mitre_technique` - MITRE ATT&CK ID
   - `mitre_tactic` - Attack tactic
   - `severity` - Critical/High/Medium

### **3. View Dashboards**
1. Click **☰ Menu** → **Dashboard**
2. You should see pre-created visualizations
3. Or create your own custom dashboard

### **4. Search for Specific Threats**

**Credential Dumping:**
```
threat_detected: "credential_dumping"
```

**Reconnaissance:**
```
threat_detected: "reconnaissance"
```

**Lateral Movement:**
```
threat_detected: "lateral_movement"
```

**PowerShell Execution:**
```
threat_detected: "encoded_powershell" OR threat_detected: "powershell_download"
```

---

## 🔍 SAMPLE DATA AVAILABLE

The system has ingested sample APT attack data including:

### **1. Credential Dumping Logs**
- Mimikatz execution
- LSASS process access
- Procdump usage
- Password dumpers

### **2. Reconnaissance Logs**
- `whoami`, `net user`, `net group`
- `ipconfig`, `netstat`
- Domain enumeration
- System information gathering

### **3. Lateral Movement Logs**
- RDP connections (Event ID 4624, LogonType 10)
- SMB lateral movement (LogonType 3)
- PSExec usage
- Admin share access

### **4. PowerShell Execution Logs**
- Base64 encoded commands
- Download cradles (Invoke-WebRequest)
- Invoke-Expression (IEX)
- PowerShell remoting

### **5. Data Exfiltration Logs**
- Large outbound transfers (>10MB)
- Unusual ports
- DNS tunneling
- High volume traffic

---

## 🛠️ MANAGEMENT COMMANDS

### **View Logs**
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f logstash
docker-compose logs -f kibana
docker-compose logs -f elasticsearch
```

### **Restart Services**
```bash
# All services
docker-compose restart

# Specific service
docker-compose restart logstash
```

### **Stop System**
```bash
docker-compose down
```

### **Stop and Remove All Data**
```bash
docker-compose down -v
```

### **Start System**
```bash
docker-compose up -d
```

### **Check Service Status**
```bash
docker-compose ps
```

### **View Elasticsearch Indices**
```bash
curl 'http://localhost:9200/_cat/indices?v'
```

### **Count Documents**
```bash
curl 'http://localhost:9200/apt-detection-*/_count?pretty'
```

---

## 🧪 TEST QUERIES

### **Search Elasticsearch Directly**

**Get recent threats:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' -H 'Content-Type: application/json' -d '{
  "query": {
    "exists": {
      "field": "threat_detected"
    }
  },
  "size": 5
}'
```

**Search for specific MITRE technique:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "mitre_technique": "T1003"
    }
  }
}'
```

**Get all reconnaissance activities:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "threat_detected": "reconnaissance"
    }
  }
}'
```

---

## 📈 PROGRAM FLOW SUMMARY

```
┌─────────────────────────────────────────────────────┐
│              DATA SOURCES                           │
│  • Sample APT logs (in sample-data/)                │
│  • System logs                                       │
│  • Network traffic                                   │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│              FILEBEAT & PACKETBEAT                  │
│  • Read log files                                    │
│  • Capture network packets                          │
│  • Forward to Logstash on port 5044                 │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│              LOGSTASH (Port 5044)                   │
│                                                      │
│  INPUT:                                              │
│   • Beats input (port 5044)                         │
│   • Direct file input (sample-data/)                │
│                                                      │
│  FILTER (Threat Detection):                         │
│   • Parse Windows Event Logs                        │
│   • Detect credential dumping (T1003)               │
│   • Detect reconnaissance (T1087)                   │
│   • Detect lateral movement (T1021)                 │
│   • Detect PowerShell execution (T1059.001)         │
│   • Detect data exfiltration (T1041)                │
│   • Add GeoIP enrichment                            │
│   • Tag threats with "apt_detected"                 │
│                                                      │
│  OUTPUT:                                             │
│   • Route to apt-threats-* (if tagged)              │
│   • Route to apt-detection-* (all events)           │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│              ELASTICSEARCH (Port 9200)              │
│                                                      │
│  Indices:                                            │
│   • apt-detection-YYYY.MM.DD (all events)           │
│   • apt-threats-YYYY.MM.DD (threats only)           │
│                                                      │
│  Storage:                                            │
│   • Full-text search                                │
│   • Aggregations                                     │
│   • Time-series data                                 │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│              KIBANA (Port 5601)                     │
│                                                      │
│  Features:                                           │
│   • Discover - Search and filter events             │
│   • Dashboards - Pre-built visualizations           │
│   • MITRE ATT&CK mapping                            │
│   • Real-time threat monitoring                     │
│   • Custom queries and alerts                       │
└─────────────────────────────────────────────────────┘
```

---

## 🎯 DETECTED THREAT EXAMPLES

The system automatically detects and tags the following:

### **Critical Threats:**
- **Credential Dumping** (LSASS access, Mimikatz)
  - MITRE: T1003.001
  - Severity: Critical

- **Data Exfiltration** (Large transfers >10MB)
  - MITRE: T1041
  - Severity: Critical

### **High Threats:**
- **Lateral Movement** (RDP, SMB connections)
  - MITRE: T1021
  - Severity: High

- **Encoded PowerShell** (Base64 commands)
  - MITRE: T1059.001
  - Severity: High

### **Medium Threats:**
- **Reconnaissance** (whoami, net user, ipconfig)
  - MITRE: T1087, T1082
  - Severity: Medium

---

## 📚 NEXT STEPS

### **1. Explore Kibana**
- Create custom dashboards
- Set up alerts for critical threats
- Analyze MITRE ATT&CK tactics

### **2. Add More Data**
- Ingest real Windows Event Logs
- Add Sysmon logs
- Configure network monitoring

### **3. Tune Detection Rules**
- Adjust severity levels
- Add custom detection patterns
- Fine-tune false positive rates

### **4. Production Hardening**
- Enable X-Pack Security
- Configure HTTPS
- Set up user authentication
- Implement role-based access control

---

## 🔒 SECURITY NOTE

⚠️ **This is a development environment!**

Current configuration:
- ❌ No authentication enabled
- ❌ HTTP only (no HTTPS)
- ❌ No encryption at rest
- ❌ Default encryption keys

For production use, you must:
1. Enable Elasticsearch X-Pack Security
2. Configure HTTPS with proper certificates
3. Set strong unique encryption keys
4. Enable authentication and authorization
5. Configure firewall rules
6. Use secrets management

---

## 📞 SUPPORT

For issues or questions:
1. Check logs: `docker-compose logs -f`
2. Verify services: `docker-compose ps`
3. Check Elasticsearch: `curl http://localhost:9200`
4. Check Kibana: `curl http://localhost:5601/api/status`

---

## ✨ SUCCESS!

Your APT Detection System is fully operational and ready to use!

**Access Kibana now:** http://localhost:5601

🎉 Happy threat hunting!
