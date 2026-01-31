#!/usr/bin/env bash
set -euo pipefail

# Configure branch protection rules for a GitHub repository
# Usage: add-ruleset.sh <repo>
# Example: add-ruleset.sh org/project

REPO="${1:-}"

if [ -z "$REPO" ]; then
    echo "Error: Repository name required"
    echo "Usage: $0 <repo>"
    echo "Example: $0 org/project"
    exit 1
fi

echo "Fetching repository information..."
REPO_DATA=$(gh api repos/"$REPO")
DEFAULT_BRANCH=$(echo "$REPO_DATA" | jq -r '.default_branch')
REPO_ID=$(echo "$REPO_DATA" | jq -r '.id')

echo "Repository: $REPO"
echo "Default branch: $DEFAULT_BRANCH"

# Check if a ruleset with the name "Default" already exists
echo "Checking for existing ruleset..."
RULESETS_RESPONSE=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/$REPO/rulesets" 2>/dev/null || true)

# Check if the response is an error (has a "message" field indicating error)
if echo "$RULESETS_RESPONSE" | jq -e 'has("message")' >/dev/null 2>&1; then
    ERROR_MSG=$(echo "$RULESETS_RESPONSE" | jq -r '.message')
    echo "✗ Cannot check existing rulesets: $ERROR_MSG"
    exit 1
else
    # Check if a ruleset named "Default" exists
    EXISTING_RULESET=$(echo "$RULESETS_RESPONSE" | jq -r '.[] | select(.name == "Default") | .name' 2>/dev/null || true)
    if [ -n "$EXISTING_RULESET" ]; then
        echo "✓ Ruleset 'Default' already exists - nothing to do"
        exit 0
    fi
fi

echo "Creating branch protection ruleset..."

# Create the ruleset payload
RULESET_PAYLOAD=$(cat <<EOF
{
  "name": "Default",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [
    {
      "actor_id": 5,
      "actor_type": "RepositoryRole",
      "bypass_mode": "always"
    }
  ],
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/$DEFAULT_BRANCH"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "deletion"
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "required_linear_history"
    },
    {
      "type": "required_signatures"
    },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false
      }
    }
  ]
}
EOF
)

# Create the ruleset
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/$REPO/rulesets" \
  --input - <<< "$RULESET_PAYLOAD" >/dev/null 2>/dev/null

echo "✓ Branch protection ruleset created successfully"
