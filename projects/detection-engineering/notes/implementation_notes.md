# Implementation Notes

These notes preserve additional technical details from the Detection Engineering Project that were intentionally kept out of the main README.

The README provides an overview of the detection library, while this document records the development methodology, telemetry decisions, validation procedures, known limitations, and operational lessons discovered throughout the project.

---

# Why the Detection Library Was Created

The security environment already collected telemetry from several sources, including:

- Windows Security Event Logs
- Sysmon
- Suricata
- pfSense
- Splunk

Although the telemetry was available, collecting logs alone did not provide a repeatable method for identifying security-relevant activity.

The Detection Engineering Project transformed that telemetry into reusable security content by developing documented Splunk searches capable of identifying:

- Failed Windows authentication attempts
- PowerShell process execution
- Network reconnaissance activity
- New local user account creation

Each detection was developed using a consistent workflow:

1. Define the activity to detect
2. Identify the required telemetry source
3. Generate controlled test activity
4. Confirm that the telemetry reached Splunk
5. Explore the available event fields
6. Build the initial detection
7. Refine the search
8. Validate the results
9. Document the detection
10. Preserve the search through version control

---

# Why Multiple Telemetry Sources Were Used

The project intentionally avoided relying on a single data source.

Different types of activity are visible through different forms of telemetry:

| Detection | Telemetry Source | Event or Signature |
|---|---|---|
| Failed Login Activity | Windows Security Log | Event ID 4625 |
| PowerShell Execution | Sysmon | Event ID 1 |
| Port Scan Activity | Suricata | ET SCAN alerts |
| User Account Creation | Windows Security Log | Event ID 4720 |

Windows Security logs provided authentication and account-management visibility.

Sysmon provided detailed process-creation telemetry, including executable paths, command-line arguments, and parent processes.

Suricata provided network-based visibility into reconnaissance activity that would not necessarily appear in endpoint logs.

Using multiple telemetry sources demonstrated that effective detection engineering depends on understanding which source provides the best visibility into the behavior being investigated.

---

# Detection Development Methodology

Each detection began with a broad search designed to answer a basic question:

> Is the expected telemetry reaching Splunk?

Examples included:

```spl
index=* EventCode=4625
```

```spl
index=* EventCode=1
```

```spl
index=* EventCode=4720
```

Broad searches were used before adding specific indexes, sourcetypes, field names, or filtering logic.

This approach reduced the risk of incorrectly assuming that every environment uses the same:

- Index names
- Sourcetypes
- Field extractions
- Event formats
- Splunk add-ons
- Parsing configurations

Once the event was located, the raw data and extracted fields were reviewed before building the final detection.

---

# Detection 01 – Failed Login Activity

## Objective

Identify failed authentication attempts against Windows systems and provide visibility into the accounts and systems experiencing authentication failures.

## Telemetry

Windows Security Event ID:

```text
4625
```

Event ID 4625 is generated when an account fails to log on successfully.

## Detection Search

```spl
index=* EventCode=4625
| stats count by Account_Name, host
| sort - count
```

## Validation Method

Failed logins were intentionally generated on the monitored Windows endpoint by entering an incorrect password several times before successfully authenticating.

Validation confirmed:

- The expected number of failed logins appeared in Splunk
- The correct account was identified
- The expected host generated the activity
- The detection grouped the events correctly

## Known Limitation

A single failed login is not inherently malicious.

Possible legitimate causes include:

- Mistyped passwords
- Expired credentials
- Service accounts with outdated passwords
- Misconfigured applications
- Scheduled tasks using old credentials

The initial detection was intentionally broad so that the full detection and alerting workflow could be validated.

---

# Detection 02 – PowerShell Execution

## Objective

Identify the creation of PowerShell processes and provide useful investigative context through command-line and parent-process information.

## Telemetry

Sysmon Event ID:

```text
1
```

Sysmon Event ID 1 records process creation.

## Detection Search

```spl
index=* EventCode=1 Image="*\\powershell.exe"
| table _time, host, Image, CommandLine, ParentImage
| sort - _time
```

## Validation Method

PowerShell was launched in several ways:

```powershell
powershell.exe
```

```powershell
powershell.exe -Command Get-Date
```

PowerShell was also launched directly from the Start Menu.

