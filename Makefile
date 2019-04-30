.PHONY: hello fizzbuzz clean 

all: hello fizzbuzz

clean:
	rm -f {hello,fizzbuzz}.o 
	rm -f {hello,fizzbuzz}

hello:
	nasm -f macho64 hello.asm
	ld -macosx_version_min 10.7.0 -lSystem -o hello hello.o

fizzbuzz:
	nasm -f macho64 fizzbuzz.asm
	ld -macosx_version_min 10.9.0 -lSystem -o fizzbuzz fizzbuzz.o
