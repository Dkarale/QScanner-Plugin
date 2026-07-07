# Test Cases: QScanner VS Code / Windsurf Extension
**Jira Epic:** CMS-33577  
**Version:** 1.0  
**Date:** 2026-07-06  

---

## Legend

| Field | Values |
|---|---|
| **Priority** | P1 (Critical), P2 (High), P3 (Medium), P4 (Low) |
| **Status** | Not Run / Pass / Fail / Blocked / Skip |
| **Type** | Functional, Integration, Security, UI, Negative, Performance |

---

## F1 — Extension Bootstrap & Binary Management (CMS-33576)

### TC-F1-01: Extension Activates Without Binary Installed
- **Priority:** P1
- **Type:** Functional
- **Precondition:** QScanner binary not present on PATH and `binaryPath` not configured
- **Steps:**
  1. Install the `.vsix` extension in VS Code
  2. Open any workspace folder
  3. Open the QScanner sidebar panel
- **Expected:** Extension activates without error; "Install QScanner" welcome screen is displayed; `qscanner.installed` context flag = `false`
- **Status:** Not Run

### TC-F1-02: Binary Detection via PATH
- **Priority:** P1
- **Type:** Functional
- **Precondition:** `qscanner` binary is installed and available on system PATH
- **Steps:**
  1. Install extension; ensure `binaryPath` setting is empty
  2. Open workspace; open QScanner panel
- **Expected:** Binary detected automatically; welcome screen shows "Scan Now"; `qscanner.installed` = `true`
- **Status:** Not Run

### TC-F1-03: Binary Detection via `binaryPath` Setting
- **Priority:** P2
- **Type:** Functional
- **Precondition:** Binary NOT on PATH; placed at a custom path (e.g., `/opt/tools/qscanner`)
- **Steps:**
  1. Set `qscanner.binaryPath` to the custom absolute path
  2. Reload VS Code window
  3. Open QScanner panel
- **Expected:** Binary detected from custom path; extension in installed state
- **Status:** Not Run

### TC-F1-04: One-Click Binary Install (Linux x64)
- **Priority:** P1
- **Type:** Functional / Integration
- **Precondition:** Binary not installed; internet access available; Linux x64 machine
- **Steps:**
  1. Click "Install QScanner" button in welcome screen
  2. Monitor download progress notification
  3. After completion, check extension state
- **Expected:** Binary downloaded silently to extension storage dir; `qscanner.installed` = `true`; "Scan Now" welcome screen shown; no user intervention required
- **Status:** Not Run

### TC-F1-05: One-Click Binary Install (macOS ARM64)
- **Priority:** P2
- **Type:** Functional / Integration
- **Precondition:** macOS ARM64 machine; binary not installed
- **Steps:** Same as TC-F1-04 on macOS ARM64
- **Expected:** ARM64 binary variant downloaded and installed correctly
- **Status:** Not Run

### TC-F1-06: One-Click Binary Install (Windows x64)
- **Priority:** P2
- **Type:** Functional / Integration
- **Precondition:** Windows x64 machine; binary not installed
- **Steps:** Same as TC-F1-04 on Windows x64
- **Expected:** Windows `.exe` variant downloaded and installed; PATH separator handling correct
- **Status:** Not Run

### TC-F1-07: Update QScanner Binary to Latest Version
- **Priority:** P2
- **Type:** Functional
- **Precondition:** Older version of binary already installed
- **Steps:**
  1. Run `QScanner: Update QScanner` from Command Palette
  2. Observe notification
- **Expected:** Latest binary downloaded; version number updated; success notification shown
- **Status:** Not Run

