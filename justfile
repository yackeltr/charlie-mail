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
  #!/usr/bin/env zsh
  pnpm -C sidecar/mail dev &
  SIDECAR_PID=$!
  echo "Started sidecar (PID: $SIDECAR_PID)"
  echo "Waiting for sidecar to be ready..."
  # Give the process a moment to start before checking
  sleep 0.5
  for i in {1..30}; do
    if ! kill -0 $SIDECAR_PID 2>/dev/null; then
      echo "Error: Sidecar process died unexpectedly"
      exit 1
    fi
    if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
      echo "Sidecar is ready!"
      break
    fi
    sleep 1
  done
  if ! lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "Warning: Sidecar may not be ready on port 3000, but continuing..."
  fi
  pnpm -C apps/desktop tauri dev