Validation confirmed that each new PowerShell process generated a Sysmon Event ID 1 and appeared in the Splunk results.

## Important Distinction

Sysmon Event ID 1 records the creation of the PowerShell process.

It does not automatically record every command entered inside an already-running PowerShell session.

For example, opening one PowerShell window and running several commands generally produces one process-creation event for the PowerShell launch rather than one Event ID 1 for every command executed inside that session.

## Field Limitation

During testing, the `User` field sometimes appeared as:

```text
NOT_TRANSLATED
```

This did not indicate that the detection was broken.

It indicated that Splunk had not translated the account identifier into a friendly username for those events. Because the field was not consistently useful, it was removed from the final table while more reliable fields were retained.

---

# Detection 03 – Port Scan Activity

## Objective

Identify network reconnaissance activity using Suricata alerts generated by Nmap scanning.

## Telemetry

Suricata ET SCAN alerts forwarded through the pfSense and Splunk telemetry pipeline.

## Detection Search

```spl
index=* sourcetype=linux_messages_syslog "ET SCAN"
| table _time, host, _raw
| sort - _time
```

## Validation Commands

A TCP SYN scan was used during initial testing:

```bash
sudo nmap -sS <target-ip>
```

Additional validation used:

```bash
sudo nmap -A -T4 <target-ip>
```

## Validation Method

The scan was generated from Kali Linux against the monitored Windows endpoint.

Validation confirmed:

- Kali generated the expected scan traffic
- Suricata detected the activity
- The alert was forwarded through pfSense
- Splunk indexed the event
- The detection returned the newest ET SCAN alert

## Known Limitation

Many of the useful Suricata fields remained inside the `_raw` event rather than appearing as individual Splunk columns.

The raw event still contained useful investigative data, including:

- Source IP address
- Destination IP address
- Destination port
- Protocol
- Signature
- Signature ID
- Alert category
- Severity

Future improvements could include additional field extraction and more precise signature filtering.

---

# Detection 04 – User Account Creation

## Objective

Identify newly created local Windows user accounts.

## Telemetry

Windows Security Event ID:

```text
4720
```

Event ID 4720 is generated when a new user account is created.

## Detection Search

```spl
index=* EventCode=4720
| table _time, ComputerName, SAM_Account_Name, Security_ID
| sort - _time
```

## Validation Method

Temporary local user accounts were created on the monitored Windows endpoint.

Validation confirmed:

- A new Event ID 4720 was generated
- The event reached Splunk
- The new account appeared at the top of the detection results
- The computer name remained consistent
- Each account received a unique Security Identifier

## Known Limitation

Available field names may vary depending on:

- Splunk version
- Installed add-ons
- Field extractions
- Windows event formatting
- Parsing configuration

The detection was built using fields that were confirmed to work in the project environment rather than assuming that every field shown in outside examples would be available.

---

# Splunk Alert Configuration

The Failed Login Activity detection was converted into a scheduled Splunk alert.

## Alert Settings

```text
Title: Alert - Failed Login Activity
Alert Type: Scheduled
Cron Schedule: */5 * * * *
Earliest Time: -15m
Latest Time: now
Trigger Condition: Number of Results greater than 0
Throttle: 15 minutes
```

The alert ran every five minutes while searching the previous fifteen minutes of data.

The overlapping search window reduced the chance that events would be missed because of small forwarding or indexing delays.

## Alert Validation

Failed login events were generated again on the Windows endpoint.

After the scheduled search executed, the alert was reviewed under:

```text
Activity > Triggered Alerts
```

Validation confirmed that the alert executed automatically and contained the expected failed authentication events.

## Alert Behavior

A triggered alert represents one execution of the scheduled search.

It does not necessarily represent one individual security event.

If several matching events are found during the search window, Splunk may generate one alert containing all matching results.

---

# Problems Encountered

## Controlled Folder Access Blocked Git

When the repository was initialized on the Strong Windows management workstation, Windows Controlled Folder Access blocked Git from writing to the protected folder.

The event was reviewed in Windows Security, the legitimate Git executable was identified, and access was allowed.

This reinforced an important operational lesson: legitimate administrative tools can trigger security controls, and exceptions should only be made after validating the executable and intended activity.

---

## Field Names Varied Across Events

Fields shown in external documentation were not always available or consistently populated in the project environment.

