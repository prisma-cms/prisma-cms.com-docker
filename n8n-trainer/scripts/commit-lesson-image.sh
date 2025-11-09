#!/bin/bash

# Скрипт коммита контейнера n8n-trainer в готовый образ
# Использование: ./commit-lesson-image.sh CONTAINER_NAME LESSON
# Пример: ./n8n-trainer/scripts/commit-lesson-image.sh docker-freecode-n8n-trainer-lesson01-1 lesson-01-if

set -e

# Проверка аргументов
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 CONTAINER_NAME LESSON"
    echo "Example: $0 docker-freecode-n8n-trainer-lesson01-1 lesson-01-if"
    exit 1
fi

CONTAINER_NAME=$1
LESSON=$2
IMAGE_NAME="n8n-trainer:${LESSON}-ready"

echo "📦 Committing container to image..."
echo "   Container: $CONTAINER_NAME"
echo "   Image: $IMAGE_NAME"

# Проверка существования контейнера
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "❌ Error: Container $CONTAINER_NAME not found"
    echo ""
    echo "Available containers:"
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
    exit 1
fi

# Проверка, запущен ли контейнер
CONTAINER_STATUS=$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")
if [ "$CONTAINER_STATUS" != "running" ]; then
    echo "⚠️  Warning: Container is not running (status: $CONTAINER_STATUS)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted"
        exit 1
    fi
fi

# Коммит контейнера
echo "🔨 Creating image from container..."
docker commit \
    --author "n8n-trainer" \
    --message "Ready image for $LESSON with initialized database and workflows" \
    "$CONTAINER_NAME" \
    "$IMAGE_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Image created successfully!"
    echo ""
    echo "📊 Image info:"
    docker images "$IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    echo "💡 You can now create user containers with:"
    echo "   ./n8n-trainer/scripts/create-trainer-container.sh USER_ID $LESSON"
else
    echo "❌ Failed to create image"
    exit 1
fi
