# Detection Name

Port Scan Activity

## Objective

Detect network reconnaissance by identifying Suricata alerts generated in response
to port scanning activity within the environment.

---

## Detection Summary

| Field | Value |
|-------|-------|
| Status | Validated |
| Detection Version | 1.0 |
| Severity | Medium |
| MITRE ATT&CK | T1046 - Network Service Discovery |
| Data Source | Suricata IDS |
| Event ID(s) | ET SCAN signature-based alert |

---

## Background

Port scanning is commonly used during network reconnaissance to identify reachable systems, open ports, and exposed services. Although port scans may be performed legitimately by administrators or vulnerability management teams, unexpected scanning activity can indicate an attacker attempting to identify potential targets and attack paths.

Monitoring Suricata scan alerts provides early visibility into this activity before an attacker gains access to an endpoint.

---

## Splunk Search

```spl
index=* sourcetype=linux_messages_syslog "ET SCAN"
| table _time, host, _raw
|sort - _time
```

---

## Validation Steps

- Launched an Nmap scan from an attacker machine
- Targeted the Weak Windows machine within the environment
- Confirmed Suricata generated an ET SCAN alert
- Verified the Suricata event was forwarded to Splunk
- Executed the detection search and confirmed the scan activity was identified

---

## Expected Results

The detection should return Suricata ET SCAN alerts associated with network reconnaissance activity.

The raw event should contain investigative details such as:

- Suricata signature
- Source IP address
- Destination IP address
- Destination port
- Network protocol
- Signature ID
- Alert category
- Severity

---

## Tuning Opportunities

- Exclude approved vulnerability scanners
- Filter authorized administrative scanning activity
- Suppress repeated alerts from known testing systems
- Prioritize scans targeting sensitive hosts or network segments
- Correlate scan activity across multiple destination systems
- Extract structured Suricata fields from the raw event for improved analysis

---

## Investigative Notes

When this detection triggers, analysts should review:

- The source IP address initiating the scan
- The destination system being scanned
- The ports and services targeted
- The Suricata signature and signature ID
- Other activity originating from the same source
- Whether the scanning system is authorized
- Related endpoint or authentication activity occurring near the same time

---

## References

- MITRE ATT&CK T1046 – Network Service Discovery
- Suricata Documentation
- Emerging Threats Rules Documentation