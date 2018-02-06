SHELL_BITS = files/tiddlyctl.sh
IS_WSL := $(shell uname -v | grep -i microsoft 1>/dev/null 2>/dev/null ; echo $$?)

test:
	for bit in $(SHELL_BITS) ; do \
		echo "Testing $$bit" ; \
		(test -z $(TRAVIS) && test $(IS_WSL) = 1) && \
		    docker run -v "$(shell pwd):/mnt" koalaman/shellcheck $$bit || \
			shellcheck $$bit ; \
	done
	yamllint tasks/*.yml defaults/*.yml meta/*.yml

container: version
	./scripts/build-container
