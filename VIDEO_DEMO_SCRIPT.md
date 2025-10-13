# 🎥 Video Demo Script - APT Detection System

## 📹 Recording Setup Guide

### Pre-Recording Checklist

**Technical Setup:**
- [ ] Screen recording software installed (OBS Studio, Camtasia, or built-in)
- [ ] Microphone tested (clear audio, no background noise)
- [ ] System fully started (`./start.sh`)
- [ ] All services healthy
- [ ] Kibana loaded and responsive
- [ ] Test recording (5 seconds) to verify quality
- [ ] Close unnecessary applications
- [ ] Disable notifications (Do Not Disturb mode)
- [ ] Clear browser history/bookmarks bar
- [ ] Set browser zoom to 100%
- [ ] Prepare water (for your voice)

**Screen Recording Settings:**
- Resolution: 1920x1080 (Full HD)
- Frame rate: 30 FPS
- Audio: Both system + microphone
- Cursor highlighting: ON
- Show clicks: Optional

**Recording Tools:**
- **Linux:** OBS Studio, SimpleScreenRecorder, Kazam
- **Mac:** QuickTime, ScreenFlow
- **Windows:** OBS Studio, Camtasia
- **Online:** Loom, Screencast-O-Matic

---

## 🎬 Complete Video Script (10-12 minutes)

### SECTION 1: Introduction (0:00 - 1:00)

**[SHOW: Terminal or IDE with project folder]**

**SPEAK:**
> "Hello! In this video, I'll demonstrate an Advanced Persistent Threat Detection System I've built using the ELK Stack.
>
> APTs are sophisticated cyberattacks where attackers establish a foothold in a network and remain undetected for extended periods. This system helps detect these multi-stage attacks in real-time by monitoring security events and mapping them to the MITRE ATT&CK framework.
>
> Let's dive in!"

**[TRANSITION: Fade to architecture diagram or README.md]**

---

### SECTION 2: System Overview (1:00 - 2:30)

**[SHOW: README.md open, scroll to architecture diagram]**

**SPEAK:**
> "The system follows a pipeline architecture with four main components:
>
> First, Beats agents collect logs from various sources - Windows Event Logs, Linux system logs, and network traffic.
>
> Second, Logstash receives these logs, parses them, and applies detection rules to identify suspicious activities.
>
> Third, Elasticsearch indexes the data for fast searching and analysis.
>
> Finally, Kibana provides the visualization interface where security analysts can explore threats, create dashboards, and set up alerts.
>
> The entire system is containerized using Docker, making it easy to deploy and scale."

**[HIGHLIGHT with cursor: Each component as you mention it]**

---

### SECTION 3: MITRE ATT&CK Coverage (2:30 - 3:30)

**[SHOW: README.md, scroll to MITRE coverage table]**

**SPEAK:**
> "What makes this system powerful is its coverage of MITRE ATT&CK techniques. MITRE ATT&CK is an industry-standard knowledge base of adversary tactics and techniques based on real-world observations.
>
> The system detects:
> - Credential Access techniques like Mimikatz and LSASS dumping
> - Discovery activities such as reconnaissance and enumeration
> - Lateral Movement via RDP, SMB, and PSExec
> - Execution techniques including PowerShell abuse
> - And Data Exfiltration attempts
>
> In total, we cover 18 different techniques across 6 major attack tactics."

**[HIGHLIGHT: The coverage table rows as you speak]**

---

### SECTION 4: Starting the System (3:30 - 4:00)

**[SHOW: Terminal]**

**TYPE and SPEAK:**
```bash
cd Detection-of-APT-s-attack
./start.sh
```

> "Starting the system is simple. Just run the start script, and it handles everything automatically.
>
> It checks requirements, starts all Docker containers, generates sample data, and sets up Kibana dashboards.
>
> I'll skip ahead since we don't need to wait for the startup process."

**[FAST FORWARD or CUT to services running]**

**[SHOW: docker-compose ps output]**

**SPEAK:**
> "And we're ready! All services are up and healthy."

---

### SECTION 5: Accessing Kibana (4:00 - 4:30)

