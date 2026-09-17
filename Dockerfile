FROM node:20-alpine AS builder

WORKDIR /build

COPY package.json package-lock.json ./

RUN npm ci --omit=dev --ignore-scripts


FROM node:20-alpine AS runtime

LABEL org.opencontainers.image.title="node-app" \
      org.opencontainers.image.description="Node.js containerization fixture for the aws-cicd-framework pipeline" \
      org.opencontainers.image.source="https://github.com/loriamichaelj/aws-cicd-demo-node-app" \
      org.opencontainers.image.vendor="loriamichaelj" \
      org.opencontainers.image.licenses="MIT"

ENV NODE_ENV=production

RUN addgroup -S -g 10001 app \
    && adduser -S -u 10001 -G app -H -s /sbin/nologin app

WORKDIR /app

COPY --from=builder --chown=10001:10001 /build/node_modules ./node_modules

COPY --chown=10001:10001 package.json ./

COPY --chown=10001:10001 src/ ./src/

USER 10001

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD ["node", "--check", "src/index.js"]

ENTRYPOINT ["node", "src/index.js"]
