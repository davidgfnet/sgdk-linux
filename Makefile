
all:
	# Build the toolchain first
	bash ./build-toolchain.sh
	# Now proceed to build the SGDK
	bash ./build-sgdk.sh

clean:
	rm -rf build SGDK-1.51 output
	make -C sjasm clean

cleanall:	clean
	rm -rf sources

