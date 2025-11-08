# Multi-stage build cho Next.js Chatbot
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
# Dùng npm install thay vì npm ci để tránh lỗi khi package-lock.json không đồng bộ
RUN npm install --legacy-peer-deps

# Copy source code (exclude vercel.json và các file không cần thiết)
COPY . .
# Xóa vercel.json nếu có (không cần cho VPS deployment)
RUN rm -f vercel.json

# Build Next.js application
RUN npm run build

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Tạo non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy necessary files từ build stage
COPY --from=build /app/public ./public
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
# Copy data files (Excel) vào production
COPY --from=build /app/src/data ./src/data

# Set ownership
RUN chown -R nextjs:nodejs /app

USER nextjs

# Expose port
EXPOSE 9002

ENV PORT=9002
ENV HOSTNAME="0.0.0.0"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9002/api/health || exit 1

# Start Next.js
CMD ["node", "server.js"]

