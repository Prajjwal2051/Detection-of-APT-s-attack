# 🎯 Quick Demo Cheat Sheet - APT Detection System

## ⚡ 5-Minute Demo Script

### 1. Introduction (30 sec)
**SAY:** "APT Detection System using ELK Stack. Detects multi-stage attacks mapped to MITRE ATT&CK."

### 2. Show Architecture (30 sec)
**SHOW:** README.md diagram
**SAY:** "Beats collect logs → Logstash detects threats → Elasticsearch stores → Kibana visualizes"

### 3. Live Detection (2 min)
**DO:** Open http://localhost:5601 → Analytics → Discover → apt-threats-*
**SEARCH:** `severity: "critical"`
**SAY:** "Real-time critical threats: credential dumping, data exfiltration"

### 4. Show Details (1 min)
**DO:** Click on credential_dumping event
**SHOW:** MITRE T1003.001, severity, host, process
**SAY:** "Each event tagged with MITRE technique for incident response"

### 5. Show Coverage (1 min)
**SAY:** "Detects 5 attack stages: Reconnaissance → Credential Theft → Lateral Movement → Execution → Exfiltration"

---

## 🔍 Key Search Queries

```
# All threats
_exists_: threat_detected

# Critical only
severity: "critical"

# Credential dumping
threat_detected: "credential_dumping"

# Lateral movement
threat_detected: "lateral_movement"

# Specific host
host.name: "VICTIM-PC"

# MITRE technique
mitre_technique: "T1003.001"

# PowerShell threats
threat_detected: *powershell*

# Multiple types
threat_detected: ("credential_dumping" OR "lateral_movement")
```

---

## 🚀 Quick Setup Commands

```bash
# Start system
./start.sh

# Check status
docker-compose ps

# Verify data
curl 'http://localhost:9200/apt-*/_count?pretty'

# Access Kibana
http://localhost:5601

# Emergency data insert
curl -X POST "http://localhost:9200/apt-threats-$(date +%Y.%m.%d)/_doc" \
  -H 'Content-Type: application/json' -d'{
  "@timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "threat_detected": "credential_dumping",
  "severity": "critical",
  "mitre_technique": "T1003.001",
  "host": {"name": "DEMO-PC"},
  "message": "Mimikatz detected"
}'
```

---

## 📊 Demo Flow Options

### Option A: Threat-Focused (Best for Security Audience)
1. Show credential dumping (Mimikatz)
2. Show lateral movement (RDP)
3. Show data exfiltration
4. Explain MITRE mapping

### Option B: Attack Chain (Best for Technical Audience)
1. Reconnaissance on VICTIM-PC
2. Credential theft (same host)
3. Lateral movement to DC01
4. Data exfiltration
5. Show complete timeline

### Option C: Features-Focused (Best for General Audience)
1. Real-time detection
2. Search capabilities
3. Visualization
4. MITRE framework integration

---

## 🎯 Key Points to Mention

✅ **Open-source solution** (no licensing costs)
✅ **MITRE ATT&CK aligned** (industry standard)
✅ **Real-time detection** (immediate alerts)
✅ **Scalable architecture** (Docker containers)
✅ **Extensible** (add custom rules)
✅ **Production-ready design** (ELK Stack proven at scale)

---

## 🛠️ Troubleshooting Quick Fixes

### No data showing?
1. Change time range to "Last 30 days"
2. Check: `curl 'http://localhost:9200/_cat/indices' | grep apt`
3. Restart: `docker-compose restart logstash filebeat`

### Kibana not loading?
1. Wait 1 minute (might still be starting)
2. Check: `docker-compose ps kibana`
3. Restart: `docker-compose restart kibana`

### Index pattern error?
1. Go to: Management → Stack Management → Index Patterns
2. Create: `apt-detection-*` with `@timestamp`
3. Create: `apt-threats-*` with `@timestamp`

---

## 💬 Answer Common Questions

**Q: How does it compare to Splunk?**
A: Same core functionality, open-source, can integrate with Splunk

**Q: False positives?**
A: Tunable rules, severity levels, correlation reduces FPs

**Q: Can it scale?**
A: Yes, ELK Stack used by Netflix, Uber, LinkedIn for massive scale

**Q: Real APT detection?**
A: Uses proven MITRE techniques, tested with real attack simulations

**Q: Integration?**
A: Accepts syslog, forwards to SIEM/SOAR, Slack/email alerts

---

## 📱 URLs to Have Ready

- **Kibana:** http://localhost:5601
- **GitHub:** https://github.com/Prajjwal2051/Detection-of-APT-s-attack
- **MITRE ATT&CK:** https://attack.mitre.org/
- **Your docs:** README.md, DEMO_GUIDE.md

---

## ⏱️ Time Allocation

**5-min demo:** 30s intro + 2m live demo + 1m features + 1m Q&A
**10-min demo:** 1m intro + 5m live demo + 2m technical + 2m Q&A
**20-min demo:** 2m problem + 3m solution + 8m live demo + 5m technical + 2m Q&A

---

## 🎬 Demo Opening Lines

**Option 1 (Impact):**
> "APT attacks cost organizations millions. This system detects them in real-time using MITRE ATT&CK techniques."

**Option 2 (Technical):**
> "I've built a threat detection platform using ELK Stack that monitors security events and identifies multi-stage APT attacks."

**Option 3 (Problem-Solution):**
> "Traditional security tools miss APT attacks because they happen slowly over time. This system correlates events across the attack chain."

---

## 🎯 Demo Closing Lines

**Option 1 (Call to Action):**
> "All code is on GitHub. The system is modular and ready for production deployment. Questions?"

**Option 2 (Impact):**
> "This demonstrates how open-source tools can provide enterprise-grade threat detection. Thank you!"

**Option 3 (Future):**
> "Future enhancements include ML-based anomaly detection and automated response. I'm happy to discuss technical details."

---

## 📋 Pre-Demo Checklist (Print This!)

**1 Day Before:**
- [ ] Test full system on demo machine
- [ ] Practice demo script 3 times
- [ ] Prepare backup (screenshots/video)
- [ ] Charge laptop

**1 Hour Before:**
- [ ] Run `./start.sh`
- [ ] Verify all services up
- [ ] Create index patterns
- [ ] Test searches
- [ ] Close unnecessary apps

**5 Minutes Before:**
- [ ] Open Kibana tab
- [ ] Open GitHub tab
- [ ] Open terminal
- [ ] Enable Do Not Disturb
- [ ] Deep breath 😊

---

## 🌟 Confidence Boosters

- You built this system from scratch ✓
- You understand every component ✓
- You've tested it thoroughly ✓
- You have backup plans ✓
- You're prepared for questions ✓

**You've got this! 🚀**

---

## Emergency Contact Info

**If demo machine fails:**
- Have backup laptop ready
- Use screenshots/video
- Explain architecture verbally
- Show code on GitHub

**If internet fails:**
- Everything runs locally (no internet needed!)
- Just can't show GitHub live
- Have repo cloned locally

**If time runs short:**
- Skip technical details
- Focus on live demo
- Show most impressive features
- Offer to follow up via email

---

## 🎤 Presentation Tips

1. **Start strong** - Show the cool stuff first
2. **Speak slowly** - Let concepts sink in
3. **Make eye contact** - Engage with audience
4. **Use analogies** - "Like a security camera for your network"
5. **Show passion** - Your enthusiasm matters!
6. **Pause for questions** - Make it interactive
7. **End with impact** - Leave them impressed

---

**Remember:** The best demo is the one that tells a story! 📖

**Good luck! Break a leg! 🎭**
