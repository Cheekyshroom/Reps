install:
	pip install --user hy
	printf "#!/usr/bin/env bash\ncd $(shell pwd)\n./main.hy \$$@\n" > $(shell pwd)/run.sh
	chmod +x $(shell pwd)/run.sh
	ln -sf $(shell pwd)/run.sh /usr/local/bin/reps
