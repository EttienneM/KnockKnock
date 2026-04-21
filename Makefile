LABEL      := com.ettienne.knockknock
BINARY     := $(HOME)/bin/knockknock
PLIST_SRC  := com.ettienne.knockknock.plist
PLIST_DST  := $(HOME)/Library/LaunchAgents/$(LABEL).plist
LOG_PATH   := $(HOME)/Library/Logs/knockknock/knockknock.log
UID        := $(shell id -u)

.PHONY: build install uninstall reload logs test-fire status clean

build:
	swift build -c release

install: build
	@mkdir -p $(HOME)/bin
	@mkdir -p $(HOME)/Library/Logs/knockknock
	cp .build/release/knockknock $(BINARY)
	codesign --sign - --force $(BINARY)
	sed \
		-e 's|__BINARY_PATH__|$(BINARY)|g' \
		-e 's|__LOG_PATH__|$(LOG_PATH)|g' \
		$(PLIST_SRC) > $(PLIST_DST)
	launchctl bootstrap gui/$(UID) $(PLIST_DST)
	@echo "Installed. Run 'make status' to confirm."

uninstall:
	-launchctl bootout gui/$(UID)/$(LABEL)
	rm -f $(PLIST_DST)
	rm -f $(BINARY)
	@echo "Uninstalled. Config and logs left in place."

reload:
	launchctl bootout gui/$(UID)/$(LABEL)
	launchctl bootstrap gui/$(UID) $(PLIST_DST)

logs:
	tail -f $(LOG_PATH)

test-fire:
	notifyutil -p com.apple.screenIsUnlocked

status:
	@launchctl list | grep knockknock || echo "(not loaded)"

clean:
	rm -rf .build
