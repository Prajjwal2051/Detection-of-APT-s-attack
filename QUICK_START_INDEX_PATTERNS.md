# 🚀 Quick Start: Create Index Patterns in Kibana

## TL;DR - Visual Steps

```
Step 1: Open Kibana
        http://localhost:5601
        
Step 2: Click ☰ Menu → Management → Stack Management

Step 3: Click "Index Patterns" (under Kibana section)

Step 4: Click "Create index pattern" button

Step 5: Type: apt-detection-*
        Click "Next step"
        
Step 6: Select time field: @timestamp
        Click "Create index pattern"
        
Step 7: Repeat for: apt-threats-*
```

---

## Visual Navigation Map

```
Kibana Home Page
        ↓
Click ☰ (top-left corner)
        ↓
┌─────────────────────┐
│ Menu                │
│ ├─ Analytics        │
│ ├─ Observability    │
│ └─ Management       │ ← Click here
│     └─ Stack Mgmt   │ ← Then click here
└─────────────────────┘
        ↓
┌──────────────────────────────────┐
│ Stack Management                 │
│                                  │
│ Kibana Section:                  │
│ ├─ Index Patterns   ← Click!    │
│ ├─ Saved Objects                 │
│ └─ Tags                          │
└──────────────────────────────────┘
        ↓
┌──────────────────────────────────┐
│ Index Patterns                   │
│                                  │
│ [Create index pattern] ← Click!  │
└──────────────────────────────────┘
        ↓
┌──────────────────────────────────┐
│ Step 1 of 2: Define pattern     │
│                                  │
│ Index pattern name:              │
│ ┌────────────────────────────┐  │
│ │ apt-detection-*            │  │ ← Type this
│ └────────────────────────────┘  │
│                                  │
│ ✓ Success! Pattern matches       │
│                                  │
│ [Next step >] ← Click!           │
└──────────────────────────────────┘
        ↓
┌──────────────────────────────────┐
│ Step 2 of 2: Configure settings  │
│                                  │
│ Time field:                      │
│ ┌────────────────────────────┐  │
│ │ @timestamp           ▼     │  │ ← Select this
│ └────────────────────────────┘  │
│                                  │
│ [Create index pattern] ← Click!  │
└──────────────────────────────────┘
        ↓
┌──────────────────────────────────┐
│ ✓ Index pattern created!         │
│                                  │
│ apt-detection-*                  │
│ Time field: @timestamp           │
└──────────────────────────────────┘
```

---

## What You Type

### First Index Pattern
```
Name: apt-detection-*
Time field: @timestamp
```

### Second Index Pattern  
```
Name: apt-threats-*
Time field: @timestamp
```

---

## Success Indicators

### ✅ Pattern is correct when you see:
```
✓ Success! Your index pattern matches:
  • apt-detection-2025.10.14
  • apt-detection-2025.10.13
```

### ❌ Error if you see:
```
❌ No matching indices found.
```
**Fix:** Make sure data is indexed first (see troubleshooting below)

---

## After Creating Patterns

### Verify Both Exist

**Location:** Stack Management → Index Patterns

**You should see:**
```
┌──────────────────────────────────────┐
│ Name              Time field  Default │
├──────────────────────────────────────┤
│ apt-detection-*   @timestamp    ⭐    │
│ apt-threats-*     @timestamp          │
└──────────────────────────────────────┘
```

---

## Quick Troubleshooting

### If "No matching indices found":

```bash
# Check if data exists
curl 'http://localhost:9200/_cat/indices?v' | grep apt

# If nothing appears, regenerate data
cd scripts
./generate-sample-apt-data.sh

# Wait 2 minutes for processing
sleep 120

# Restart Logstash to force processing
docker-compose restart logstash filebeat

# Wait another minute
sleep 60

# Check again
curl 'http://localhost:9200/_cat/indices?v' | grep apt
```

### If data still doesn't appear:

```bash
# Check Logstash is processing
docker-compose logs logstash | grep -i "pipeline started"

# Check Filebeat is running
docker-compose logs filebeat | grep -i "publish"

# View sample data files
ls -lh sample-data/

# Manual data ingestion (if needed)
curl -X POST "localhost:9200/apt-detection-$(date +%Y.%m.%d)/_doc" \
  -H 'Content-Type: application/json' \
  -d @sample-data/apt-events.json
```

