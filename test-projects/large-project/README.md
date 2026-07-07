# TD-14: Large Project — Performance / Timeout Test

This project must be generated locally — it is too large to commit to git.

## Generate

```bash
cd test-projects/large-project
npx create-react-app . --template typescript
```

Then add known-vulnerable packages:

```bash
npm install lodash@4.17.15 axios@0.19.0 minimist@1.2.0
```

## Purpose

- **TC-F3-09**: Scan timeout behaviour
- **TC-F3-04**: Stop scan mid-flight
