.PHONY: clean build test-upload upload install-dev help

# Default target
help:
	@echo "Available commands:"
	@echo "  clean        - Remove build artifacts and cache files"
	@echo "  build        - Build the package (wheel and sdist)"
	@echo "  test-upload  - Upload to TestPyPI (requires .pypirc)"
	@echo "  upload       - Upload to PyPI (requires .pypirc)"
	@echo "  install-dev  - Install package in development mode"
	@echo "  install-deps - Install build dependencies"
	@echo "  check        - Check package with twine"

# Clean build artifacts
clean:
	rm -rf build/
	rm -rf dist/
	rm -rf src/*.egg-info/
	rm -rf .pytest_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

# Install build dependencies
install-deps:
	pip install build twine

# Build the package
build: clean
	python -m build

# Check the built package
check: build
	twine check dist/*

# Upload to TestPyPI
test-upload: build check
	twine upload --repository testpypi dist/*

# Upload to PyPI
upload: build check
	twine upload dist/*

# Install in development mode
install-dev:
	pip install -e .

# Install from TestPyPI (for testing)
install-test:
	pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ applied-biostats-helper

# Install from PyPI
install:
	pip install applied-biostats-helper

# Full release workflow
release: clean build check upload
	@echo "Package successfully released to PyPI!" 