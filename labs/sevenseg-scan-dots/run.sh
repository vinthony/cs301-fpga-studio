#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p out evidence
iverilog -g2012 -s tb -o out/check rtl/DotSelect.v rtl/SevenSegmentScanDots.v verification/tb.sv
vvp out/check
