# 🔍 APT Attack Search Examples Guide

Complete guide for searching specific attacks in your APT Detection System.

---

## 📋 TABLE OF CONTENTS

1. [Command Line Searches (Elasticsearch API)](#command-line-searches)
2. [Kibana UI Searches](#kibana-ui-searches)
3. [Attack-Specific Examples](#attack-specific-examples)
4. [Advanced Search Queries](#advanced-search-queries)
5. [Quick Reference](#quick-reference)

---

## 🖥️ COMMAND LINE SEARCHES

### Example 1: **Credential Dumping Attack (CRITICAL)**

Search for Mimikatz, LSASS access, and credential dumping tools.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "threat_detected": "credential_dumping"
    }
  },
  "size": 5,
  "_source": [
    "@timestamp",
    "host.name",
    "threat_detected",
    "mitre_technique",
    "mitre_tactic",
    "severity",
    "winlog.event_data.SourceImage",
    "winlog.event_data.TargetImage"
  ]
}'
```

**Expected Results:**
- **MITRE Technique:** T1003.001 (LSASS Memory)
- **Severity:** Critical
- **Indicators:** 
  - Source: mimikatz.exe, procdump.exe
  - Target: lsass.exe

---

### Example 2: **Reconnaissance Activity (MEDIUM)**

Search for enumeration commands like whoami, net user, ipconfig.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "threat_detected": "reconnaissance"
    }
  },
  "size": 5,
  "_source": [
    "@timestamp",
    "host.name",
    "threat_detected",
    "mitre_technique",
    "severity",
    "message"
  ]
}'
```

**Expected Results:**
- **MITRE Technique:** T1087, T1082
- **Severity:** Medium
- **Commands:** whoami, net user, ipconfig, netstat

---

### Example 3: **Lateral Movement (HIGH)**

Search for RDP, SMB, and PSExec usage.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "threat_detected": "lateral_movement"
    }
  },
  "size": 5,
  "_source": [
    "@timestamp",
    "host.name",
    "threat_detected",
    "mitre_technique",
    "severity",
    "winlog.event_data.LogonType",
    "winlog.event_data.IpAddress"
  ]
}'
```

**Expected Results:**
- **MITRE Technique:** T1021.001 (RDP), T1021.002 (SMB)
- **Severity:** High
- **Indicators:**
  - Event ID 4624 with LogonType 3 or 10
  - Remote IP addresses

---

### Example 4: **PowerShell Execution (HIGH)**

Search for encoded PowerShell and download cradles.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "should": [
        {"match": {"threat_detected": "encoded_powershell"}},
        {"match": {"threat_detected": "powershell_download"}}
      ]
    }
  },
  "size": 5,
  "_source": [
    "@timestamp",
    "host.name",
    "threat_detected",
    "mitre_technique",
    "severity",
    "winlog.event_data.CommandLine",
    "winlog.event_data.ScriptBlockText"
  ]
}'
```

**Expected Results:**
- **MITRE Technique:** T1059.001 (PowerShell)
- **Severity:** High
- **Indicators:**
  - Base64 encoded commands (-encodedCommand)
  - Invoke-WebRequest, DownloadString
  - IEX (Invoke-Expression)

---

### Example 5: **Data Exfiltration (CRITICAL)**

Search for large data transfers and suspicious network activity.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "threat_detected": "data_exfiltration"
    }
  },
  "size": 5,
  "_source": [
    "@timestamp",
    "host.name",
    "threat_detected",
    "mitre_technique",
    "severity",
    "network.bytes",
    "destination.ip"
  ]
}'
```

**Expected Results:**
- **MITRE Technique:** T1041 (Exfiltration Over C2 Channel)
- **Severity:** Critical
- **Indicators:**
  - Large transfers (>10MB)
  - Suspicious destination IPs

---

### Example 6: **ALL Critical Threats**

Get all attacks marked as critical severity.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "term": {
      "severity": "critical"
    }
  },
  "size": 10,
  "_source": [
    "@timestamp",
    "host.name",
    "threat_detected",
    "mitre_technique",
    "mitre_tactic",
    "severity"
  ]
}'
```

---

### Example 7: **Specific MITRE Technique**

Search by MITRE ATT&CK technique ID.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "match": {
      "mitre_technique": "T1003"
    }
  },
  "size": 5
}'
```

---

### Example 8: **Attacks on Specific Host**

Find all threats on a specific machine.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"match": {"host.name": "VICTIM-PC"}},
        {"exists": {"field": "threat_detected"}}
      ]
    }
  },
  "size": 10
}'
```

