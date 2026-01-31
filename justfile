set shell := ["bash", "-c"]

# List available commands
[private]
@default:
    just --list
    echo ""
    echo "For help with a specific recipe, run: just --usage <recipe>"

# Use a blueprint to initialize a project
[group("blueprints")]
[arg("project_folder", long="project-folder", help="Path of the project to initialize")]
[arg("blueprint", long="blueprint", pattern="^(python)$", help="Name of the blueprint")]
[confirm("Are you sure? This action cannot be undone (y/n):")]
apply project_folder blueprint:
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Check if the project folder exists
    if [ ! -d "{{project_folder}}" ]; then
        echo "✗ Error: Project folder '{{project_folder}}' does not exist."
        exit 1
    fi
    
    echo "Applying '{{blueprint}}' blueprint to project at '{{project_folder}}'..."
    cp -r ./blueprints/{{blueprint}}/* {{project_folder}}/
    echo "✓ Blueprint applied successfully."
    

# Configure branch protection rules for a GitHub repository
[group("github")]
[arg("repo", help="Full repository name (e.g., 'org/project')")]
add-ruleset repo:
    @./.scripts/add-ruleset.sh {{repo}}
