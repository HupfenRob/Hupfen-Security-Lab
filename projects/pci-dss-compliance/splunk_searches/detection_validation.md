# Detection Validation

## Purpose

This document describes the validation process used to confirm that the Suricata reconnaissance detection functioned correctly within the **Building and Validating a PCI DSS-Inspired Security Operations Lab** project.

Rather than assuming the detection would operate correctly after configuration, the complete monitoring pipeline was exercised using controlled attack simulation to verify telemetry collection, event correlation, automated alert generation, and analyst visibility.

---

## Detection Overview

| Property | Value |
|----------|-------|
| Detection Name | Suricata Nmap Reconnaissance Detection |
| Data Source | Suricata EVE JSON |
| SIEM | Splunk Enterprise |
| Attack Platform | Kali Linux |
| Detection Type | Scheduled Search |
| MITRE ATT&CK | T1595 – Active Scanning<br>T1046 – Network Service Discovery |

---

## Validation Methodology

Validation was performed using controlled reconnaissance activity generated from the Kali Linux workstation.

The objective was to confirm that each stage of the monitoring pipeline operated as expected:

1. Generate reconnaissance traffic from Kali Linux.
2. Inspect the traffic with Suricata.
3. Generate structured EVE JSON telemetry.
4. Forward telemetry to Splunk.
5. Execute the scheduled detection.
6. Generate an automated alert.
7. Correlate supporting evidence across multiple telemetry sources.

This process validated both the individual detection and the overall security monitoring architecture.

---

## Expected Results

Successful validation included:

- Nmap reconnaissance traffic generated successfully
- Suricata identified reconnaissance activity
- EVE JSON events created successfully
- Events indexed within Splunk
- Detection search returned expected results
- Scheduled alert triggered successfully
- Supporting telemetry correlated during investigation

---

## Investigation Workflow

Validation extended beyond confirming that an alert was generated.

The resulting detection was reviewed alongside supporting telemetry from multiple sources, including:

- pfSense firewall logs
- Suricata intrusion detection events
- Windows endpoint telemetry
- Linux system logs

Correlating evidence across multiple telemetry sources demonstrated that the alert accurately represented the observed network activity while providing investigators with sufficient context to begin analysis.

---

## Project Significance

This validation represents the final stage of the PCI DSS-inspired security operations environment.

Earlier phases established:

- Network segmentation
- Centralized logging
- Endpoint visibility
- Network intrusion detection

This validation confirmed that those individual components functioned together as an integrated security monitoring platform capable of detecting, alerting, and supporting security investigations.

The techniques demonstrated here provide the foundation for the more advanced detections developed throughout the **Detection Engineering** project.