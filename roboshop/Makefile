
help: ## This help dialog.
    @IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done
cart: ## setup cart component
	@bash components/cart.sh
catalogue: ## setup catalogue component
	@bash components/catalogue.sh
user: ## setup user component
	@bash components/user.sh
shipping: ## setup shipping component
	@bash components/shipping.sh
mysql: ## setup mysql component
	@bash components/mysql.sh
mongodb: ## setup mongodb component
	@bash components/mongodb.sh
payment: ## setup payment component
	@bash components/payment.sh
frontend: ## setup frontend component
	@bash components/frontend.sh
robbitmq: ## setup robbitmq component
	@bash components/robbitmq.sh
redis: ## setup redis component
	@bash components/redis.sh


## this is making file
