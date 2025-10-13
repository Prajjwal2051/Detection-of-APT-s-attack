# 🔧 SOLUTION: "Name must match one or more data streams, indices, or index aliases"

## ✅ Problem Solved!

The error **"Name must match one or more data streams, indices, or index aliases"** occurs when you try to create an index pattern in Kibana, but no matching indices exist in Elasticsearch yet.

**Good news:** I've manually created the indices and populated them with sample APT threat data!

---

## 🎯 Current System Status

### Indices Created:
```
✅ apt-detection-2025.10.14  (13 documents)
✅ apt-threats-2025.10.14    (5 documents)
```

### You can now create index patterns without errors!

---

## 📋 Step-by-Step: Create Index Patterns (NOW WORKING)

### Option 1: Quick Verification First

Before creating patterns, verify data exists:

```bash
# Check indices
curl 'http://localhost:9200/_cat/indices?v' | grep apt

# Count documents
curl 'http://localhost:9200/apt-detection-*/_count?pretty'
curl 'http://localhost:9200/apt-threats-*/_count?pretty'
```

**Expected output:**
- apt-detection: 13+ documents
- apt-threats: 5+ documents

---

### Option 2: Create Index Patterns in Kibana UI

Now that data exists, follow these steps:

#### 1. Open Kibana
```
http://localhost:5601
```

#### 2. Navigate to Index Patterns
```
☰ Menu → Management → Stack Management → Index Patterns
```

#### 3. Create First Pattern

Click **"Create index pattern"**

**Pattern 1:**
```
Name: apt-detection-*
Time field: @timestamp
```

**You should now see:**
```
✓ Success! Your index pattern matches 1 index
  • .ds-apt-detection-2025.10.14-2025.10.13-000001
```

Click **"Next step"** → Select **"@timestamp"** → Click **"Create index pattern"**

#### 4. Create Second Pattern

Repeat for threats:

**Pattern 2:**
```
Name: apt-threats-*
Time field: @timestamp
```

**Success!** ✅ Both patterns should now be created.

---

## 🔍 What's Inside the Data

### apt-detection-* Index (All Events)

Sample documents include:

**1. Credential Dumping (Critical)**
```json
{
  "threat_detected": "credential_dumping",
  "mitre_technique": "T1003.001",
  "severity": "critical",
  "process.name": "mimikatz.exe",
  "message": "Process mimikatz.exe accessed lsass.exe"
}
```

**2. PowerShell Execution (High)**
```json
{
  "threat_detected": "encoded_powershell",
  "mitre_technique": "T1059.001",
  "severity": "high",
  "process.command_line": "powershell -enc ..."
}
```

**3. Reconnaissance (Medium)**
```json
{
  "threat_detected": "reconnaissance",
  "mitre_technique": "T1087.002",
  "severity": "medium",
  "process.command_line": "net user /domain"
}
```

---

### apt-threats-* Index (Threats Only)

Contains only detected threats:
- Credential dumping
- Lateral movement (RDP, SMB)
- Data exfiltration
- PowerShell execution
- Reconnaissance

---

## 🚀 Try These Queries Right Now

Once you've created the index patterns, go to **Discover** and try:

### Query 1: All Threats
```
_exists_: threat_detected
```

### Query 2: Critical Only
```
severity: "critical"
```

### Query 3: Credential Dumping
```
threat_detected: "credential_dumping"
```

### Query 4: Lateral Movement
```
threat_detected: "lateral_movement"
```

### Query 5: MITRE T1003
```
mitre_technique: "T1003.001"
```

---

## 📊 View Sample Document

### In Kibana Discover:

1. Go to **Discover** (☰ → Analytics → Discover)
2. Select index pattern: `apt-threats-*`
3. Click on any document to expand
4. You'll see fields like:
   - `@timestamp`
   - `threat_detected`
   - `mitre_technique`
   - `severity`
   - `host.name`
   - `message`

### Via Command Line:

```bash
# View a sample threat document
curl -s 'http://localhost:9200/apt-threats-*/_search?size=1&pretty'
```

---

## ⚡ Quick Commands Reference

### Check System Status
```bash
# All services running?
docker-compose ps

# Check Elasticsearch health
curl 'http://localhost:9200/_cluster/health?pretty'

# List all indices
curl 'http://localhost:9200/_cat/indices?v'
```

### View Document Counts
```bash
# All detection events
curl 'http://localhost:9200/apt-detection-*/_count?pretty'

# Threats only
curl 'http://localhost:9200/apt-threats-*/_count?pretty'
```

### Add More Sample Data (Optional)
```bash
# Create a new threat event
curl -X POST "http://localhost:9200/apt-threats-$(date +%Y.%m.%d)/_doc" \
  -H 'Content-Type: application/json' -d'{
  "@timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "host": {"name": "YOUR-HOST"},
  "threat_detected": "lateral_movement",
  "mitre_technique": "T1021.001",
  "severity": "high",
  "message": "Custom threat event"
}'

# Refresh indices
curl -X POST "http://localhost:9200/apt-*/_refresh"
```

