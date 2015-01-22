.PHONY: all clean

LUMEN := LUMEN_HOST=luajit lumen
RUNTIME := lib/lumen/runtime.lua lib/lumen/io.lua
LIBS :=	obj/lib.lua \
	obj/motor.lua \
	obj/http.lua \
	obj/stream.lua

all: bin/echo.lua bin/serve.lua

clean:
	@git checkout bin/echo.lua bin/serve.lua
	@rm -f obj/*

bin/echo.lua: $(LIBS) obj/echo.lua
	@echo $@
	@cat $(RUNTIME) $^ > $@.tmp
	@mv $@.tmp $@

bin/serve.lua: $(LIBS) obj/serve.lua
	@echo $@
	@cat $(RUNTIME) $^ > $@.tmp
	@mv $@.tmp $@

obj/echo.lua: echo.l obj/lib.lua
	@echo "  $@"
	@$(LUMEN) `echo $^ | cut -d ' ' -f 2-` -c $< -o $@ -t lua

obj/motor.lua: motor.l obj/lib.lua
	@echo "  $@"
	@$(LUMEN) `echo $^ | cut -d ' ' -f 2-` -c $< -o $@ -t lua

obj/%.lua : %.l
	@echo "  $@"
	@$(LUMEN) -c $< -o $@ -t lua
