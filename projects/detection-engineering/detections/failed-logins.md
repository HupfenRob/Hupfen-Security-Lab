# Failed Login Activity

## Objective

Identify failed Windows logon attempts and provide visibility into accounts experiencing authentication failures.

---

## Detection Summary

| Field | Value |
|-------|-------|
| Status | Validated |
| Detection Version | 1.0 |
| Severity | Low |
| MITRE ATT&CK Technique(s) | T1110 - Brute Force |
| Data Source | Windows Security Event Log |
| Event ID(s) | 4625 |

---

## Background

Failed logon attempts occur for many legitimate reasons, including users entering incorrect passwords or expired credentials. However, repeated authentication failures may also indicate password spraying, brute-force attacks, unauthorized access attempts, or misconfigured applications.

Monitoring failed login activity provides analysts with valuable visibility into authentication behavior and often serves as the starting point for larger security investigations.

---

## Splunk Search

```spl
index=* EventCode=4625
| stats count by Account_Name, host
| sort - count
```

---

## Validation Steps

1. Log out of the Weak Windows machine.
2. Enter an incorrect password several times.
3. Log in successfully using the correct password.
4. Verify that Event ID 4625 appears in Splunk.
5. Confirm that the detection identifies the generated events.

---

## Expected Results

The detection should identify failed login attempts, group the results by account and host, and display the systems generating the authentication failures.

---

## Tuning Opportunities

Additional context such as the source IP address, logon type, or failure reason can be incorporated to improve investigative value and reduce false positives. Future tuning may also include threshold-based alerting or filtering known administrative and service accounts.

---

## Analyst Notes

This detection serves as the foundation for future authentication monitoring and can be expanded to identify brute-force attacks, password spraying, and other suspicious authentication activity.
