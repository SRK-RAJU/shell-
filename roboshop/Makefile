
help: ## This help dialog  help full for step by step
    @IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done

git-pull:
	@echo ---------- GIT PULL CODE RUNS ------------
	@git pull &>/dev/null
cart: git-pull  ## setup Cart component
	@sudo bash components/cart.sh
catalogue: git-pull ## setup Catalogue component
	@sudo bash components/catalogue.sh
user:  git-pull ## setup User component
	@sudo bash components/user.sh
shipping: git-pull ## setup Shipping component
	@sudo bash components/shipping.sh
mysql: git-pull ## setup MySQL component
	@sudo bash components/mysql.sh
mongodb: git-pull  ## setup MongoDB component
	@sudo bash components/mongodb.sh
payment:git-pull  ## setup Payment component
	@sudo bash components/payment.sh
frontend: git-pull ## setup Frontend component
	@sudo bash components/frontend.sh
rabbitmq: git-pull  ## setup RabbitMQ component
	@sudo bash components/rabbitmq.sh
redis: git-pull  ## setup Redis component
	@sudo bash components/redis.sh


## this is making file
