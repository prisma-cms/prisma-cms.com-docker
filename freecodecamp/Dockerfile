FROM node:lts

# # RUN apk add bash mc python3 make g++
# RUN apk add bash mc curl git
# # RUN apk add --upgrade --no-cache vips-dev build-base \
# #   --repository https://alpine.global.ssl.fastly.net/alpine/v3.10/community/

# RUN apt-get update && apt-get install -y --no-install-recommends gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

WORKDIR /app

RUN git clone https://github.com/freeCodeCamp/freeCodeCamp.git


# # ARG SITE=boilerplate

WORKDIR /app/freeCodeCamp

# COPY ./freeCodeCamp /app
COPY ./.env ./.env

RUN npm install --unsafe-perm


# WORKDIR /app/tools/scripts/seed/

# RUN npm run seed


# WORKDIR /app/api-server

# # # WORKDIR /app/freeCodeCamp
# RUN npm i


# WORKDIR /app/

# RUN npm run seed


# WORKDIR /app/api-server

# RUN ls -la /
# RUN ls -la /app
# RUN ls -la
# RUN ls -la /app/api-server/package.json


# # # Установку зависимостей нельзя переносить в entrypoint,
# # # потому что тот скрипт срабатывает уже тогда, когда контейнер создан и заменен имеющийся (если уже был запущен)
# # RUN yarn install --ignore-engines

# EXPOSE 3000
# EXPOSE 9000
