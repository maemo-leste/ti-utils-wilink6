CC = $(CROSS_COMPILE)gcc
CFLAGS = -O2 -Wall
CFLAGS += -DCONFIG_LIBNL20 -I$(DESTDIR)/usr/include -I$(DESTDIR)/include -I$(DESTDIR)/usr/include/libnl3

LDFLAGS += -L$(DESTDIR)/lib
LIBS += -lnl-3 -lnl-genl-3 -lm

OBJS = nvs.o misc_cmds.o calibrator.o plt.o ini.o

%.o: %.c calibrator.h nl80211.h plt.h nvs_dual_band.h
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(OBJS) 
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o wilink6calibrator

uim:
	$(CC) $(CFLAGS) $(LDFLAGS) uim_rfkill/$@.c -o $@

static: $(OBJS) 
	$(CC) $(LDFLAGS) --static $(OBJS) $(LIBS) -o wilink6calibrator

install:
	install -d $(DESTDIR)/usr/bin/
	install -d $(DESTDIR)/usr/share/ti-utils
	@echo Copying files
	@cp -f ./wilink6calibrator $(DESTDIR)/usr/bin/
	@chmod 755 $(DESTDIR)/usr/bin/wilink6calibrator
	@cp -rf ./hw/ini_files $(DESTDIR)/usr/share/ti-utils

clean:
	@rm -f *.o wilink6calibrator uim
