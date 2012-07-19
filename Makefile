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

nginxstart:
	@/usr/local/nginx/sbin/nginx -c \
	/Users/led/Desktop/hack/pymwyfa/priv/dev.nginx.conf

nginxstop:
	@/usr/local/nginx/sbin/nginx -s stop

coffee:
	@/usr/local/bin/coffee -c -o ./apps/pymwyfa_web/priv/www/static/js/ \
	./apps/pymwyfa_web/priv/www/static/coffee/

proxystart:
	@/usr/local/sbin/haproxy -f dev.haproxy.conf

docs:
	@erl -noshell -run edoc_run application '$(APP)' '"."' '[]'
