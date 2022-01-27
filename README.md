# gcp-proxy

Simple proxy server in Google Cloud

## Motivation

Testing a simple function app setup in Google Cloud with Terraform. Can be used to proxy requests.

## Prerequisites

- [Terraform](https://www.terraform.io/)
- [Node](https://nodejs.org/en/)
- [Google cloud SDK](https://cloud.google.com/sdk/docs/install)

## Setup

1. Clone the project
2. `cd gcp-proxy & npm install`

## Development

1. Start typescript compilation `npm run watch`
2. In another shell, start the local server `npm start`

## Deployment

1. Get a free Google Cloud account: https://console.cloud.google.com/freetrial
2. Create new project, add project's ID to `terraform/variables.tf`. Update also `terraform/modules/api/openapi.yml`
3. Enable following APIs from "APIs & Services"
   - Cloud Build
   - Cloud Run
   - Cloud Functions
   - Identity-Aware Proxy
4. Enable necessary services

```
gcloud services enable apigateway.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicecontrol.googleapis.com
```

5. Select one of the supported regions for API gateway, and put it to `terraform/variables.tf`. Update also `terraform/modules/api/openapi.yml`.

```
 asia-northeast1
 australia-southeast1
 europe-west1
 europe-west2
 us-east1
 us-east4
 us-central1
 us-west2
 us-west3
 us-west4
```

6. Check your service account id (or create one) and put it to `terraform/variables.tf`

7. Initialize terraform

```
cd terraform
terraform init
```

9. Plan the deployment `terraform plan`

10. Deploy `terraform apply`

11. Create an API key in Google Cloud console "API Keys" and restrict it to proxy-api only.

12. Test your api by querying your url with `x-api-key` header. Check `terraform/modules/api/openapi.yml` for full API documentation

## License

MIT - See [LICENSE](LICENSE)
