# PCI DSS-Inspired Security Operations Lab Splunk Searches

This directory contains the Splunk searches developed and validated during the **Building and Validating a PCI DSS-Inspired Security Operations Lab** project.

The searches demonstrate how centralized security telemetry can be transformed into repeatable detections capable of identifying suspicious activity, generating alerts, and supporting analyst investigations. They represent the transition from passive log collection to active security monitoring within the lab environment.

## Contents

| Search | Description |
|--------|-------------|
| `suricata_nmap_detection.spl` | Identifies Suricata ET Open signatures associated with Nmap reconnaissance activity and serves as the basis for automated alert generation and validation. |

## Purpose

The searches in this directory document the detection logic used to validate the completed monitoring pipeline. They demonstrate how network telemetry collected from Suricata and indexed within Splunk can be queried, correlated, and transformed into repeatable security detections.

While this project focuses on validating the complete security operations environment, more advanced detection development, tuning, documentation, and validation are explored in the **Detection Engineering** project.