### TC-F1-08: Update to Specific Version via `version` Setting
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.version` to a specific version string (e.g., `2.1.0`)
  2. Run `QScanner: Update QScanner`
- **Expected:** That specific version is downloaded, not the latest
- **Status:** Not Run

### TC-F1-09: Binary Install Fails — Network Unavailable
- **Priority:** P2
- **Type:** Negative
- **Precondition:** Network blocked / CDN unreachable
- **Steps:**
  1. Disconnect network or block CDN URL
  2. Click "Install QScanner"
- **Expected:** Error notification shown with actionable message; extension does not crash; still shows "Install QScanner" state
- **Status:** Not Run

### TC-F1-10: Binary Version Polling
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. With binary installed, run `QScanner: Show Binary Version` (or check status bar)
- **Expected:** Correct version string displayed (matches `qscanner --version` output)
- **Status:** Not Run

---

## F2 — Authentication & Secure Credential Storage (CMS-33578)

### TC-F2-01: Store Access Token via SecretStorage
- **Priority:** P1
- **Type:** Security / Functional
- **Steps:**
  1. Run `QScanner: Set Access Token (Secure)` from Command Palette
  2. Enter a valid access token in the input box
- **Expected:** Token stored in VS Code `SecretStorage` (OS keychain); token NOT written to `settings.json` or any disk-readable file; no plaintext in extension storage directory
- **Status:** Not Run

### TC-F2-02: Store OAuth Client Credentials via SecretStorage
- **Priority:** P1
- **Type:** Security / Functional
- **Steps:**
  1. Run `QScanner: Set Client Credentials (Secure)`
  2. Enter `clientId` and `clientSecret`
- **Expected:** Both values stored in `SecretStorage`; not present in `settings.json`
- **Status:** Not Run

### TC-F2-03: Credentials Never Written to Disk Unencrypted
- **Priority:** P1
- **Type:** Security
- **Steps:**
  1. Store credentials via TC-F2-01
  2. Search workspace and extension global storage dir for token string using grep
- **Expected:** Token string NOT found in any plaintext file on disk
- **Status:** Not Run

### TC-F2-04: Credential Status Display
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Run `QScanner: Show Credential Status`
- **Expected:** Shows which credential type is configured (access token / OAuth / none); does NOT reveal actual secret values
- **Status:** Not Run

### TC-F2-05: Clear Credentials
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Store credentials (TC-F2-01)
  2. Run `QScanner: Clear Credentials`
  3. Attempt a scan
- **Expected:** Credentials removed from SecretStorage; scan fails with authentication error / prompts re-authentication
- **Status:** Not Run

### TC-F2-06: Fallback to settings.json When SecretStorage Unavailable
- **Priority:** P2
- **Type:** Functional / Negative
- **Precondition:** SecretStorage unavailable (e.g., headless Linux without libsecret)
- **Steps:**
  1. Set credentials in `settings.json` directly (`qscanner.accessToken`)
  2. Reload window; attempt scan
- **Expected:** Extension falls back to reading from `settings.json`; scan proceeds with settings-based credentials
- **Status:** Not Run

### TC-F2-07: Migrate Credentials from settings.json to SecretStorage
- **Priority:** P2
- **Type:** Functional
- **Precondition:** Credentials present in `settings.json` (legacy config)
- **Steps:**
  1. Run `QScanner: Migrate Credentials from settings.json`
- **Expected:** Credentials moved to SecretStorage; removed from `settings.json`; confirmation message shown
- **Status:** Not Run

### TC-F2-08: Invalid Access Token — Scan Fails with Clear Error
- **Priority:** P2
- **Type:** Negative
- **Steps:**
  1. Store an invalid/expired access token
  2. Trigger a scan
- **Expected:** Binary returns auth error; extension shows meaningful error notification; does not crash
- **Status:** Not Run

---

## F3 — SCA Vulnerability Scanning (CMS-33580)

### TC-F3-01: Basic SCA Scan — Workspace Root
- **Priority:** P1
- **Type:** Functional / Integration
- **Precondition:** Valid credentials; binary installed; test project with known CVEs (see TEST_DATA.md)
- **Steps:**
  1. Open test project with vulnerable packages
  2. Click "Scan Now" or run `QScanner: Scan`
  3. Wait for scan to complete
- **Expected:** `qscanner code <workspace_path>` invoked with correct auth flags; `{hash}-Report.json` generated; CVE findings displayed in tree view grouped by CRITICAL / HIGH / MEDIUM / LOW
- **Status:** Not Run

### TC-F3-02: Tree View Severity Grouping
- **Priority:** P1
- **Type:** UI / Functional
- **Steps:**
  1. Run scan on project with vulnerabilities across multiple severities (TEST_DATA.md: multi-severity project)
  2. Observe the `qscannerIssueViewer` tree
- **Expected:** Separate collapsible groups for CRITICAL, HIGH, MEDIUM, LOW; each group shows correct CVE count; groups with 0 findings are not shown
- **Status:** Not Run

### TC-F3-03: Patchable Items Show Wrench Icon
- **Priority:** P2
- **Type:** UI
- **Steps:**
  1. Run scan on project with patchable and non-patchable vulnerabilities
  2. Observe icons in tree view
- **Expected:** Patchable CVEs show wrench (🔧) icon; non-patchable CVEs show warning icon; icons consistent across groups
- **Status:** Not Run

### TC-F3-04: Stop Scan Command Halts Binary Process
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Trigger scan on large project
  2. While scan is running, run `QScanner: Stop Scan`
- **Expected:** Binary process terminated; scanning spinner removed; tree view returns to pre-scan state (or shows partial results); `qscanner.scanRunning` = `false`
- **Status:** Not Run

### TC-F3-05: Scan with `excludeDirs` Setting
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.excludeDirs` to `["node_modules", "vendor"]`
  2. Run scan
