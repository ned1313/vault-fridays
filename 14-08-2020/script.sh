### Start vault server
vault server -dev

### Set the vault token environment variable
export VAULT_TOKEN=ROOT_TOKEN

$env:VAULT_TOKEN="ROOT_TOKEN"

### Set the vault server address
export VAULT_ADDR=http://127.0.0.1:8200

$env:VAULT_ADDR="http://127.0.0.1:8200"

### Configure aws secrets engine
vault secrets enable aws

### Set variables for ACCESS_KEY, SECRET_KEY, and REGION
$ACCESS_KEY="ACCESS_KEY"
$SECRET_KEY="SECRET_KEY"
$REGION="us-east-1"

vault write aws/config/root access_key=$ACCESS_KEY secret_key=$SECRET_KEY region=$REGION

### Create a role for the credentials

vault write aws/roles/ec2admin credential_type=iam_user policy_document=-<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "ec2:*",
        "Resource": "*"
      }
    ]
  }
EOF

### Let's get some credentials!

vault read aws/creds/ec2admin

### Get config settings

vault path-help aws/config/lease/
