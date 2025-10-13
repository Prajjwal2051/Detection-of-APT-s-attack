# 📋 Detailed Guide: Creating Index Patterns in Kibana

## What Are Index Patterns?

**Index patterns** tell Kibana which Elasticsearch indices you want to explore and analyze. Think of them as "data sources" that connect Kibana's visualizations to your actual data in Elasticsearch.

For our APT Detection System, we need to create two index patterns:
1. **`apt-detection-*`** - Shows ALL events (normal logs + detected threats)
2. **`apt-threats-*`** - Shows ONLY detected threats (filtered for quick analysis)

---

## Prerequisites

Before you start:
- ✅ Kibana should be running at http://localhost:5601
- ✅ Elasticsearch should have data indexed
- ✅ You should see the Kibana home page

**Verify data exists:**
```bash
# Check if indices are created
curl 'http://localhost:9200/_cat/indices?v' | grep apt
```

You should see output like:
```
yellow open apt-detection-2025.10.14 ...
yellow open apt-threats-2025.10.14   ...
```

---

## Step-by-Step Guide with Visual Descriptions

### STEP 1: Open Kibana

Open your web browser and navigate to:
```
http://localhost:5601
```

**What you'll see:**
```
┌─────────────────────────────────────────────────────┐
│  [Elastic Logo]              [Help ?] [User Icon]   │
├─────────────────────────────────────────────────────┤
│                                                      │
│            Welcome to Elastic                        │
│                                                      │
│   [Analytics]  [Enterprise Search]  [Observability] │
│   [Security]   [Management]                          │
│                                                      │
│                                                      │
│   Quick Links:                                       │
│   • Add data                                         │
│   • Explore on my own                                │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**If you see a welcome screen:**
- Click **"Explore on my own"** button
- This takes you to the Kibana home page

---

### STEP 2: Open the Navigation Menu

**Action:** Click the **☰ hamburger icon** in the top-left corner

**Location:** Look for three horizontal lines (☰) at the very top-left of the screen

```
┌─────────────────────────────────────────────────────┐
│  ☰ [Elastic]                           [Help] [👤]  │  ← Click HERE
├─────────────────────────────────────────────────────┤
```

**What happens:**
A sidebar menu slides out from the left side:

```
┌─────────────────┐
│ ☰ Menu          │
├─────────────────┤
│ Analytics       │  ← Section 1
│   Discover      │
│   Dashboard     │
│   Visualize     │
│   Canvas        │
│   Maps          │
│                 │
│ Observability   │  ← Section 2
│   Logs          │
│   Metrics       │
│   APM           │
│                 │
│ Security        │  ← Section 3
│   Overview      │
│   Alerts        │
│                 │
│ Management      │  ← THIS ONE! Section 4
│   Dev Tools     │
│   Stack Mgmt    │
│   Fleet         │
│                 │
└─────────────────┘
```

---

### STEP 3: Navigate to Stack Management

**Action:** Scroll down in the menu and click **"Management"** section

You'll see this expand:

```
│ Management      │ ◄─ Click to expand
│   ▼             │
├─────────────────┤
│   Dev Tools     │
│   Stack Management    │ ◄─ Click THIS
│   Fleet         │
│   Integrations  │
└─────────────────┘
```

**Action:** Click on **"Stack Management"**

**What happens:**
The page changes to the Stack Management interface:

```
┌─────────────────────────────────────────────────────┐
│  ☰ Stack Management                                 │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Kibana                     │  Data                  │
│  ├─ Index Patterns          │  ├─ Index Management  │
│  ├─ Saved Objects           │  ├─ Index Lifecycle   │
│  ├─ Tags                    │  ├─ Snapshot & Restore│
│  ├─ Spaces                  │  └─ Rollup Jobs       │
│  ├─ Advanced Settings       │                        │
│  └─ Data Views              │  Ingest               │
│                             │  ├─ Ingest Pipelines   │
│  Alerts and Insights        │  └─ Logstash Pipelines│
│  ├─ Rules                   │                        │
│  ├─ Connectors              │  Security             │
│  └─ Cases                   │  ├─ Users             │
│                             │  ├─ Roles             │
│  Stack                      │  └─ API Keys          │
│  ├─ License Management      │                        │
│  └─ Upgrade Assistant       │                        │
│                             │                        │
└─────────────────────────────────────────────────────┘
```

---

### STEP 4: Click on "Index Patterns"

**Location:** Look under the **"Kibana"** section on the left side

**Action:** Click on **"Index Patterns"** or **"Data Views"** (newer Kibana versions call it "Data Views")

```
┌─────────────────────────────────────────────────────┐
│  ☰ Stack Management                                 │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Kibana                                              │
│  ├─ Index Patterns     ◄──── CLICK HERE             │
│  ├─ Saved Objects                                    │
│  ├─ Tags                                             │
│  └─ ...                                              │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**What happens:**
You'll see the Index Patterns management page:

