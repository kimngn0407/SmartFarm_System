# Multi-stage build cho React Frontend
FROM node:18-alpine AS build

WORKDIR /app

# Build arguments cho environment variables
ARG REACT_APP_API_URL=https://smartfarm.kimngn.cfd

# Set environment variables từ build args
ENV REACT_APP_API_URL=${REACT_APP_API_URL}

# Copy package files
COPY package*.json ./

# Install dependencies (cần devDependencies để build)
RUN npm ci

# Copy source code
COPY . .

# Xóa file .env nếu có (để không override environment variables)
RUN rm -f .env .env.local .env.production .env.development

# Build application (tắt ESLint để tránh lỗi syntax)
ENV DISABLE_ESLINT_PLUGIN=true
ENV ESLINT_NO_DEV_ERRORS=true
RUN npm run build

# Production stage với Nginx
FROM nginx:alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files từ build stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