---

### Example 9: **Time Range Query**

Find attacks within the last hour.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"exists": {"field": "threat_detected"}},
        {
          "range": {
            "@timestamp": {
              "gte": "now-1h"
            }
          }
        }
      ]
    }
  },
  "size": 10
}'
```

---

### Example 10: **Aggregation - Count Threats by Type**

Get statistics on detected threat types.

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "size": 0,
  "aggs": {
    "threat_types": {
      "terms": {
        "field": "threat_detected.keyword",
        "size": 10
      }
    }
  }
}'
```

---

## 🌐 KIBANA UI SEARCHES

### **Step-by-Step Guide:**

1. **Open Kibana:**
   ```
   http://localhost:5601
   ```

2. **Navigate to Discover:**
   - Click **☰ Menu** (top left)
   - Go to **Analytics** → **Discover**

3. **Select Index Pattern:**
   - Click the dropdown at top left
   - Select: `apt-detection-*`

4. **Use Search Queries:**

---

### **Kibana Query Examples:**

#### **1. Credential Dumping:**
```
threat_detected: "credential_dumping"
```

#### **2. Reconnaissance:**
```
threat_detected: "reconnaissance"
```

#### **3. Multiple Threat Types:**
```
threat_detected: ("credential_dumping" OR "lateral_movement")
```

#### **4. Critical Threats:**
```
severity: "critical"
```

#### **5. Specific Host:**
```
host.name: "VICTIM-PC"
```

#### **6. MITRE Technique:**
```
mitre_technique: "T1003"
```

#### **7. Specific Time Range:**
- Use the time picker at top right
- Select "Last 15 minutes", "Last 1 hour", etc.
- Or set custom absolute time range

#### **8. PowerShell Attacks:**
```
threat_detected: ("encoded_powershell" OR "powershell_download")
```

#### **9. High or Critical Severity:**
```
severity: ("high" OR "critical")
```

#### **10. Command Pattern Search:**
```
message: *mimikatz* OR message: *lsass*
```

---

## 🎯 ATTACK-SPECIFIC EXAMPLES

### **CREDENTIAL DUMPING (T1003)**

**What it detects:**
- Mimikatz execution
- LSASS process access
- Procdump usage
- Password dumpers

**Kibana Query:**
```
threat_detected: "credential_dumping"
```

**CLI Query:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {"match": {"threat_detected": "credential_dumping"}},
  "size": 5
}'
```

**Key Fields to Examine:**
- `winlog.event_data.SourceImage` - Tool used (mimikatz.exe)
- `winlog.event_data.TargetImage` - Target process (lsass.exe)
- `winlog.event_data.GrantedAccess` - Access rights requested

---

### **RECONNAISSANCE (T1087, T1082)**

**What it detects:**
- whoami, net user, net group
- ipconfig, netstat, systeminfo
- nltest, dsquery

**Kibana Query:**
```
threat_detected: "reconnaissance"
```

**CLI Query:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {"match": {"threat_detected": "reconnaissance"}},
  "size": 5
}'
```

**Key Fields to Examine:**
- `message` - Command executed
- `host.name` - Compromised machine

---

### **LATERAL MOVEMENT (T1021)**

**What it detects:**
- RDP connections (LogonType 10)
- SMB lateral movement (LogonType 3)
- PSExec usage
- Admin share access

**Kibana Query:**
```
threat_detected: "lateral_movement"
```

**CLI Query:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {"match": {"threat_detected": "lateral_movement"}},
  "size": 5
}'
```

**Key Fields to Examine:**
- `winlog.event_id` - 4624 (successful logon)
- `winlog.event_data.LogonType` - 3 or 10
- `winlog.event_data.IpAddress` - Source IP

---

### **POWERSHELL EXECUTION (T1059.001)**

**What it detects:**
- Base64 encoded commands
- Download cradles (Invoke-WebRequest)
- Invoke-Expression (IEX)
- Remote execution

**Kibana Query:**
```
threat_detected: ("encoded_powershell" OR "powershell_download")
```

**CLI Query:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "should": [
        {"match": {"threat_detected": "encoded_powershell"}},
        {"match": {"threat_detected": "powershell_download"}}
      ]
    }
  },
  "size": 5
}'
```

**Key Fields to Examine:**
- `winlog.event_data.CommandLine` - Full command
- `winlog.event_data.ScriptBlockText` - Script content

---

### **DATA EXFILTRATION (T1041)**

