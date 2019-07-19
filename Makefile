include .env
export $(shell sed 's/=.*//' .env)

image:
	cd packer && \
	packer build ubuntu-consul-template.json && \
	cd -