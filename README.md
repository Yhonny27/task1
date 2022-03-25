demotask1
Deploy infrastructure to GCP using Terraform

This Terraform file deploys an instance in GCP to run a cronjob script and pull messages to the PubSub tool every 5 minutes.

Requirements You must have Terraform installed on your computer. You must have a Google Cloud Platform (GCP) account. You must have downloaded a Google Cloud Platform credentials file. You must have enabled the Google Compute Engine API. It uses the Terraform Google Cloud Provider that interacts with the many resources supported by Google Cloud Platform (GCP) through its APIs.

The first command that should be run after writing a new Terraform configuration is the terraform init command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

terraform init Validate the changes.

Run command:

terraform plan Deploy the changes.

Run command:

terraform apply Test the deploy.

When the terraform apply command completes, use the Google Cloud console, you should see the new Google Compute instance.

Clean up the resources created.

When you have finished, run command:

terraform destroy
