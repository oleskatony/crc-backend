import os
import boto3
import shutil
import zipfile
import tempfile
import importlib.util

# Create a temporary directory to extract the Lambda function code
temp_dir = tempfile.mkdtemp()

# Extract the Lambda function code from the .zip file
zip_file_path = 'custom_lambda/visitor_counter_lambda.zip'
with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
    zip_ref.extractall(temp_dir)

# Import the extracted Lambda function module
module_path = os.path.join(temp_dir, 'main.py')
spec = importlib.util.spec_from_file_location('main', module_path)
main = importlib.util.module_from_spec(spec)
spec.loader.exec_module(main)

#import dependencies are available for the Lambda function code to execute properly during testing 
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table_name = 'VisitorCounter'
table = dynamodb.Table(table_name)

# Run the test on the Lambda function code
def test_lambda_handler():
    # Provide test input data
    event = {}
    context = {}

    # Invoke the Lambda function
    response = main.lambda_handler(event, context)

    # Perform assertions on the response
    assert response['statusCode'] == 200
    assert response['body'] == 'Visitor count updated successfully'

# Cleanup: Remove the temporary extracted code
shutil.rmtree(temp_dir)
