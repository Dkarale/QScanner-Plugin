# Test Data & Environment Setup: QScanner VS Code Extension
**Jira Epic:** CMS-33577  
**Version:** 1.0  
**Date:** 2026-07-06  

---

## 1. Test Environment Setup

### 1.1 Required Software

| Component | Version / Notes |
|---|---|
| VS Code | Latest stable (≥ 1.85) |
| Windsurf IDE | Latest stable |
| Node.js | 18.x LTS (for extension host) |
| QScanner Binary | Latest from Qualys CDN (pre-download for offline tests) |
| OS | Linux x64, macOS x64, macOS ARM64, Windows x64 |

### 1.2 VS Code Extension Installation

```bash
# Build VSIX (from extension source)
npm run package

# Install VSIX
code --install-extension qscanner-vscode-<version>.vsix
```

### 1.3 Required Qualys Credentials

| Credential Type | Where to Get |
|---|---|
| Access Token | Qualys CS QA/Staging pod → Account → API tokens |
| OAuth Client ID + Secret | Qualys CS QA/Staging pod → OAuth app registration |
| Gateway URL (Staging) | e.g., `https://gateway-stg.qualys.com` |
| POD name | e.g., `us1`, `eu1` (staging equivalents) |

> **Security Note:** Never commit credentials to the repository. Store in environment variables or VS Code `SecretStorage` only.

---

## 2. Test Project Datasets

> **Coverage note:** QScanner supports 8 language ecosystems for SCA. Each supported manifest/lock file type has a dedicated test dataset below. Repository-mode files (scanned via `qscanner code`) are the primary target for the VS Code extension.

### Supported Language × File Coverage Matrix

| # | Language | Manifest / Lock File | Supported In Repo Mode | Test Dataset |
|---|---|---|---|---|
| 1 | Ruby | `Gemfile.lock` | ✅ | TD-04 |
| 1 | Ruby | `*.gemspec` | ✅ | TD-04 |
| 2 | Rust | `Cargo.lock` | ✅ | TD-05 |
| 3 | PHP | `composer.lock` | ✅ | TD-06 |
| 3 | PHP | `installed.json` | ✅ | TD-06 |
| 4 | Java | `pom.xml` | ✅ | TD-07 |
| 4 | Java | `gradle.lockfile` | ✅ | TD-07 |
| 4 | Java | `.sbt.lock` | ✅ | TD-07 |
| 5 | Go | `go.mod` | ✅ | TD-03 |
| 6 | Python | `requirements.txt` | ✅ | TD-02 |
| 6 | Python | `Pipfile.lock` | ✅ | TD-08 |
| 6 | Python | `poetry.lock` | ✅ | TD-08 |
| 6 | Python | `uv.lock` | ✅ | TD-08 |
| 6 | Python | `environment.yaml` (conda) | ✅ | TD-08 |
| 7 | .NET | `packages.lock.json` | ✅ | TD-09 |
| 7 | .NET | `packages.config` | ✅ | TD-09 |
| 7 | .NET | `deps.json` | ✅ | TD-09 |
| 7 | .NET | `packages.props` | ✅ | TD-09 |
| 7 | .NET | `App.runtimeconfig.json` | ✅ | TD-09 |
| 8 | Node.js | `package-lock.json` | ✅ | TD-01 |
| 8 | Node.js | `yarn.lock` | ✅ | TD-10 |
| 8 | Node.js | `bun.lock` | ✅ | TD-10 |
| 8 | Node.js | `pnpm-lock.yaml` | ✅ | TD-10 |

---

### 2.1 TD-01: Node.js (npm) — `package-lock.json` Vulnerable Project

**Purpose:** SCA scan (TC-F3-01, TC-F3-02, TC-F3-03), Patch All (TC-F6-01), Patch Single npm (TC-F5-01)

**Structure:**
```
test-projects/npm-vulnerable/
├── package.json
└── package-lock.json
```

