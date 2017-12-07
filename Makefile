SHELL_BITS = files/tiddlyctl.sh
test:
	for bit in $(SHELL_BITS) ; do \
	    docker run -v "$(shell pwd):/mnt" koalaman/shellcheck $$bit ; \
	done
	yamllint tasks/*.yml defaults/*.yml meta/*.yml

container: version
	./scripts/build-container
