# Roles and Starting Screens

This document explains how the app picks the initial screen after a user logs in.
The logic lives in `feature/auth/wrapper/auth_wrapper.dart` inside `_resolveHomeRoute`.

## Permission mapping

The route is resolved in order using the following rules:

1. Users without `canUseApp` are sent to `/noAccess`.
2. Everyone else lands on `/grafik`.

## Example

Initially users were routed directly to specific screens based on permissions.
After some iterations the starting screen has settled on `/grafik` for all
authenticated users who have `canUseApp` enabled.