**`package.json`:**
```json
{
  "name": "qscanner-test-npm-vulnerable",
  "version": "1.0.0",
  "dependencies": {
    "lodash": "4.17.15",
    "axios": "0.19.0",
    "minimist": "1.2.0",
    "path-parse": "1.0.6",
    "hosted-git-info": "2.7.1",
    "ws": "6.2.1",
    "glob-parent": "3.1.0",
    "browserslist": "4.14.2"
  }
}
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| lodash | 4.17.15 | CVE-2021-23337 | HIGH | Yes → 4.17.21 |
| axios | 0.19.0 | CVE-2023-45857 | MEDIUM | Yes → 1.6.0 |
| minimist | 1.2.0 | CVE-2021-44906 | CRITICAL | Yes → 1.2.6 |
| path-parse | 1.0.6 | CVE-2021-23343 | MEDIUM | Yes → 1.0.7 |
| hosted-git-info | 2.7.1 | CVE-2021-23362 | MEDIUM | Yes → 2.8.9 |
| ws | 6.2.1 | CVE-2024-37890 | HIGH | Yes → 6.2.3 |

---

### 2.2 TD-02: Python — `requirements.txt` Vulnerable Project

**Purpose:** Patch pip (TC-F5-02), SCA scan cross-ecosystem

**Structure:**
```
test-projects/python-vulnerable/
├── requirements.txt
└── app.py
```

**`requirements.txt`:**
```
Flask==2.0.1
Pillow==8.3.1
cryptography==3.3.1
PyYAML==5.3.1
urllib3==1.26.4
requests==2.25.0
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| Pillow | 8.3.1 | CVE-2023-44271 | HIGH | Yes → 10.0.1 |
| cryptography | 3.3.1 | CVE-2023-49083 | HIGH | Yes → 41.0.6 |
| PyYAML | 5.3.1 | CVE-2020-14343 | CRITICAL | Yes → 6.0 |
| urllib3 | 1.26.4 | CVE-2023-45803 | MEDIUM | Yes → 2.0.7 |

---

### 2.3 TD-03: Go — `go.mod` Vulnerable Project

**Purpose:** Patch Go (TC-F5-03), go mod tidy prompt

**Structure:**
```
test-projects/go-vulnerable/
├── go.mod
├── go.sum
└── main.go
```

**`go.mod`:**
```
module qscanner-test-go

go 1.20

require (
    github.com/gin-gonic/gin v1.7.0
    golang.org/x/crypto v0.0.0-20210513164829-c07d793c2f9a
    github.com/dgrijalva/jwt-go v3.2.0+incompatible
)
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| golang.org/x/crypto | 0.0.0-20210513 | CVE-2022-27191 | HIGH | Yes |
| github.com/dgrijalva/jwt-go | v3.2.0 | CVE-2020-26160 | HIGH | Yes → use golang-jwt/jwt |

---

### 2.4 TD-04: Ruby — `Gemfile.lock` + `gemspec` Vulnerable Project

**Purpose:** SCA scan coverage for Ruby ecosystem; verify Gemfile.lock and gemspec manifest parsing

**Structure:**
```
test-projects/ruby-vulnerable/
├── Gemfile
├── Gemfile.lock
└── myapp.gemspec
```

**`Gemfile`:**
```ruby
source 'https://rubygems.org'
gem 'rack', '2.1.4'
gem 'nokogiri', '1.10.9'
gem 'rails', '6.0.3.2'
gem 'devise', '4.7.1'
```

**`Gemfile.lock`** (pinned vulnerable versions):
```
GEMS
  remote: https://rubygems.org/
  specs:
    rack (2.1.4)
    nokogiri (1.10.9)
      mini_portile2 (~> 2.4.0)
    rails (6.0.3.2)
    devise (4.7.1)

BUNDLED WITH
   2.1.4
```

**`myapp.gemspec`:**
```ruby
Gem::Specification.new do |s|
  s.name        = 'myapp'
  s.version     = '0.1.0'
  s.add_dependency 'rack', '2.1.4'
  s.add_dependency 'nokogiri', '1.10.9'
