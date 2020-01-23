.PHONY: all clean

all: bin/unison

clean:
	rm -rf src
	rm -rf build
	rm -rf bin
	
src/ocaml.done:
	mkdir -p src
	git clone --bare git@github.com:ocaml/ocaml.git src/ocaml.git
	touch $@

src/unison.done:
	mkdir -p src
	git clone --bare git@github.com:bcpierce00/unison.git src/unison.git
	touch $@

build/ocaml.done: src/ocaml.done
	rm -rf build/ocaml
	mkdir -p build/ocaml
	git --git-dir=src/ocaml.git --work-tree=build/ocaml checkout 4.08.1 .
	cd build/ocaml; ./configure --prefix=$$(readlink -f prefix)
	$(MAKE) -C build/ocaml world.opt
	$(MAKE) -C build/ocaml install
	touch $@

build/unison.done: src/unison.done build/ocaml.done
	rm -rf build/unison
	mkdir -p build/unison
	git --git-dir=src/unison.git --work-tree=build/unison checkout v2.51.2 .
	for i in patches/*.diff; do (cd build/unison; patch -p0) < "$$i"; done
	PATH="$$(readlink -f build/ocaml/prefix/bin):$$PATH" $(MAKE) -C build/unison UISTYLE=text MACOSX_DEPLOYMENT_TARGET=10.13
	touch $@

bin/unison: build/unison.done
	mkdir -p bin
	cp build/unison/src/unison "$@"
