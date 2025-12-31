set shell := ["zsh", "-cu"]

default:
  @just --list

fmt:
  cargo fmt
  pnpm -C apps/desktop format
  pnpm -C sidecar/mail format

lint:
  cargo clippy --all-targets --all-features -- -D warnings
  pnpm -C apps/desktop lint
  pnpm -C sidecar/mail lint

test:
  cargo test --all --all-features
  pnpm -C apps/desktop test
  pnpm -C sidecar/mail test

dev:
  pnpm -C sidecar/mail dev &
  @echo "Waiting for sidecar to be ready..."
  @for i in {1..30}; do \
    lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 && echo "Sidecar is ready!" && break || sleep 1; \
  done
  @lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 || echo "Warning: Sidecar may not be ready on port 3000, but continuing..."
  pnpm -C apps/desktop tauri dev