end
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| nokogiri | 1.10.9 | CVE-2021-30560 | HIGH | Yes → 1.13.6 |
| rack | 2.1.4 | CVE-2022-44570 | MEDIUM | Yes → 2.2.6.4 |
| rails | 6.0.3.2 | CVE-2021-22880 | MEDIUM | Yes → 6.0.3.7 |

---

### 2.5 TD-05: Rust — `Cargo.lock` Vulnerable Project

**Purpose:** SCA scan coverage for Rust ecosystem; verify `Cargo.lock` parsing

**Structure:**
```
test-projects/rust-vulnerable/
├── Cargo.toml
└── Cargo.lock
```

**`Cargo.toml`:**
```toml
[package]
name = "qscanner-test-rust"
version = "0.1.0"
edition = "2021"

[dependencies]
time = "0.1.44"
openssl = "0.10.45"
regex = "1.5.4"
crossbeam-utils = "0.8.4"
```

**`Cargo.lock`** (pinned vulnerable versions — key entries):
```toml
[[package]]
name = "time"
version = "0.1.44"
source = "registry+https://github.com/rust-lang/crates.io-index"

[[package]]
name = "openssl"
version = "0.10.45"
source = "registry+https://github.com/rust-lang/crates.io-index"

[[package]]
name = "regex"
version = "1.5.4"
source = "registry+https://github.com/rust-lang/crates.io-index"
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| time | 0.1.44 | CVE-2020-26235 | MEDIUM | Yes → 0.3.x |
| openssl | 0.10.45 | CVE-2023-0286 | HIGH | Yes → 0.10.55 |
| regex | 1.5.4 | CVE-2022-24713 | MEDIUM | Yes → 1.5.5 |

---

### 2.6 TD-06: PHP — `composer.lock` + `installed.json` Vulnerable Project

**Purpose:** SCA scan coverage for PHP ecosystem; verify both `composer.lock` and `installed.json` manifest parsing

**Structure:**
```
test-projects/php-vulnerable/
├── composer.json
├── composer.lock
└── vendor/
    └── composer/
        └── installed.json
```

**`composer.json`:**
```json
{
  "name": "qscanner/test-php-vulnerable",
  "require": {
    "symfony/http-foundation": "4.4.0",
    "guzzlehttp/guzzle": "6.5.4",
    "monolog/monolog": "1.25.0",
    "phpunit/phpunit": "8.5.0"
  }
}
```

**`composer.lock`** (key vulnerable entries):
```json
{
  "packages": [
    {
      "name": "symfony/http-foundation",
      "version": "v4.4.0"
    },
    {
      "name": "guzzlehttp/guzzle",
      "version": "6.5.4"
    },
    {
      "name": "monolog/monolog",
      "version": "1.25.0"
    }
  ]
}
```

**`vendor/composer/installed.json`** (mirrors above packages for installed.json scan coverage)

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| symfony/http-foundation | 4.4.0 | CVE-2021-41270 | MEDIUM | Yes → 4.4.35 |
| guzzlehttp/guzzle | 6.5.4 | CVE-2022-29248 | HIGH | Yes → 7.4.5 |
| phpunit/phpunit | 8.5.0 | CVE-2017-9841 | CRITICAL | Yes → 9.x |

---

### 2.7 TD-07: Java — `pom.xml` + `gradle.lockfile` + `.sbt.lock` Vulnerable Projects

**Purpose:** SCA scan coverage for Java ecosystem across all three build systems

**Structure:**
```
test-projects/java-vulnerable/
├── maven/
│   └── pom.xml
├── gradle/
│   ├── build.gradle
│   └── gradle.lockfile
└── sbt/
    ├── build.sbt
    └── project/
        └── .sbt.lock
