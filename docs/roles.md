# Roles and Starting Screens

This document explains how the app picks the initial screen after a user logs in.
The logic lives in `feature/auth/wrapper/auth_wrapper.dart` inside `_resolveHomeRoute`.

## Permission mapping

The route is resolved in order using the following rules:

1. Users without `canUseApp` are sent to `/noAccess`.
2. Everyone else lands on `/grafik`.

## Supply run approval

The app defines a `canApprove` permission used for confirming supply runs.
By default this permission is enabled for the `admin`, `kierownik` and
`kierownikProdukcji` roles.  Accessing the `/approveSupplyRuns` route requires
this permission.

## Service request approval

Service requests can be approved by users that have the
`canApproveServiceTasks` permission. By default this is granted to the `admin`,
`kierownik` and `kierownikProdukcji` roles. The approval screen lives at
`/approveServiceRequests` and becomes available as a menu action in the service
request list for those users.

## Example

Initially users were routed directly to specific screens based on permissions.
After some iterations the starting screen has settled on `/grafik` for all
authenticated users who have `canUseApp` enabled.
