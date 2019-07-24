### Conul HA deployment in AWS

#### Tools used:
- AWS: EC2, ASG, ELB, SSM
- Packer: To build AMI
- Ansible: Installs consul role on the AMI
- Terraform: Creates the infrastructure
    

#### How to run it:

- make build:<br>
    -- Builds a custom AMI with consul installed on it.
- make plan:<br>
    -- runs terraform plan and creates a plan file.
- make apply:<br>
    -- runs terraform apply with the plan file.

#### Prerequisites:
An aws user with aws cli access, packer and terraform installed.

#### Note:
Check the `dotenv-sample` file to create a .env file where you can keep the env configs.


#### Testing:
Ansible role can be tested on the vagrant machines which can be created using the Vagrant file. For auto-joing during the testing create local host records and add the option retry-join to the `config.json` file
```
"retry_join": [ 
  "consul01.local.domain:8301",
  "consul02.local.domain:8301",
  "consul03.local.domain:8301"
```
