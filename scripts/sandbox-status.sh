#!/bin/bash
# sandbox-status.sh - Check status of all sandboxes

echo "==================================================================="
echo "MULTI-SANDBOX ARCHITECTURE - STATUS OVERVIEW"
echo "==================================================================="
echo ""

for sandbox in sandboxes/*/; do
    sandbox_name=$(basename "$sandbox")
    echo "-------------------------------------------------------------------"
    echo "Sandbox: $sandbox_name"
    echo "-------------------------------------------------------------------"
    cd "$sandbox" || continue

    if [ -f "ai/feature_list.json" ]; then
        total=$(jq '.features | length' ai/feature_list.json)
        failing=$(jq '[.features[] | select(.status == "failing")] | length' ai/feature_list.json)
        passing=$(jq '[.features[] | select(.status == "passing")] | length' ai/feature_list.json)
        blocked=$(jq '[.features[] | select(.status == "blocked")] | length' ai/feature_list.json)

        echo "Total Features:   $total"
        echo "Failing:          $failing"
        echo "Passing:          $passing"
        echo "Blocked:          $blocked"

        goal=$(jq -r '.metadata.projectGoal' ai/feature_list.json)
        echo "Goal: $goal"
    else
        echo "ERROR: No feature_list.json found"
    fi

    cd - > /dev/null || exit
    echo ""
done

echo "==================================================================="
echo "SUMMARY"
echo "==================================================================="
total_features=0
total_failing=0
total_passing=0

for sandbox in sandboxes/*/; do
    cd "$sandbox" || continue
    if [ -f "ai/feature_list.json" ]; then
        total=$(jq '.features | length' ai/feature_list.json)
        failing=$(jq '[.features[] | select(.status == "failing")] | length' ai/feature_list.json)
        passing=$(jq '[.features[] | select(.status == "passing")] | length' ai/feature_list.json)

        total_features=$((total_features + total))
        total_failing=$((total_failing + failing))
        total_passing=$((total_passing + passing))
    fi
    cd - > /dev/null || exit
done

echo "Total Features:   $total_features"
echo "Total Failing:    $total_failing"
echo "Total Passing:    $total_passing"
completion=$((total_passing * 100 / total_features))
echo "Completion:       $completion%"
echo "==================================================================="
