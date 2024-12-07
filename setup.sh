#!/bin/bash

# Exit on errors
set -e

# Source the environment variables
echo "Sourcing environment variables from source-file.sh"
source ./source-file.sh

# Check for CUDA drivers
echo "Checking for CUDA drivers..."
if ! command -v nvidia-smi &> /dev/null; then
    echo "CUDA drivers not found. Please install them first."
    exit 1
else
    echo "CUDA drivers found:"
    nvidia-smi
fi

# Create and activate virtual environment
echo "Setting up virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate

# Install requirements for label-studio-ml-backend
echo "Setting up label-studio-ml-backend..."
cd label-studio-ml-backend
git checkout sam2_video_multi_obj_tracking # Replace with the specific branch name
pip install -e .
cd label_studio_ml/examples/segment_anything_2_video
pip install -r requirements.txt
pip install -r requirements-test.txt
cd $VIDEO_STUDIO 

# Install segment-anything-2
echo "Installing segment-anything-2..."
cd segment-anything-2
pip install -e .
cd checkpoints
./download_ckpts.sh
cd $VIDEO_STUDIO

# Install additional requirements
echo "Installing additional requirements..."
pip install -r requirements.txt

echo "Setup completed successfully!"