**[SHOW: Browser opening http://localhost:5601]**

**SPEAK:**
> "Let's open Kibana at localhost port 5601."

**[SHOW: Kibana loading, then home page]**

**SPEAK:**
> "This is the Kibana interface. On the left, we have the navigation menu. Let's go to Discover to start analyzing threats."

**[CLICK: Menu → Analytics → Discover]**

---

### SECTION 6: Viewing Detected Threats (4:30 - 6:30)

**[SHOW: Discover page]**

**SPEAK:**
> "First, I'll select the apt-threats index pattern, which contains only detected threat events."

**[CLICK: Dropdown, select apt-threats-*]**

**[SHOW: List of threat events appears]**

**SPEAK:**
> "Here we can see all detected APT activities. The timeline at the top shows when these threats occurred, and below we have the list of individual events.
>
> On the left sidebar, we can see available fields like threat_detected, severity, and mitre_technique.
>
> Let's search for critical threats specifically."

**[TYPE in search bar:]**
```
severity: "critical"
```

**[PRESS Enter]**

**[SHOW: Filtered results]**

**SPEAK:**
> "Now we're looking at only critical severity threats. Let's investigate one of these."

**[CLICK: Expand a credential_dumping event]**

---

### SECTION 7: Analyzing Credential Dumping (6:30 - 7:30)

**[SHOW: Expanded document with all fields visible]**

**SPEAK:**
> "This is a credential dumping attack. Let me walk through the key fields:
>
> The threat_detected field shows 'credential_dumping', which tells us the type of attack.
>
> The MITRE technique is T1003.001, which specifically refers to LSASS Memory dumping - a common method attackers use to steal credentials.
>
> The severity is marked as critical because credential theft is a high-risk activity.
>
> Looking at the process information, we can see mimikatz.exe was used to access lsass.exe, which is the Windows process that stores credentials.
>
> The host name tells us which machine was affected, and the timestamp shows exactly when this occurred."

**[SCROLL through fields while explaining, HIGHLIGHT each one with cursor]**

**SPEAK:**
> "This is exactly the kind of activity that indicates an APT attack in progress."

---

### SECTION 8: Tracking Lateral Movement (7:30 - 8:30)

**[CLEAR previous search, TYPE new query:]**
```
threat_detected: "lateral_movement"
```

**[SHOW: Results]**

**SPEAK:**
> "After stealing credentials, attackers typically move laterally across the network to reach their objectives. Let's look at these lateral movement events."

**[CLICK: Expand an RDP event]**

**SPEAK:**
> "This event shows a Remote Desktop Protocol connection, mapped to MITRE technique T1021.001.
>
> We can see the logon type is 10, which indicates a remote interactive logon via RDP.
>
> The system detected this as part of the attack chain because it follows the credential dumping activity, suggesting the attacker is using stolen credentials to access other systems."

**[HIGHLIGHT: Key fields]**

---

### SECTION 9: Data Exfiltration Detection (8:30 - 9:15)

**[SEARCH:]**
```
threat_detected: "data_exfiltration"
```

**[SHOW: Results]**

**SPEAK:**
> "The final stage of an APT attack is often data exfiltration. Here we've detected a large data transfer to an external IP address.
>
> The network bytes field shows over 50 megabytes of data being transferred outbound, which triggered our detection rule.
>
> This is mapped to MITRE technique T1041 for exfiltration over Command and Control channel.
>
> Being able to detect this quickly is crucial because it indicates the attacker has achieved their objective and is stealing sensitive data."

---

### SECTION 10: Search Capabilities (9:15 - 10:00)

**[CLEAR search bar]**

**SPEAK:**
> "The system provides powerful search capabilities. Let me show you a few examples."

**[TYPE and demonstrate each:]**

1. **Search by host:**
```
host.name: "VICTIM-PC"
```

**SPEAK:**
> "We can view all activities on a specific host to understand the complete attack timeline on that machine."

2. **Search by MITRE technique:**
```
mitre_technique: "T1003.001"
```

**SPEAK:**
> "Or search for specific MITRE techniques across all events."

3. **Complex query:**
```
threat_detected: ("credential_dumping" OR "lateral_movement") AND severity: "critical"
```

**SPEAK:**
> "We can also combine multiple conditions to find exactly what we need."

---

### SECTION 11: Time-Based Analysis (10:00 - 10:30)

**[CLICK: Time picker (top-right)]**

**SPEAK:**
> "Time-based analysis is crucial for understanding attack patterns. We can filter events by time range using this picker."

**[SELECT: Different time ranges, show how data updates]**

**SPEAK:**
> "This helps us focus on specific time periods or identify when attack activities peaked."

---

### SECTION 12: Additional Features (10:30 - 11:00)

**[CLICK: Visualization button or navigate to Dashboard]**

**SPEAK:**
> "Beyond searching, Kibana allows us to create visualizations and dashboards for a complete security monitoring solution.
>
> We can build pie charts showing threat distribution, timeline charts for trend analysis, and tables for detailed reporting.
>
> These dashboards give security teams at-a-glance visibility into the threat landscape."

**[SHOW: A sample visualization or dashboard if created]**

---

### SECTION 13: Technical Implementation (11:00 - 11:45)

**[SWITCH TO: Terminal or code editor]**

**SPEAK:**
> "Let me briefly show you how this works under the hood."

**[SHOW: docker-compose.yml]**

**SPEAK:**
> "The entire system is defined in this Docker Compose file, making deployment incredibly simple."

**[SHOW: logstash/pipeline/beats-input.conf]**

**SPEAK:**
> "The detection logic lives in Logstash configuration files. Here's an example of how we detect credential dumping attacks using pattern matching on process names and targets."

**[SCROLL through detection rules]**

**SPEAK:**
> "These rules can be easily customized or extended for specific environments."

---

### SECTION 14: Conclusion & Resources (11:45 - 12:00)

**[SHOW: GitHub repository page or README.md]**

**SPEAK:**
> "The complete source code, documentation, and setup instructions are available on GitHub. The repository includes:
> - Full source code
> - Comprehensive documentation
> - Setup scripts for one-command deployment
> - Sample data for testing
> - Detection rule examples
>
> You can have this system running on your machine in about 5 minutes.
>
> This project demonstrates how open-source tools can provide enterprise-grade threat detection capabilities mapped to industry-standard frameworks like MITRE ATT&CK.
>
> Thank you for watching! If you have questions, feel free to reach out through GitHub or leave comments below. Don't forget to star the repository if you found this helpful!"

**[SHOW: GitHub URL prominently]**
```
https://github.com/Prajjwal2051/Detection-of-APT-s-attack
```

**[FADE OUT]**

---

## 🎬 Alternative: Short Version (5 minutes)

### For Social Media / Quick Demo

**[0:00-0:30] Hook:**
> "Watch me detect a multi-stage APT attack in real-time using this custom-built system!"

**[0:30-1:00] Quick Overview:**
> "Built with ELK Stack, detects 5 attack stages, mapped to MITRE ATT&CK"

**[1:00-3:30] Live Demo:**
- Show credential dumping (0:30)
- Show lateral movement (0:30)
- Show data exfiltration (0:30)
- Quick search demo (1:00)

**[3:30-4:30] Key Features:**
> "Real-time detection, powerful search, MITRE mapping, visualizations"

**[4:30-5:00] Call to Action:**
> "Link in description to GitHub repo. Try it yourself!"

---

## 🎨 Video Editing Tips

### Post-Production Enhancements:

**Add Text Overlays:**
- Component names when showing architecture
- MITRE technique IDs when discussing threats
- Key terms and definitions
- GitHub URL at end

**Add Highlights:**
- Red boxes around important UI elements
- Arrows pointing to key fields
- Zoom in on important text
- Slow motion for complex steps

**Add B-Roll:**
- Screenshots of documentation
- Animated diagrams
- Code snippets
- Statistics/charts

**Background Music:**
- Use subtle, non-distracting music (royalty-free)
- Lower volume during speaking
- Slightly upbeat for technical content

**Chapter Markers:**
```
0:00 - Introduction
1:00 - System Architecture
2:30 - MITRE ATT&CK Coverage
3:30 - Live Demo
4:30 - Threat Detection
7:30 - Search Capabilities
10:00 - Technical Details
11:00 - Conclusion
```

---

## 📝 Video Description Template

```
🔐 APT Detection System - Real-time Threat Monitoring with ELK Stack

In this video, I demonstrate an Advanced Persistent Threat (APT) detection system I built using the ELK Stack (Elasticsearch, Logstash, Kibana). The system detects sophisticated multi-stage cyberattacks in real-time and maps them to the MITRE ATT&CK framework.

🎯 What's Covered:
✓ System architecture overview
✓ MITRE ATT&CK integration
✓ Live threat detection demo
✓ Credential dumping detection
✓ Lateral movement tracking
✓ Data exfiltration alerts
✓ Powerful search capabilities
✓ Technical implementation

🛠️ Technologies Used:
- Elasticsearch (Search & Storage)
- Logstash (Detection & Processing)
- Kibana (Visualization)
- Docker (Containerization)
- MITRE ATT&CK Framework

📦 Features:
- Real-time detection of 18 MITRE ATT&CK techniques
- Coverage of 6 major attack tactics
- Containerized deployment (5-minute setup)
- Open-source (no licensing costs)
- Fully documented and extensible

🔗 GitHub Repository:
https://github.com/Prajjwal2051/Detection-of-APT-s-attack

📚 Documentation:
- Complete setup guide
- Detection rule explanations
- Search query examples
- Demo scripts

⏰ Timestamps:
0:00 - Introduction
1:00 - System Architecture
2:30 - MITRE ATT&CK Coverage
4:00 - Live Demo Starts
6:30 - Credential Dumping
7:30 - Lateral Movement
8:30 - Data Exfiltration
10:00 - Technical Implementation
11:00 - Resources & Conclusion

💡 Use Cases:
- Security Operations Centers (SOC)
- Incident Response
- Threat Hunting
- Compliance Monitoring
- Security Training

🎓 Perfect for:
- Cybersecurity students
- SOC analysts
- Security researchers
- DevSecOps engineers
- Anyone interested in threat detection

📧 Contact:
- GitHub: github.com/Prajjwal2051
- Issues/Questions: Use GitHub Issues

👍 Like, Subscribe, and Star the repo if you find this useful!

#cybersecurity #APT #threatdetection #ELKStack #MITRE #infosec #hacking #SOC
```

---

## 🎙️ Recording Tips

### Before Recording:

1. **Practice the script 3-4 times**
2. **Time yourself** (adjust pace if needed)
3. **Prepare system** (everything working)
4. **Test microphone levels**
5. **Close background apps**
6. **Drink water** (clear voice)

### During Recording:

1. **Speak clearly and steadily** (not too fast)
2. **Pause between sections** (easier editing)
3. **Show, then tell** (let visuals sink in)
4. **Don't worry about mistakes** (edit later)
5. **Use cursor to guide attention**
6. **Pause on important screens** (let viewers read)

### After Recording:

1. **Watch the raw footage**
2. **Cut out mistakes and pauses**
3. **Add transitions between sections**
4. **Include text overlays for key points**
5. **Balance audio levels**
6. **Add intro/outro screens**
7. **Export in high quality** (1080p minimum)

---

## 📤 Where to Share

**Primary Platforms:**
- **YouTube** - Best for detailed technical content
- **GitHub** - Embed in README
- **LinkedIn** - Professional audience
- **Twitter/X** - Short clips with link

**Secondary Platforms:**
- **Reddit** - r/cybersecurity, r/netsec
- **Dev.to** - Technical blog post with video
- **Medium** - Article with embedded video
- **Personal website/portfolio**

**Academic:**
- Include in project reports
- Use in presentations
- Share with professors/colleagues
- Submit to student competitions

---

## 🏆 Success Metrics

**Good video indicators:**
- Clear audio (no background noise)
- Smooth demo (no hiccups)
- Engaging pacing (not too slow/fast)
- Professional appearance
- Adds value (viewers learn something)

**Engagement goals:**
- Views (target: 100+ in first month)
- Likes/thumbs up
- Comments with questions
- GitHub stars increase
- Shares/retweets

---

**Happy recording! 🎥 You've got this! 🚀**
