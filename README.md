# CloudAndBigData

Part 1: Cloud: https://github.com/teabetab/CoursCloudN7

### Quick guide
```shell
# install
bash scripts/install.sh

# spin up instances
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve

# Get instance ips
terraform output -json ips
```