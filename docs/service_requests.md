# Service Request Approval Data

This document shows example Firestore documents before and after approving a service request and the task created as a result.

## Pending `service_requests` entry

```json
{
  "id": "req1",
  "startDateTime": "2024-04-25T10:00:00.000Z",
  "endDateTime": "2024-04-25T12:00:00.000Z",
  "type": "ServiceRequestElement",
  "additionalInfo": "Hydraulic leak check",
  "addedByUserId": "u1",
  "addedTimestamp": "2024-04-23T09:00:00.000Z",
  "closed": false,
  "location": "Hall A",
  "description": "Przeciek w maszynie X",
  "orderNumber": "PO-42",
  "urgency": "normal",
  "suggestedDate": "2024-04-25T10:00:00.000Z",
  "estimatedDuration": 120,
  "requiredPeopleCount": 2,
  "taskType": "Serwis",
  "status": "pending",
  "taskId": null
}
```

## After approval

The same document gets its status updated and receives a reference to the created task:

```json
{
  "status": "approved",
  "taskId": "task123"
}
```

## Resulting `task_elements_v2` entry

```json
{
  "id": "task123",
  "startDateTime": "2024-04-25T10:00:00.000Z",
  "endDateTime": "2024-04-25T12:00:00.000Z",
  "type": "TaskElement",
  "additionalInfo": "Hydraulic leak check",
  "addedByUserId": "u1",
  "addedTimestamp": "2024-04-23T09:00:00.000Z",
  "closed": false,
  "orderId": "PO-42",
  "status": "Realizacja",
  "taskType": "Serwis",
  "carIds": []
}
```
