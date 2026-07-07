# Test Plan: QScanner VS Code / Windsurf Extension
**Jira Epic:** [CMS-33577](https://jira.intranet.qualys.com/browse/CMS-33577)  
**Version:** 1.0  
**Date:** 2026-07-06  
**Author:** QA Team  
**Assignee:** Hiten Shah  

---

## 1. Overview

The QScanner VS Code/Windsurf Extension integrates the Qualys `qscanner` binary directly into the developer IDE. It wraps the binary to provide:
- SCA (Software Composition Analysis) vulnerability detection
- AI/Cloud compliance scanning
- One-click patching for 15+ package managers
- Secure credential storage via OS keychain
- Automated binary management (download, install, update)

This test plan covers all functional, integration, edge-case, and security testing for the extension across all supported platforms.

---

## 2. Scope

### 2.1 In Scope

| Feature Area | Jira Task |
|---|---|
| Extension Bootstrap & Binary Management | CMS-33576 |
| Authentication & Secure Credential Storage | CMS-33578 |
| SCA Vulnerability Scanning | CMS-33580 |
| Compliance Scanning (AI/Cloud Benchmarks) | CMS-33581 |
| Patch Orchestration (single package, patcher engine) | CMS-33582, CMS-33583 |
| Patch All & Patch By Severity | CMS-33584 |
| UI — Findings Panel, Detail View & Welcome Screens | CMS-33585 |
| Configuration & Settings | CMS-33586 |
| Right-Click "Scan This Project" (Explorer Context) | CMS-33588 |

### 2.2 Out of Scope
- IntelliJ plugin feature parity (covered by separate test plan)
- Blog post (CMS-33589 — marketing artifact)
- Backend/API-side scanning engine internals
- VS Code Marketplace publishing pipeline

---

## 3. Test Objectives

1. Verify the extension correctly installs, detects, and manages the `qscanner` binary across all supported platforms.
2. Validate that credentials are stored securely using OS-level keychain and never written to disk in plaintext.
3. Confirm SCA scan results are parsed and rendered correctly in the tree view with proper severity grouping.
4. Verify compliance scan results are rendered correctly — FAIL/SKIPPED shown, PASS hidden.
5. Validate one-click patch operations (single, severity group, all) with backup/undo support.
6. Confirm all configuration settings are reflected in binary CLI invocations.
7. Verify context-menu scanning targets the selected folder, not the workspace root.
8. Validate all welcome screen states and context flag transitions.

---

## 4. Test Strategy

### 4.1 Test Types

| Type | Description |
|---|---|
| **Functional Testing** | Verify each feature works as per acceptance criteria |
| **Integration Testing** | Verify extension ↔ binary ↔ Qualys backend interactions |
| **UI/UX Testing** | Validate tree view, detail panels, welcome screens, and icons |
| **Security Testing** | Credential storage, no plaintext secrets on disk |
| **Negative / Error Testing** | Missing binary, bad credentials, network failure, malformed reports |
| **Cross-Platform Testing** | Linux x64, macOS x64/ARM64, Windows x64 |
| **Regression Testing** | Re-run core cases after patches/updates |
| **Performance Testing** | Large workspace scan, timeout behavior |

### 4.2 Test Execution Approach

- **Manual testing** for UI/UX, credential flows, and first-run experience
- **Automated testing** (VS Code extension test framework / Playwright) for command invocations and tree view validation where feasible
- **Exploratory testing** for edge cases around patch orchestration and undo

---

## 5. Feature Areas & Test Coverage Summary

### 5.1 F1 — Extension Bootstrap & Binary Management (CMS-33576)
- Binary detection via PATH and `binaryPath` setting
- Silent download and install per platform/arch
- Welcome screen shown when binary missing
- `Update QScanner` command updates to latest/specified version
- Binary version polling

### 5.2 F2 — Authentication & Secure Credential Storage (CMS-33578)
- Access token storage via VS Code `SecretStorage`
- OAuth clientId/clientSecret storage
- Credentials never written to `settings.json` unencrypted
- Fallback to `settings.json` when secure storage unavailable
- Migration from `settings.json` to keychain
- Credential status display
- Clear credentials command

### 5.3 F3 — SCA Vulnerability Scanning (CMS-33580)
- Invoke `qscanner code <path>` with all relevant flags
- Parse `{hash}-Report.json` from workspace storage
- Render CVE tree view grouped by CRITICAL / HIGH / MEDIUM / LOW
- Severity icons and patchable (wrench) indicator
- Stop scan command halts binary process

### 5.4 F4 — Compliance Scanning (CMS-33581)
- `enableComplianceScan` toggles compliance mode
- `--compliance-benchmarks` passed correctly
- `Inventory.Compliance[]` parsed from report
- FAIL (✗) and SKIPPED (?) shown; PASS hidden
- Compliance section only visible when enabled
- Findings grouped by benchmark

### 5.5 F5 — Patch Orchestration Engine (CMS-33582 / CMS-33583)
- Package manager auto-detection
- Lock-file → manifest mapping (walk up to git root / 8 levels)
- Timestamped backup created in `.qscanner/backups/` before any write
- Patched manifest written correctly
- Post-patch command prompt (npm install, pip install, go mod tidy, etc.)
- Run Now / Later / Undo notification flow
- Undo restores original file

### 5.6 F6 — Patch All & Patch By Severity (CMS-33584)
- `patchAll` patches every patchable vulnerability in workspace
- `patchBySeverity` patches all patchable items in severity group
- Patch All button visible in toolbar when results exist
- Patch All in Group accessible via right-click on severity node

### 5.7 F7 — UI — Findings Panel, Detail View & Welcome Screens (CMS-33585)
- `qscannerIssueViewer` TreeView renders with severity grouping
- Compliance findings shown in separate COMPLIANCE FINDINGS section
- `qscannerHelpViewer` webview opens on item click with CVE/compliance detail
- Welcome screen states:
  - Scanning spinner when `qscanner.scanRunning = true`
  - "Scan Now" button when `qscanner.installed = true && !scanRunning && !hasResults`
  - "Install QScanner" when `qscanner.installed = false`
- Context flag transitions correct

### 5.8 F8 — Configuration & Settings (CMS-33586)
- All settings registered in `package.json`: `binaryPath`, `pod`, `gatewayUrl`, `excludeDirs`, `excludeFiles`, `showOnlyPatchable`, `scanTimeout`, `detectionPriority`, `proxy`, `cacheDir`, `certPath`, `maxNetworkRetries`, `skipVerifyTls`, `version`, `enableComplianceScan`, `complianceBenchmarks`
- Settings reactively passed to binary invocations
- `showOnlyPatchable` filters tree view in real-time

### 5.9 F9 — Right-Click Scan (CMS-33588)
- `qscanner.scanFolder` command registered in Explorer context menu
- Shown when `explorerResourceIsFolder` context is true
- Scan targets selected directory, not workspace root

---

## 6. Entry & Exit Criteria

### 6.1 Entry Criteria
- Extension `.vsix` package built and installable
- QScanner binary available for at least one target platform
- Test environment set up with valid Qualys credentials
- Test projects prepared (see TEST_DATA.md)

### 6.2 Exit Criteria
- All P1/P2 test cases pass
- No open Critical or High severity defects
- All P2-High Jira tasks (CMS-33576, CMS-33578, CMS-33581, CMS-33588) test cases pass
- Patch undo verified on at least 3 package manager types
- Cross-platform smoke tests passed on Linux and macOS

---

## 7. Test Environment

| Component | Details |
|---|---|
| IDEs | VS Code (latest stable), Windsurf |
| Platforms | Linux x64, macOS x64, macOS ARM64, Windows x64 |
| Node.js | 18.x LTS (extension host) |
| QScanner Binary | Latest release from Qualys CDN |
| Qualys Backend | Staging/QA pod with valid credentials |
| Test Projects | See TEST_DATA.md |

---

## 8. Risk & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Binary CDN unavailable during testing | High | Pre-download binaries for all platforms |
| OS keychain unavailable in CI | Medium | Test fallback `settings.json` path explicitly |
| Large workspace scan timeouts | Low | Use `scanTimeout` setting; prepare small/medium test projects |
| Platform-specific path separator bugs | Medium | Include dedicated cross-platform test cases |
| Undo corrupting original file | High | Verify backup hash before/after each undo test |

---

## 9. Defect Management

- All defects logged in Jira under project **CMS**, linked to `CMS-33577`
- Severity mapping:
  - **Blocker** — data loss, credential leak, crash on activate
  - **Critical** — scan not working, patch fails silently
  - **Major** — wrong UI state, settings not applied
  - **Minor** — cosmetic, wording issues

---

## 10. Related Documents

- [TEST_CASES.md](./TEST_CASES.md) — Detailed test cases per feature area
- [TEST_DATA.md](./TEST_DATA.md) — Test data, sample projects, and environment setup
