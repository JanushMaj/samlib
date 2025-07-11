# Roles and Starting Screens

This document explains how the app picks the initial screen after a user logs in.
The logic lives in `feature/auth/wrapper/auth_wrapper.dart` inside `_resolveHomeRoute`.

## Permission mapping

The route is resolved in order using the following rules:

1. Users without `canUseApp` are sent to `/noAccess`.
2. Everyone else lands on `/mainMenu`.

## Example

Previously users were routed directly to specific screens based on permissions.
After introducing the main menu, all authenticated users with `canUseApp`
enabled start at `/mainMenu` regardless of other permissions.
