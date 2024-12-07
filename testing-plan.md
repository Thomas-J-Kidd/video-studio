# Test Plan Document for Project
## Overview

This test plan outlines the testing strategy for the project's API, focusing on both unit tests and integration tests to ensure functionality, correctness, and reliability. The tests are implemented using pytest and include numerical tolerance checks for approximate floating-point values that are computed from the x,y coordinates of the returned mask from SAM2 compared to a true value ran from a manual test. This test uses a specific video with a specific labeling interface and will only work for this circumstance. TODO: create a more encompassing test for video tracking that can be automated. 

### Step 0: Make sure to source your set up file from the main repo directory

## Test Plan Sections
### 1. Unit Tests

Unit tests are designed to validate the functionality of individual components within the application. The primary unit test verifies the prediction endpoint of the API and includes the following aspects:

- Validation of HTTP response status.
- Exact matching of non-numeric fields in the API response.
- Approximate equality checks for floating-point numerical fields (e.g., bounding box coordinates, dimensions).

#### Setup Steps

1. Ensure the correct Python environment is set up:

```bash 
pip install -r requirements-test.txt
```

Run the tests using pytest:
```bash
pytest test_api.py
```

#### Details of the Unit Test

The following key points describe the implemented test:

- Client Fixture: A reusable client is set up using Flask's test client to simulate API requests.
- Test Logic:
    - Sends a POST request with predefined input data (request).
    - Verifies the HTTP status code is 200.
    - Compares the response with expected output (expected_response) by:
        - Checking non-numeric fields for exact equality.
        - Comparing floating-point sequences using a custom tolerance function compare_sequences.

### 2. Integration Tests

Integration tests ensure the interaction between multiple components, including the model inference pipeline, API handling, and data processing.
#### Integration Test Scenarios

1) Input Handling:
   - Tests whether the API correctly parses and processes complex nested JSON input structures, including task data, labels, and parameters.
2) Model Inference Pipeline:
   - Verifies that the model correctly processes the input data and generates predictions within tolerance limits for floating-point values.
3) API Endpoint Stability:
   - Ensures the /predict endpoint handles valid and invalid requests gracefully.

### 3. Testing Tools and Utilities

The test suite includes utility functions to streamline testing:

- `approx_equal(a, b, tol)`
  - Ensures numerical fields are approximately equal within a specified tolerance (1e0 by default).
- `compare_sequences(actual_seq, expected_seq, tol)`
  - Compares lists of dictionaries (e.g., bounding box sequences) with approximate checks for numeric values.

## Example test script
```python
import pytest
import json
from model import NewModel

@pytest.fixture
def client():
    from _wsgi import init_app
    app = init_app(model_class=NewModel)
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def approx_equal(a, b, tol=1e-2):
    if isinstance(a, float) and isinstance(b, float):
        return abs(a - b) < tol
    return a == b

def compare_sequences(actual_seq, expected_seq, tol=1e-2):
    if len(actual_seq) != len(expected_seq):
        return False
    for act_item, exp_item in zip(actual_seq, expected_seq):
        if not isinstance(act_item, dict) or not isinstance(exp_item, dict):
            return False
        if set(act_item.keys()) != set(exp_item.keys()):
            return False
        for key in act_item.keys():
            if not approx_equal(act_item[key], exp_item[key], tol=tol):
                return False
    return True

def test_predict(client):
    request = {
        # Request payload (truncated for brevity)
    }
    expected_response = {
        # Expected response payload (truncated for brevity)
    }

    response = client.post('/predict', data=json.dumps(request), content_type='application/json')
    assert response.status_code == 200

    actual = response.get_json()
    actual_seq = actual["results"][0]["result"][0]["value"]["sequence"]
    expected_seq = expected_response["results"][0]["result"][0]["value"]["sequence"]

    actual_copy = dict(actual)
    expected_copy = dict(expected_response)
    actual_copy_seq = actual_copy["results"][0]["result"][0]["value"].pop("sequence")
    expected_copy_seq = expected_copy["results"][0]["result"][0]["value"].pop("sequence")

    assert actual_copy == expected_copy, "Non-numeric parts of the response differ."
    assert compare_sequences(actual_seq, expected_seq, tol=1), "Sequence values differ beyond tolerance."
```

## Usage Instructions
Run the test in the followind directory:
```bash
cd ./label-studio-ml-backend/label_studio_ml/examples/segment_anything_2_video
```
by running the following command:
```bash
pytest test_api.py
```

We can run this as our github workflow actions:

```yaml
name: Run Install and Pytest Tests

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.8'

    - name: Install CUDA Toolkit
      run: |
        sudo apt update
        sudo apt install -y nvidia-cuda-toolkit
        echo "CUDA installed"
      
    - name: Check for NVIDIA GPU
      run: |
        if ! command -v nvidia-smi &> /dev/null; then
          echo "NVIDIA GPU not detected. Skipping CUDA tests."
        else
          nvidia-smi
        fi

    - name: Set up environment variables
      run: source ./source-file.sh

    - name: Run setup.sh script
      run: |
        chmod +x setup.sh
        ./setup.sh

    - name: Run Pytest
      run: |
        source .venv/bin/activate
        pytest --maxfail=5 --disable-warnings
```