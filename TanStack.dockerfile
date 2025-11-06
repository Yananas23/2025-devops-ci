FROM node:lts AS builder
WORKDIR /app

RUN npm install -g pnpm

COPY package*.json ./
COPY pnpm-lock.yaml ./

RUN pnpm install --legacy-peer-deps

COPY . .

RUN pnpm run build

FROM node:lts-slim AS runner
WORKDIR /app

RUN npm install -g pnpm

RUN pnpm add -g serve

COPY --from=builder /app/dist ./dist

USER node

EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
