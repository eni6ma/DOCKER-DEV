#!/bin/bash

# Build script for development Docker environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="dev-environment"
TAG="latest"
REGISTRY=""
PUSH=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --registry)
            REGISTRY="$2"
            shift 2
            ;;
        --tag)
            TAG="$2"
            shift 2
            ;;
        --push)
            PUSH=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --registry <url>    Docker registry URL"
            echo "  --tag <tag>         Image tag (default: latest)"
            echo "  --push              Push image after building"
            echo "  --help              Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Build image
echo -e "${GREEN}Building Docker image...${NC}"
if [ -n "$REGISTRY" ]; then
    FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}:${TAG}"
else
    FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"
fi

echo -e "${YELLOW}Image: ${FULL_IMAGE_NAME}${NC}"
docker build -t "${FULL_IMAGE_NAME}" .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful!${NC}"
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

# Push image if requested
if [ "$PUSH" = true ]; then
    if [ -z "$REGISTRY" ]; then
        echo -e "${RED}Error: --registry is required when using --push${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Pushing image to registry...${NC}"
    docker push "${FULL_IMAGE_NAME}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Push successful!${NC}"
        echo -e "${GREEN}Image available at: ${FULL_IMAGE_NAME}${NC}"
    else
        echo -e "${RED}✗ Push failed!${NC}"
        exit 1
    fi
fi

# Print image info
echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Build complete!${NC}"
echo -e "${GREEN}======================================${NC}"
echo "Image: ${FULL_IMAGE_NAME}"
echo ""
echo "To run the container:"
echo "  docker run -it ${FULL_IMAGE_NAME}"
echo ""
echo "Or with docker-compose:"
echo "  docker-compose up -d"
echo ""

