from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket


# replace this PLACEHOLDER dict with your the service account info from the JSON file
service_account_info = {
  "type": "service_account",
  "project_id": "[redacted]",
  "private_key_id": "[redacted]",
  "private_key": "-----BEGIN PRIVATE KEY-----\n[redacted]\n-----END PRIVATE KEY-----\n",
  "client_email": "tf-serviceaccount@[redacted].iam.gserviceaccount.com",
  "client_id": "[redacted]",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/tf-serviceaccount@[redacted].iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

def create_gcp_block():
  service_account_info = service_account_info
  GcpCredentials(
      service_account_info=service_account_info
  ,).save("gcs-decap",overwrite=True)
  return True

# service_account_info = {
#   "type": "service_account",
#   "project_id": "PROJECT_ID",
#   "private_key_id": "KEY_ID",
#   "private_key": "-----BEGIN PRIVATE KEY-----\nPRIVATE_KEY\n-----END PRIVATE KEY-----\n",
#   "client_email": "SERVICE_ACCOUNT_EMAIL",
#   "client_id": "CLIENT_ID",
#   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
#   "token_uri": "https://accounts.google.com/o/oauth2/token",
#   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
#   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/SERVICE_ACCOUNT_EMAIL"
# }
