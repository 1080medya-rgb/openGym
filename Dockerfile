# 1. Aşama: Derleme (Builder)
FROM node:20 AS builder
WORKDIR /app

# Paket dosyalarını kopyala
COPY frontend/package*.json ./

# Rolldown native modüllerinin ve optional bağımlılıkların eksiksiz yüklenmesini sağla
RUN npm install --include=optional

# Tüm frontend dosyalarını kopyala ve build al
COPY frontend/ ./
RUN npm run build

# 2. Aşama: Canlı Sunucu
FROM node:20
WORKDIR /app
RUN npm install -g http-server

# Derlenen dist klasörünü public altına kopyala
COPY --from=builder /app/dist /app/public

EXPOSE 3000
CMD ["http-server", "/app/public", "-p", "3000"]
