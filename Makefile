build-image:
	cd packer && \
	packer build ubuntu-consul-template.json && \
	cd -