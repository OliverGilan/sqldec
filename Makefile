all: clean build

clean: 
	(cd sqldef && make clean)
	rm -rf commands/psqldef

build:
	(cd sqldef && make build)
	cp -r sqldef/build commands
