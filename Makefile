ERL ?= erl
APP := pymwyfa

.PHONY: deps

all: deps
	@./rebar compile

app:
	@./rebar compile skip_deps=true

deps:
	@./rebar get-deps

clean:
	@./rebar clean

distclean: clean
	@./rebar delete-deps

webstart: app
	exec erl -sname pymwyfa -pa $(PWD)/apps/*/ebin -pa $(PWD)/deps/*/ebin \
        -boot start_sasl -config $(PWD)/apps/pymwyfa_web/priv/app.config \
        -s pymwyfa_web

proxystart:
	@/usr/local/sbin/haproxy -f dev.haproxy.conf

docs:
	@erl -noshell -run edoc_run application '$(APP)' '"."' '[]'
