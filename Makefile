OLDROM = clcd-myrom.rom
NEWROM = clcd-rom.bin
XEMU_BIN = xemu-xclcd

all:	$(NEWROM) loadable.prg

$(NEWROM): rom.a65 Makefile $(OLDROM)
	cl65 -t none -o $@ --ld-args -D__STACKSTART__=0xFFFF $<


loadable.prg: loadable.a65 Makefile $(OLDROM)
	cl65 -t none -o $@ --ld-args -D__STACKSTART__=0xFFFF $<

$(OLDROM):
	wget -O $(OLDROM) http://commodore-lcd.lgb.hu/j/clcd-myrom.rom

xemu-rom:
	$(MAKE) $(NEWROM)
	$(XEMU_BIN) -rom105 $(NEWROM)

xemu-loadable:
	$(MAKE) loadable.prg
	$(XEMU_BIN) -prg loadable.prg

compare:
	$(MAKE) $(NEWROM)
	md5sum $(OLDROM) ; md5sum $(NEWROM)
	hd $(OLDROM) > $(OLDROM).hex
	hd $(NEWROM) > $(NEWROM).hex
	diff -au $(OLDROM).hex $(NEWROM).hex

clean:
	rm -f loadable.prg $(NEWROM) *.o $(OLDROM).hex $(NEWROM).hex

distclean:
	$(MAKE) clean
	rm -f $(OLDROM)

.PHONY: xemu-rom xemu-loadable compare clean distclean

