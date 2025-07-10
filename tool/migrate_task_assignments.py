#!/usr/bin/env python3
"""Migrate TaskElement documents to assignment documents.

This script reads all documents from the ``grafik_elements`` collection with
``type == 'TaskElement'`` and creates documents in ``task_assignments`` for each
worker assigned to the task. The assignment spans the full start and end time of
the task.

The script can be executed once. It checks ``migrations/task_element_assignments``
for a ``done`` flag before running. If the migration was already run it prints a
message and exits.

The script expects Google Application Credentials to be available. Set the
``GOOGLE_APPLICATION_CREDENTIALS`` environment variable to the path of your
service account JSON key before running.
"""

from google.cloud import firestore
from google.api_core.datetime_helpers import DatetimeWithNanoseconds


MIGRATION_DOC_ID = "task_element_assignments"


def migrate():
    db = firestore.Client()

    marker_ref = db.collection("migrations").document(MIGRATION_DOC_ID)
    if marker_ref.get().exists:
        print("Migration already performed. Exiting.")
        return

    tasks = (
        db.collection("grafik_elements")
        .where("type", "==", "TaskElement")
        .stream()
    )

    batch = db.batch()
    created = 0
    for task in tasks:
        data = task.to_dict()
        worker_ids = data.get("workerIds", [])
        start = data.get("startDateTime")
        end = data.get("endDateTime")
        if not isinstance(start, DatetimeWithNanoseconds) or not isinstance(
            end, DatetimeWithNanoseconds
        ):
            continue
        for wid in worker_ids:
            ref = db.collection("task_assignments").document()
            batch.set(
                ref,
                {
                    "taskId": task.id,
                    "workerId": wid,
                    "startDateTime": start,
                    "endDateTime": end,
                },
            )
            created += 1
            if created % 500 == 0:
                batch.commit()
                batch = db.batch()
    if created % 500:
        batch.commit()

    marker_ref.set({"done": True, "timestamp": firestore.SERVER_TIMESTAMP})
    print(f"Created {created} assignment documents.")


if __name__ == "__main__":
    migrate()
