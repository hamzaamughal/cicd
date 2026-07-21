# --- Stage 1: install dependencies ---
# Separate stage so Docker can cache this layer — it only re-runs if
# package.json/package-lock.json change, not on every code change.
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# --- Stage 2: build the app ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# --- Stage 3: run the app ---
# Fresh, tiny image — only what's needed to run, not to build.
# This is why the final image is ~150MB instead of ~1GB+.
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Don't run the app as root inside the container (security basic)
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000

CMD ["node", "server.js"]
