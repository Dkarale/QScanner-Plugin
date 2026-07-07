# TD-12: Mixed Ecosystem — All 8 SCA Languages

Used for:
- **TC-F5-09**: Package manager auto-detection across ecosystems
- **TC-F6-01**: Patch All across multiple ecosystems

## Manifest files in this project

| File | Language | Known Vulnerable Packages |
|---|---|---|
| `package-lock.json` | Node.js (npm) | lodash 4.17.15, minimist 1.2.0, axios 0.19.0 |
| `requirements.txt` | Python (pip) | Pillow 8.3.1, cryptography 3.3.1, PyYAML 5.3.1 |
| `go.mod` | Go | golang.org/x/crypto, dgrijalva/jwt-go |
| `Gemfile.lock` | Ruby | nokogiri 1.10.9, rack 2.1.4 |
| `Cargo.lock` | Rust | openssl 0.10.45, regex 1.5.4 |
| `composer.lock` | PHP | guzzlehttp/guzzle 6.5.4, phpunit/phpunit 8.5.0 |
| `pom.xml` | Java (Maven) | log4j-core 2.14.1, jackson-databind 2.12.3 |
| `packages.lock.json` | .NET | Newtonsoft.Json 12.0.3, log4net 2.0.8 |
