#!/bin/bash

# Set the environment variables
export LABEL_STUDIO_URL="http://0.0.0.0:8080/projects/?page=1"
export LABEL_STUDIO_API_KEY="4b2be218f8c03a1719933db947f045def3a3aa9f"
export MAX_FRAMES_TO_TRACK="25" # Adjust based on your need
export PROMPT_TYPE="box"         # or "point"
export VIDEO_STUDIO="$(pwd)"
export SEGMENT_ANYTHING_2_REPO_PATH="$(pwd)/segment-anything-2"
export LOG_LEVEL="DEBUG"
export DEBUG="true"

# Confirm the variables are set
echo "Environment variables set:"
echo "LABEL_STUDIO_URL=$LABEL_STUDIO_URL"
echo "LABEL_STUDIO_API_KEY=$LABEL_STUDIO_API_KEY"
echo "MAX_FRAMES_TO_TRACK=$MAX_FRAMES_TO_TRACK"
echo "PROMPT_TYPE=$PROMPT_TYPE"
echo "SEGMENT_ANYTHING_2_REPO_PATH=$SEGMENT_ANYTHING_2_REPO_PATH"

