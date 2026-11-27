#!/bin/sh
set -eu
cd "$(dirname "$0")"
exec uv run --locked ansible-playbook -i inventory.ini polis.yml "$@"
