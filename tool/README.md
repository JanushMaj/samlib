# Migration Scripts

## TaskElement to Assignment Migration

`migrate_task_assignments.py` converts every `TaskElement` in Firestore into
individual assignment documents.

Run once with a service account configured:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json
python tool/migrate_task_assignments.py
```

A marker document `migrations/task_element_assignments` prevents accidental
re‑running.
