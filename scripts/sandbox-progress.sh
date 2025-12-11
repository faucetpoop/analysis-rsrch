#!/bin/bash
# sandbox-progress.sh - View combined progress logs from all sandboxes

echo "==================================================================="
echo "MULTI-SANDBOX ARCHITECTURE - COMBINED PROGRESS LOG"
echo "==================================================================="
echo ""

for sandbox in sandboxes/*/; do
    sandbox_name=$(basename "$sandbox")

    if [ -f "${sandbox}ai/progress.log" ]; then
        echo "-------------------------------------------------------------------"
        echo "Sandbox: $sandbox_name"
        echo "-------------------------------------------------------------------"
        cat "${sandbox}ai/progress.log"
        echo ""
    fi
done

echo "==================================================================="
