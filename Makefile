all:
	odin build . -out:dct_transform.exe

opti:
	odin build . -out:dct_transform.exe -o:speed

opti_max:
	odin build . -out:dct_transform.exe -o:aggressive -no-bounds-check -microarch:native -no-type-assert -disable-assert

clean:
	rm dct_transform.exe

run:
	./dct_transform.exe