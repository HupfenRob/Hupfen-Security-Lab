# Detection Name

PowerShell Execution

## Objective

Detect PowerShell process execution using Sysmon Event ID 1 to provide visibility into
PowerShell activity on Windows systems.

---

## Detection Summary

| Field | Value |
|-------|-------|
| Status | Validated |
| Detection Version | 1.0 |
| Severity | Informational |
| MITRE ATT&CK | T1059.001 - PowerShell |
| Data Source | Sysmon |
| Event ID(s) | 1 |

---

## Background

PowerShell is one of the most widely used administrative tools in Windows environments. While
PowerShell widely used for legitimate administration and automation, it is also commonly abused by attackers for execution, persistence, and post-exploitation activities. Monitoring PowerShell execution provides valuable visibility into activity that may warrant further investigation.

---

## Splunk Search

```spl
index=* EventCode=1 Image="*\\powershell.exe"
| table _time, host, Image, CommandLine, ParentImage
| sort _time
```

---

## Validation Steps

- Opened PowerShell from the Start menu, Command Prompt, and Run dialog
- Executed several PowerShell commands
- Confirmed Sysmon generated Event ID 1
- Verified the event was forwarded to Splunk
- Executed the detection search and confirmed the PowerShell process was identified

---

## Expected Results

The detection should identify PowerShell process creation events and display the relevant
process information collected by Sysmon.

---

## Tuning Opportunities

- Filtering known administrative scripts
- Excluding approved automation accounts
- Creating separate detections for encoded commands or suspicious command-line arguments
- Correlating PowerShell execution with other events such as network connections or account creation

---

## Investigative Notes

When this detection triggers, analysts should review:

- The PowerShell command line
- The parent process
- The user who launched PowerShell
- The host where the activity occurred
- Related Sysmon process creation events

---

## References

- Microsoft Sysmon Documentation
- MITRE ATT&CK T1059.001 - PowerShell

---

## Detection Status

Successfully validated within the Hupfen Security Lab.