# SAMLIB

This repository contains a Flutter project. To analyze the code run:

```bash
flutter analyze
```

If you don't have Flutter installed, follow the official installation guide:

<https://docs.flutter.dev/get-started/install>

Alternatively you can install via snap on Ubuntu:

```bash
sudo snap install flutter --classic
flutter doctor
```

Then run `flutter analyze` in the repository root.

The `/approveServiceRequests` route is used for approving service task
requests in the app.


## Approving service requests

1. Navigate to `/approveServiceRequests` to view pending entries.
2. Select workers and confirm approval.
3. The app creates a task in the `task_elements_v2` collection and updates the original record in `service_requests` with `status: approved` and `taskId` of the created task.
4. Example documents are shown in `docs/service_requests.md`.
