
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
cart: git-pull  ## setup cart component
	@bash components/cart.sh
catalogue: git-pull ## setup catalogue component
	@bash components/catalogue.sh
user:  git-pull ## setup user component
	@bash components/user.sh
shipping: git-pull ## setup shipping component
	@bash components/shipping.sh
mysql: git-pull ## setup mysql component
	@bash components/mysql.sh
mongodb: git-pull  ## setup mongodb component
	@bash components/mongodb.sh
payment:git-pull  ## setup payment component
	@bash components/payment.sh
frontend: git-pull ## setup frontend component
	@bash components/frontend.sh
robbitmq:git-pull  ## setup robbitmq component
	@bash components/robbitmq.sh
redis:git-pull  ## setup redis component
	@bash components/redis.sh


## this is making file