```

#### 2.7a `pom.xml` (Maven):
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.qualys.test</groupId>
  <artifactId>qscanner-test-java</artifactId>
  <version>1.0.0</version>
  <dependencies>
    <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-core</artifactId>
      <version>2.14.1</version>
    </dependency>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.12.3</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.3.10</version>
    </dependency>
    <dependency>
      <groupId>commons-collections</groupId>
      <artifactId>commons-collections</artifactId>
      <version>3.2.1</version>
    </dependency>
  </dependencies>
</project>
```

#### 2.7b `gradle.lockfile` (Gradle):
```
org.apache.logging.log4j:log4j-core:2.14.1=runtimeClasspath
com.fasterxml.jackson.core:jackson-databind:2.12.3=runtimeClasspath
```

#### 2.7c `.sbt.lock` (SBT — placed in `project/`):
```
[libraries]
  "org.apache.logging.log4j:log4j-core:2.14.1": {
    configurations: [compile]
  }
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| log4j-core | 2.14.1 | CVE-2021-44228 (Log4Shell) | CRITICAL | Yes → 2.17.1 |
| jackson-databind | 2.12.3 | CVE-2021-46877 | HIGH | Yes → 2.14.2 |
| spring-webmvc | 5.3.10 | CVE-2022-22965 (Spring4Shell) | CRITICAL | Yes → 5.3.18 |
| commons-collections | 3.2.1 | CVE-2015-6420 | CRITICAL | Yes → 3.2.2 |

---

### 2.8 TD-08: Python — Additional Lock File Variants

**Purpose:** SCA scan coverage for `Pipfile.lock`, `poetry.lock`, `uv.lock`, and `environment.yaml` (conda)

**Structure:**
```
test-projects/python-lockfiles/
├── pipenv/
│   ├── Pipfile
│   └── Pipfile.lock
├── poetry/
│   ├── pyproject.toml
│   └── poetry.lock
├── uv/
│   ├── pyproject.toml
│   └── uv.lock
└── conda/
    └── environment.yaml
```

#### 2.8a `Pipfile.lock` (Pipenv):
```json
{
  "default": {
    "pillow": {"version": "==8.3.1"},
    "cryptography": {"version": "==3.3.1"},
    "pyyaml": {"version": "==5.3.1"}
  }
}
```

#### 2.8b `poetry.lock` (Poetry — key entries):
```toml
[[package]]
name = "Pillow"
version = "8.3.1"

[[package]]
name = "cryptography"
version = "3.3.1"

[[package]]
name = "PyYAML"
version = "5.3.1"
```

#### 2.8c `uv.lock`:
```toml
[[package]]
name = "pillow"
version = "8.3.1"

[[package]]
name = "cryptography"
version = "3.3.1"
```

#### 2.8d `environment.yaml` (Conda):
```yaml
name: qscanner-test-conda
channels:
  - defaults
dependencies:
  - python=3.9
  - pillow=8.3.1
  - cryptography=3.3.1
  - pyyaml=5.3.1
```

**Known CVEs:** Same as TD-02 (Pillow, cryptography, PyYAML)

---

### 2.9 TD-09: .NET — All Five Manifest Types

**Purpose:** SCA scan coverage for .NET ecosystem across `packages.lock.json`, `packages.config`, `deps.json`, `packages.props`, `App.runtimeconfig.json`

**Structure:**
```
test-projects/dotnet-vulnerable/
├── packages-lock/
│   └── packages.lock.json
├── packages-config/
│   └── packages.config
├── deps-json/
│   └── MyApp.deps.json
├── packages-props/
│   └── Packages.props
└── runtime-config/
    └── App.runtimeconfig.json
```

#### 2.9a `packages.lock.json` (NuGet lock file):
```json
{
  "version": 1,
  "dependencies": {
    "net6.0": {
      "Newtonsoft.Json": {
        "type": "Direct",
        "requested": "[12.0.3, )",
        "resolved": "12.0.3",
        "contentHash": "..."
      },
      "System.Text.RegularExpressions": {
        "type": "Direct",
        "resolved": "4.3.0"
      }
    }
  }
}
```

#### 2.9b `packages.config` (legacy NuGet):
```xml
<?xml version="1.0" encoding="utf-8"?>
<packages>
  <package id="Newtonsoft.Json" version="12.0.3" targetFramework="net48" />
  <package id="System.Text.RegularExpressions" version="4.3.0" targetFramework="net48" />
  <package id="log4net" version="2.0.8" targetFramework="net48" />
