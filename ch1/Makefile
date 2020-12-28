TARGET	:= c64
SRCNAME := ch1
PRGNAME	:= $(SRCNAME).prg
AS	:= ca65
LD	:= ld65
ADDR	:= 0x033c

X64	:= x64

ASFLAGS	:= -l $(SRCNAME).lst -t $(TARGET)
LDFLAGS	:= --lib c64.lib -C c64-asm.cfg --start-addr $(ADDR)

.PHONY: all test clean

all: $(PRGNAME)

$(PRGNAME): $(SRCNAME).o
	$(LD) $(LDFLAGS) -o $@ $<

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<		

test: $(PRGNAME)
	$(X64) -autoload $<

clean:
	@rm -f *.lst *.prg *.sym *.o