```
┌─────────────────────────────────────────────────────┐
│  ☰ Index Patterns                                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  [Create index pattern]  ◄──── This button          │
│                                                      │
│  ┌─────────────────────────────────────────────┐   │
│  │  No index patterns yet                       │   │
│  │                                               │   │
│  │  Index patterns help you explore your data   │   │
│  │  in Kibana. Create your first pattern to     │   │
│  │  get started.                                 │   │
│  │                                               │   │
│  │  [Create index pattern]                       │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Note:** If you already have index patterns, you'll see a list instead of the empty state above.

---

### STEP 5: Click "Create Index Pattern"

**Action:** Click the blue **"Create index pattern"** button

**Location:** Either at the top of the page or in the center of the empty state

```
┌─────────────────────────────────────────────────────┐
│  [Create index pattern]  ◄──── CLICK THIS           │
├─────────────────────────────────────────────────────┤
```

**What happens:**
You're taken to the index pattern creation wizard:

```
┌─────────────────────────────────────────────────────┐
│  Create index pattern                                │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Step 1 of 2: Define an index pattern                │
│                                                      │
│  Index pattern name                                  │
│  ┌─────────────────────────────────────────────┐   │
│  │  [cursor blinking]                           │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
│  Use * to match multiple indices.                    │
│  Examples: logstash-*, my-index-*                   │
│                                                      │
│  Available indices:                                  │
│  • apt-detection-2025.10.14                         │
│  • apt-threats-2025.10.14                           │
│  • .kibana_*                                         │
│                                                      │
│  [Next step >]  (disabled until you type)           │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

### STEP 6: Type the Index Pattern Name

**Action:** In the text box, type exactly:
```
apt-detection-*
```

**Important:** 
- Use lowercase letters
- Include the asterisk (*) at the end
- The asterisk means "match all indices that start with apt-detection-"

**As you type:**

```
┌─────────────────────────────────────────────────────┐
│  Index pattern name                                  │
│  ┌─────────────────────────────────────────────┐   │
│  │  apt-detection-*                             │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
│  ✓ Success! Your index pattern matches:             │
│    • apt-detection-2025.10.14                       │
│    • apt-detection-2025.10.13                       │
│                                                      │
│  [Next step >]  ◄──── Now enabled!                  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**What you should see:**
- A green checkmark ✓ appears
- Text says "Success! Your index pattern matches"
- List of matching indices appears
- The "Next step" button becomes blue and clickable

**If you see an error:**
```
❌ No matching indices found.
```
**Solution:**
1. Check your spelling (should be `apt-detection-*`)
2. Verify data exists: Run `curl 'http://localhost:9200/_cat/indices' | grep apt`
3. If no indices exist, regenerate data: `cd scripts && ./generate-sample-apt-data.sh`

---

### STEP 7: Click "Next Step"

**Action:** Click the blue **"Next step >"** button at the bottom right

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│  [Cancel]                           [Next step >]   │
│                                      ↑              │
│                                  CLICK HERE         │
└─────────────────────────────────────────────────────┘
```

**What happens:**
You move to Step 2 - Configure settings:

```
┌─────────────────────────────────────────────────────┐
│  Create index pattern                                │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Step 2 of 2: Configure settings                     │
│                                                      │
│  Time field                                          │
│  ┌─────────────────────────────────────────────┐   │
│  │  @timestamp                              ▼  │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
│  This field will be used for time-based filtering.   │
│  If you don't want to use time-based events,         │
│  select "I don't want to use the time filter"        │
│                                                      │
│  Custom index pattern ID (optional)                  │
│  ┌─────────────────────────────────────────────┐   │
│  │  apt-detection-*                             │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
│  [< Back]              [Create index pattern]       │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

### STEP 8: Select Time Field

**What you'll see:**
A dropdown menu labeled **"Time field"**

**Default value:** Usually `@timestamp` is already selected

**Action:** 
- If `@timestamp` is already selected, you don't need to do anything
- If not, click the dropdown and select `@timestamp`

**Dropdown options:**
```
┌─────────────────────────────────┐
│  @timestamp            ◄─ SELECT THIS
│  event.created                  │
│  event.start                    │
│  I don't want to use time filter│
└─────────────────────────────────┘
```

**Why @timestamp?**
- This is the standard field that contains when each event occurred
- Required for timeline visualizations
- Enables time-based filtering (Last 24 hours, Last 7 days, etc.)

---

### STEP 9: Create the Index Pattern

**Action:** Click the blue **"Create index pattern"** button at the bottom right

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│  [< Back]              [Create index pattern]       │
│                                     ↑               │
│                                 CLICK HERE          │
└─────────────────────────────────────────────────────┘
```

