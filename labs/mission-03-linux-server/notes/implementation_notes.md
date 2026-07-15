# Mission 3 Implementation Notes

## Design Decisions

### Why Ubuntu Server?

Ubuntu Server 24.04 LTS was selected because it is widely deployed in enterprise environments, receives long-term security updates, and provides a stable platform for security tooling. Its extensive package repositories and documentation also make it well suited for building a cybersecurity lab.

---

### Why OpenSSH?

OpenSSH was configured to provide secure remote administration from the Windows management workstation. Remote management reflects common enterprise practices and allows the server to be administered without relying on direct console access.

---

### Why auditd?

The Linux Audit Framework (auditd) records security-relevant events that are not always captured by traditional system logs. Audit rules were configured to monitor administrative activity and changes to critical system resources, providing detailed telemetry for future detection engineering and forensic analysis.

---

### Why Persistent journald Logging?

By default, Linux journal logs may be stored only in memory and lost after a reboot. Persistent journald logging was enabled so security events remain available for troubleshooting, investigations, and centralized log collection.

---

### Why AIDE?

AIDE (Advanced Intrusion Detection Environment) establishes a trusted baseline of critical system files by recording cryptographic hashes. Future integrity checks can compare the current system against this baseline to detect unauthorized modifications.

---

## Validation Performed

Validation included:

- Confirming SSH connectivity
- Verifying auditd was actively recording events
- Confirming persistent journald logging
- Initializing the AIDE database
- Capturing baseline file hashes
- Verifying normal administrative activity generated telemetry

---

## Supporting Scripts

The `scripts` directory contains automation created during this mission.

Current script:

- `capture_baseline_hashes.sh` – Generates SHA-256 hashes for critical Linux system files to establish a trusted integrity baseline for future comparison.

---

## Lessons Learned

- Linux security should begin with a trusted baseline
- Logging should be configured before deploying security tools
- File integrity monitoring complements audit logging
- Small automation scripts simplify recurring administrative tasks