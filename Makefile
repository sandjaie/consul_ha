include .env
export $(shell sed 's/=.*//' .env)

image:
	cd packer && \
	packer build ubuntu-consul-template.json && \
	cd -

plan:
	cd terraform && \
	terraform plan -out /tmp/consul.plan && \
	cd -

apply:
	cd terraform && \
	terraform apply "/tmp/consul.plan" && \
	cd -