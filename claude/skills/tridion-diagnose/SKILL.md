---
name: tridion-diagnose
description: Use when diagnosing Tridion Docs (Trisoft) issues on APP34/APP35 — stuck exports, publications pending, FLM pipeline failures, service failures, Oracle errors, UNC access denied, MSDTC, BackgroundTask hung, metadata download failures, or any Tridion ops incident.
---

# Tridion Diagnose

Structured diagnostic workflow for Tridion Docs production issues.

## Step 1 — Load Context (always first)

Read both files before doing anything else:

1. `/Users/wanj/autodesk/TridionDocs/Trisoft-Documentation/tridion-ops-context.md` — system topology, services, config locations, FLM pipeline, critical gotchas
2. `/Users/wanj/autodesk/TridionDocs/Trisoft-Documentation/tridion-runbook.md` — step-by-step procedures for common fixes

## Step 2 — Connect to Server

Use `user-winrm` MCP: `win_execute_powershell(hostname, command)`

- Primary host: `TRISOFTUW2APP34.ads.autodesk.com`
- Auth: `win_setup_credentials("TRISOFTUW2APP34.ads.autodesk.com")` if not already connected

## Step 3 — Triage by Symptom

| Symptom | Check first |
|---|---|
| Export stuck at "Busy" | BackgroundTask running? UNC loopback? (Gotcha #1) |
| Publications stuck "Pending" | BackgroundTask state + logs for ORA-12541 |
| Service won't start/restart | StopPending? (Gotcha #3) SCM password stale? |
| FLM ZIP not reaching Phrase | ZipWatcher logs, FLM-Source-Tridion2FLM scheduled task |
| Access denied on `\\tridiondocs-loc\...` | BackConnectionHostNames (Gotcha #1) |
| ORA-12541 in logs | Oracle TNS listener — but check BackgroundTask state first (Gotcha #4) |
| Crawler/SolrLucene fails to start | MSDTC reset after reboot (Gotcha #2) |
| ExpandBaseline / metadata download fails | Open Issue #1 — see incident log |

## Step 4 — Check Incident Log if Unresolved

If runbook has no matching procedure, read:
`/Users/wanj/autodesk/TridionDocs/Trisoft-Documentation/tridion-incident-log.md`

Look for: same symptoms, same error messages, same service/component. Past incidents include layered failures (MSDTC + BackgroundTask hung + UNC loopback) that can recur together.

## Step 5 — Diagnose, Then Propose

1. State your hypothesis with confidence rating and evidence
2. List what evidence you still need
3. **Do not apply fixes without explicit approval**

## Quick Checks (PowerShell)

```powershell
# Service state
Get-Service 'Trisoft InfoShare BackgroundTask One' | Select Name,Status,StartType

# Recent BackgroundTask log (most recent by date in filename)
Get-ChildItem 'D:\InfoShare\Data\Logs\' -Filter 'BackgroundTask_pid*' |
  Sort LastWriteTime -Descending | Select -First 1 | Get-Content -Tail 50

# UNC loopback check
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0'
(Get-ItemProperty $key).BackConnectionHostNames

# MSDTC XA state
Get-DtcNetworkSetting -DtcName Local | Select -Property *XA*,*Network*

# FLM export directory
Get-ChildItem 'D:\TRI_PRD_FLM\Source\' | Sort LastWriteTime -Descending | Select -First 10
```
