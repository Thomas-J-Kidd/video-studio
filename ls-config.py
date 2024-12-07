# Define the URL where Label Studio is accessible and the API key for your user account
LABEL_STUDIO_URL = os.getenv("LABEL_STUDIO_URL")
# API key is available at the Account & Settings > Access Tokens page in Label Studio UI
API_KEY = os.getenv("LABEL_STUDIO_API_KEY")

# Import the SDK and the client module
from label_studio_sdk.client import LabelStudio

# Connect to the Label Studio API and check the connection
ls = LabelStudio(base_url=LABEL_STUDIO_URL, api_key=API_KEY)


from label_studio_sdk.label_interface import LabelInterface
from label_studio_sdk.label_interface.create import labels

# Define labeling interface
label_config = LabelInterface.create({
    'video ': 'Video',
    'bbox': labels(['bag', 'hole', 'board'], tag_type="RectangleLabels")
})

# Create a project with the specified title and labeling configuration
project = ls.projects.create(
    title='Text Classification',
    label_config=label_config
)

