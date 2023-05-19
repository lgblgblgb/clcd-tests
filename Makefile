ROMURL = http://commodore-lcd.lgb.hu/j/clcd-myrom.rom
OLDROM = clcd-myrom.rom
NEWROM = clcd-rom.bin
KERROM = clcd-kernal.bin
PRG = loadable.prg
XEMU_BIN = xemu-xclcd
D81 = disk.d81

all:	$(NEWROM) $(KERROM) $(PRG)

$(D81): $(PRG) Makefile
	dd if=/dev/zero of=$@ bs=819200 count=1
	echo "format disk,00\nwrite $< yoda\ndir" | c1541 $@

$(NEWROM): rom.a65 Makefile $(OLDROM)
	cl65 -t none -o $@ --ld-args -D__STACKSTART__=0xFFFF $<

$(KERROM).16k: kernal.a65 Makefile $(OLDROM)
	cl65 -t none -o $@ --ld-args -D__STACKSTART__=0xFFFF $<

$(KERROM): $(KERROM).16k Makefile
	rm -f $@
	cat $< $< > $@

$(PRG): loadable.a65 Makefile $(OLDROM)
	cl65 -t none -o $@ --ld-args -D__STACKSTART__=0xFFFF $<

$(OLDROM):
	wget -O $(OLDROM) $(ROMURL)

xemu-rom:
	$(MAKE) $(NEWROM)
	$(XEMU_BIN) -rom105 $(NEWROM)

xemu-loadable:
	$(MAKE) $(PRG)
	$(XEMU_BIN) -prg $(PRG)

xemu-kernal:
	$(MAKE) $(KERROM)
	$(XEMU_BIN) -rom102 $(KERROM)

compare:
	$(MAKE) $(NEWROM)
	md5sum $(OLDROM) ; md5sum $(NEWROM)
	hd $(OLDROM) > $(OLDROM).hex
	hd $(NEWROM) > $(NEWROM).hex
	diff -au $(OLDROM).hex $(NEWROM).hex

clean:
	rm -f $(PRG) $(NEWROM) $(KERROM) $(KERROM).16k $(D81) *.o *.hex

distclean:
	$(MAKE) clean
	rm -f $(OLDROM)

update:
	$(MAKE) $(NEWROM) $(PRG) $(D81)
	mkdir -p bin
	cp $(NEWROM) $(KERROM) $(KERROM).16k $(PRG) $(D81) bin/
	cp $(OLDROM) bin/old-clcd-myrom.bin

.PHONY: xemu-rom xemu-loadable xemu-kernal compare clean distclean update

