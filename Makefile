.PHONY: build push run clean help shell test

# Configuration
IMAGE_NAME := dev-environment
IMAGE_TAG := latest
REGISTRY :=
FULL_IMAGE := $(if $(REGISTRY),$(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG),$(IMAGE_NAME):$(IMAGE_TAG))

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ''
	@echo 'Configuration:'
	@echo '  IMAGE_NAME=$(IMAGE_NAME)'
	@echo '  IMAGE_TAG=$(IMAGE_TAG)'
	@echo '  REGISTRY=$(if $(REGISTRY),$(REGISTRY),(not set))'
	@echo '  FULL_IMAGE=$(FULL_IMAGE)'

build: ## Build the Docker image
	@echo "Building $(FULL_IMAGE)..."
	docker build -t $(FULL_IMAGE) .
	@echo "✓ Build complete!"

push: build ## Build and push to registry
	@if [ -z "$(REGISTRY)" ]; then \
		echo "Error: REGISTRY is not set. Set it like: make push REGISTRY=your-registry.com"; \
		exit 1; \
	fi
	@echo "Pushing $(FULL_IMAGE)..."
	docker push $(FULL_IMAGE)
	@echo "✓ Push complete!"

run: ## Run the container interactively
	docker run -it --rm \
		-v $$(pwd)/workspace:/home/developer/workspace \
		-v $$HOME/.ssh:/home/developer/.ssh:ro \
		$(FULL_IMAGE) \
		bash

shell: ## Start a shell in the running container (or run a new one)
	@if docker ps --filter "name=dev-env" --format "{{.Names}}" | grep -q "^dev-env$$"; then \
		docker exec -it dev-env bash; \
	else \
		docker run -it --rm \
			-v $$(pwd)/workspace:/home/developer/workspace \
			-v $$HOME/.ssh:/home/developer/.ssh:ro \
			$(FULL_IMAGE) \
			bash; \
	fi

clean: ## Remove Docker image
	@echo "Removing image $(FULL_IMAGE)..."
	-docker rmi $(FULL_IMAGE)
	@echo "✓ Clean complete!"

test: ## Run tests to verify all tools are installed
	@echo "Testing Docker image..."
	docker run --rm $(FULL_IMAGE) bash -c "\
		echo '=== Testing installed tools ===' && \
		echo '' && \
		echo 'Rust:' && rustc --version && cargo --version && \
		echo '' && \
		echo 'Go:' && go version && \
		echo '' && \
		echo 'Node.js:' && node --version && npm --version && yarn --version && \
		echo '' && \
		echo 'Python:' && python3 --version && pip3 --version && \
		echo '' && \
		echo 'C/C++:' && gcc --version && g++ --version && \
		echo '' && \
		echo 'Build tools:' && cmake --version && make --version && \
		echo '' && \
		echo '✓ All tools verified!'"
	@echo "✓ Test complete!"

info: ## Show information about the Docker image
	@echo "Image information for $(FULL_IMAGE):"
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

inspect: ## Inspect the Docker image
	@echo "Inspecting $(FULL_IMAGE)..."
	@docker inspect $(FULL_IMAGE) | jq .

size: ## Show size breakdown of the Docker image
	@echo "Size analysis for $(FULL_IMAGE):"
	@docker history $(FULL_IMAGE) --format "{{.Size}}\t{{.CreatedBy}}" | head -20

volumes: ## Run container with common volume mounts
	docker run -it --rm \
		-v $$(pwd)/workspace:/home/developer/workspace \
		-v $$HOME/.ssh:/home/developer/.ssh:ro \
		-v $$HOME/.gitconfig:/home/developer/.gitconfig:ro \
		-v $$HOME/.gnupg:/home/developer/.gnupg:ro \
		$(FULL_IMAGE) \
		bash