**What happens:**
A success message appears and you're taken to the index pattern details page:

```
┌─────────────────────────────────────────────────────┐
│  ✓ Index pattern created: apt-detection-*           │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Index pattern: apt-detection-*                      │
│  Time field: @timestamp                              │
│                                                      │
│  Fields (showing 50 of 127)                          │
│  ┌─────────────────────────────────────────────┐   │
│  │ Name                  Type      Searchable   │   │
│  ├─────────────────────────────────────────────┤   │
│  │ @timestamp            date      ✓            │   │
│  │ agent.name            text      ✓            │   │
│  │ host.name             text      ✓            │   │
│  │ message               text      ✓            │   │
│  │ process.name          text      ✓            │   │
│  │ threat_detected       text      ✓            │   │
│  │ severity              keyword   ✓            │   │
│  │ mitre_technique       keyword   ✓            │   │
│  │ mitre_tactic          text      ✓            │   │
│  │ ...                                          │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Congratulations! 🎉** You've created your first index pattern!

---

### STEP 10: Repeat for Threats Index

**Action:** Now create a second index pattern for threats only

**Click the back arrow or navigate to:**
- **Menu (☰)** → **Management** → **Stack Management** → **Index Patterns**

**You'll now see:**
```
┌─────────────────────────────────────────────────────┐
│  Index Patterns                  [Create pattern]   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Name                    Time field    Default      │
│  ┌─────────────────────────────────────────────┐   │
│  │ apt-detection-*      @timestamp      ⭐      │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
│  [Create index pattern]                              │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Action:** Click **"Create index pattern"** again

---

### STEP 11: Create Second Index Pattern

**Repeat steps 5-9, but this time:**

**Step 6 - Type:**
```
apt-threats-*
```

**Step 7 - Click:** "Next step"

**Step 8 - Select:** `@timestamp`

**Step 9 - Click:** "Create index pattern"

**Result:**
```
┌─────────────────────────────────────────────────────┐
│  ✓ Index pattern created: apt-threats-*             │
└─────────────────────────────────────────────────────┘
```

---

### STEP 12: Verify Both Patterns Exist

**Navigate back to:** Index Patterns page

**You should now see:**
```
┌─────────────────────────────────────────────────────┐
│  Index Patterns                  [Create pattern]   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Name                    Time field    Default      │
│  ┌─────────────────────────────────────────────┐   │
│  │ apt-detection-*      @timestamp      ⭐      │   │
│  │ apt-threats-*        @timestamp               │   │
│  └─────────────────────────────────────────────┘   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Perfect!** ✅ Both index patterns are created!

---

## What Each Index Pattern Shows

### `apt-detection-*` - All Events

**Contains:**
- Normal log events (e.g., regular Windows logins, network traffic)
- Detected threats (Mimikatz, lateral movement, etc.)
- Total: ~3,700+ documents

**Use for:**
- General investigation
- Looking at context around threats
- Finding patterns in all activity

**Example query:**
```
host.name: "VICTIM-PC"
```
Shows all activity on that host, both normal and malicious.

---

### `apt-threats-*` - Threats Only

**Contains:**
- Only events with detected threats
- Pre-filtered for quick analysis
- Total: ~50-100 documents (the actual threats)

**Use for:**
- Quick threat overview
- Security dashboards
- Incident response
- Threat hunting

**Example query:**
```
severity: "critical"
```
Shows only critical-severity threats.

---

## What's Next?

Now that you have index patterns, you can:

### 1. Explore Data in Discover

**Navigation:** Menu (☰) → Analytics → Discover

**Steps:**
1. Select `apt-detection-*` from the dropdown (top-left)
2. You'll see all your security events
3. Try searching: `threat_detected: "credential_dumping"`

---

### 2. Create Visualizations

**Navigation:** Menu (☰) → Analytics → Visualize Library

**Examples:**
- Pie chart: Threat distribution
- Bar chart: Threats over time
- Table: Top affected hosts

---

### 3. Build a Dashboard

**Navigation:** Menu (☰) → Analytics → Dashboard

**Steps:**
1. Click "Create dashboard"
2. Add visualizations
3. Arrange and save

---

## Troubleshooting

### Problem: "No matching indices found"

**Cause:** Elasticsearch doesn't have data yet

**Solution:**
```bash
# Check if indices exist
curl 'http://localhost:9200/_cat/indices?v' | grep apt

