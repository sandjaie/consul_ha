### Conul HA deployment in AWS

#### Tools used:
- AWS: EC2, ASG, ELB, SSM
- Packer: To build AMI
- Ansible: Installs consul role on the AMI
- Terraform: Creates the infrastructure
    

#### TL;DR - How to run it:

- make build:<br>
    -- Builds a custom AMI with consul installed on it.
- make plan:<br>
    -- runs terraform plan and creates a plan file.
- make apply:<br>
    -- runs terraform apply with the plan file.

#### Prerequisites:
A aws user with aws cli access, packer and terraform installed.


