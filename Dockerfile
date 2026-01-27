# Stage 1: base
FROM node:24-alpine AS base
WORKDIR /app
COPY package*.json ./

# Stage 2: build_dependencies
FROM base AS build_dependencies
RUN npm ci

# Stage 3: build
FROM build_dependencies AS build
COPY . .
RUN npm run build

# Stage 4: production
FROM node:24-alpine AS production
WORKDIR /app
ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 -G nodejs appuser

COPY --chown=appuser:nodejs --from=build /app/package*.json ./
COPY --chown=appuser:nodejs --from=build /app/index.js ./

RUN npm ci --omit=dev

USER appuser

EXPOSE 3000

CMD ["node", "index.js"]
