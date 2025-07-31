#!/bin/bash

# Script to poll GitHub Actions status for a PR
PR_NUMBER=${1:-2}  # Default to PR #2 if not specified
POLL_INTERVAL=10   # Poll every 10 seconds

echo "Polling CI status for PR #$PR_NUMBER..."

while true; do
    # Get the latest run status
    RUN_INFO=$(gh run list --branch fix-ci-hanging-tests --limit 1 --json status,conclusion,name,databaseId,createdAt)
    
    if [ -z "$RUN_INFO" ] || [ "$RUN_INFO" = "[]" ]; then
        echo "No runs found yet. Waiting..."
    else
        STATUS=$(echo "$RUN_INFO" | jq -r '.[0].status')
        CONCLUSION=$(echo "$RUN_INFO" | jq -r '.[0].conclusion')
        RUN_ID=$(echo "$RUN_INFO" | jq -r '.[0].databaseId')
        CREATED=$(echo "$RUN_INFO" | jq -r '.[0].createdAt')
        
        echo -e "\n[$(date '+%Y-%m-%d %H:%M:%S')] Run #$RUN_ID"
        echo "  Status: $STATUS"
        echo "  Conclusion: $CONCLUSION"
        echo "  Started: $CREATED"
        
        if [ "$STATUS" = "completed" ]; then
            echo -e "\nCI run completed with conclusion: $CONCLUSION"
            
            if [ "$CONCLUSION" = "failure" ] || [ "$CONCLUSION" = "timed_out" ]; then
                echo "Downloading logs..."
                gh run download "$RUN_ID" --dir "./ci-logs-$RUN_ID" 2>/dev/null || echo "No artifacts to download"
                
                echo "Viewing run logs..."
                gh run view "$RUN_ID" --log > "./ci-logs-$RUN_ID.txt"
                echo "Logs saved to ./ci-logs-$RUN_ID.txt"
            fi
            
            break
        fi
    fi
    
    sleep $POLL_INTERVAL
done