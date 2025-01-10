FROM node:22-alpine

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN npm i -g pnpm

WORKDIR /app

FROM base as builder

COPY . .

RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm --frozen-lockfile --ignore-scripts install


RUN pnpm run build

ENV NODE_ENV=production

EXPOSE 3000

RUN chown -R node /app

USER node 

CMD ["pnpm", "start"]