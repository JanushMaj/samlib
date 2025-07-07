# SAMLIB Project – Code Conventions

## Overview

This project follows a clean and maintainable architecture, inspired by principles of Clean Architecture and Domain-Driven Design. However, decisions are made pragmatically, not dogmatically.

The structure is divided into layers:

- `domain/` – pure Dart models and logic, free of external dependencies.
- `data/` – DTOs, Firebase services, repositories.
- `feature/` – Cubits and UI widgets per feature.
- `shared/` – reusable UI components and utilities.

---

## ✅ Layered Rules

### `domain/` – Domain Layer

- No Firebase, Flutter, or JSON imports.
- Only Dart types and business logic.
- Fields are explicitly typed and immutable where possible.

### `data/` – Data Layer

- DTOs are manually implemented – **no `json_serializable`, no `.g.dart`**.
- Firestore interaction is limited to this layer.
- DTOs handle mapping: `fromJson`, `toJson`, `fromFirestore`, `toDomain`.

### `feature/` – Feature Layer

- UI widgets and Cubits are feature-scoped.
- Cubits orchestrate logic, but do **not** contain Firebase, JSON, or Firestore logic.
- No usage of `BuildContext`, `Navigator`, `ScaffoldMessenger`, or Flutter-specific APIs in logic or services.

---

## ❌ Things We Never Do (By Design)

- ❌ We do **not** use `json_serializable`.
- ❌ We do **not** include `.g.dart` or use `build_runner`.
- ❌ We do **not** allow DTOs in the UI layer.
- ❌ We do **not** write domain models with serialization.
- ❌ We do **not** duplicate logic across cubits and services.

---

## ⚠️ About Testing

> "Tests on production" – with context.



This decision is conscious and context-driven. 


---

## 🚷 Architecture Freeze – No Going Back

To avoid pointless refactors and flip-flopping between styles, the current architecture is **frozen**.

- We **do not** revert to `json_serializable`, ever.
- We **do not** refactor DTOs back into domain models.
- We **do not** embed logic in UI widgets.

This keeps the codebase stable, scalable, and easy to onboard into.

---

## 🧠 Remember

This project is:
- built on pragmatic, opinionated decisions,
- structured for maintainability,
- optimized for clarity, not academic perfection.

When in doubt: **keep layers clean, dependencies simple, and logic obvious**.
