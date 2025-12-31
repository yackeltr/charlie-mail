# AI Development Rules

This document contains rules and guidelines for AI tools working on this codebase.

## Database Architecture

- **Rust owns DB writes.** The Rust core library (`crates/core/`) is responsible for all database writes. The Node.js sidecar (`sidecar/mail/`) should only return artifacts/data, never write directly to the database.

## Performance & Regressions

- **No "just fetch all UIDs" regressions.** Avoid patterns that fetch all UIDs or large datasets when more efficient alternatives exist. Always consider performance implications and use pagination, filtering, or incremental approaches when appropriate.

## Testing Requirements

- **Always add/update tests for sync + job leasing + migrations.** When working on:
  - Synchronization logic
  - Job leasing mechanisms
  - Database migrations
  
  Ensure comprehensive test coverage is added or updated.

## Schema Management

- **Prefer migrations over "edit schema in place".** Always create proper database migrations rather than modifying the schema directly. Use the `schema/` directory for migration files and follow established migration patterns.

