# PCI DSS-Inspired Security Operations Lab Diagrams

This directory contains architectural and workflow diagrams created for the **Building and Validating a PCI DSS-Inspired Security Operations Lab** project.

The diagrams provide high-level visual representations of the environment's architecture, telemetry pipeline, detection workflows, and operational processes. They complement the implementation screenshots by illustrating how the individual technologies integrate to form a complete security operations environment.

## Contents

| Diagram | Description |
|----------|-------------|
| `network_architecture.png` | Illustrates the segmented USERS, MGMT, and CDE network architecture protected by pfSense. |
| `centralized_logging_architecture.png` | Demonstrates how telemetry from Windows, Linux, pfSense, and Suricata is centralized within Splunk Enterprise. |
| `network_detection_architecture.png` | Shows the integration of Suricata IDS into the environment and the flow of structured EVE JSON telemetry for network monitoring. |
| `telemetry_validation_diagram.png` | Illustrates the end-to-end telemetry validation process from controlled activity generation through centralized log collection and verification. |
| `detection_workflow_diagram.png` | Depicts how validated telemetry is transformed into automated Splunk detections and scheduled alerts. |
| `monitoring_to_security_operations.png` | Illustrates the complete operational workflow from monitoring and telemetry collection through detection, alerting, investigation, and security operations. |

## Purpose

These diagrams document the evolution of the environment from a segmented network architecture into a fully operational security monitoring platform. Together, they illustrate the relationships between infrastructure, telemetry collection, intrusion detection, centralized logging, detection engineering, and analyst investigation, providing architectural context that supports the implementation documented throughout the project.