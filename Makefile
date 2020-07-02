
all:
	# Download packages
	bash ./download-packages.sh
	# Build the toolchain first
	bash ./build-toolchain.sh
	# Now proceed to build the SGDK
	bash ./build-sgdk.sh

download:
	bash ./download-packages.sh

clean:
	rm -rf build SGDK-1.51 output
	make -C sjasm clean

install:
	cp -r output/* $DESTDIR/

cleanall:	clean
	rm -rf sources downloads

