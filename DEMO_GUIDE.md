# 🎬 Complete Demo Guide: APT Detection System Prototype

## 📋 Table of Contents
1. [Pre-Demo Setup](#pre-demo-setup)
2. [Quick Start Demo (5 minutes)](#quick-start-demo-5-minutes)
3. [Full Demo Presentation (15-20 minutes)](#full-demo-presentation-15-20-minutes)
4. [Live Demonstration Script](#live-demonstration-script)
5. [Key Features to Highlight](#key-features-to-highlight)
6. [Demo Scenarios](#demo-scenarios)
7. [Troubleshooting During Demo](#troubleshooting-during-demo)
8. [Questions & Answers](#questions--answers)

---

## 🚀 Pre-Demo Setup

### 1. One Day Before Demo

**System Requirements Check:**
```bash
# Verify Docker is installed
docker --version
docker-compose --version

# Check system resources
free -h        # At least 4GB RAM free
df -h          # At least 10GB disk space free

# Test internet connectivity (for pulling images)
ping -c 3 google.com
```

**Clone/Setup Project:**
```bash
# If presenting on a new machine
git clone https://github.com/Prajjwal2051/Detection-of-APT-s-attack.git
cd Detection-of-APT-s-attack

# Make scripts executable
chmod +x start.sh scripts/*.sh
```

---

### 2. Morning of Demo (30 minutes before)

**Start the System:**
```bash
# Navigate to project directory
cd /path/to/Detection-of-APT-s-attack

# Start everything
./start.sh

# This will:
# ✓ Check requirements
# ✓ Start ELK Stack
# ✓ Generate sample data
# ✓ Create dashboards
```

**Verify Everything is Running:**
```bash
# Check all services are up
docker-compose ps

# Should show all services as "Up" or "healthy"

# Test Elasticsearch
curl http://localhost:9200

# Test Kibana (wait for "available" status)
curl http://localhost:5601/api/status | grep available
```

**Verify Data Exists:**
```bash
# Check indices
curl 'http://localhost:9200/_cat/indices?v' | grep apt

# Count documents
curl 'http://localhost:9200/apt-detection-*/_count?pretty'
curl 'http://localhost:9200/apt-threats-*/_count?pretty'
```

**If No Data, Run:**
```bash
cd scripts
./generate-sample-apt-data.sh

# Manually create indices (if needed)
bash << 'EOF'
curl -X POST "http://localhost:9200/apt-detection-$(date +%Y.%m.%d)/_doc" \
  -H 'Content-Type: application/json' -d'{
  "@timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "host": {"name": "VICTIM-PC"},
  "process": {"name": "mimikatz.exe"},
  "threat_detected": "credential_dumping",
  "mitre_technique": "T1003.001",
  "severity": "critical",
  "message": "Mimikatz detected accessing LSASS"
}'
EOF
```

**Create Index Patterns in Kibana:**
```
1. Open: http://localhost:5601
2. Go to: Management → Stack Management → Index Patterns
3. Create: apt-detection-*
4. Create: apt-threats-*
```

**Bookmark Important URLs:**
- Kibana: http://localhost:5601
- Elasticsearch: http://localhost:9200
- Project GitHub: https://github.com/Prajjwal2051/Detection-of-APT-s-attack

---

## ⚡ Quick Start Demo (5 minutes)

Perfect for short presentations or quick walkthroughs.

### Script:

**[SLIDE 1: Introduction - 30 seconds]**

> "I've built an APT Detection System using the ELK Stack that can detect and analyze Advanced Persistent Threat attacks in real-time. This system monitors security events and identifies malicious activities mapped to the MITRE ATT&CK framework."

**[DEMO 1: Show System Architecture - 1 minute]**

Open `README.md` and show the architecture diagram:

```
Data Sources → Beats → Logstash → Elasticsearch → Kibana
     ↓            ↓         ↓            ↓            ↓
  Windows      Collect   Detect      Store      Visualize
   Linux       Network   Threats     Index      Analyze
```

**[DEMO 2: Live Detection - 2 minutes]**

Open Kibana (http://localhost:5601):

```
1. Click: Analytics → Discover
2. Select: apt-threats-*
3. Show: All detected threats on screen
4. Point out: threat_detected, severity, mitre_technique fields
```

**Search Query:**
```
severity: "critical"
```

**Say:** 
> "Here we see real-time critical threats including credential dumping and data exfiltration. Each event is tagged with MITRE ATT&CK technique IDs for incident response."

**[DEMO 3: Show MITRE Coverage - 1 minute]**

Search:
```
_exists_: mitre_technique
```

**Click on a document, show:**
- MITRE Technique: T1003.001
- Tactic: Credential Access
- Severity: Critical
- Host affected
- Process details

**[DEMO 4: Quick Stats - 30 seconds]**

**Say:**
> "The system has detected:
> - X credential dumping attempts
> - Y lateral movement activities
> - Z data exfiltration events
> All mapped to MITRE ATT&CK framework across 6 major tactics."

**[CLOSING - 30 seconds]**

> "This demonstrates a working threat detection system that can be deployed in enterprise environments for real-time APT monitoring. All code is available on GitHub."

---

## 🎯 Full Demo Presentation (15-20 minutes)

### Presentation Structure

#### Part 1: Problem Statement (2 minutes)

**SAY:**
> "Advanced Persistent Threats (APTs) are sophisticated, long-term cyberattacks where attackers establish a foothold in a network and remain undetected for months or years. Traditional security tools often miss these attacks because:
> 
> 1. APTs use multiple stages (reconnaissance → credential theft → lateral movement → exfiltration)
> 2. Attackers use legitimate tools to blend in
> 3. Activities happen slowly over time
> 
> Organizations need a way to detect and correlate these multi-stage attacks."

**SHOW:** Statistics or news headlines about APT attacks (have a slide ready)

---

#### Part 2: Solution Overview (3 minutes)

**SAY:**
> "I've developed an APT Detection System using the ELK Stack that:
> 
> ✓ Collects logs from multiple sources (Windows, Linux, Network)
> ✓ Applies detection rules based on MITRE ATT&CK framework
> ✓ Correlates events across different attack stages
> ✓ Provides real-time visualization and alerting
> ✓ Enables threat hunting and incident response"

**SHOW:** Architecture diagram from README.md

**EXPLAIN each component:**
- **Beats**: Lightweight data collectors
- **Logstash**: Data processing with threat detection logic
- **Elasticsearch**: Fast search and storage
- **Kibana**: Visualization and analysis interface

---

#### Part 3: MITRE ATT&CK Coverage (2 minutes)

**SHOW:** Table from README.md

**SAY:**
> "The system detects attacks mapped to MITRE ATT&CK framework, covering:
> 
> - **Credential Access** (T1003): Mimikatz, LSASS dumping
> - **Discovery** (T1087, T1082): Reconnaissance activities
> - **Lateral Movement** (T1021): RDP, SMB, PSExec
> - **Execution** (T1059): PowerShell abuse
> - **Exfiltration** (T1041): Large data transfers
> 
> This provides comprehensive coverage of the APT attack lifecycle."

---

#### Part 4: Live Demo - Detection (8 minutes)

**DEMO 1: Access Kibana**
```
Open: http://localhost:5601
```

**SAY:**
> "This is Kibana, our analysis interface. Let me show you detected threats."

---

**DEMO 2: View All Threats**
```
Click: Analytics → Discover
Select: apt-threats-*
```

**SAY:**
> "These are all detected APT activities. Each event has been analyzed and tagged by our detection engine."

**Point out:**
- Timeline showing when attacks occurred
- List of threat events
- Available fields on the left

---

**DEMO 3: Credential Dumping Detection**

**Type in search bar:**
```
threat_detected: "credential_dumping"
```

**Click on a result, expand it**

**SAY:**
> "Here's a credential dumping attack. Notice:
> - **Process**: mimikatz.exe
> - **Target**: lsass.exe (Windows credential store)
> - **MITRE ID**: T1003.001 (LSASS Memory)
> - **Severity**: Critical
> - **Timestamp**: When it occurred
> 
> This is a classic APT technique for stealing credentials."

---

**DEMO 4: Lateral Movement Detection**

**Search:**
```
threat_detected: "lateral_movement"
```

**Expand a document**

**SAY:**
> "After stealing credentials, attackers move laterally across the network. This event shows:
> - **Logon Type**: 10 (Remote Desktop)
> - **MITRE ID**: T1021.001 (RDP)
> - **Source/Target**: Shows movement path
> 
> This helps us track the attacker's progression through our network."

---

**DEMO 5: Data Exfiltration Detection**

**Search:**
```
threat_detected: "data_exfiltration"
```

**SAY:**
> "Finally, we detect data exfiltration:
> - **Transfer Size**: 50+ MB
> - **Direction**: Outbound
> - **Destination**: External IP
> - **MITRE ID**: T1041
> 
> This indicates the attacker is stealing data from the organization."

---

**DEMO 6: Search by Severity**

**Search:**
```
severity: "critical"
```

**SAY:**
> "We can filter by severity to prioritize incident response. Critical threats require immediate action."

---

**DEMO 7: Search by Host**

**Search:**
```
host.name: "VICTIM-PC"
```

**SAY:**
> "We can also view all activities on a specific host to understand the full attack chain on that machine."

---

**DEMO 8: Time-based Analysis**

**Click time picker (top-right)**
**Select: Last 24 hours**

**SAY:**
> "Time-based filtering helps us understand attack timelines and identify patterns."

---

#### Part 5: Advanced Features (2 minutes)

**DEMO: Create a Quick Visualization**

```
1. From Discover, click "Visualize" button
2. Select: Pie Chart
3. Choose: threat_detected.keyword
4. Click: Update
```

**SAY:**
> "We can quickly create visualizations to understand threat distribution. This pie chart shows the breakdown of different attack types."

**SHOW:** How it looks

---

**DEMO: Show Field Statistics**

**Click on field name: `severity`**
**Show the breakdown**

**SAY:**
> "Kibana provides instant statistics on any field. Here we see the distribution of severity levels across all threats."

---

#### Part 6: Technical Implementation (2 minutes)

**Open Terminal**

**Show docker-compose.yml:**
```bash
cat docker-compose.yml | head -30
```

**SAY:**
> "The system is fully containerized using Docker Compose, making it easy to deploy and scale."

**Show detection rules:**
```bash
cat logstash/pipeline/beats-input.conf | grep -A 10 "credential_dumping"
```

**SAY:**
> "Detection logic is implemented in Logstash using pattern matching and regular expressions. For example, here's how we detect Mimikatz..."

**Show sample data:**
```bash
cat sample-data/credential-dumping.log
```

**SAY:**
> "This is sample log data simulating real APT attacks for testing and demonstration."

---

#### Part 7: Use Cases & Benefits (2 minutes)

**SAY:**
> "This system provides several key benefits:
> 
> **1. Real-time Detection**: Immediate alerts when APT activities are detected
> 
> **2. Threat Hunting**: Security analysts can search for indicators of compromise
> 
> **3. Incident Response**: Complete timeline of attack activities for investigation
> 
> **4. Compliance**: Demonstrates security monitoring for audits
> 
> **5. Training**: Security teams can learn APT techniques and detection methods
> 
> **6. Cost-effective**: Uses open-source tools, no expensive licenses"

---

#### Part 8: Q&A and Closing (2 minutes)

**SAY:**
> "The complete code is available on GitHub. The system is modular and can be extended with:
> - Additional detection rules
> - Integration with SIEM platforms
> - Machine learning for anomaly detection
> - Custom dashboards and reports
> 
> Questions?"

---

## 🎭 Live Demonstration Script

### Full Scenario: Detecting a Multi-Stage APT Attack

**Setup (2 minutes):**

**SAY:**
> "Let me demonstrate how this system detects a complete APT attack chain. Imagine an attacker has gained initial access to our network. Watch how the system detects each stage."

---

**Stage 1: Reconnaissance (1 minute)**

**Search:**
```
threat_detected: "reconnaissance"
```

**Click on event, show:**
- Command: `net user /domain`
- Host: VICTIM-PC

**SAY:**
> "The attacker starts by enumerating domain users to identify high-value targets."

---

**Stage 2: Credential Theft (1 minute)**

**Search:**
```
threat_detected: "credential_dumping" AND host.name: "VICTIM-PC"
```

**Show:**
- Mimikatz execution
- LSASS access

**SAY:**
> "Next, they use Mimikatz to steal credentials from memory. This is immediately detected and flagged as critical."

---

**Stage 3: Lateral Movement (1 minute)**

**Search:**
```
threat_detected: "lateral_movement"
```

**Show:**
- RDP logon from VICTIM-PC to DC01

**SAY:**
> "Using stolen credentials, the attacker moves laterally to the domain controller. We detect the unusual RDP connection."

---

**Stage 4: Data Exfiltration (1 minute)**

**Search:**
```
threat_detected: "data_exfiltration"
```

**Show:**
- Large data transfer
- External destination

**SAY:**
> "Finally, the attacker exfiltrates sensitive data. The system alerts on the unusually large outbound transfer."

---

**Summary (1 minute)**

**Show all events together:**
```
host.name: "VICTIM-PC" OR host.name: "DC01"
```

**Sort by timestamp**

**SAY:**
> "Here's the complete attack timeline. This visualization helps incident responders understand the full scope of the attack and take appropriate action."

---

## ✨ Key Features to Highlight

### Feature Checklist

During your demo, make sure to showcase:

- [ ] **Real-time Detection**: Show how events appear immediately
- [ ] **MITRE Mapping**: Point out MITRE ATT&CK technique IDs
- [ ] **Severity Classification**: Show critical vs high vs medium
- [ ] **Search Capabilities**: Demonstrate powerful queries
- [ ] **Time-based Analysis**: Use time picker
- [ ] **Field Filtering**: Click on field values to filter
- [ ] **Data Visualization**: Show at least one chart
- [ ] **Host Correlation**: Track activity across hosts
- [ ] **Attack Chain**: Show multi-stage attack progression
- [ ] **Incident Response**: Explain how analysts would use this

---

## 🎬 Demo Scenarios

### Scenario 1: Security Operations Center (SOC)

**Context:** You're a SOC analyst monitoring alerts

**Demo:**
1. Show Kibana Discover with `apt-threats-*`
2. Filter by `severity: "critical"`
3. Investigate a credential dumping event
4. Show how you'd respond:
   - Isolate affected host
   - Reset compromised credentials
   - Check for lateral movement

---

### Scenario 2: Incident Response

**Context:** Investigating a suspected breach

**Demo:**
1. Start with a known compromised host
2. Search: `host.name: "VICTIM-PC"`
3. Sort by timestamp to build timeline
4. Identify all attack stages
5. Find other affected systems
6. Generate report

---

### Scenario 3: Threat Hunting

**Context:** Proactively searching for threats

**Demo:**
1. Search for PowerShell execution: `process.name: "powershell.exe"`
2. Filter for encoded commands
3. Identify suspicious patterns
4. Correlate with other indicators

---

### Scenario 4: Compliance Audit

**Context:** Demonstrating security monitoring

**Demo:**
1. Show system architecture
2. Demonstrate log collection
3. Show threat detection capabilities
4. Display MITRE ATT&CK coverage
5. Show how alerts would be generated

---

## 🚨 Troubleshooting During Demo

### If Kibana doesn't load:

```bash
# Check status
docker-compose ps

# Restart Kibana
docker-compose restart kibana

# Wait 30 seconds
sleep 30
```

**SAY while waiting:**
> "While Kibana restarts, let me explain the architecture..."

---

### If no data appears:

```bash
# Quick fix: Insert sample data
curl -X POST "http://localhost:9200/apt-threats-$(date +%Y.%m.%d)/_doc" \
  -H 'Content-Type: application/json' -d'{
  "@timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "threat_detected": "credential_dumping",
  "severity": "critical",
  "host": {"name": "DEMO-PC"},
  "message": "Demo threat event"
}'

# Refresh
curl -X POST "http://localhost:9200/apt-*/_refresh"
```

**SAY:**
> "Let me generate some fresh threat data..."

---

### If time range is wrong:

**In Kibana:**
- Click time picker (top-right)
- Select "Last 30 days" or "Last year"
- Data should appear

---

### If index pattern error:

```
1. Go to: Management → Stack Management → Index Patterns
2. Create: apt-detection-*
3. Create: apt-threats-*
4. Return to Discover
```

---

### Emergency Fallback:

If live demo fails, have these ready:

1. **Screenshots** of key features
2. **Recorded video** of the demo
3. **PDF** of README with architecture
4. **Slides** explaining the concepts

---

## ❓ Common Questions & Answers

### Q1: "How does this compare to commercial SIEM solutions?"

**A:** 
> "This is a proof-of-concept demonstrating APT detection capabilities using open-source tools. Commercial SIEMs like Splunk or QRadar offer more features (user behavior analytics, threat intelligence integration, etc.), but this system:
> - Costs nothing (open-source)
> - Can be customized for specific needs
> - Provides core detection functionality
> - Can integrate with commercial tools as a data source"

---

### Q2: "Can this detect zero-day attacks?"

**A:**
> "The current implementation uses signature-based detection for known APT techniques. However, it can be extended with:
> - Machine learning for anomaly detection
> - Behavioral analysis
> - Threat intelligence feeds
> These additions would help detect novel attack methods."

---

### Q3: "What about false positives?"

**A:**
> "False positives are minimized by:
> - Using well-documented MITRE techniques
> - Correlating multiple indicators
> - Adjusting severity levels
> In production, you'd tune rules based on your environment and add whitelisting for legitimate admin activities."

---

### Q4: "How scalable is this?"

**A:**
> "The ELK Stack is highly scalable:
> - Elasticsearch can cluster across multiple nodes
> - Logstash can be load-balanced
> - This demo runs on a single machine, but production deployments handle terabytes of logs daily at companies like Netflix, Uber, and LinkedIn."

---

### Q5: "Can it integrate with existing security tools?"

**A:**
> "Yes! It can:
> - Receive logs from existing SIEM via syslog
> - Forward alerts to ticketing systems (Jira, ServiceNow)
> - Send notifications to Slack, email, etc.
> - Export data to other analysis tools
> The design is modular and integration-friendly."

---

### Q6: "What about encrypted traffic?"

**A:**
> "For encrypted traffic, you'd need:
> - SSL/TLS inspection at the network layer
> - Endpoint agents to monitor before encryption
> - DNS query analysis (many C2 channels use DNS)
> Packetbeat can monitor network metadata even for encrypted connections."

---

### Q7: "How do you keep detection rules updated?"

**A:**
> "Detection rules should be:
> - Updated based on threat intelligence
> - Aligned with latest MITRE ATT&CK updates
> - Tuned based on false positive feedback
> You could automate rule updates using tools like Sigma rules or Elastic's detection rules repository."

---

### Q8: "What's the performance impact?"

**A:**
> "This demo uses:
> - 4GB RAM (2GB for Elasticsearch)
> - 2 CPU cores
> - Minimal disk I/O
> 
> In production, resource usage scales with log volume. For 1TB/day, you'd need a cluster, but for small to medium environments, a single server is sufficient."

---

## 📊 Backup Materials to Prepare

### Before Demo Day:

1. **Screenshots** (save these):
   - Kibana Discover with threats
   - Sample threat document expanded
   - Visualization examples
   - System architecture diagram

2. **Video Recording** (optional but recommended):
   - Record full demo walkthrough
   - Upload to YouTube (unlisted)
   - Have link ready as backup

3. **Presentation Slides**:
   - Problem statement
   - Solution overview
   - Architecture diagram
   - MITRE coverage table
   - Key features
   - Screenshots of demo
   - Conclusion

4. **Printed Materials**:
   - README.md (first 5 pages)
   - Architecture diagram (large format)
   - MITRE ATT&CK coverage table
   - Sample queries cheat sheet

---

## 🎓 Practice Checklist

### Day Before Demo:

- [ ] Run through entire demo script 2-3 times
- [ ] Time yourself (should fit within time limit)
- [ ] Test on actual demo machine/laptop
- [ ] Verify all URLs work
- [ ] Have backup internet connection
- [ ] Charge laptop fully
- [ ] Clear browser history/tabs
- [ ] Close unnecessary applications
- [ ] Test screen sharing (if remote)
- [ ] Prepare for Q&A (review FAQ section)

---

## 🎯 Success Criteria

Your demo is successful if audience understands:

✅ What APTs are and why they're dangerous
✅ How the system detects multi-stage attacks
✅ How it maps to MITRE ATT&CK framework
✅ How security analysts would use it
✅ The technical implementation approach
✅ Practical value for organizations

---

## 📝 Demo Day Checklist

### Setup (30 mins before):

- [ ] System fully started (`./start.sh`)
- [ ] All services healthy (`docker-compose ps`)
- [ ] Data exists (curl checks)
- [ ] Index patterns created
- [ ] Browser tabs ready (Kibana, GitHub)
- [ ] Terminal ready with commands
- [ ] Presentation mode enabled (hide notifications)
- [ ] Phone on silent

### During Demo:

- [ ] Speak clearly and at good pace
- [ ] Make eye contact with audience
- [ ] Point out important UI elements
- [ ] Explain technical terms
- [ ] Show enthusiasm about the project
- [ ] Handle questions confidently
- [ ] Stay within time limit

### After Demo:

- [ ] Share GitHub URL
- [ ] Offer to answer questions via email
- [ ] Thank the audience

---

## 🚀 Quick Start Command Summary

```bash
# Start everything
./start.sh

# Verify running
docker-compose ps

# Check data
curl 'http://localhost:9200/apt-*/_count?pretty'

# Access Kibana
open http://localhost:5601

# If needed, add more data
curl -X POST "http://localhost:9200/apt-threats-$(date +%Y.%m.%d)/_doc" \
  -H 'Content-Type: application/json' -d'{...}'

# Stop everything
docker-compose down
```

---

## 📚 Additional Resources to Mention

- GitHub Repository: https://github.com/Prajjwal2051/Detection-of-APT-s-attack
- MITRE ATT&CK: https://attack.mitre.org/
- Elastic Stack: https://www.elastic.co/
- Your Documentation: README.md, guides in repo

---

## 🎉 Final Tips

1. **Practice, practice, practice** - Know your demo inside-out
2. **Have a backup plan** - Screenshots, video, slides
3. **Start with impact** - Show the cool stuff first
4. **Tell a story** - Walk through an attack scenario
5. **Be confident** - You built this, you know it well!
6. **Engage audience** - Ask questions, encourage interaction
7. **Time management** - Leave time for Q&A
8. **Technical depth** - Adjust based on audience knowledge
9. **Show passion** - Your enthusiasm is contagious
10. **Have fun!** - Enjoy showcasing your work

---

**Good luck with your demo! 🚀 You've got this! 💪**

---

## Quick Reference Card

**URLs:**
- Kibana: http://localhost:5601
- Elasticsearch: http://localhost:9200
- GitHub: https://github.com/Prajjwal2051/Detection-of-APT-s-attack

**Key Searches:**
```
severity: "critical"
threat_detected: "credential_dumping"
threat_detected: "lateral_movement"
host.name: "VICTIM-PC"
mitre_technique: "T1003.001"
```

**Emergency Commands:**
```bash
./start.sh                          # Start everything
docker-compose restart kibana       # Restart Kibana
docker-compose logs -f elasticsearch # Debug
curl localhost:9200/_cat/indices    # Check indices
```

**If All Else Fails:**
Show documentation, explain architecture, discuss technical approach, answer questions!
