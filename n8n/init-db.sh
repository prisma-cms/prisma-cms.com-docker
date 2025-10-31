#!/bin/bash
set -e

echo "Checking if database exists..."

# Ждем доступности PostgreSQL
until PGPASSWORD=$DB_POSTGRESDB_PASSWORD psql -h "$DB_POSTGRESDB_HOST" -U "$DB_POSTGRESDB_USER" -p "$DB_POSTGRESDB_PORT" -lqt | cut -d \| -f 1 | grep -qw postgres; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "PostgreSQL is ready!"

# Проверяем существование базы данных
DB_EXISTS=$(PGPASSWORD=$DB_POSTGRESDB_PASSWORD psql -h "$DB_POSTGRESDB_HOST" -U "$DB_POSTGRESDB_USER" -p "$DB_POSTGRESDB_PORT" -lqt | cut -d \| -f 1 | grep -qw "$DB_POSTGRESDB_DATABASE" && echo "yes" || echo "no")

if [ "$DB_EXISTS" = "no" ]; then
  echo "Database $DB_POSTGRESDB_DATABASE does not exist. Creating..."
  PGPASSWORD=$DB_POSTGRESDB_PASSWORD psql -h "$DB_POSTGRESDB_HOST" -U "$DB_POSTGRESDB_USER" -p "$DB_POSTGRESDB_PORT" -c "CREATE DATABASE $DB_POSTGRESDB_DATABASE;"
  echo "Database $DB_POSTGRESDB_DATABASE created successfully!"
else
  echo "Database $DB_POSTGRESDB_DATABASE already exists."
fi

echo "Database initialization completed!"
