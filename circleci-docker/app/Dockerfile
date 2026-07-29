FROM node:18-alpine

LABEL org.opencontainers.image.title="CircleCI Node.js Application"
LABEL org.opencontainers.image.description="Containerized Node.js app built through CI/CD pipeline"
LABEL org.opencontainers.image.version="1.1"
LABEL maintainer="Muhammad Hammad"

WORKDIR /app

ENV NODE_ENV=production \
    NPM_CONFIG_UPDATE_NOTIFIER=false

COPY package*.json ./

RUN npm ci --omit=dev && \
    npm cache clean --force

COPY . .

RUN addgroup -S nodejs -g 1001 && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s \
             --timeout=5s \
             --start-period=10s \
             --retries=3 \
CMD node -e "require('http').get('http://localhost:3000/',(res)=>process.exit(res.statusCode===200?0:1)).on('error',()=>process.exit(1))"

CMD ["node", "index.js"]
