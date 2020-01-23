.PHONY: all clean

all: bin/unison

clean:
	rm -rf src
	rm -rf build
	rm -rf bin

# Clone the OCaml repository.
src/ocaml.done:
	mkdir -p src
	rm -rf src/ocaml.git
	git clone --bare git@github.com:ocaml/ocaml.git src/ocaml.git
	touch $@

# Create a clean checkout of the OCaml respoitory.
build/ocaml.done: src/ocaml.done
	rm -rf build/ocaml
	mkdir -p build/ocaml
	git --git-dir=src/ocaml.git --work-tree=build/ocaml checkout 4.08.1 .
	touch $@

# Build and install OCaml into the local prefix directory.
build/ocaml/prefix/bin/ocamlopt: build/ocaml.done
	cd build/ocaml; ./configure --prefix=$$(readlink -f prefix)
	$(MAKE) -C build/ocaml world.opt
	$(MAKE) -C build/ocaml install

# Clone the Unison repository.
src/unison.done:
	mkdir -p src
	rm -rf src/unison.git
	git clone --bare git@github.com:bcpierce00/unison.git src/unison.git
	touch $@

# Create a clean checkout of the Unison respoitory and apply necessary patches.
build/unison.done: src/unison.done
	rm -rf build/unison
	mkdir -p build/unison
	git --git-dir=src/unison.git --work-tree=build/unison checkout v2.51.2 .
	for i in patches/*.diff; do (cd build/unison; patch -p0) < "$$i"; done
	touch $@

# Build Unison.
build/unison/src/unison: build/unison.done build/ocaml/prefix/bin/ocamlopt
	PATH="$$(readlink -f build/ocaml/prefix/bin):$$PATH" $(MAKE) -j 1 -C build/unison UISTYLE=text MACOSX_DEPLOYMENT_TARGET=10.13

# Copy the unison binary to the output directory.
bin/unison: build/unison/src/unison
	mkdir -p bin
	cp "$<" "$@"
