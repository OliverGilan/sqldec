all: clean build

clean: 
	(cd sqldef && make clean)
	rm -rf commands/build

build:
	(cd sqldef && make build)
	cp -r sqldef/build commands