- **Expected:** `--exclude-dirs node_modules,vendor` (or equivalent flag) passed to binary; excluded dirs not scanned
- **Status:** Not Run

### TC-F3-06: Scan with `excludeFiles` Setting
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.excludeFiles` to `["test-requirements.txt"]`
  2. Run scan
- **Expected:** Specified files excluded from scan via CLI flags
- **Status:** Not Run

### TC-F3-07: Scan with `detectionPriority` Setting
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.detectionPriority` to each valid value
  2. Run scan
- **Expected:** `--detection-priority <value>` flag included in binary invocation
- **Status:** Not Run

### TC-F3-08: Scan with Proxy Setting
- **Priority:** P3
- **Type:** Functional / Integration
- **Precondition:** Proxy server available
- **Steps:**
  1. Set `qscanner.proxy` to a valid proxy URL
  2. Run scan
- **Expected:** Binary invoked with `--proxy <url>` flag; scan succeeds through proxy
- **Status:** Not Run

### TC-F3-09: Scan Timeout Respected
- **Priority:** P3
- **Type:** Functional / Negative
- **Steps:**
  1. Set `qscanner.scanTimeout` to a very short value (e.g., 5 seconds)
  2. Run scan on large project
- **Expected:** Scan terminates after timeout; appropriate error/timeout notification shown
- **Status:** Not Run

### TC-F3-10: No Vulnerabilities Found — Empty State
- **Priority:** P2
- **Type:** Functional / UI
- **Steps:**
  1. Run scan on clean project with no vulnerable dependencies
- **Expected:** Tree view shows "No vulnerabilities found" or empty state message; no crashes
- **Status:** Not Run

### TC-F3-11: Report JSON Polling — File Appears After Delay
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Trigger scan; binary generates report after several seconds
  2. Observe extension polling behavior
- **Expected:** Extension polls for `{hash}-Report.json` and picks it up once written; results appear without requiring user action
- **Status:** Not Run

---

## F4 — Compliance Scanning (CMS-33581)

### TC-F4-01: Compliance Scan Disabled by Default
- **Priority:** P2
- **Type:** Functional
- **Precondition:** `qscanner.enableComplianceScan` = `false` (default)
- **Steps:**
  1. Run scan
  2. Observe tree view
- **Expected:** COMPLIANCE FINDINGS section NOT shown; `--scan-types` flag does NOT include `compliance`
- **Status:** Not Run

### TC-F4-02: Enable Compliance Scan
- **Priority:** P1
- **Type:** Functional / Integration
- **Steps:**
  1. Set `qscanner.enableComplianceScan` = `true`
  2. Set `qscanner.complianceBenchmarks` to `["CIS_DOCKER_1.6", "NIST_AI_RMF"]` (or valid benchmarks)
  3. Run scan
- **Expected:** `--scan-types sca,compliance` and `--compliance-benchmarks CIS_DOCKER_1.6,NIST_AI_RMF` passed to binary; compliance findings appear in separate COMPLIANCE FINDINGS section
- **Status:** Not Run

### TC-F4-03: FAIL Findings Shown with ✗ Icon
- **Priority:** P1
- **Type:** UI / Functional
- **Steps:**
  1. Run compliance scan against project/config with known FAIL findings
- **Expected:** FAIL findings displayed under benchmark node with ✗ indicator
- **Status:** Not Run

### TC-F4-04: SKIPPED Findings Shown with ? Icon
- **Priority:** P2
- **Type:** UI / Functional
- **Steps:**
  1. Run compliance scan where some controls are SKIPPED
- **Expected:** SKIPPED findings displayed with ? indicator
- **Status:** Not Run

### TC-F4-05: PASS Findings Hidden
- **Priority:** P1
- **Type:** Functional
- **Steps:**
  1. Run compliance scan with known PASS/FAIL/SKIPPED mix
  2. Check tree view
