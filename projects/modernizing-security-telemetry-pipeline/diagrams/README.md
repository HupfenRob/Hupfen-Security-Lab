# Modernizing Security Telemetry Pipeline Diagrams

This directory contains architectural diagrams created for the Modernizing the Security Telemetry Pipeline project.

The diagrams illustrate the evolution of the telemetry pipeline from traditional syslog forwarding to structured Suricata EVE JSON telemetry, providing architectural context for the implementation documented in the project README.

## Contents

| Diagram | Description |
|----------|-------------|
| `original_telemetry_pipeline.png` | Illustrates the original telemetry pipeline, where Suricata alerts were forwarded to Splunk using traditional syslog messages through pfSense. |
| `updated_pipeline_diagram.png` | Illustrates the modernized telemetry pipeline, showing structured Suricata EVE JSON events being forwarded to Splunk while preserving the existing network architecture. |

## Purpose

These diagrams provide a high-level overview of the telemetry architecture before and after modernization. They complement the implementation screenshots by illustrating how structured telemetry improves visibility and establishes a stronger foundation for future security monitoring, detection engineering, and incident response.