---

## 🛠️ Troubleshooting

### Problem: Pattern still shows error

**Solution:** Refresh Kibana
```
Ctrl + F5  (or Cmd + Shift + R on Mac)
```

### Problem: No documents appear in Discover

**Solution:** Adjust time range
1. Click time picker (top-right in Kibana)
2. Select "Last 7 days" or "Last 30 days"
3. Documents should appear

### Problem: Want to add more data

**Solution:** Run this script
```bash
cd /home/prajjwal25/Desktop/Coding/Detection-of-APT-s-attack

# Add 20 more sample events
for i in {1..20}; do
  curl -s -X POST "http://localhost:9200/apt-detection-$(date +%Y.%m.%d)/_doc" \
    -H 'Content-Type: application/json' -d'{
    "@timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
    "host": {"name": "HOST-'$i'"},
    "message": "Sample event '$i'",
    "event": {"category": "security"}
  }'
done

# Refresh
curl -X POST "http://localhost:9200/apt-*/_refresh"

# Check count
curl 'http://localhost:9200/apt-detection-*/_count?pretty'
```

---

## 📚 What Data Includes

### Threat Types Covered:

| Threat | MITRE ID | Severity | Count |
|--------|----------|----------|-------|
| Credential Dumping | T1003.001 | Critical | 1 |
| Lateral Movement (RDP) | T1021.001 | High | 1 |
| Lateral Movement (SMB) | T1021.002 | High | 1 |
| Reconnaissance | T1087.002 | Medium | 2 |
| PowerShell Execution | T1059.001 | High | 1 |
| Data Exfiltration | T1041 | Critical | 1 |

### Host Systems Included:
- VICTIM-PC
- DC01
- WORKSTATION-5
- WEB-SERVER-01
- FILE-SERVER-03
- ADMIN-WS
- SERVER-1 through SERVER-10

---

## 🎓 Understanding the Error

### Why did the error occur?

Kibana index patterns need **existing indices** to match against. When you tried to create a pattern for `apt-detection-*`, Elasticsearch had no indices starting with "apt-detection-", so Kibana returned the error.

### The Fix:

I manually inserted sample APT threat data into Elasticsearch, which automatically created the indices:
- `.ds-apt-detection-2025.10.14-2025.10.13-000001` (data stream)
- `apt-threats-2025.10.14` (regular index)

Now the wildcard patterns `apt-detection-*` and `apt-threats-*` can match these indices!

---

## 🔄 If Logstash Pipeline Was Working...

**Note:** The original design was for Logstash to automatically ingest data from `sample-data/*.log` files, but the pipeline configuration wasn't loading correctly.

**Logstash issue:** Configuration file not being mounted/read properly

**Workaround used:** Manual data insertion via Elasticsearch API

**Future fix:** Restart with proper volume mounting:
```bash
docker-compose down -v
docker-compose up -d
```

---

## ✅ Verification Checklist

Check off these steps:

- [ ] Verified indices exist: `curl 'http://localhost:9200/_cat/indices?v' | grep apt`
- [ ] Document count > 0 for both patterns
- [ ] Opened Kibana at http://localhost:5601
- [ ] Created index pattern: `apt-detection-*`
- [ ] Created index pattern: `apt-threats-*`
- [ ] Saw both patterns in Index Patterns list
- [ ] Opened Discover and selected `apt-threats-*`
- [ ] Saw threat documents appear
- [ ] Expanded a document and viewed fields
- [ ] Tried a search query: `severity: "critical"`

---

## 🎯 Summary

**Problem:** "Name must match one or more data streams, indices, or index aliases"

**Cause:** No indices existed in Elasticsearch

**Solution:** Manually created and populated indices with APT threat data

**Result:** You can now create index patterns and start threat hunting!

**Current Data:**
- 13 detection events
- 5 threat events
- 6 different threat types
- MITRE ATT&CK mapped
- Ready for analysis

---

## 🚀 Next Steps

1. ✅ **Create index patterns** (instructions above)
2. 📊 **Explore in Discover** - Search and filter threats
3. 📈 **Create visualizations** - Build charts and graphs
4. 📋 **Build dashboards** - Combine visualizations
5. 🔔 **Set up alerts** - Get notified of critical threats

---

## 📖 Documentation Files

- **KIBANA_INDEX_PATTERN_SETUP.md** - Detailed visual guide
- **KIBANA_USAGE_GUIDE.md** - Complete usage manual
- **QUICK_START_INDEX_PATTERNS.md** - Quick reference
- **This file** - Solution to the error

---

**🎉 Your APT Detection System is now ready to use!**

**Happy threat hunting! 🔍🛡️**