# If nothing appears, regenerate data
cd /home/prajjwal25/Desktop/Coding/Detection-of-APT-s-attack/scripts
./generate-sample-apt-data.sh

# Wait 30 seconds for indexing
sleep 30

# Check again
curl 'http://localhost:9200/_cat/indices?v' | grep apt
```

---

### Problem: Can't find "Index Patterns" option

**Cause:** Using a newer version of Kibana

**Solution:** Look for **"Data Views"** instead of "Index Patterns" - they're the same thing

**Navigation:**
- Menu (☰) → Management → Stack Management → **Data Views**

---

### Problem: @timestamp field not available

**Cause:** Data hasn't been indexed properly

**Solution:**
```bash
# Check if data has timestamp field
curl -s 'http://localhost:9200/apt-detection-*/_search?size=1&pretty' | grep timestamp

# Should see: "@timestamp": "2025-10-14T..."

# If not, restart Logstash
docker-compose restart logstash

# Wait 1 minute and try again
```

---

### Problem: Index pattern created but shows 0 documents

**Cause:** Time range too narrow

**Solution:**
1. Click the **time picker** (top-right in Kibana)
2. Select **"Last 7 days"** or **"Last 30 days"**
3. Data should appear

---

## Quick Verification Commands

Run these in your terminal to verify everything is working:

```bash
# Check Kibana is running
curl -s http://localhost:5601/api/status | grep "available"
# Should return: "available"

# Check Elasticsearch health
curl -s http://localhost:9200/_cluster/health | grep "status"
# Should return: "yellow" or "green"

# Count documents in apt-detection index
curl -s 'http://localhost:9200/apt-detection-*/_count?pretty'
# Should show: "count": 3700+ (or similar)

# Count documents in apt-threats index
curl -s 'http://localhost:9200/apt-threats-*/_count?pretty'
# Should show: "count": 50+ (or similar)

# List all index patterns (via API)
curl -s 'http://localhost:5601/api/saved_objects/_find?type=index-pattern&per_page=100' | grep title
# Should show: apt-detection-* and apt-threats-*
```

---

## Visual Checklist

Use this checklist to confirm you've completed all steps:

- [ ] Opened Kibana at http://localhost:5601
- [ ] Clicked the ☰ menu icon
- [ ] Navigated to Management → Stack Management
- [ ] Clicked "Index Patterns" (or "Data Views")
- [ ] Clicked "Create index pattern"
- [ ] Typed `apt-detection-*`
- [ ] Saw green checkmark and matching indices
- [ ] Clicked "Next step"
- [ ] Selected `@timestamp` as time field
- [ ] Clicked "Create index pattern"
- [ ] Saw success message
- [ ] Repeated process for `apt-threats-*`
- [ ] Verified both patterns exist in the list

---

## Summary

You've now successfully created two index patterns:

| Pattern | Purpose | Doc Count |
|---------|---------|-----------|
| `apt-detection-*` | All events (normal + threats) | ~3,700+ |
| `apt-threats-*` | Threats only | ~50-100 |

**What you can do now:**
- ✅ Search and explore data in Discover
- ✅ Create visualizations and charts
- ✅ Build security dashboards
- ✅ Set up alerts for threats
- ✅ Perform threat hunting

**Next steps:**
1. Read: `KIBANA_USAGE_GUIDE.md` for detailed usage
2. Try: Sample queries in `SEARCH_EXAMPLES.md`
3. Build: Your first dashboard

---

## Additional Resources

- **Complete Kibana Guide:** `KIBANA_USAGE_GUIDE.md`
- **Search Examples:** `SEARCH_EXAMPLES.md`
- **Project Overview:** `README.md`
- **Detection Rules:** `DETECTION_QUERIES.md`

---

**🎉 Congratulations! You're ready to start threat hunting!** 🔍🛡️
