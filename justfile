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
  pnpm -C apps/desktop tauri dev
