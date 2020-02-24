.PHONY: install test run

install:
	mix deps.get

test:
	mix test && mix dialyzer

run:
	elixir --sname stockmonit -S mix run --no-halt