---

## What's Next?

Once patterns are created:

### 1. Go to Discover
```
☰ Menu → Analytics → Discover
```

### 2. Select Index Pattern
```
Click dropdown (top-left) → apt-detection-*
```

### 3. Search for Threats
```
threat_detected: "credential_dumping"
```

---

## Common Clicks You'll Make

| Action | Where | What |
|--------|-------|------|
| Open menu | Top-left ☰ | Click |
| Select index | Dropdown near search | apt-detection-* |
| Search | Top search bar | Type query |
| Expand event | Left arrow (▶) | Click |
| Filter time | Top-right clock icon | Select range |
| Add filter | "+ Add filter" button | Click |

---

## Button Colors Guide

| Color | Means | Example |
|-------|-------|---------|
| 🔵 Blue | Primary action | "Create index pattern" |
| ⚪ Gray | Disabled | "Next step" (before typing) |
| 🔴 Red | Delete/Danger | "Delete pattern" |
| 🟢 Green | Success | ✓ Success message |

---

## Keyboard Shortcuts

While in Kibana:

| Key | Action |
|-----|--------|
| `/` | Focus search bar |
| `Ctrl + Enter` | Run search |
| `Esc` | Close panels |
| `t` | Toggle time picker |

---

## Time Estimates

| Task | Time |
|------|------|
| Open Kibana | 5 seconds |
| Navigate to Index Patterns | 15 seconds |
| Create first pattern | 30 seconds |
| Create second pattern | 20 seconds |
| **Total** | **~1-2 minutes** |

---

## Visual Checklist

Print this and check off as you go:

```
□ Opened http://localhost:5601
□ Clicked ☰ menu icon
□ Clicked Management
□ Clicked Stack Management  
□ Clicked Index Patterns
□ Clicked Create index pattern
□ Typed: apt-detection-*
□ Saw green ✓ checkmark
□ Clicked Next step
□ Selected @timestamp
□ Clicked Create index pattern
□ Saw success message
□ Repeated for apt-threats-*
□ Verified both patterns in list
```

---

## Screenshots of Key Screens

### Screen 1: Kibana Home
```
┌─────────────────────────────────┐
│ ☰ Elastic              ? 👤    │ ← Click ☰ here
├─────────────────────────────────┤
│                                 │
│    Welcome to Elastic           │
│                                 │
└─────────────────────────────────┘
```

### Screen 2: Stack Management
```
┌─────────────────────────────────┐
│ ☰ Stack Management              │
├─────────────────────────────────┤
│ Kibana                          │
│ ├─ Index Patterns  ← HERE       │
│ ├─ Saved Objects                │
│ └─ Tags                         │
└─────────────────────────────────┘
```

### Screen 3: Create Pattern
```
┌─────────────────────────────────┐
│ Create index pattern            │
├─────────────────────────────────┤
│ Index pattern name:             │
│ ┌─────────────────────────┐    │
│ │ apt-detection-*         │    │
│ └─────────────────────────┘    │
│ ✓ Success! Pattern matches      │
└─────────────────────────────────┘
```

---

## Pro Tips

1. **Copy-paste is your friend** - Copy `apt-detection-*` exactly
2. **Watch for the checkmark** - Green ✓ means it's working
3. **@timestamp is always right** - It's the standard time field
4. **Create both patterns** - You'll need both for full analysis
5. **Bookmark Kibana** - You'll use it often

---

## Summary

**Two patterns to create:**

1. `apt-detection-*` with `@timestamp` ← All events
2. `apt-threats-*` with `@timestamp` ← Threats only

**Total time:** 1-2 minutes

**What you get:** Ability to search, visualize, and analyze APT threats!

---

## Need More Help?

📖 **Detailed guides:**
- `KIBANA_INDEX_PATTERN_SETUP.md` - Complete visual guide
- `KIBANA_USAGE_GUIDE.md` - How to use Kibana
- `README.md` - Project overview

🔧 **If stuck:**
```bash
# Check system status
docker-compose ps

# View logs
docker-compose logs kibana
docker-compose logs elasticsearch

# Restart everything
docker-compose restart
```

---

**Good luck! You've got this! 🎉**
