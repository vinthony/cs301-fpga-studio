#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p out evidence
iverilog -g2012 -s tb -o out/check rtl/DotSelect.v verification/tb.sv
vvp out/check
python3 verification/check.py
