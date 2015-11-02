.PHONY: all clean distclean run

NODE_DIR := node_modules
NPM_BIN := $(NODE_DIR)/.bin
COFFEE_CC := $(NPM_BIN)/coffee
ELECTRON := $(NPM_BIN)/electron

DEPS := $(COFFEE_CC) $(ELECTRON)

COFFEE_SRC := . server
IN := $(wildcard $(addsuffix /*.coffee, $(COFFEE_SRC)))
OUT := $(patsubst %.coffee,%.js,$(IN))

all: $(OUT)

%.js: %.coffee $(COFFEE_CC)
	$(COFFEE_CC) -bc --no-header $<

clean:
	rm -f $(out)

distclean: clean
	rm -rf $(NODE_DIR)

$(DEPS):
	npm install

run: all $(ELECTRON)
	$(ELECTRON) .
	node watch.js
