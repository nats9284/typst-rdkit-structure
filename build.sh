#!/bin/bash
set -euxo pipefail
source <path-to-emsdk >/emsdk_env.sh
make release_wasm
