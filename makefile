CHCFILES := $(shell find . -name "*.chc" -type f)
BASENAMES := $(notdir $(CHCFILES))
HTMLFILES := $(addprefix website/,$(BASENAMES:.chc=.html))

CHC := $(PWD)/chc

.PHONY: all clean clean-html list help FORCE

all: $(HTMLFILES)

FORCE:

# Rule: input file = ANY .chc, output = website/filename.html
website/%.html: FORCE
	@CHCFILE=$(shell find . -name "$*.chc" | head -n 1); \
	echo "Compiling $$CHCFILE → $@ ..."; \
	mkdir -p website; \
	$(CHC) "$$CHCFILE" "$@"; \
	echo "Compiled $$CHCFILE to $@"; \
	./loadpage

# cleaning files
clean:
	@echo "Cleaning website/ and temp files..."
	@rm -rf website/
	@find . -name "tmp.c" -type f -delete
	@find . -name "temp" -type f -delete
	@echo "Removed generated files."

clean-html:
	@echo "Cleaning only website/ HTML files..."
	@rm -rf website/

list:
	@echo "Found CHC files:"
	@find . -name "*.chc" -type f

help:
	@echo "Available targets:"
	@echo "  all        - Compile all .chc files to HTML (stored in website/)"
	@echo "  clean      - Remove all generated HTML and temp files"
	@echo "  clean-html - Remove only HTML files (website/)"
	@echo "  list       - List all .chc files found"
	@echo "  help       - Show this help message"