</packages>
```

#### 2.9c `MyApp.deps.json` (runtime deps manifest — key entries):
```json
{
  "targets": {
    ".NETCoreApp,Version=v6.0": {
      "Newtonsoft.Json/12.0.3": { "runtime": {} },
      "log4net/2.0.8": { "runtime": {} }
    }
  },
  "libraries": {
    "Newtonsoft.Json/12.0.3": { "type": "package" },
    "log4net/2.0.8": { "type": "package" }
  }
}
```

#### 2.9d `Packages.props` (Central Package Management):
```xml
<Project>
  <ItemGroup>
    <PackageVersion Include="Newtonsoft.Json" Version="12.0.3" />
    <PackageVersion Include="log4net" Version="2.0.8" />
  </ItemGroup>
</Project>
```

#### 2.9e `App.runtimeconfig.json`:
```json
{
  "runtimeOptions": {
    "tfm": "net6.0",
    "framework": {
      "name": "Microsoft.NETCore.App",
      "version": "6.0.0"
    }
  }
}
```

**Known CVEs (expected):**
| Package | Version | CVE | Severity | Patchable |
|---|---|---|---|---|
| Newtonsoft.Json | 12.0.3 | CVE-2024-21907 | HIGH | Yes → 13.0.3 |
| System.Text.RegularExpressions | 4.3.0 | CVE-2019-0820 | HIGH | Yes → 4.3.1 |
| log4net | 2.0.8 | CVE-2018-1285 | CRITICAL | Yes → 2.0.15 |

---

### 2.10 TD-10: Node.js — Alternative Lock File Variants (`yarn.lock`, `bun.lock`, `pnpm-lock.yaml`)

**Purpose:** SCA scan coverage for Yarn, Bun, and pnpm lock file formats

**Structure:**
```
test-projects/nodejs-lockfiles/
├── yarn/
│   ├── package.json
│   └── yarn.lock
├── bun/
│   ├── package.json
│   └── bun.lock
└── pnpm/
    ├── package.json
    └── pnpm-lock.yaml
```

#### 2.10a `yarn.lock` (Yarn Classic v1):
```
lodash@4.17.15:
  version "4.17.15"
  resolved "https://registry.yarnpkg.com/lodash/-/lodash-4.17.15.tgz"
  integrity sha512-...

minimist@1.2.0:
  version "1.2.0"
  resolved "https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz"
  integrity sha512-...

axios@0.19.0:
  version "0.19.0"
  resolved "https://registry.yarnpkg.com/axios/-/axios-0.19.0.tgz"
  integrity sha512-...
```

#### 2.10b `bun.lock`:
```
{
  "lockfileVersion": 0,
  "packages": {
    "lodash": ["lodash@4.17.15", "", {}, "sha512-..."],
    "minimist": ["minimist@1.2.0", "", {}, "sha512-..."]
  }
}
```

#### 2.10c `pnpm-lock.yaml`:
```yaml
lockfileVersion: '6.0'
packages:
  /lodash@4.17.15:
    resolution: {integrity: sha512-...}
    dev: false
  /minimist@1.2.0:
    resolution: {integrity: sha512-...}
    dev: false
  /axios@0.19.0:
    resolution: {integrity: sha512-...}
    dev: false
