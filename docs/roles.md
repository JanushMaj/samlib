# Roles and Starting Screens

This document explains how the app picks the initial screen after a user logs in.
The logic lives in `feature/auth/wrapper/auth_wrapper.dart` inside `_resolveHomeRoute`.

## Permission mapping

The route is resolved in order using the following rules:

1. Users without `canUseApp` are sent to `/noAccess`.
2. Users with `canSeeWeeklySummary` go to `/weekGrafik`.
3. Users with `canEditGrafik` or `canSeeAllGrafik` go to `/grafik`.
4. Everyone else is taken to `/myTasks`.

## Example

A simplified example mapping might look like:

- Users with `canEditGrafik` → `/weekGrafik`
- Role `hala` → `/grafik`
- Others with `canUseApp` → `/myTasks`