- **Expected:** PASS findings NOT shown anywhere in the tree view; only FAIL and SKIPPED visible
- **Status:** Not Run

### TC-F4-06: Compliance Findings Grouped by Benchmark
- **Priority:** P2
- **Type:** UI
- **Steps:**
  1. Configure multiple benchmarks; run scan
- **Expected:** Each benchmark shown as a separate expandable node under COMPLIANCE FINDINGS; findings nested under their benchmark
- **Status:** Not Run

### TC-F4-07: Compliance Section Disappears When Disabled
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Run scan with compliance enabled (findings shown)
  2. Set `enableComplianceScan` = `false`
  3. Re-run scan
- **Expected:** COMPLIANCE FINDINGS section removed from tree view after re-scan
- **Status:** Not Run

---

## F5 — Patch Orchestration Engine (CMS-33582 / CMS-33583)

### TC-F5-01: Patch Single Package — npm
- **Priority:** P1
- **Type:** Functional / Integration
- **Precondition:** Project with patchable npm vulnerability; `package.json` present
- **Steps:**
  1. Run scan; identify a patchable CVE in tree view
  2. Right-click the CVE item → "Patch"
  3. Observe backup creation, manifest update, and post-patch prompt
- **Expected:** `.qscanner/backups/<timestamp>/package.json` backup created; `package.json` updated with patched version; notification offers "Run `npm install` Now / Later / Undo"
- **Status:** Not Run

### TC-F5-02: Patch Single Package — pip (requirements.txt)
- **Priority:** P1
- **Type:** Functional / Integration
- **Steps:** Same as TC-F5-01 for a Python project with `requirements.txt` and a patchable vulnerability
- **Expected:** Backup created; `requirements.txt` patched; post-patch prompt: "Run `pip install -r requirements.txt` Now / Later / Undo"
- **Status:** Not Run

### TC-F5-03: Patch Single Package — go mod
- **Priority:** P2
- **Type:** Functional / Integration
- **Steps:** Same as TC-F5-01 for a Go project with `go.mod` and a patchable vulnerability
- **Expected:** `go.mod` patched; post-patch prompt: "Run `go mod tidy` Now / Later / Undo"
- **Status:** Not Run

### TC-F5-04: Backup Created Before Write
- **Priority:** P1
- **Type:** Functional / Security
- **Steps:**
  1. Trigger any patch operation
  2. Inspect `.qscanner/backups/` directory
- **Expected:** Timestamped backup directory created before manifest is modified; backup contains original (unmodified) manifest file
- **Status:** Not Run

### TC-F5-05: Undo Patch Restores Original File
- **Priority:** P1
- **Type:** Functional
- **Steps:**
  1. Record original file hash/content
  2. Apply a patch
  3. Click "Undo" in the post-patch notification
- **Expected:** Manifest file restored to original content; backup file content matches restored file; success notification shown
- **Status:** Not Run

### TC-F5-06: Lock-file → Manifest Walk-Up (8 levels)
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Create a project where lock file is at root but a nested subproject is scanned (deep in directory tree)
  2. Patch a vulnerability in the nested subproject
- **Expected:** Extension walks up directory tree (up to 8 levels or git root) to find the correct manifest; correct manifest patched, not an incorrect parent
- **Status:** Not Run

### TC-F5-07: Post-Patch "Run Now" Executes Install Command
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Apply a patch
  2. Click "Run Now" in notification
- **Expected:** Install command executed in VS Code integrated terminal; output visible to user
- **Status:** Not Run

### TC-F5-08: Post-Patch "Later" Dismisses Without Running
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Apply a patch
  2. Click "Later"
- **Expected:** Notification dismissed; no command run; patched manifest retained
- **Status:** Not Run

### TC-F5-09: Package Manager Auto-Detection
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Open project with mixed package manager files (`package.json` + `requirements.txt` + `go.mod`)
  2. Patch a vulnerability from each ecosystem
- **Expected:** Correct package manager detected for each CVE; correct post-patch command suggested for each
- **Status:** Not Run

---

## F6 — Patch All & Patch By Severity (CMS-33584)

### TC-F6-01: Patch All — All Patchable Vulnerabilities Fixed
- **Priority:** P1
- **Type:** Functional / Integration
- **Precondition:** Scan results with multiple patchable vulnerabilities across severities
- **Steps:**
  1. Click "Patch All" toolbar button
  2. Confirm prompt (if any)
- **Expected:** All patchable vulnerabilities patched; separate backup per manifest file; post-patch prompt per package manager; non-patchable vulnerabilities remain
- **Status:** Not Run

