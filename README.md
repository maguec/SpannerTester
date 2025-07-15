# Spin up a Spanner node and a VM with access for testing

## Terraform 

### Export environment variables
```bash
export GOOGLE_APPLICATION_CREDENTIALS=<PATH_TO_JSON_FILE>
export TF_VAR_gcp_project_id=<PROJECT_ID>
export TF_VAR_gcp_region=<REGION>
```

### Run Terraform

```bash
terraform init
terraform apply
```
