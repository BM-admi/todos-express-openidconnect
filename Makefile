all:
	docker-compose up --build --force-recreate --always-recreate-deps --remove-orphans -d

well-known:
	curl -sL https://$(ONELOGIN_ACCOUNT).onelogin.com/oidc/2/.well-known/openid-configuration | jq -r "."

local-start:
	[ -d .node_modules ] || npm install
	npm start

clean:
	docker-compose down -v
