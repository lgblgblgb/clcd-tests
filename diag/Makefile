XEMU = /home/lgb/prog_here/xemu-next/build/bin/xclcd.native

all:	diag diag-32k

diag:	diag.a65 ld65.cfg Makefile
	ca65 -t none -l diag.lst -o diag.o diag.a65
	ld65 -C ld65.cfg -m diag.map -o diag diag.o
	rm -f diag.o
	./chksum.py diag

diag-32k: diag Makefile
	cat diag diag > diag-32k

xemu:
	$(MAKE) diag-32k
	$(XEMU) -rom102 diag-32k -clock 16
