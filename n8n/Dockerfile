FROM docker.n8n.io/n8nio/n8n

USER root

# Устанавливаем PostgreSQL клиент для проверки и создания базы данных
RUN apk add --no-cache postgresql-client

# Копируем скрипт инициализации
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Принимаем build arguments
ARG DB_POSTGRESDB_HOST
ARG DB_POSTGRESDB_PORT
ARG DB_POSTGRESDB_DATABASE
ARG DB_POSTGRESDB_USER
ARG DB_POSTGRESDB_PASSWORD

# Устанавливаем переменные окружения для скрипта
ENV DB_POSTGRESDB_HOST=${DB_POSTGRESDB_HOST}
ENV DB_POSTGRESDB_PORT=${DB_POSTGRESDB_PORT}
ENV DB_POSTGRESDB_DATABASE=${DB_POSTGRESDB_DATABASE}
ENV DB_POSTGRESDB_USER=${DB_POSTGRESDB_USER}
ENV DB_POSTGRESDB_PASSWORD=${DB_POSTGRESDB_PASSWORD}

USER node

RUN sh /init-db.sh

# Стандартный entrypoint для n8n
# ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
# CMD ["n8n"]


