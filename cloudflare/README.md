# Terraform Fundigic

## Install Terraform on OSX
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -install-autocomplete
```

## Cloudflare

### Configuration

#### Add credentials to .zshrc
```bash
# if using API Token
export TF_VAR_CLOUDFLARE_TOKEN='...'
# if using API Key
export TF_VAR_CLOUDFLARE_EMAIL='user@example.com'
export TF_VAR_CLOUDFLARE_KEY='...'
# specify Account ID
export TF_CLOUDFLARE_ACCOUNT_ID='...'
```


### For Usage

```bash
cd cloudflare
terraform init
terraform plan
terraform apply
```

### Fetch current state of CloudFlare configuration 

https://github.com/cloudflare/cf-terraforming

#### Install Go

#### Different PATH for Go (optional)
```bash
export GOPATH=$HOME/some_dir/go
export PATH=$PATH:$(go env GOPATH)/bin
```
Add this to your shell settings (`~/.zshrc` or `~/.bash_profile`)

```bash
brew install go
```

#### Install cf-terraforming

```bash
GO111MODULE=on go get -u github.com/cloudflare/cf-terraforming/...
```

#### Download record resources
```bash
cf-terraforming -t $TF_VAR_CLOUDFLARE_TOKEN --account $CLOUDFLARE_ACCOUNT_ID record > records.tf
```

### Download record resources state
```bash
cf-terraforming -t $TF_VAR_CLOUDFLARE_TOKEN --account $CLOUDFLARE_ACCOUNT_ID record --tfstate > terraform.tfstate
```

#### Sync your code with your remote settings

### Create state file

CF-Terraforming allow to download `resource` settings and `state` files.
But according to [this](https://developers.cloudflare.com/terraform/advanced-topics/importing-cloudflare-resources]) manual
Generating Terraform configuration will not avoid when running plan terraform to make changes by creating what we already generated.
That is why `terraform import` is needed. 

So first generate temporary `tf` file for `record` resources and `zone` (not mandatory)

- For Zone
  ```bash
  cf-terraforming --email $TF_VAR_CLOUDFLARE_EMAIL --key $TF_VAR_CLOUDFLARE_KEY --account $TF_VAR_CLOUDFLARE_ACCOUNT_ID zone -z example.com > zone_example_com.tf  
  ```
- For record
  ```bash
  cf-terraforming --email $TF_VAR_CLOUDFLARE_EMAIL --key $TF_VAR_CLOUDFLARE_KEY --account $TF_VAR_CLOUDFLARE_ACCOUNT_ID record -z example.com > record_example.com.tf
  ```

### Setting Zone
```
 resource "cloudflare_record" "A_localhost_example_com_fbd25d2b041a99dfef1156779429419b" {
     zone_id = "d64be27fdef2d961c3d4b1173dbb1fd3"
     name = "localhost"
     type = "A"
     ttl = "1"
     proxied = "false"
     value = "127.0.0.1"
 }
 ```
 
Import requires two IDs. The `zone_id` for **Zone** and `id` for **Record**.
The `id` of the specific zones you will find in `record_example.com.tf` file. 
The above zone scratch shows the zone id and record id which can be found here:

=> `A_localhost_example_com_`**fbd25d2b041a99dfef1156779429419b**

Generating `state` file with current (remote) data with this script is done by using those
information like so

#### - starting from zone

```bash
terraform import -var-file=domains/example_com.tfvars module.dns.cloudflare_zone.dns_domain d64be27fdef2d961c3d4b1173dbb1fd3
```

New file `terraform.tfstate` will appear with **zone** dict.

#### - proceeding with record

Here we need to obtain record IDs. To do that extraction of IDs from record
file is needed. Make use of `grep` and `while` loop to run command on all 
**record** id.

```bash
# for zone
terraform import -var-file=domains/example_com.tfvars module.dns.cloudflare_zone.dns_domain d64be27fdef2d961c3d4b1173dbb1fd3
# for records
i=0; while read r; do terraform import -var-file=domains/example_com.tfvars module.dns.cloudflare_record.dns_record[${i}] d64be27fdef2d961c3d4b1173dbb1fd3/${r} ;i=$((i+1)); done < <(grep -E 'resource' record_example.com.tf | grep -oE '[a-f0-9]{32}')
```
And like that we will have full, actual `.tfstate` file. After running `plan` and there will be information that resources will be removed and added again it's because
`index_key` is set to `int` but loop in terraform config makes values of that key a string.