```

**Known CVEs (expected):** Same as TD-01 (lodash, minimist, axios)

---

### 2.11 TD-11: Clean Project — No Vulnerabilities

**Purpose:** Empty state test (TC-F3-10)

**Structure:**
```
test-projects/clean-project/
├── package.json
└── index.js
```

**`package.json`:**
```json
{
  "name": "qscanner-test-clean",
  "version": "1.0.0",
  "dependencies": {
    "chalk": "5.3.0"
  }
}
```

---

### 2.12 TD-12: Mixed Ecosystem Project — All 8 Languages

**Purpose:** Package manager auto-detection (TC-F5-09), Patch All cross-ecosystem (TC-F6-01), verify scan covers all supported languages in one workspace

**Structure:**
```
test-projects/mixed-ecosystem/
├── package-lock.json     ← Node.js/npm (from TD-01)
├── yarn.lock             ← Node.js/yarn (from TD-10)
├── requirements.txt      ← Python/pip (from TD-02)
├── Pipfile.lock          ← Python/pipenv (from TD-08)
├── go.mod                ← Go (from TD-03)
├── Gemfile.lock          ← Ruby (from TD-04)
├── Cargo.lock            ← Rust (from TD-05)
├── composer.lock         ← PHP (from TD-06)
├── pom.xml               ← Java/Maven (from TD-07)
├── packages.lock.json    ← .NET (from TD-09)
└── README.md
```

Use vulnerable versions from their respective TDs above.

---

### 2.13 TD-13: Monorepo / Nested Project — Walk-Up Test

**Purpose:** Lock-file walk-up to git root (TC-F5-06), Right-click subfolder scan (TC-F9-03)

**Structure:**
```
test-projects/monorepo/
├── .git/
├── packages/
│   ├── frontend/
│   │   └── package.json    ← vulnerable npm deps
│   └── backend/
│       └── requirements.txt ← vulnerable pip deps
└── package.json             ← workspace root (clean)
```

---

### 2.14 TD-14: Large Project — Performance / Timeout Test

**Purpose:** Scan timeout behavior (TC-F3-09), Stop scan (TC-F3-04)

**Structure:**
```
test-projects/large-project/
├── package-lock.json    ← 200+ dependencies
└── requirements.txt     ← 100+ packages
```

Generate via:
```bash
# npm: install many packages
npx create-react-app large-project --template typescript
# Add additional known-vulnerable packages
```

---

### 2.15 TD-15: AI/Cloud Compliance Test Config

**Purpose:** Compliance scanning (TC-F4-01 through TC-F4-07)

**Description:** A Dockerfile or IaC config (Terraform / CloudFormation) with known compliance violations against `CIS_DOCKER_1.6` or `NIST_AI_RMF` benchmarks.

**Structure:**
```
test-projects/compliance-test/
├── Dockerfile           ← CIS Docker violations
└── terraform/
    └── main.tf          ← Cloud misconfigurations
