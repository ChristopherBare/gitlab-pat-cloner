#!/bin/bash

# Path to the file storing the GitLab Personal Access Token
# Make sure the file named "gitlab_pat.txt" exists in the same folder as this script
TOKEN_FILE="./gitlab_pat.txt"

# Check if the token file exists
if [[ ! -f "$TOKEN_FILE" ]]; then
    echo "Error: Personal Access Token file ($TOKEN_FILE) not found."
    touch gitlab_pat.txt
    echo "Please add your GitLab Personal Access Token inside it the file that was just created called $TOKEN_FILE."
    exit 1
fi

# Read the token from the file
PERSONAL_ACCESS_TOKEN=$(<"$TOKEN_FILE")

# Ensure the token is not empty
if [[ -z "$PERSONAL_ACCESS_TOKEN" ]]; then
    echo "Error: Personal Access Token file is empty."
    exit 1
fi

# Prompt the user for the GitLab repository path (after gitlab.com/)
read -p "Enter the repository path (e.g., group/project.git): " REPO_PATH
if [[ -z "$REPO_PATH" ]]; then
    echo "Error: Repository path cannot be empty."
    exit 1
fi

# Prompt the user for the destination directory
read -p "Enter the directory to clone into: " DEST_DIR
if [[ -z "$DEST_DIR" ]]; then
    echo "Error: Destination directory cannot be empty."
    exit 1
else 
    echo "Changing to $DEST_DIR"
    cd $DEST_DIR
fi

# Construct the full clone URL
CLONE_URL="https://oauth2:${PERSONAL_ACCESS_TOKEN}@gitlab.com/${REPO_PATH}"

# Perform the clone operation
echo "Cloning repository..."
git clone "$CLONE_URL"

# Check if the clone was successful
if [[ $? -eq 0 ]]; then
    echo "Repository cloned successfully into $DEST_DIR."
else
    echo "Error: Failed to clone the repository."
    exit 1
fi
