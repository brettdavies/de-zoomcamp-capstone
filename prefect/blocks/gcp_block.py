import os
from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket

# Access the environment variable
project_id = os.getenv('project_id')

service_account_info = {
  "type": "service_account",
  "project_id": f"{project_id}",
  "private_key_id": "[redacted]",
  "private_key": "-----BEGIN PRIVATE KEY-----\n[redacted]\n-----END PRIVATE KEY-----\n",
  "client_email": f"tf-serviceaccount@{project_id}.iam.gserviceaccount.com",
  "client_id": "[redacted]",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": f"https://www.googleapis.com/robot/v1/metadata/x509/tf-serviceaccount@{project_id}.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

block = GcpCredentials(
  service_account_info=service_account_info
)
block.save("gcp-cred",overwrite=True)

block2 = GcsBucket(
  bucket=f"dl_raw_{project_id}",
  bucket_folder="",
  gcp_credentials=GcpCredentials.load("gcp-cred")
)
block2.save("gcs-bucket",overwrite=True)
