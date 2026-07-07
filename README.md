# QScanner VS Code Extension — Test Artifacts

This repository contains the test plan, test cases, and test data for the **QScanner VS Code / Windsurf Extension** (Jira Epic: CMS-33577).

## Contents

| File / Directory | Description |
|---|---|
| `TEST_PLAN.md` | Test strategy, scope, objectives, risk, entry/exit criteria |
| `TEST_CASES.md` | Detailed test cases (57 cases across F1–F9 feature areas) |
| `TEST_DATA.md` | Test data reference — manifest file contents, known CVEs, environment setup |
| `test-projects/` | Actual test project files for all 16 datasets (TD-01 through TD-16) |

## Test Projects

| Dataset | Directory | Language / Ecosystem |
|---|---|---|
| TD-01 | `test-projects/npm-vulnerable/` | Node.js — `package-lock.json` |
| TD-02 | `test-projects/python-vulnerable/` | Python — `requirements.txt` |
| TD-03 | `test-projects/go-vulnerable/` | Go — `go.mod` |
| TD-04 | `test-projects/ruby-vulnerable/` | Ruby — `Gemfile.lock` + `gemspec` |
| TD-05 | `test-projects/rust-vulnerable/` | Rust — `Cargo.lock` |
| TD-06 | `test-projects/php-vulnerable/` | PHP — `composer.lock` + `installed.json` |
| TD-07 | `test-projects/java-vulnerable/` | Java — `pom.xml` + `gradle.lockfile` + `.sbt.lock` |
| TD-08 | `test-projects/python-lockfiles/` | Python — `Pipfile.lock`, `poetry.lock`, `uv.lock`, `environment.yaml` |
| TD-09 | `test-projects/dotnet-vulnerable/` | .NET — all 5 NuGet manifest types |
| TD-10 | `test-projects/nodejs-lockfiles/` | Node.js — `yarn.lock`, `bun.lock`, `pnpm-lock.yaml` |
| TD-11 | `test-projects/clean-project/` | Node.js — no vulnerabilities (empty state) |
| TD-12 | `test-projects/mixed-ecosystem/` | All 8 languages in one workspace |
| TD-13 | `test-projects/monorepo/` | Nested monorepo walk-up test |
| TD-14 | `test-projects/large-project/` | Performance / timeout test (generate locally) |
| TD-15 | `test-projects/compliance-test/` | CIS Docker + Terraform AWS misconfigs |
| TD-16 | `test-projects/settings-test/` | `.vscode/settings.json` variants |

## Quick Start

```bash
git clone <repo-url>
cd QScanner-Plugin

# Open any test project in VS Code / Windsurf
code test-projects/npm-vulnerable
```

## Generating TD-14 (Large Project) Locally

TD-14 is too large to commit. Generate it locally:

```bash
cd test-projects/large-project
npx create-react-app . --template typescript
```

## Jira

- Epic: [CMS-33577](https://qualys.atlassian.net/browse/CMS-33577)
