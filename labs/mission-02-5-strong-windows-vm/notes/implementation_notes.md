# Mission 2.5 Implementation Notes

## Design Decisions

### Why Separate Administrative Accounts?

A dedicated `ITAdmin` account was created to separate privileged administration from everyday activity. This follows the principle of least privilege and produces clearer authentication telemetry for future investigations.

---

### Why Sysmon?

Sysmon provides endpoint telemetry beyond the default Windows Security log, including process creation, network connections, registry activity, and image loading. These events support later detection engineering and threat hunting projects.

---

### Why PowerShell Logging?

PowerShell is widely used by administrators and attackers alike. Enabling PowerShell logging ensures future attack simulations generate meaningful telemetry for detection engineering and incident response.

---

### Why Attack Surface Reduction (ASR)?

ASR rules reduce common attack techniques such as malicious Office macros, credential theft, and script abuse. Rules were initially configured in Audit Mode before enforcement to minimize disruption.

---

## Validation Performed

- Verified Sysmon generated operational events
- Confirmed Advanced Audit Policy settings
- Verified PowerShell logging
- Confirmed Defender protections were enabled
- Validated administrative account separation
- Confirmed workstation functionality after hardening

---

## Supporting Scripts

The `scripts` directory contains PowerShell automation used during this mission, including:

- ASR configuration
- Local administrator password management
- Supporting workstation configuration

---

## Lessons Learned

- Least privilege should be implemented from the beginning
- Endpoint logging should be enabled before security testing
- Layered security controls complement one another
- Audit mode is valuable before enforcing restrictive policies