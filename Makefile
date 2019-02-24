build:
	mkdir -p build
test: build
	mkdir -p build/test
test/FowlerNollVo: test FowlerNollVo/*.pony FowlerNollVo/test/*.pony
	ponyc FowlerNollVo/test -o build/test --debug
test/execute: test/FowlerNollVo
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
