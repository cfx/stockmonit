.PHONY: install test run docs

install:
	mix local.rebar --force && mix local.hex --force && mix deps.get

test:
	mix test && mix dialyzer

run:
	elixir --sname stockmonit -S mix run --no-halt

docs:
	mix docs