**What it detects:**
- Large data transfers (>10MB)
- Unusual destination IPs
- DNS tunneling
- High volume traffic

**Kibana Query:**
```
threat_detected: "data_exfiltration"
```

**CLI Query:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {"match": {"threat_detected": "data_exfiltration"}},
  "size": 5
}'
```

**Key Fields to Examine:**
- `network.bytes` - Transfer size
- `destination.ip` - External IP address
- `destination.port` - Communication port

---

## 🔬 ADVANCED SEARCH QUERIES

### **Complex Boolean Query**

Find critical threats on specific host within time range:

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"match": {"host.name": "VICTIM-PC"}},
        {"term": {"severity": "critical"}}
      ],
      "filter": {
        "range": {
          "@timestamp": {
            "gte": "2024-01-15T00:00:00",
            "lte": "2024-01-15T23:59:59"
          }
        }
      }
    }
  },
  "size": 10
}'
```

---

### **Aggregation - Threat Timeline**

Get threat counts grouped by hour:

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "size": 0,
  "aggs": {
    "threats_over_time": {
      "date_histogram": {
        "field": "@timestamp",
        "interval": "1h"
      },
      "aggs": {
        "threat_types": {
          "terms": {
            "field": "threat_detected.keyword"
          }
        }
      }
    }
  }
}'
```

---

### **Find Correlated Attacks**

Find multiple attack stages on same host:

```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"match": {"host.name": "VICTIM-PC"}}
      ],
      "should": [
        {"match": {"threat_detected": "reconnaissance"}},
        {"match": {"threat_detected": "credential_dumping"}},
        {"match": {"threat_detected": "lateral_movement"}}
      ],
      "minimum_should_match": 2
    }
  },
  "sort": [{"@timestamp": "asc"}],
  "size": 20
}'
```

---

## 📊 QUICK REFERENCE

### **Threat Detection Fields:**

| Field | Description | Example Values |
|-------|-------------|----------------|
| `threat_detected` | Type of threat | credential_dumping, reconnaissance, lateral_movement |
| `mitre_technique` | MITRE ATT&CK ID | T1003, T1087, T1021 |
| `mitre_tactic` | Attack tactic | Credential Access, Discovery, Lateral Movement |
| `severity` | Threat severity | critical, high, medium, low |
| `host.name` | Affected machine | VICTIM-PC, DC01 |
| `@timestamp` | Event time | 2024-01-15T10:23:45.000Z |

---

### **Severity Levels:**

- **Critical:** Credential dumping, data exfiltration
- **High:** Lateral movement, PowerShell execution
- **Medium:** Reconnaissance, suspicious processes

---

### **MITRE ATT&CK Coverage:**

| Tactic | Technique | Threat Type |
|--------|-----------|-------------|
| Credential Access | T1003.001 | credential_dumping |
| Discovery | T1087, T1082 | reconnaissance |
| Lateral Movement | T1021.001, T1021.002 | lateral_movement |
| Execution | T1059.001 | encoded_powershell |
| Exfiltration | T1041 | data_exfiltration |

---

## 🛠️ USEFUL COMMANDS

### **Count All Threats:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_count?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {"exists": {"field": "threat_detected"}}
}'
```

### **List All Threat Types:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "size": 0,
  "aggs": {
    "unique_threats": {
      "terms": {"field": "threat_detected.keyword", "size": 20}
    }
  }
}'
```

### **Get Latest Threats:**
```bash
curl -s 'http://localhost:9200/apt-detection-*/_search?pretty' \
  -H 'Content-Type: application/json' -d '{
  "query": {"exists": {"field": "threat_detected"}},
  "sort": [{"@timestamp": "desc"}],
  "size": 5
}'
```

---

## 🎓 TIPS

1. **Use wildcards in Kibana:**
   ```
   message: *mimikatz*
   ```

2. **Combine multiple conditions:**
   ```
   severity: "critical" AND host.name: "VICTIM-PC"
   ```

3. **Exclude fields:**
   ```
   threat_detected: * AND NOT severity: "medium"
   ```

4. **Use field existence:**
   ```
   _exists_: threat_detected
   ```

5. **Time-based searches:**
   - Always use the time picker for better performance
   - Narrow down time ranges when possible

---

## 📞 NEED HELP?

- **View all indexed data:** http://localhost:5601
- **Elasticsearch API:** http://localhost:9200
- **Check indices:** `curl 'http://localhost:9200/_cat/indices?v'`
- **View logs:** `docker-compose logs -f logstash`

---

**Happy Threat Hunting! 🔍🛡️**
