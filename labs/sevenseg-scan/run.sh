#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p out evidence
rm -f evidence/web-check.json
iverilog -g2012 -s tb -o out/check rtl/SevenSegmentScan.v verification/tb.sv
vvp out/check

if [ "$#" -gt 0 ]; then
 node verification/compare_web.cjs "$1"
fi
shasum -a 256 rtl/SevenSegmentScan.v verification/tb.sv verification/compare_web.cjs run.sh > evidence/source.sha256
