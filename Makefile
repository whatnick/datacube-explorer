.DEFAULT_GOAL := help

help: ## Display this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install all requirements and explorer
	pip install -U setuptools pip
	pip install -U -r requirements-test.txt
	pip install -e .[test]

.PHONY: format
format: ## Reformat all Python code
	isort -rc cubedash integration_tests
	black cubedash integration_tests

.PHONY: lint
lint: ## Run all Python linting checks
	python setup.py check -rms
	flake8 cubedash/ integration_tests/
	black --check cubedash integration_tests

.PHONY: weblint
weblint: ## Run stylelint across HTML and SASS
	stylelint $(find . -iname '*.html') $(find . -iname '*.sass')

.PHONY: style
style: cubedash/static/base.css ## Compile SASS stylesheets to CSS

cubedash/static/base.css: cubedash/static/base.sass
	sass -t compact --no-cache $< $@

.PHONY: test
test: ## Run tests using pytest
	pytest --cov=cubedash -r sx --durations=5

.PHONY: testcov
testcov:
	pytest --cov=cubedash
	@echo "building coverage html"
	@coverage html

.PHONY: clean
clean:  ## Clean all working/temporary files
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf build
	# python setup.py clean

.PHONY: up build schema index
# DOCKER STUFF
up: ## Start server using Docker
	docker-compose up

build: ## Build the Docker image
	docker-compose build

schema: ## Initialise DB using Docker
	docker-compose exec explorer \
		python3 /code/cubedash/generate.py --init-database

index: ## Update DB using Docker
	docker-compose exec explorer \
		python3 /code/cubedash/generate.py --all