CHCFILES := $(shell find . -name "*.chc" -type f)
HTMLFILES := $(CHCFILES:.chc=.html)
CHC := $(PWD)/chc

all: $(HTMLFILES)

# compile each .chc to .html
%.html: %.chc
	echo "Compiling $< ..."
	$(CHC) $< $@
	echo "Compiled $< to $@"
	rm -f $(dir $<)tmp.c $(dir $<)temp	
	./loadpage
# cleaning files
clean:
	echo "Cleaning all generated files..."
	find . -name "*.html" -type f -delete
	find . -name "tmp.c" -type 	f -delete
	find . -name "temp" -type f -delete
	echo "Removed generated files."

# clean only HTML files
clean-html:
	echo "Cleaning only HTML files..."
	find . -name "*.html" -type f -delete
#list chc file
list:
	echo "Found CHC files:"
	find . -name "*.chc" -type f

# help
help:
	echo "Available targets:"
	echo "  all        - Compile all .chc files to HTML"
	echo "  clean      - Remove all generated HTML files"
	echo "  clean-html - Remove only HTML files, keep CHC files"
	echo "  list       - List all .chc files found"
	echo "  help       - Show this help message"

.PHONY: all clean clean-html list help
