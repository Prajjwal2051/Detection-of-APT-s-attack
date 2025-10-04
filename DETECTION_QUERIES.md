# APT Detection Queries - Quick Reference

This document provides ready-to-use Elasticsearch queries for detecting APT activities.

## Using These Queries

### In Kibana Console (Dev Tools)
1. Go to **Management** → **Dev Tools**
2. Copy and paste the query
3. Click the play button (▶️)

### Via curl
```bash
curl -X GET "localhost:9200/apt-detection-*/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '<QUERY_JSON>'
```

---

## 1. Credential Dumping Detection

### Find LSASS Access (Mimikatz-like behavior)
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
  },
  "size": 50,
  "sort": [{ "@timestamp": "desc" }]
}
```

### Find All Credential Dumping Attempts (Last 24h)
```json
GET /apt-threats-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "threat_detected": "credential_dumping" } },
        { "range": { "@timestamp": { "gte": "now-24h" } } }
      ]
    }
  }
}
```

### Count by Host
```json
GET /apt-threats-*/_search
{
  "size": 0,
  "query": {
    "term": { "threat_detected": "credential_dumping" }
  },
  "aggs": {
    "by_host": {
      "terms": { "field": "host.name.keyword", "size": 20 }
    }
  }
}
```

---

## 2. Reconnaissance Detection

### Find Recent Reconnaissance Commands
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "should": [
        { "regexp": { "message": ".*\\b(whoami|net user|net group|nltest|dsquery)\\b.*" } },
        { "regexp": { "winlog.event_data.CommandLine": ".*\\b(whoami|net user|net group)\\b.*" } }
      ],
      "minimum_should_match": 1,
      "filter": [
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  }
}
```

### Hosts with Multiple Recon Commands
```json
GET /apt-detection-*/_search
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        { "term": { "threat_detected": "reconnaissance" } },
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  },
  "aggs": {
    "by_host": {
      "terms": { "field": "host.name.keyword", "size": 50 },
      "aggs": {
        "command_count": { "value_count": { "field": "message.keyword" } }
      }
    }
  }
}
```

---

## 3. Lateral Movement Detection

### Find RDP Lateral Movement
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "winlog.event_id": 4624 } },
        { "term": { "winlog.event_data.LogonType": "10" } }
      ],
      "filter": [
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  }
}
```

### Find SMB Lateral Movement
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "bool": {
            "must": [
              { "term": { "winlog.event_id": 4624 } },
              { "term": { "winlog.event_data.LogonType": "3" } }
            ]
          }
        },
        { "term": { "winlog.event_id": 5140 } }
      ]
    }
  }
}
```

### Failed Login Attempts Before Success
```json
GET /apt-detection-*/_search
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        { "term": { "winlog.event_id": 4625 } },
        { "range": { "@timestamp": { "gte": "now-30m" } } }
      ]
    }
  },
  "aggs": {
    "by_source": {
      "terms": { "field": "source.ip", "size": 20 },
      "aggs": {
        "failed_count": { "value_count": { "field": "winlog.event_id" } }
      }
    }
  }
}
```

---

## 4. PowerShell Execution Detection

### Find Encoded PowerShell Commands
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "should": [
        { "regexp": { "winlog.event_data.CommandLine": ".*-[Ee]nc.*[A-Za-z0-9+/]{50,}.*" } },
        { "regexp": { "winlog.event_data.ScriptBlockText": ".*FromBase64String.*" } }
      ],
      "minimum_should_match": 1
    }
  }
}
```

### Find PowerShell Download Cradles
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "regexp": { "winlog.provider_name": ".*PowerShell.*" } }
      ],
      "should": [
        { "regexp": { "winlog.event_data.ScriptBlockText": ".*(Invoke-WebRequest|DownloadString|DownloadFile).*" } }
      ]
    }
  }
}
```

### All PowerShell Threats
```json
GET /apt-threats-*/_search
{
  "query": {
    "bool": {
      "should": [
        { "term": { "threat_detected": "encoded_powershell" } },
        { "term": { "threat_detected": "powershell_download" } }
      ],
      "filter": [
        { "range": { "@timestamp": { "gte": "now-24h" } } }
      ]
    }
  }
}
```

---

## 5. Data Exfiltration Detection

### Find Large Outbound Transfers
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

### Sum Outbound Traffic by Destination
```json
GET /apt-detection-*/_search
{
  "size": 0,
  "query": {
    "range": { "network.bytes": { "gte": 1048576 } }
  },
  "aggs": {
    "by_destination": {
      "terms": { "field": "destination.ip", "size": 20 },
      "aggs": {
        "total_bytes": { "sum": { "field": "network.bytes" } }
      }
    }
  }
}
```

