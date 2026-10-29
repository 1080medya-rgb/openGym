# 1. Aşama: Standart (Debian tabanlı) Node 20 imajı
FROM node:20 AS builder
WORKDIR /app

# Frontend paketlerini kopyala ve yükle
COPY frontend/package*.json ./
RUN npm install

# Tüm frontend dosyalarını kopyala ve build al
COPY frontend/ ./
RUN npm run build

# 2. Aşama: Derlenen dosyaları hafif bir sunucu ile yayınlama
FROM node:20
WORKDIR /app
RUN npm install -g http-server

# Derlenen dist klasörünü public altına kopyala
COPY --from=builder /app/dist /app/public

EXPOSE 3000
CMD ["http-server", "/app/public", "-p", "3000"]
