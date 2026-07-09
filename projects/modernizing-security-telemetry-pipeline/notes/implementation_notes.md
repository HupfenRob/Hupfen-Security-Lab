# Implementation Notes

These notes capture additional engineering details from this project that were intentionally omitted from the README. The README documents the project at a high level, while these notes provide additional implementation details for future reference.

---

# Why the Pipeline Was Modernized

The existing telemetry pipeline successfully forwarded Suricata alerts into Splunk using pfSense's remote syslog service. While functional, the original pipeline forwarded primarily plain-text alert data, limiting the amount of information available for searching, correlation, and detection engineering.

Rather than replacing the existing logging architecture, this project focused on improving the quality of the telemetry already being collected.

By enabling Suricata's native EVE JSON output, significantly richer event data became available while preserving the existing infrastructure.

---

# Why EVE JSON Was Selected

EVE JSON is Suricata's native structured logging format.

Unlike traditional syslog messages, EVE JSON preserves individual event fields as structured data, including:

- Source and destination IP addresses
- Source and destination ports
- Protocol information
- Alert signatures
- Classification
- Severity
- Flow information
- DNS, HTTP, TLS, and other protocol metadata

This additional context improves:

- Splunk searches
- Detection engineering
- Threat hunting
- Incident investigations
- Future alert development

---

# Problems Encountered

Several challenges were encountered while modernizing the telemetry pipeline.

## Locating the correct EVE JSON file

Although Suricata documentation describes the EVE JSON format, locating the active log location within the pfSense filesystem required additional investigation.

---

## Verifying telemetry generation

Configuration changes alone do not prove success.

The EVE JSON output was manually inspected to confirm that structured events were actively being generated before forwarding telemetry to Splunk.

---

## Validating end-to-end data flow

Each stage of the pipeline was validated independently.

Rather than assuming events would automatically appear in Splunk, telemetry generation, forwarding, and indexing were verified as separate steps.

---

# Lessons Learned

One of the biggest lessons from this project was that improving telemetry often provides greater long-term value than simply deploying additional security tools.

Structured telemetry creates better opportunities for:

- detection engineering
- correlation
- forensic analysis
- incident response

This project also reinforced the importance of validating every stage of a logging pipeline independently rather than assuming that successful configuration guarantees successful operation.

---

# Validation Commands

Example commands used during validation included:

```bash
ssh admin@<pfSense-IP>
```

```bash
cd /var/log/suricata/
```

```bash
cat eve.json
```

```bash
tail -f eve.json
```

Network activity was generated from the Kali Linux workstation to produce fresh Suricata events that could be validated throughout the pipeline.

---

# Useful File Locations

Suricata logs

```text
/var/log/suricata/
```

EVE JSON output

```text
/var/log/suricata/<interface>/eve.json
```

---

# References

Official Suricata Documentation

https://docs.suricata.io/

pfSense Documentation

https://docs.netgate.com/pfsense/

Splunk Documentation

https://docs.splunk.com/

---

These notes supplement the README and preserve implementation details that may be useful when reproducing or extending this project in the future.