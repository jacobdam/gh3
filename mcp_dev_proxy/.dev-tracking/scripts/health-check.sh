#!/bin/bash

# MCP Dev Proxy - Agent Session Health Check
# Run this at the start of every agent session

echo "🔍 MCP Dev Proxy Health Check"
echo "================================"

# Check task definition consistency
echo "📋 Task Definition Validation..."
missing_definitions=0
while IFS= read -r line; do
    if [[ "$line" =~ TASK-[0-9]+ ]]; then
        task_id=$(echo "$line" | grep -o 'TASK-[0-9]*')
        if [ ! -f ".dev-tracking/tasks/definitions/${task_id}.md" ]; then
            echo "❌ Missing: ${task_id}.md"
            missing_definitions=$((missing_definitions + 1))
        fi
    fi
done < .dev-tracking/tasks/current-sprint.md

if [ $missing_definitions -eq 0 ]; then
    echo "✅ All Ready tasks have definition files"
else
    echo "⚠️  $missing_definitions missing task definition files"
fi

# Check git status
echo ""
echo "📊 Git Status..."
uncommitted=$(git status --porcelain | wc -l)
if [ $uncommitted -eq 0 ]; then
    echo "✅ Working directory clean"
else
    echo "⚠️  $uncommitted uncommitted changes detected"
    git status --short
fi

# Check current branch
current_branch=$(git branch --show-current)
echo "🌿 Current branch: $current_branch"

# Quick improvement suggestions
echo ""
echo "💡 Quick Improvement Suggestions..."

# Check for large files that could be extracted
large_files=$(find lib -name "*.dart" -exec wc -l {} + 2>/dev/null | sort -n | tail -3 | head -2)
if [ ! -z "$large_files" ]; then
    echo "📦 Consider extracting components from large files:"
    echo "$large_files" | while read lines file; do
        if [ "$lines" -gt 200 ]; then
            echo "   - $(basename $file): $lines lines (Extract opportunity: 15-20 min)"
        fi
    done
fi

# Check for TODO/FIXME comments
todos=$(grep -r "TODO\|FIXME" lib --include="*.dart" 2>/dev/null | wc -l)
if [ $todos -gt 0 ]; then
    echo "✏️  $todos TODO/FIXME comments to address (5-10 min each)"
fi

# Check test coverage gaps
if [ -d "test" ]; then
    lib_files=$(find lib -name "*.dart" | wc -l)
    test_files=$(find test -name "*_test.dart" | wc -l)
    if [ $test_files -lt $lib_files ]; then
        echo "🧪 Test coverage gap: $lib_files lib files, $test_files test files (10-15 min per missing test)"
    fi
fi

echo ""
echo "================================"
echo "Ready for agent session startup!"