### DNS Tunneling Detection
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "network.protocol": "dns" } }
      ],
      "should": [
        { "range": { "dns.question.name.length": { "gte": 50 } } },
        { "script": { "script": "doc['destination.port'].value != 53" } }
      ],
      "minimum_should_match": 1
    }
  }
}
```

---

## 6. All APT Threats (Summary)

### All Detected Threats (Last Hour)
```json
GET /apt-threats-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "exists": { "field": "threat_detected" } },
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  },
  "sort": [{ "@timestamp": "desc" }]
}
```

### Threat Distribution by Type
```json
GET /apt-threats-*/_search
{
  "size": 0,
  "aggs": {
    "threat_types": {
      "terms": { "field": "threat_detected.keyword", "size": 20 }
    }
  }
}
```

### MITRE ATT&CK Tactics Distribution
```json
GET /apt-threats-*/_search
{
  "size": 0,
  "aggs": {
    "tactics": {
      "terms": { "field": "mitre_tactic.keyword", "size": 20 }
    }
  }
}
```

### Critical Severity Threats
```json
GET /apt-threats-*/_search
{
  "query": {
    "term": { "severity": "critical" }
  },
  "sort": [{ "@timestamp": "desc" }]
}
```

---

## 7. Timeline Analysis

### Threats Timeline (5-minute buckets)
```json
GET /apt-threats-*/_search
{
  "size": 0,
  "query": {
    "range": { "@timestamp": { "gte": "now-24h" } }
  },
  "aggs": {
    "threats_over_time": {
      "date_histogram": {
        "field": "@timestamp",
        "fixed_interval": "5m"
      },
      "aggs": {
        "by_threat": {
          "terms": { "field": "threat_detected.keyword" }
        }
      }
    }
  }
}
```

---

## 8. Investigation Queries

### Find All Activity from Specific Host
```json
GET /apt-detection-*/_search
{
  "query": {
    "term": { "host.name.keyword": "VICTIM-PC" }
  },
  "sort": [{ "@timestamp": "desc" }],
  "size": 100
}
```

### Find All Activity from Specific User
```json
GET /apt-detection-*/_search
{
  "query": {
    "bool": {
      "should": [
        { "term": { "winlog.event_data.User.keyword": "ADMIN" } },
        { "term": { "winlog.event_data.TargetUserName.keyword": "ADMIN" } }
      ]
    }
  }
}
```

### Find Activity in Time Range
```json
GET /apt-detection-*/_search
{
  "query": {
    "range": {
      "@timestamp": {
        "gte": "2024-01-15T10:00:00Z",
        "lte": "2024-01-15T11:00:00Z"
      }
    }
  },
  "sort": [{ "@timestamp": "asc" }]
}
```

---

## 9. Kibana Query Language (KQL) Examples

Use these in Kibana Discover search bar:

```
# All credential dumping
threat_detected: "credential_dumping"

# Critical threats only
severity: "critical"

# Multiple threat types
threat_detected: ("credential_dumping" OR "lateral_movement")

# Specific MITRE technique
mitre_technique: "T1003.001"

# Specific host
host.name: "VICTIM-PC"

# Failed logins
winlog.event_id: 4625

# PowerShell events
tags: "suspicious_powershell"

# Combine multiple conditions
threat_detected: "lateral_movement" AND severity: "high" AND host.name: "DC01"
```

---

## 10. Export & Reporting Queries

### Generate Threat Report (JSON)
```bash
curl -X GET "localhost:9200/apt-threats-*/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "range": { "@timestamp": { "gte": "now-24h" } }
    },
    "size": 1000
  }' > threat_report.json
```

### Count Threats by Severity
```json
GET /apt-threats-*/_search
{
  "size": 0,
  "aggs": {
    "by_severity": {
      "terms": { "field": "severity.keyword" }
    }
  }
}
```

---

## Tips for Using Queries

1. **Adjust time ranges**: Change `now-1h`, `now-24h`, etc. based on your needs
2. **Increase size**: Default is 10, increase with `"size": 100` for more results
3. **Combine queries**: Use `bool` with `must`, `should`, `must_not` for complex logic
4. **Use wildcards**: `*` matches any characters in regexp patterns
5. **Save searches**: Save frequently-used queries in Kibana

## Performance Notes

- Add time filters to improve query speed
- Use `size: 0` for aggregation-only queries
- Limit aggregation bucket sizes for faster responses
- Consider using index patterns to query specific time ranges

---

For more information, see the main README.md file.
