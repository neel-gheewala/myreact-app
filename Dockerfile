#Stage 1: Build react app
FROM node:18-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --only=production

COPY . .
RUN npm run build

#stage 2: Serve with nginx
FROM nginx:alpine

#set security headers
RUN echo 'server_tokens off;' > /etc/nginx/conf.d/security.conf

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
