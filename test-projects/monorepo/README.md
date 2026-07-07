# TD-13: Monorepo — Walk-Up Test Project

Used for:
- **TC-F5-06**: Lock-file → manifest walk-up (up to git root / 8 levels)
- **TC-F9-03**: Right-click subfolder scan targets selected folder, not workspace root

## Structure

```
monorepo/                          ← workspace root (clean)
├── packages/
│   ├── frontend/                  ← Right-click scan target
│   │   ├── package.json
│   │   └── package-lock.json      ← lodash 4.17.15, minimist 1.2.0 (vulnerable)
│   └── backend/
│       └── requirements.txt       ← Pillow 8.3.1, cryptography 3.3.1 (vulnerable)
└── package.json                   ← root: clean (chalk only)
```

## How to use

1. Open this folder as the VS Code workspace root
2. Right-click `packages/frontend` → "QScanner: Scan This Project"
3. Expected: scan targets `packages/frontend`, NOT the workspace root
4. Verify CVEs from lodash/minimist appear, NOT chalk
