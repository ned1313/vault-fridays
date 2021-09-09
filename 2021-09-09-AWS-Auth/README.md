# Configuring and Using the AWS Authentication Method

In this guide we are going to enable the AWS authentication method in Vault and use that authentication method to provision Vault tokens for clients and assign them Vault policies.

## Authentication Methods

The core authentication mechanism in Vault is the token. A token provides both authentication and authorization through the use of associated policies. Tokens can be generated directly on Vault and sent to a client, but this requires having a pre-existing token that has permissions to generate new tokens with the desired policies. Instead of using tokens to create tokens, Vault has authentication method that rely on some other source for authentication. You could use a source like Active Directory, GitHub, or AWS. Vault is configured to trust the authentication method to perform authentication of the client, and after a successful authentication Vault will issue the client a token to perform operations on Vault. 

## The AWS Authentication Method

There are actually two authentication types at play with AWS, `ec2` and `iam`. The `ec2` method allows EC2 instances to authenticate using the identity associated with the instance. The `ec2` method is useful if you would like an EC2 instance to authenticate to Vault and access secrets. For all other identity types in AWS, you will use the `iam` authentication type. That is the type we will focus on in this guide.

The `iam` authentication type makes use of the AWS STS API to validate the identity of the client. First the client generates a signed `GetCallerIdentity` request and sends it to the Vault server. Next the Vault server sends the request to the AWS STS API endpoint to verify the identity of the client that signed the request. If everything matches, Vault considers the authentication successful - i.e. the client is who they say they are - and generates a token for the client to use.

Because the Vault server needs to talk to the AWS STS API, it needs both an IAM identity of it's own and an IAM policy that allows it to perform the necessary actions against the AWS STS API. An example policy is included as part of this guide.

## Prerequisites

You will need the following to successfully set up and test the AWS auth method on Vault:

1. An AWS account with permissions to create users, roles, and policies
1. An instance of Vault server running (dev is fine)

And that's it! Not much here. 

## Process Overview

We walk through the following steps:

1. Enable the AWS auth method
1. Create an AWS IAM user with the necessary permissions
1. Create access and secret keys for the Vault IAM user
1. Configure the AWS auth method with the Vault IAM user credentials
1. Create an AWS user that will be used for testing
1. Create a policy on Vault that will be assigned to an authenticated AWS user
1. Create a role on the auth method for all AWS users and associate the policy
1. Verify authentication using the AWS IAM user

The commands for walking through this process are in the commands.sh file.

## Future Improvements

It is not clear to me how Vault resolves roles when trying to use the authentication method as a user. You might not be able to use the `vault login` command to do so, and instead need to rely on the API? The issue I have here is deciding which policies to assign an authenticated client. With the `ec2` method you can look at the instance profile and role tags to make an authentication decision in Vault. The `iam` method support principals that are users or roles, and the arn value can include a wildcard. You could use paths on the IAM side to influence Vault policy assignment, but that seems like the wrong approach. You cannot use group membership, although that would be nice. There is an integration with the Identity secrets engine that might bear fruit. Further investigation is warranted.