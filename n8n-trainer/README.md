# n8n Trainer

Система тренажеров n8n с предустановленными воркфлоу для обучения.

## Структура

```
n8n-trainer/
├── Dockerfile              # Общий Dockerfile для всех уроков
├── lesson-01-if/           # Урок 1: Условная логика
│   ├── workflows/          # JSON-файлы с воркфлоу
│   │   └── lesson-01-if.json
│   └── README.md           # Описание урока
├── lesson-02-xxx/          # Урок 2 (будущий)
│   ├── workflows/
│   └── README.md
└── users/                  # Данные пользователей (создается автоматически)
    └── {user_id}/
        └── .n8n/           # SQLite база и данные пользователя
```

## Как работает

1. **Заготовки уроков**: Каждый урок находится в своей папке с воркфлоу в формате JSON
2. **SQLite база**: Каждый контейнер использует локальную SQLite (без внешней БД)
3. **Автоимпорт**: При сборке образа воркфлоу импортируются командой `n8n import:workflow --separate --input=/workflows/`
4. **Изоляция пользователей**: Каждый пользователь получает свой volume с данными

## Создание контейнера для пользователя

### Шаг 1: Сборка базового образа

Образ собирается через docker-compose с явным указанием имени:

```bash
# В docker-compose.yml указано:
# n8n-trainer-lesson01:
#   image: docker-freecode-n8n-trainer-lesson-01-if
#   build:
#     context: ./n8n-trainer
#     args:
#       - LESSON=lesson-01-if

# Собираем образ
docker-compose build n8n-trainer-lesson01
```

Это создаст образ `docker-freecode-n8n-trainer-lesson-01-if` с предустановленными воркфлоу урока.

### Шаг 2: Создание контейнера для пользователя

#### Через скрипт (рекомендуется)

```bash
# Создать контейнер для пользователя
./prisma-cms/freecode.academy/server/nexus/types/n8n-trainer/docker/scripts/create-trainer-container.sh USER_ID lesson-01-if

# Пример:
./prisma-cms/freecode.academy/server/nexus/types/n8n-trainer/docker/scripts/create-trainer-container.sh user123 lesson-01-if

# С автоматическим удалением существующего контейнера:
./prisma-cms/freecode.academy/server/nexus/types/n8n-trainer/docker/scripts/create-trainer-container.sh user123 lesson-01-if --force
```

#### Через GraphQL мутацию

```graphql
mutation n8nTrainerCreateContainer {
  n8nTrainerCreateContainer(lesson: "lesson-01-if") {
    name
    lesson
    status
  }
}
```

Мутация автоматически создаст контейнер для текущего авторизованного пользователя.

#### Вручную через docker

```bash
docker run -d \
  --name n8n-trainer-user123-lesson-01-if \
  --network prisma-cms-default \
  --label "app.type=n8n-trainer" \
  --label "app.lesson=lesson-01-if" \
  --label "app.user_id=user123" \
  -e DB_TYPE=sqlite \
  -e N8N_SECURE_COOKIE=false \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false \
  -e N8N_DIAGNOSTICS_ENABLED=false \
  -e N8N_DIAGNOSTICS_CONFIG_FRONTEND=false \
  -e N8N_DIAGNOSTICS_CONFIG_BACKEND=false \
  docker-freecode-n8n-trainer-lesson-01-if
```

**Преимущества этого подхода:**
- Один образ для всех пользователей урока
- Быстрый запуск (образ уже собран с воркфлоу)
- Легко масштабируется (сотни контейнеров из одного образа)
- Изоляция данных (каждый контейнер имеет свою SQLite базу)
- Автоматизация через GraphQL API

## Доступные уроки

### Lesson 01: IF Logic
- **Папка**: `lesson-01-if`
- **Тема**: Условная логика
- **Воркфлоу**: Простая проверка числа с ручным триггером
- **Уровень**: Начальный

## Сброс контейнера пользователя

Для сброса данных пользователя к начальному состоянию достаточно удалить и пересоздать контейнер:

```bash
# Удалите контейнер (данные хранятся внутри контейнера, не в volume)
docker rm -f n8n-trainer-user123-lesson-01-if

# Создайте контейнер заново из того же образа
./prisma-cms/freecode.academy/server/nexus/types/n8n-trainer/docker/scripts/create-trainer-container.sh user123 lesson-01-if --force
```

Контейнер будет создан заново с чистой базой данных и исходными воркфлоу из образа.

## Создание нового урока

1. Создайте папку `lesson-XX-название`
2. Скопируйте структуру из существующего урока
3. Создайте воркфлоу в формате JSON в папке `workflows/`
4. Обновите `README.md` с описанием урока
5. При необходимости измените `Dockerfile` и `import-workflows.sh`

## Технические детали

- **База данных**: SQLite (файл `database.sqlite` в `/home/node/.n8n/` внутри контейнера)
- **Импорт**: Выполняется при сборке образа командой `n8n import:workflow --separate --input=/workflows/`
- **Dockerfile**: Один общий Dockerfile с аргументом `LESSON` для выбора урока
- **Изоляция**: Каждый пользователь работает в своем контейнере с изолированной базой данных
- **Персистентность**: Все изменения пользователя сохраняются внутри контейнера
- **Именование образов**: Формат `docker-freecode-n8n-trainer-{LESSON}` (например, `docker-freecode-n8n-trainer-lesson-01-if`)
- **Именование контейнеров**: Формат `n8n-trainer-{USER_ID}-{LESSON}` (например, `n8n-trainer-user123-lesson-01-if`)

### Доступные скрипты

- **`scripts/create-trainer-container.sh`** - Создание контейнера для пользователя
  ```bash
  ./scripts/create-trainer-container.sh USER_ID LESSON [--force]
  ```

### GraphQL API

- **Мутация**: `n8nTrainerCreateContainer(lesson: String!)`
  - Автоматически определяет текущего пользователя
  - Создает контейнер с именем `n8n-trainer-{userId}-{lesson}`
  - Возвращает информацию о созданном контейнере

## Структура Dockerfile

```dockerfile
FROM n8nio/n8n:latest

ARG LESSON=

USER root
RUN apk add --no-cache sqlite jq bash util-linux

# Копируем воркфлоу конкретного урока
COPY ${LESSON}/workflows /workflows

USER node
# Импортируем воркфлоу при сборке образа
RUN n8n import:workflow --separate --input=/workflows/
```
