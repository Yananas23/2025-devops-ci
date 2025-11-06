FROM node:lts AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npm run build

FROM node:lts-slim AS runner
WORKDIR /app

RUN npm install -g serve

COPY --from=builder /app/dist ./dist

USER node

EXPOSE 3000
CMD ["serve", "-s", "dist", "-l", "3000"]
