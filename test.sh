#!/bin/bash
set -euxo pipefail
typst compile tests/test.typ --root .
