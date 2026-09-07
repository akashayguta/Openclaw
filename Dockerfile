FROM node:24-bookworm

WORKDIR /app

RUN npm install -g openclaw@latest

ENV NODE_ENV=production
ENV OPENCLAW_HOME=/data/.openclaw

RUN mkdir -p /data/.openclaw/workspace

# Copy instructions file and startup script into the container
COPY AGENTS.md /app/AGENTS.md
COPY start.sh /app/start.sh

RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