```

**Sample `Dockerfile` with known FAIL controls:**
```dockerfile
FROM ubuntu:20.04
# CIS DI-4.1: ensure images are not run as root (FAIL — no USER directive)
RUN apt-get update && apt-get install -y curl
# CIS DI-4.9: ensure HEALTHCHECK is set (FAIL — no HEALTHCHECK)
CMD ["/bin/bash"]
```

---

### 2.16 TD-16: Settings Validation Test Config (`settings.json` snippets)

**Purpose:** All settings configuration tests (TC-F8-*)

**Sample `.vscode/settings.json` for settings tests:**
```json
{
  "qscanner.binaryPath": "/opt/tools/qscanner",
  "qscanner.pod": "us1",
  "qscanner.gatewayUrl": "https://gateway-stg.qualys.com",
  "qscanner.excludeDirs": ["node_modules", "vendor", ".git"],
  "qscanner.excludeFiles": ["test-requirements.txt"],
  "qscanner.showOnlyPatchable": false,
  "qscanner.scanTimeout": 300,
  "qscanner.detectionPriority": "cvss",
  "qscanner.proxy": "",
  "qscanner.cacheDir": "/tmp/qscanner-cache",
  "qscanner.certPath": "",
  "qscanner.maxNetworkRetries": 3,
  "qscanner.skipVerifyTls": false,
  "qscanner.version": "latest",
  "qscanner.enableComplianceScan": false,
  "qscanner.complianceBenchmarks": ["CIS_DOCKER_1.6"]
}
```

---

## 3. Credential Test Data

### 3.1 Valid Credentials (Staging Pod)

| Field | Value |
|---|---|
| Pod | Qualys CS staging — obtain from team |
| Access Token | Obtain from QA Qualys account |
| ClientId / ClientSecret | Register OAuth app in staging |

### 3.2 Invalid Credential Cases

| Scenario | Data |
|---|---|
| Invalid token | `INVALID_TOKEN_12345` |
| Expired token | Use a known expired token from Qualys QA team |
| Empty credentials | Do not set any credential; confirm auth error |

---

## 4. Binary Platform Matrix

| Platform | Architecture | Binary Filename | Download Test Required |
|---|---|---|---|
| Linux | x64 | `qscanner-linux-amd64` | TC-F1-04 |
| macOS | x64 | `qscanner-darwin-amd64` | TC-F1-05 |
| macOS | ARM64 | `qscanner-darwin-arm64` | TC-F1-05 |
| Windows | x64 | `qscanner-windows-amd64.exe` | TC-F1-06 |

---

## 5. Environment Configurations for Special Tests

### 5.1 SecretStorage Unavailable (TC-F2-06)
- Use a headless Linux environment without `libsecret` / `gnome-keyring`
- Alternatively: mock `SecretStorage` to throw `Error: SecretStorage not available`

### 5.2 Network-Blocked Environment (TC-F1-09)
```bash
# Block outbound HTTPS to CDN (Linux iptables)
sudo iptables -A OUTPUT -d cdn.qualys.com -j DROP
# Restore after test
sudo iptables -D OUTPUT -d cdn.qualys.com -j DROP
```

### 5.3 Proxy Environment (TC-F3-08)
- Set up a local proxy (e.g., `mitmproxy` or `squid`) at `http://localhost:8080`
- Set `qscanner.proxy` = `http://localhost:8080`

---

## 6. Test Data Directory Structure

All test projects should be placed under:
```
/home/ubuntu/CascadeProjects/QScanner-Plugin/test-projects/
├── npm-vulnerable/            ← TD-01: Node.js package-lock.json
├── python-vulnerable/         ← TD-02: Python requirements.txt
├── go-vulnerable/             ← TD-03: Go go.mod
├── ruby-vulnerable/           ← TD-04: Ruby Gemfile.lock + gemspec
├── rust-vulnerable/           ← TD-05: Rust Cargo.lock
├── php-vulnerable/            ← TD-06: PHP composer.lock + installed.json
├── java-vulnerable/           ← TD-07: Java pom.xml + gradle.lockfile + .sbt.lock
│   ├── maven/
│   ├── gradle/
│   └── sbt/
├── python-lockfiles/          ← TD-08: Python Pipfile.lock, poetry.lock, uv.lock, conda
│   ├── pipenv/
│   ├── poetry/
│   ├── uv/
│   └── conda/
├── dotnet-vulnerable/         ← TD-09: .NET all 5 manifest types
│   ├── packages-lock/
│   ├── packages-config/
│   ├── deps-json/
│   ├── packages-props/
│   └── runtime-config/
├── nodejs-lockfiles/          ← TD-10: Node.js yarn.lock, bun.lock, pnpm-lock.yaml
│   ├── yarn/
│   ├── bun/
│   └── pnpm/
├── clean-project/             ← TD-11: No vulnerabilities (empty state)
├── mixed-ecosystem/           ← TD-12: All 8 languages in one workspace
├── monorepo/                  ← TD-13: Nested project walk-up test
├── large-project/             ← TD-14: Performance / timeout test
├── compliance-test/           ← TD-15: AI/Cloud compliance (CIS, NIST)
└── settings-test/             ← TD-16: .vscode/settings.json variants
```

> Run `scripts/setup-test-data.sh` (to be created) to generate these automatically.