### TC-F6-02: Patch All Button Visibility
- **Priority:** P2
- **Type:** UI
- **Steps:**
  1. Open extension before scan — observe toolbar
  2. Run scan with patchable results — observe toolbar
  3. Run scan with no patchable results — observe toolbar
- **Expected:** Patch All button visible ONLY when scan results with at least one patchable vulnerability exist
- **Status:** Not Run

### TC-F6-03: Patch By Severity (CRITICAL group)
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Run scan; right-click CRITICAL severity group node
  2. Select "Patch All in Group"
- **Expected:** Only CRITICAL patchable vulnerabilities patched; HIGH/MEDIUM/LOW untouched
- **Status:** Not Run

### TC-F6-04: Patch By Severity — Right-Click Context Menu Availability
- **Priority:** P2
- **Type:** UI
- **Steps:**
  1. Right-click CRITICAL, HIGH, MEDIUM, LOW group nodes
  2. Right-click individual CVE node
  3. Right-click non-patchable group
- **Expected:** "Patch All in Group" shown on severity group nodes; not shown on groups with no patchable items; individual CVE right-click shows single-item patch option
- **Status:** Not Run

---

## F7 — UI — Findings Panel, Detail View & Welcome Screens (CMS-33585)

### TC-F7-01: Welcome Screen — "Install QScanner" State
- **Priority:** P1
- **Type:** UI
- **Precondition:** Binary not installed; `qscanner.installed` = `false`
- **Steps:**
  1. Open QScanner sidebar panel
- **Expected:** "Install QScanner" button displayed; no scan controls visible
- **Status:** Not Run

### TC-F7-02: Welcome Screen — "Scan Now" State
- **Priority:** P1
- **Type:** UI
- **Precondition:** Binary installed; no scan running; no existing results
- **Steps:**
  1. Open QScanner sidebar panel after binary is detected
- **Expected:** "Scan Now" button displayed; `qscanner.installed` = `true`, `scanRunning` = `false`, `hasResults` = `false`
- **Status:** Not Run

### TC-F7-03: Welcome Screen — Scanning Spinner State
- **Priority:** P1
- **Type:** UI
- **Steps:**
  1. Trigger a scan
  2. Observe sidebar panel immediately
- **Expected:** Scanning spinner/progress indicator shown; `qscanner.scanRunning` = `true`; Scan Now button hidden
- **Status:** Not Run

### TC-F7-04: CVE Detail View Opens on Item Click
- **Priority:** P1
- **Type:** UI / Functional
- **Steps:**
  1. Run scan; click a CVE item in tree view
- **Expected:** `qscannerHelpViewer` webview opens alongside; displays CVE ID, CVSS score, description, affected package, fix version, links
- **Status:** Not Run

### TC-F7-05: Compliance Detail View Opens on Item Click
- **Priority:** P2
- **Type:** UI / Functional
- **Steps:**
  1. Run compliance scan; click a FAIL compliance finding
- **Expected:** Detail webview shows control ID, benchmark, description, posture (FAIL), remediation guidance
- **Status:** Not Run

### TC-F7-06: Context Flags Transition Correctly
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Observe `qscanner.installed` / `scanRunning` / `hasResults` across: no binary → binary installed → scan started → scan completed → cleared
- **Expected:** Each flag transitions at the correct moment; UI state always consistent with flags
- **Status:** Not Run

### TC-F7-07: SCA Findings and Compliance Findings in Separate Sections
- **Priority:** P2
- **Type:** UI
- **Steps:**
  1. Run scan with both SCA and compliance enabled
- **Expected:** Tree view has distinct sections: SCA findings (severity-grouped) and COMPLIANCE FINDINGS (benchmark-grouped); sections clearly labeled
- **Status:** Not Run

---

## F8 — Configuration & Settings (CMS-33586)

### TC-F8-01: All Settings Registered and Visible in VS Code Settings UI
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Open VS Code Settings (UI mode)
  2. Search for "qscanner"
- **Expected:** All 16 settings visible: `binaryPath`, `pod`, `gatewayUrl`, `excludeDirs`, `excludeFiles`, `showOnlyPatchable`, `scanTimeout`, `detectionPriority`, `proxy`, `cacheDir`, `certPath`, `maxNetworkRetries`, `skipVerifyTls`, `version`, `enableComplianceScan`, `complianceBenchmarks`
- **Status:** Not Run

