.PHONY: test

test:
	mix test && mix dialyzer
