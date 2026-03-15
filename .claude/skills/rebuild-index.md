---
name: rebuild-index
description: Rebuild Data/index.json and increment Data/index.version from all course .json.gz files
user_invocable: true
---

Run the rebuild-index script to regenerate the course index:

```bash
python3 scripts/rebuild-index.py
```

After running, verify the output looks correct by reading `Data/index.json`.