Examples included:

- `User` appearing as `NOT_TRANSLATED`
- Suricata details remaining inside `_raw`
- Windows account fields varying based on extraction behavior

The searches were therefore based on fields that were actually observed and validated rather than copied directly from generic examples.

---

## Detection Results Required Known Test Activity

Historical results alone were not considered sufficient validation.

Each detection was tested by generating controlled activity and confirming that the newest results matched the action that had just been performed.

---

## Scheduled Alerts Did Not Trigger Immediately

Because the failed-login alert ran on a five-minute schedule, validation required waiting for the scheduled search to execute.

The fifteen-minute search window and five-minute execution schedule were reviewed together to confirm that the timing behavior was expected.

---

# Lessons Learned

## Telemetry Must Be Understood Before Writing the Detection

A detection should not begin with a complex search copied from another environment.

The correct process is to first locate the event, examine its structure, identify useful fields, and then build the search around telemetry confirmed to exist.

---

## Simple Searches Can Still Provide Value

A detection does not need to be complex to be useful.

The initial port-scan detection relied on the `_raw` event, but it still reliably identified reconnaissance activity and provided enough context for investigation.

---

## Validation Separates Detections from Assumptions

A search that returns results is not automatically a validated detection.

Each detection was tested with controlled activity so the expected behavior and limitations were understood.

---

## Context Is Often More Valuable Than Complexity

Adding fields such as:

- Host
- Command line
- Parent process
- Source address
- Destination address

often improved the usefulness of a detection more than adding complicated search logic.

---

## Alerting and Detection Are Different Stages

A saved Splunk report provides reusable search logic.

A scheduled alert operationalizes that logic by running it automatically and recording or notifying analysts when its trigger conditions are met.

---

## Detection Engineering Is an Ongoing Process

Detections require continued maintenance as:

- Environments change
- Field extractions change
- New telemetry becomes available
- False positives are identified
- Threat behavior evolves
- New tuning requirements emerge

Version control provides a history of these changes and makes it possible to review, improve, or restore earlier versions.

---

# Repository Structure

```text
detection-engineering/
├── README.md
├── detections/
│   ├── failed_logins.md
│   ├── port_scan_activity.md
│   ├── powershell_execution.md
│   └── user_account_creation.md
├── splunk-searches/
│   ├── failed_logins.spl
│   ├── port_scan_activity.spl
│   ├── powershell_execution.spl
│   └── user_account_creation.spl
├── screenshots/
└── notes/
    └── implementation_notes.md
```

Matching base filenames between detection documents and their corresponding Splunk searches makes it easier to identify which search belongs to each detection while keeping the repository organized and easy to maintain.

---

# Useful Splunk Searches

## Confirm Failed Login Telemetry

```spl
index=* EventCode=4625
```

## Confirm Sysmon Process Creation Telemetry

```spl
index=* EventCode=1
```

## Confirm PowerShell Execution

```spl
index=* EventCode=1 Image="*\\powershell.exe"
```

## Confirm Suricata Scan Telemetry

```spl
index=* sourcetype=linux_messages_syslog
(suricata OR "ET SCAN" OR "2036252")
| sort - _time
```

## Confirm Account Creation Telemetry

```spl
index=* EventCode=4720
```

---

# Useful Event IDs

| Event ID | Source | Description |
|---|---|---|
| 4625 | Windows Security | An account failed to log on |
| 1 | Sysmon | Process creation |
| 4720 | Windows Security | A user account was created |

---

# References

Microsoft Sysmon Documentation

https://learn.microsoft.com/sysinternals/downloads/sysmon

Microsoft Windows Security Auditing Documentation

https://learn.microsoft.com/windows/security/threat-protection/auditing/security-auditing-overview

Splunk Search Reference

https://docs.splunk.com/Documentation/Splunk/latest/SearchReference/WhatsInThisManual

Splunk Alerting Documentation

https://docs.splunk.com/Documentation/Splunk/latest/Alert/Aboutalerts

Suricata Documentation

https://docs.suricata.io/

Nmap Reference Guide

https://nmap.org/book/man.html

MITRE ATT&CK

https://attack.mitre.org/

---

These notes supplement the Detection Engineering README and preserve the implementation details, validation methods, limitations, and operational lessons that may be useful when maintaining or expanding the detection library.