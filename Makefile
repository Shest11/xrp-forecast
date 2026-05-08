VENV = .venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip

.PHONY: setup
setup:
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -e .
	$(PIP) install pytest mypy black isort

.PHONY: install
install:
	$(PIP) install -e .

.PHONY: test
test:
	$(PYTHON) -m pytest tests/

.PHONY: typecheck
typecheck:
	$(PYTHON) -m mypy src/ --ignore-missing-imports

.PHONY: format
format:
	$(PYTHON) -m black src/ tests/
	$(PYTHON) -m isort src/ tests/

.PHONY: lint
lint:
	$(PYTHON) -m black --check src/ tests/
	$(PYTHON) -m isort --check src/ tests/

.PHONY: run
run:
	$(PYTHON) -m xrp_forecast.model

.PHONY: check
check: typecheck lint

.PHONY: clean
clean:
	rm -rf $(VENV) __pycache__ .pytest_cache .mypy_cache
	find . -type d -name "__pycache__" -exec rm -rf {} +

.PHONY: build
build:
	$(PYTHON) -m pip install build
	$(PYTHON) -m build

.PHONY: upload
upload: build
	$(PYTHON) -m pip install twine
	$(PYTHON) -m twine upload --repository testpypi dist/*
