# 📊 Kibana Usage Guide for APT Detection System

## Table of Contents
1. [First-Time Setup](#first-time-setup)
2. [Navigating Kibana](#navigating-kibana)
3. [Creating Index Patterns](#creating-index-patterns)
4. [Using Discover to Find Threats](#using-discover-to-find-threats)
5. [Advanced Search Queries](#advanced-search-queries)
6. [Creating Visualizations](#creating-visualizations)
7. [Building Dashboards](#building-dashboards)
8. [Setting Up Alerts](#setting-up-alerts)
9. [Common Use Cases](#common-use-cases)

---

## First-Time Setup

### Step 1: Access Kibana

Open your web browser and navigate to:
```
http://localhost:5601
```

**Note:** No login required in development mode.

### Step 2: Wait for Kibana to Load

You should see the Kibana home screen. If you see "Kibana server is not ready yet", wait 1-2 minutes.

### Step 3: Skip Welcome Screen

- If you see a welcome screen, click **"Explore on my own"**
- You'll be taken to the Kibana home page

---

## Navigating Kibana

### Main Menu (☰)

Located in the top-left corner. Key sections:

```
☰ Menu
├── Analytics
│   ├── Discover      ← Search and explore data
│   ├── Dashboard     ← View visualizations
│   └── Visualize     ← Create charts
├── Management
│   └── Stack Management
│       ├── Index Patterns    ← Define data sources
│       ├── Saved Objects     ← Export/Import
│       └── Index Management  ← Manage indices
└── Observability
    └── Logs          ← View raw logs
```

### Top Navigation Bar

- **Search bar** - Query your data
- **Time picker** - Filter by time range (top right)
- **Add filter** - Create quick filters
- **Save/Share** - Save searches and share

---

## Creating Index Patterns

Index patterns tell Kibana which Elasticsearch indices to access.

### Method 1: Using the UI

1. **Click the menu** (☰) → **Management** → **Stack Management**

2. **Click "Index Patterns"** (under Kibana section)

3. **Click "Create index pattern"**

4. **Create Pattern for All Detection Events:**
   ```
   Index pattern name: apt-detection-*
   Timestamp field: @timestamp
   ```
   Click **"Create index pattern"**

5. **Create Pattern for Threats Only:**
   ```
   Index pattern name: apt-threats-*
   Timestamp field: @timestamp
   ```
   Click **"Create index pattern"**

### Method 2: Using Dev Tools (Advanced)

1. Go to **Menu** → **Management** → **Dev Tools**

2. Run these commands:
   ```json
   PUT _data_stream/apt-detection
   PUT _data_stream/apt-threats
   ```

### Verify Index Patterns

- Go to **Stack Management** → **Index Patterns**
- You should see:
  - ✅ `apt-detection-*`
  - ✅ `apt-threats-*`

---

## Using Discover to Find Threats

### Access Discover

**Menu** (☰) → **Analytics** → **Discover**

### Select Your Index Pattern

Click the dropdown at the top-left (below search bar) and select:
- **apt-detection-*** - All events (both normal and threats)
- **apt-threats-*** - Only detected threats

### Understanding the Interface

```
┌─────────────────────────────────────────────────────┐
│ [Index Pattern ▼] [Search bar        ] [Time ▼]    │
├─────────────────────────────────────────────────────┤
│ Histogram (Timeline of events)                      │
├──────────────┬──────────────────────────────────────┤
│ Available    │ Document Table                       │
│ Fields       │ • @timestamp                         │
│ • threat_    │ • host.name                          │
│   detected   │ • message                            │
│ • severity   │ • [+ Show more]                      │
│ • mitre_     │                                      │
│   technique  │ Click to expand ▼                    │
└──────────────┴──────────────────────────────────────┘
```

### Basic Usage

1. **View All Events:**
   - Just open Discover with `apt-detection-*` selected
   - Scroll through the timeline

2. **Click on an Event:**
   - Click any event to see full details
   - Click the ▶ arrow to expand
   - You'll see all fields (threat_detected, mitre_technique, etc.)

3. **Change Time Range:**
   - Click the **time picker** (top-right)
   - Select: "Last 15 minutes", "Last 24 hours", "Last 7 days", etc.

---

## Advanced Search Queries

### Query Language (KQL - Kibana Query Language)

Kibana uses KQL for searches. Here's how to use it:

### 1. Find Specific Threat Types

**Credential Dumping:**
```
threat_detected: "credential_dumping"
```

**Lateral Movement:**
```
threat_detected: "lateral_movement"
```

**All Reconnaissance:**
```
threat_detected: "reconnaissance"
```

### 2. Filter by Severity

**Critical Threats Only:**
```
severity: "critical"
```

**High or Critical:**
```
severity: ("high" OR "critical")
```

**Not Medium:**
```
NOT severity: "medium"
```

### 3. MITRE ATT&CK Searches

**Specific Technique:**
```
mitre_technique: "T1003.001"
```

**Credential Access Tactic:**
```
mitre_tactic: "Credential Access"
```

**Multiple Techniques:**
```
mitre_technique: ("T1003.001" OR "T1021.001")
```

### 4. Host-Based Searches

**Specific Host:**
```
host.name: "VICTIM-PC"
```

**Multiple Hosts:**
```
host.name: ("VICTIM-PC" OR "DC01")
```

**Host with Threats:**
```
host.name: "VICTIM-PC" AND _exists_: threat_detected
```

### 5. Process-Based Searches

**Find Mimikatz:**
```
process.name: "mimikatz.exe"
```

**PowerShell Execution:**
```
process.name: "powershell.exe" AND threat_detected: *
```

**LSASS Access:**
```
winlog.event_data.TargetImage: *lsass.exe*
```

### 6. Time-Based Searches

**Events in Last Hour:**
- Use the time picker: "Last 1 hour"

**Specific Date Range:**
- Click time picker → "Absolute"
- Set start and end dates

### 7. Combined Searches

**Critical Threats on Specific Host:**
```
severity: "critical" AND host.name: "VICTIM-PC"
```

**PowerShell or Mimikatz:**
```
process.name: ("powershell.exe" OR "mimikatz.exe")
```

**Threats Excluding Reconnaissance:**
```
_exists_: threat_detected AND NOT threat_detected: "reconnaissance"
```

### 8. Wildcard Searches

**Any PowerShell Threat:**
```
threat_detected: *powershell*
```

**Any .exe Process:**
```
process.name: *.exe
```

### 9. Check if Field Exists

**Has Threat Detection:**
```
_exists_: threat_detected
```

**Has MITRE Mapping:**
```
_exists_: mitre_technique
```

### 10. Numeric Ranges

**Large Network Transfers (>10MB):**
```
network.bytes >= 10485760
```

**Event ID Range:**
```
winlog.event_id >= 4624 AND winlog.event_id <= 4634
```

---

## Creating Visualizations

### Step 1: Go to Visualize

**Menu** (☰) → **Analytics** → **Visualize Library**

### Step 2: Create New Visualization

Click **"Create visualization"**

### Visualization Types

#### 1. **Pie Chart - Threat Distribution**

**Setup:**
- Type: **Pie**
- Index: `apt-detection-*`
- Metrics: **Count**
- Buckets:
  - Aggregation: **Terms**
  - Field: `threat_detected.keyword`
  - Size: 10
  - Custom label: "Threat Type"

**Result:** Shows percentage of each threat type

#### 2. **Bar Chart - Threats Over Time**

**Setup:**
- Type: **Vertical Bar**
- Index: `apt-detection-*`
- Metrics: **Count**
- Buckets (X-axis):
  - Aggregation: **Date Histogram**
  - Field: `@timestamp`
  - Interval: **Auto**

**Result:** Timeline showing threat frequency

#### 3. **Data Table - Top Affected Hosts**

**Setup:**
- Type: **Table**
- Index: `apt-detection-*`
- Metrics: **Count**
- Buckets (Rows):
  - Aggregation: **Terms**
  - Field: `host.name.keyword`
  - Order By: **Metric: Count**
  - Size: 10

**Result:** List of hosts with most threats

#### 4. **Metric - Total Threats**

**Setup:**
- Type: **Metric**
- Index: `apt-threats-*`
- Metrics: **Count**
- Add Filter: `_exists_: threat_detected`

**Result:** Big number showing total threats

#### 5. **Tag Cloud - MITRE Techniques**

**Setup:**
- Type: **Tag Cloud**
- Index: `apt-detection-*`
- Metrics: **Count**
- Buckets:
  - Aggregation: **Terms**
  - Field: `mitre_technique.keyword`
  - Size: 20

**Result:** Visual representation of most common techniques

#### 6. **Heat Map - Threats by Hour**

**Setup:**
- Type: **Heat Map**
- Index: `apt-detection-*`
- Metrics: **Count**
- X-axis: Date Histogram (@timestamp, Hourly)
- Y-axis: Terms (threat_detected.keyword)

**Result:** Shows when each threat type occurs

### Step 3: Save Your Visualization

1. Click **"Save"** (top-right)
2. Enter a descriptive name (e.g., "Threat Distribution Pie Chart")
3. Click **"Save"**

---

## Building Dashboards

### Step 1: Create Dashboard

**Menu** (☰) → **Analytics** → **Dashboard** → **Create dashboard**

### Step 2: Add Visualizations

1. Click **"Add from library"**
2. Select the visualizations you created
3. Arrange them by dragging

### Recommended Dashboard Layout

```
┌─────────────────────────────────────────────────┐
│  APT Detection Dashboard                        │
├──────────────┬──────────────┬──────────────────┤
│ Total        │ Critical     │ Threats          │
│ Threats      │ Alerts       │ Last Hour        │
│ [Metric]     │ [Metric]     │ [Metric]         │
├──────────────┴──────────────┴──────────────────┤
│ Threat Distribution                             │
│ [Pie Chart]                                     │
├─────────────────────────────────────────────────┤
│ Threats Timeline                                │
│ [Area/Line Chart]                               │
├──────────────────────┬─────────────────────────┤
│ Top Affected Hosts   │ MITRE Techniques        │
│ [Data Table]         │ [Tag Cloud]             │
└──────────────────────┴─────────────────────────┘
```

### Step 3: Add Filters to Dashboard

1. Click **"Add filter"**
2. Example filters:
   - Field: `severity`, Operator: `is`, Value: `critical`
   - Field: `threat_detected`, Operator: `exists`

### Step 4: Save Dashboard

1. Click **"Save"** (top-right)
2. Name: "APT Detection Dashboard"
3. Check: "Store time with dashboard"
4. Click **"Save"**

### Step 5: Share Dashboard

1. Click **"Share"** (top-right)
2. Options:
   - **Copy link** - Share URL
   - **Download as PDF** - Export report
   - **Generate PNG** - Screenshot

---

## Setting Up Alerts

### Step 1: Go to Stack Management

**Menu** (☰) → **Management** → **Stack Management** → **Rules and Connectors**

### Step 2: Create Rule

Click **"Create rule"**

### Alert Examples

#### Alert 1: Critical Threat Detection

**Setup:**
- Name: "Critical APT Threat Detected"
- Rule type: **Elasticsearch query**
- Index: `apt-threats-*`
- Time field: `@timestamp`
- Query:
  ```json
  {
    "query": {
      "term": {
        "severity": "critical"
      }
    }
  }
  ```
- Threshold: **above 0**
- Check every: **1 minute**
- Notify: **Immediately**

#### Alert 2: Credential Dumping

**Setup:**
- Name: "Credential Dumping Detected"
- Rule type: **Elasticsearch query**
- Query:
  ```json
  {
    "query": {
      "term": {
        "threat_detected": "credential_dumping"
      }
    }
  }
  ```
- Threshold: **above 0**

#### Alert 3: Multiple Failed Logins

**Setup:**
- Name: "Brute Force Attack"
- Rule type: **Elasticsearch query**
- Query:
  ```json
  {
    "query": {
      "bool": {
        "must": [
          {"term": {"winlog.event_id": 4625}},
          {"range": {"@timestamp": {"gte": "now-5m"}}}
        ]
      }
    }
  }
  ```
- Threshold: **above 5**

### Step 3: Configure Actions

Choose how to be notified:
- **Email** - Send email alert
- **Slack** - Post to Slack channel
- **Webhook** - Call external API
- **Index** - Write to Elasticsearch index

---

## Common Use Cases

### Use Case 1: Investigate Credential Dumping

**Scenario:** You need to find all credential dumping attempts.

**Steps:**
1. Go to **Discover**
2. Select index: `apt-detection-*`
3. Search: `threat_detected: "credential_dumping"`
4. Click on an event to see:
   - Source process (likely mimikatz.exe)
   - Target process (lsass.exe)
   - Host affected
   - Timestamp
5. Check if multiple hosts affected:
   ```
   threat_detected: "credential_dumping" 
   ```
   Then look at the `host.name` field in results

**Next Actions:**
- Isolate affected hosts
- Reset credentials
- Check for lateral movement from same hosts

### Use Case 2: Track Attacker Movement

**Scenario:** Track an attacker's progression through your network.

**Steps:**
1. Find initial compromise:
   ```
   host.name: "VICTIM-PC" AND threat_detected: *
   ```
2. Sort by `@timestamp` (ascending)
3. Look for sequence:
   - Reconnaissance → Credential Dumping → Lateral Movement
4. Identify target systems:
   ```
   threat_detected: "lateral_movement" AND source.ip: "VICTIM-PC-IP"
   ```

### Use Case 3: Analyze PowerShell Activity

**Scenario:** Investigate suspicious PowerShell usage.

**Steps:**
1. Search:
   ```
   process.name: "powershell.exe" AND threat_detected: *
   ```
2. Look for patterns:
   - Encoded commands (`-enc` parameter)
   - Download cradles (`Invoke-WebRequest`)
   - Execution (`Invoke-Expression`)
3. Check command line:
   - Expand event
   - Look at `winlog.event_data.CommandLine` field
4. Decode base64 if present:
   - Copy encoded string
   - Use external tool to decode

### Use Case 4: Monitor Data Exfiltration

**Scenario:** Detect large data transfers.

**Steps:**
1. Search:
   ```
   threat_detected: "data_exfiltration"
   ```
2. Check network traffic:
   ```
   network.bytes >= 10485760 AND network.direction: "outbound"
   ```
3. Identify destinations:
   - Look at `destination.ip` field
   - Check if IPs are external
4. Calculate total data:
   - Use **Metric** visualization
   - Aggregation: **Sum**
   - Field: `network.bytes`

### Use Case 5: Generate Security Report

**Scenario:** Create weekly security report for management.

**Steps:**
1. Set time range: "Last 7 days"
2. Create dashboard with:
   - Total threats detected
   - Breakdown by severity
   - Top 10 affected systems
   - MITRE techniques observed
   - Timeline of incidents
3. Click **"Share"** → **"Download as PDF"**
4. Send to stakeholders

### Use Case 6: Threat Hunting

**Scenario:** Proactively search for IOCs (Indicators of Compromise).

**Steps:**
1. Search for suspicious processes:
   ```
   process.name: ("psexec.exe" OR "mimikatz.exe" OR "procdump.exe")
   ```
2. Look for lateral movement patterns:
   ```
   winlog.event_id: 4624 AND winlog.event_data.LogonType: ("3" OR "10")
   ```
3. Check for persistence:
   ```
   winlog.event_id: (4698 OR 4702)  /* Scheduled tasks */
   ```
4. Investigate unusual network connections:
   ```
   network.protocol: "dns" AND network.bytes > 1000
   ```

---

## Tips and Best Practices

### Performance Tips

1. **Use specific time ranges** - Don't query "All time" if not needed
2. **Add filters** - Narrow down data before complex queries
3. **Limit result size** - Use "Size" option in visualizations
4. **Use index patterns wisely** - Query `apt-threats-*` for faster results

### Search Tips

1. **Use field suggestions** - Start typing, Kibana suggests fields
2. **Save common searches** - Click "Save" to reuse queries
3. **Use filters for exact matches** - Click "+" next to field values
4. **Exclude noise** - Use `NOT` to filter out known-good events

### Dashboard Tips

1. **Refresh automatically** - Set auto-refresh interval (top-right)
2. **Use drill-downs** - Click on chart elements to filter
3. **Export data** - Use "Inspect" → "Download CSV"
4. **Clone for modifications** - Duplicate dashboard before major changes

### Security Tips

1. **Don't ignore medium severity** - They can escalate
2. **Look for patterns** - Single events may be FPs, patterns are real
3. **Correlate with other data** - Cross-reference with firewall logs
4. **Document findings** - Use Kibana's "Notes" feature in dashboards

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `/` | Focus search bar |
| `Ctrl + /` | Open shortcuts help |
| `Ctrl + Enter` | Submit search |
| `Esc` | Clear search |
| `t` | Toggle time picker |
| `?` | Show help |

---

## Troubleshooting

### Problem: No Data in Discover

**Solution:**
1. Check time range (expand to "Last 7 days")
2. Verify index pattern exists
3. Run: `curl 'http://localhost:9200/apt-detection-*/_count'`
4. If 0 results, regenerate data: `cd scripts && ./generate-sample-apt-data.sh`

### Problem: Visualization Not Showing Data

**Solution:**
1. Check filters (clear all filters)
2. Verify field name (use autocomplete)
3. Check aggregation settings
4. Refresh browser

### Problem: Can't Create Index Pattern

**Solution:**
1. Wait 2-3 minutes for data to be indexed
2. Check if indices exist: `curl 'http://localhost:9200/_cat/indices'`
3. Restart Logstash: `docker-compose restart logstash`

### Problem: Kibana is Slow

**Solution:**
1. Reduce time range
2. Add more specific filters
3. Increase Docker memory allocation
4. Reduce visualization complexity

---

## Advanced Features

### Dev Tools Console

**Menu** → **Management** → **Dev Tools**

Run Elasticsearch queries directly:

```json
GET /apt-detection-*/_search
{
  "query": {
    "match": {
      "threat_detected": "credential_dumping"
    }
  }
}
```

### Saved Objects Management

Export/Import dashboards:

1. **Stack Management** → **Saved Objects**
2. Export selected objects
3. Import on another Kibana instance

### Canvas

Create infographic-style reports:

**Menu** → **Analytics** → **Canvas**

---

## Quick Reference Card

### Most Common Searches

```
# All threats
_exists_: threat_detected

# Critical only
severity: "critical"

# Specific host
host.name: "VICTIM-PC"

# Last hour threats
threat_detected: * AND @timestamp >= now-1h

# Credential dumping
threat_detected: "credential_dumping"

# Lateral movement
threat_detected: "lateral_movement"

# PowerShell threats
threat_detected: *powershell*

# MITRE T1003
mitre_technique: "T1003*"
```

### Common Time Ranges

- Last 15 minutes
- Last 1 hour
- Last 24 hours
- Last 7 days
- This month

---

## Next Steps

1. ✅ Create your first index pattern
2. ✅ Explore Discover with sample data
3. ✅ Create at least 3 visualizations
4. ✅ Build your first dashboard
5. ✅ Set up one alert
6. ✅ Practice threat hunting queries

---

## Additional Resources

- **Kibana Documentation:** https://www.elastic.co/guide/en/kibana/current/index.html
- **KQL Syntax:** https://www.elastic.co/guide/en/kibana/current/kuery-query.html
- **This Project's README:** `README.md`
- **Search Examples:** `SEARCH_EXAMPLES.md`
- **Detection Queries:** `DETECTION_QUERIES.md`

---

**🎉 You're now ready to use Kibana for APT Detection!**

**Happy Threat Hunting! 🔍🛡️**
