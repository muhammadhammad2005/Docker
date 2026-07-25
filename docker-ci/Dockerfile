# Stage 1: Testing
FROM node:18-alpine AS testing

LABEL org.opencontainers.image.title="Docker CI Pipeline"
LABEL org.opencontainers.image.description="Multi-stage Docker build with automated testing"
LABEL org.opencontainers.image.version="1.1"

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install -g npm@latest && \
    npm ci

COPY . .

RUN npm test

# Stage 2: Production
FROM node:18-alpine AS production

WORKDIR /usr/src/app

ENV NODE_ENV=production \
    NPM_CONFIG_UPDATE_NOTIFIER=false

COPY package*.json ./

RUN npm install -g npm@latest && \
    npm ci --omit=dev && \
    npm cache clean --force

COPY --from=testing /usr/src/app/app.js ./

RUN addgroup -S nodejs -g 1001 && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /usr/src/app

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s \
             --timeout=5s \
             --start-period=10s \
             --retries=3 \
CMD node -e "require('http').get('http://localhost:3000/health',(res)=>process.exit(res.statusCode===200?0:1)).on('error',()=>process.exit(1))"

CMD ["npm", "start"]
