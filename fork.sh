#!/bin/bash
set -euo pipefail

# Check arguments
if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
    echo "Usage: $0 <new_agent_workspace> [<new_agent_name>]"
    echo "Example: $0 alice-agent Alice"
    exit 1
fi

# Get the directory containing this script
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$1"

# If target is not an absolute path and doesn't start with ./ or ../
if [[ "$TARGET_DIR" != /* ]] && [[ "$TARGET_DIR" != ./* ]] && [[ "$TARGET_DIR" != ../* ]]; then
    TARGET_DIR="$(realpath .)/${TARGET_DIR}"
fi

# Create parent directories if needed
mkdir -p "$(dirname "$TARGET_DIR")"

# If a name is provided, use it
# Else, extract agent name from the last directory component, whether it has -agent suffix or not
NEW_AGENT="${2:-$(basename "$TARGET_DIR" | sed 's/-agent$//')}"
# Name of agent in template, to be replaced
NAME_TEMPLATE="CptObscura"

# Check if directory exists
if [ -d "$TARGET_DIR" ]; then
    # Check if directory is empty
    if [ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
        echo "Error: Target directory exists and is not empty: $TARGET_DIR"
        exit 1
    fi
    echo "Warning: Target directory exists but is empty, continuing..."
fi

echo -e "\nCreating new agent '$NEW_AGENT' in directory '$TARGET_DIR'..."

# Create core directory structure
echo "Creating directory structure..."
mkdir -p "${TARGET_DIR}"/{journal,tasks/{all,active,done,new,paused,cancelled,templates},projects,knowledge,people/templates,scripts/precommit}

# Copy core files and directories
echo "Copying core files..."

function copy_file() {
    local src="${SOURCE_DIR}/$1"
    local dst="${TARGET_DIR}/$1"

    # Create target directory if copying a directory
    if [ -d "$src" ]; then
        mkdir -p "$dst"
        cp -r "$src/"* "$dst/"
    else
        # Ensure parent directory exists for files
        mkdir -p "$(dirname "$dst")"
        cp -r "$src" "$dst"
    fi

    # Process all files, whether dst is a file or directory
    find "$dst" -type f -print0 | while IFS= read -r -d '' file; do
        # Replace template strings
        perl -i -pe "s/${NAME_TEMPLATE}-template/${NEW_AGENT}/g" "$file"
        perl -i -pe "s/${NAME_TEMPLATE}/${NEW_AGENT}/g" "$file"
        # Strip template comments
        perl -i -pe 'BEGIN{undef $/;} s/<!--template-->.*?<!--\/template-->//gs' "$file"
    done

    # Make shell scripts executable
    find "$dst" -type f -name "*.sh" -exec chmod +x {} \;
}

# Core documentation and configuration
copy_file README.md
cp "${SOURCE_DIR}/Makefile" "${TARGET_DIR}/Makefile"  # copy without replacing NAME_TEMPLATE
copy_file ARCHITECTURE.md
copy_file .pre-commit-config.yaml
copy_file scripts
copy_file run.sh
copy_file fork.sh

# Copy base knowledge
copy_file knowledge/agent-forking.md
copy_file knowledge/forking-workspace.md

# Copy template
copy_file */templates/*.md

# Initialize tasks
echo "# No Active Task" > "${TARGET_DIR}/tasks/all/no-active-task.md"

# Initial setup task from template
copy_file tasks/templates/initial-agent-setup.md
cp "${SOURCE_DIR}/tasks/templates/initial-agent-setup.md" "${TARGET_DIR}/tasks/all/"
ln -sf "../all/initial-agent-setup.md" "${TARGET_DIR}/tasks/active/"
ln -sf "./tasks/all/initial-agent-setup.md" "${TARGET_DIR}/CURRENT_TASK.md"

# Create projects README
cat > "${TARGET_DIR}/projects/README.md" << EOL
# Projects

This directory contains symlinks to the projects ${NEW_AGENT} works with.
EOL

# Create basic ABOUT.md template
cat > "${TARGET_DIR}/ABOUT.md" << EOL
# About ${NEW_AGENT}

## Background
[Brief background about ${NEW_AGENT}]

## Personality
[${NEW_AGENT}'s personality traits]

## Tools
[Available tools and capabilities]

## Goals
[${NEW_AGENT}'s primary goals and objectives]

## Values
[Core values and principles]
EOL

# Create initial TASKS.md with setup as first task
cat > "${TARGET_DIR}/TASKS.md" << EOL
# Tasks

Active tasks and their current status.

## Current Task
- 🏃 [Initial Agent Setup](./tasks/all/initial-agent-setup.md)

## System Development
- 🏃 Complete initial setup
  - [ ] Establish identity and purpose
  - [ ] Begin first task
EOL

# Create initial gptme.toml
cat > "${TARGET_DIR}/gptme.toml" << EOL
files = [
  "README.md",
  "ARCHITECTURE.md",
  "ABOUT.md",
  "TASKS.md",
  "CURRENT_TASK.md",
  "projects/README.md",
  "gptme.toml"
]
EOL

# Create creator profile
cat > "${TARGET_DIR}/people/creator.md" << EOL
# Creator

## Basic Information
- Name: [Creator's name]
- Relationship to ${NEW_AGENT}: Creator
- First interaction: Creation
- Last interaction: Ongoing

## Contact Information
[Creator's preferred contact methods]

## Notes & History
- Created ${NEW_AGENT} using the gptme agent architecture
EOL

# Initialize git
(cd "${TARGET_DIR}" && git init)

# If pre-commit is installed
# Install pre-commit hooks
command -v pre-commit > /dev/null && (cd "${TARGET_DIR}" && pre-commit install)

# Commit initial files
(cd "${TARGET_DIR}" && git add . && git commit -m "feat: initialize ${NEW_AGENT} agent workspace")

# Dry run the agent to check for errors
(cd "${TARGET_DIR}" && ./run.sh --dry-run > /dev/null)

# Make the target directory relative to the current directory (prettier output)
TARGET_DIR_RELATIVE=$(python3 -c "import os, sys; print(os.path.relpath('${TARGET_DIR}', start='$(pwd)'))")

echo "
Agent workspace created successfully! Next steps:
1. cd ${TARGET_DIR_RELATIVE}
2. Start the agent with: ./run.sh
3. The agent will guide you through the setup interview
4. Follow the agent's instructions to establish its identity

The new agent workspace is ready in: ${TARGET_DIR}"
