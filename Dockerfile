  FROM node:18-alpine AS deps
  WORKDIR /app
  COPY package.json yarn.lock ./
  RUN yarn install

  FROM node:18-alpine AS builder
  WORKDIR /app
  COPY --from=deps /app/node_modules ./node_modules
  COPY . .
  RUN yarn build


  FROM node:18-alpine AS runner
  WORKDIR /app
  ENV NODE_ENV=production
  COPY --from=builder /app/next.config.js ./
  COPY --from=builder /app/node_modules ./node_modules
  COPY --from=builder /app/.next ./.next
  COPY --from=builder /app/public ./public
  COPY --from=builder /app/package.json /app/yarn.lock ./
  EXPOSE 3000

  CMD ["yarn", "start"]