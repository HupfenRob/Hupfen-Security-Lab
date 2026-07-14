# Detection Name

User Account Creation

## Objective

Detect newly created local Windows user accounts using Windows Security Event ID 4720 to provide visibility into account creation activity that may indicate unauthorized persistence or administrative changes.

---

## Detection Summary

| Field | Value |
|-------|-------|
| Status | Validated |
| Detection Version | 1.0 |
| Severity | Medium |
| MITRE ATT&CK | T1136 – Create Account |
| Data Source | Windows Security Event Log |
| Event ID(s) | 4720 – A user account was created |

---

## Background

Creating a new local user account is a legitimate administrative task, but it is also a common technique used by attackers to establish persistence after gaining access to a system. Monitoring account creation activity helps identify unexpected administrative changes and provides early visibility into potential unauthorized access.

---

## Splunk Search

```spl
index=* EventCode=4720
| table _time, ComputerName, SAM_Account_Name, Security_ID
| sort - _time
```

---

## Validation Steps

- Created a temporary local user account on the Weak Windows machine
- Confirmed Windows generated Security Event ID 4720
- Verified the event was forwarded to Splunk
- Executed the detection search and confirmed the newly created account was identified
- Repeated the process using a second temporary account to validate consistent results

---

## Expected Results

The detection should identify newly created local user accounts and display:

- Time the account was created
- Computer where the activity occurred
- Newly created account name
- Associated Security Identifier (SID)

---

## Tuning Opportunities

- Exclude authorized administrative account provisioning
- Filter accounts created during approved maintenance windows
- Correlate account creation with privileged group membership changes
- Correlate with successful logon events for newly created accounts
- Alert only when accounts are created outside normal administrative activity

---

## Investigative Notes

When this detection triggers, analysts should review:

- The newly created account
- The system where the account was created
- Whether the account creation was authorized
- Recent administrative activity on the affected system
- Any subsequent logon activity involving the new account
- Related account management events occurring near the same time

---

## References

- Microsoft Windows Security Auditing Documentation
- MITRE ATT&CK T1136 – Create Account