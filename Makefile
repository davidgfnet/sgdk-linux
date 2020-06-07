

all:
	# Build the toolchain first
	./build-toolchain.sh
	# Now proceed to build the SGDK
	./build-sgdk.sh

clean:
	rm -rf build SGDK-1.51 output
	make -C sjasm clean

cleanall:	clean
	rm -rf sources

