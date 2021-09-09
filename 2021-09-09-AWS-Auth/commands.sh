# We're going to configure AWS Authentication for an AWS account
# You're going to need some stuff! Look at the README.md

# Start up a dev instance of Vault server
vault server -dev

# Set your Vault server address
export VAULT_ADDR="http://127.0.0.1:8200"
$env:VAULT_ADDR="http://127.0.0.1:8200"

# Enable the AWS auth method at the path aws_test
vault auth enable -path=aws_test aws

# Now we'll log into the AWS CLI and create a user for Vault
aws configure # only necessary if you haven't done this already


# Create a policy for the vault_auth user
aws iam create-policy --policy-name "VaultAuthUser" --policy-document file://vault_auth_policy.json

# Mark down the policy arn

# Create a user named vault_auth
aws iam create-user --user-name vault_auth 

# Attach the policy to the user
aws iam attach-user-policy --user-name vault_auth --policy-arn POLICY_ARN

# Now create keys for the vault_auth user
aws iam create-access-key --user-name vault_auth

# Store the access and secret key in variables
VAULT_ACCESS_KEY=ACCESS_KEY
VAULT_SECRET_KEY=SECRET_KEY

# Also make note of your AWS account number and save it as a variable
AWS_ACCOUNT_ID=YOUR_AWS_ACCOUNT_NUMBER

# Configure the AWS auth method with the access and secret key
vault write auth/aws_test/config/client secret_key=$VAULT_SECRET_KEY access_key=$VAULT_ACCESS_KEY

# Create the AWS user for testing
aws iam create-user --user-name dev_account

# Create a Vault policy for assignment to dev
vault policy write dev_policy dev_policy.hcl

# Create a dev role in the AWS auth method and associate the policy
# The bound_iam_principal_arn will allow all users to login.
# You can use roles or paths to restrict who can log in.
vault write auth/aws_test/role/dev_role auth_type=iam policies=dev_policy bound_iam_principal_arn=arn:aws:iam::$AWS_ACCOUNT_ID:user/*

# Now we'll test with the user
# First we'll get access keys for the test user
aws iam create-access-key --user-name dev_account

# Store the access and secret key in variables
DEV_ACCESS_KEY=ACCESS_KEY
DEV_SECRET_KEY=SECRET_KEY

# Try to log into Vault using the dev_account credentials
vault login -method=aws -path=aws_test role=dev_role aws_access_key_id=$DEV_ACCESS_KEY aws_secret_access_key=$DEV_SECRET_KEY