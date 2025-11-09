FROM n8nio/n8n:latest

# Аргумент для выбора урока (по умолчанию lesson-01-if)
ARG LESSON=

USER root

# Устанавливаем необходимые утилиты
RUN apk add --no-cache sqlite jq bash util-linux


# Копируем воркфлоу конкретного урока
COPY ${LESSON}/workflows /workflows

USER node

RUN n8n import:workflow --separate --input=/workflows/

