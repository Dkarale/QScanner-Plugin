# TD-16: Settings Test Project

Used for testing all `qscanner.*` VS Code settings (TC-F8-*).

## Variants to test

Edit `.vscode/settings.json` per test case:

| Test Case | Setting to change | Value to use |
|---|---|---|
| TC-F8-02 | `showOnlyPatchable` | `true` / `false` |
| TC-F8-03 | `gatewayUrl` | valid staging URL |
| TC-F8-04 | `skipVerifyTls` | `true` |
| TC-F8-05 | `certPath` | path to a `.pem` file |
| TC-F8-06 | `excludeDirs` | change values and re-scan |
| TC-F8-07 | `cacheDir` | `/tmp/custom-cache` |