### TC-F8-02: `showOnlyPatchable` Filters Tree View in Real-Time
- **Priority:** P2
- **Type:** Functional / UI
- **Steps:**
  1. Run scan; verify full tree view with both patchable and non-patchable items
  2. Toggle `qscanner.showOnlyPatchable` = `true`
- **Expected:** Non-patchable CVEs immediately hidden from tree view without re-scan; toggle back restores them
- **Status:** Not Run

### TC-F8-03: `gatewayUrl` Used Instead of `pod` When Set
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.gatewayUrl` to a valid URL
  2. Run scan; capture binary invocation
- **Expected:** `--gateway-url <value>` flag used; `--pod` not passed
- **Status:** Not Run

### TC-F8-04: `skipVerifyTls` Passes Correct Flag
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.skipVerifyTls` = `true`
  2. Run scan
- **Expected:** `--skip-verify-tls` flag passed to binary
- **Status:** Not Run

### TC-F8-05: `certPath` Passed to Binary
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.certPath` to a valid certificate file path
  2. Run scan
- **Expected:** `--cert-path <file>` flag included in binary invocation
- **Status:** Not Run

### TC-F8-06: Settings Reactively Applied — No Restart Required
- **Priority:** P2
- **Type:** Functional
- **Steps:**
  1. Run scan; change any setting (e.g., `excludeDirs`)
  2. Run scan again without reloading window
- **Expected:** New setting value reflected in the subsequent binary invocation; no VS Code reload required
- **Status:** Not Run

### TC-F8-07: `cacheDir` Setting Directs Cache to Custom Location
- **Priority:** P3
- **Type:** Functional
- **Steps:**
  1. Set `qscanner.cacheDir` to a custom path
  2. Run scan
- **Expected:** `--cache-dir <path>` flag passed; cache files written to specified location
- **Status:** Not Run

---

## F9 — Right-Click "Scan This Project" (CMS-33588)

### TC-F9-01: Context Menu Shown on Folder Right-Click
- **Priority:** P1
- **Type:** UI / Functional
- **Steps:**
  1. In Explorer, right-click any folder node
  2. Observe context menu
- **Expected:** "QScanner: Scan This Project" item visible in context menu
- **Status:** Not Run

### TC-F9-02: Context Menu NOT Shown on File Right-Click
- **Priority:** P2
- **Type:** UI / Negative
- **Steps:**
  1. Right-click a file (not a folder) in Explorer
- **Expected:** "QScanner: Scan This Project" NOT visible in context menu (only available for `explorerResourceIsFolder`)
- **Status:** Not Run

### TC-F9-03: Scan Targets Selected Folder, Not Workspace Root
- **Priority:** P1
- **Type:** Functional
- **Steps:**
  1. Open a workspace with subdirectories: `packages/frontend`, `packages/backend`
  2. Right-click `packages/frontend` → "QScanner: Scan This Project"
  3. Observe binary invocation
- **Expected:** `qscanner code packages/frontend` (or absolute path to frontend) invoked; workspace root (`packages/`) NOT used as the scan target
- **Status:** Not Run

### TC-F9-04: Nested Folder Scan Results Shown in Panel
- **Priority:** P2
- **Type:** Functional / UI
- **Steps:**
  1. Right-click a subfolder and scan it
  2. Observe results panel
- **Expected:** Results reflect only that subfolder's findings; previous workspace-level results replaced (or shown in new context)
- **Status:** Not Run

---

## Cross-Platform & Regression

### TC-X-01: Extension Functions on Windsurf IDE
- **Priority:** P2
- **Type:** Functional / Integration
- **Steps:**
  1. Install `.vsix` in Windsurf
  2. Run a full scan workflow (install binary → authenticate → scan → view results)
- **Expected:** All features functional; no VS Code-specific API incompatibilities
- **Status:** Not Run

### TC-X-02: Path Separator Handling — Windows
- **Priority:** P2
- **Type:** Functional / Cross-Platform
- **Precondition:** Windows x64 machine
- **Steps:**
  1. Run scan on a workspace with nested folders
  2. Apply a patch
- **Expected:** No path separator bugs; backslash/forward-slash handled correctly in binary invocations and backup paths
- **Status:** Not Run

### TC-X-03: Extension Loads After VS Code Update
- **Priority:** P3
- **Type:** Regression
- **Steps:**
  1. Update VS Code to a newer version
  2. Reload and open QScanner panel
- **Expected:** Extension activates correctly; no API breakage
- **Status:** Not Run
