# Unison-Madness

[Unison](https://www.cis.upenn.edu/~bcpierce/unison/) seems like a cool piece of software but getting it to work is madness. Unison can only talk to the exact same version on the other end. In addition to that, those binaries have to have been compile with the same OCaml compiler versions. Otherwise you get error messages like this:

```
Fatal error: Server: Fatal error during unmarshaling (input_value: ill-formed message),
possibly because client and server have been compiled with differentversions of the OCaml compiler.
```

So relying on different OS software repositories providing matching versions is just out of the question. This repository tries to provide a way so compile a single version of OCaml and Unison on different OSes.


## Credits

This repository includes a number of patches in the `patches` directory. These are all from the MacPorts `unison` port:

https://github.com/macports/macports-ports/tree/e75563b7f431a2cb21c0bc03ff483bc1f970d64d/net/unison/files


## Compiling Unison

Close your eyes and type `make`. The binal binary will be placed under `bin/unison`. If it doesn't work, fix it.