all:
	docker-compose up --build --force-recreate --always-recreate-deps --remove-orphans -d
	docker-compose ps -a

well-known:
	curl -sL https://$(ONELOGIN_ACCOUNT).onelogin.com/oidc/2/.well-known/openid-configuration | jq -r "."

local-start:
	[ -d .node_modules ] || npm install
	npm audit fix --force
	npm run format
	npm run lint
	npm start

clean:
	docker-compose down --remove-orphans -v
