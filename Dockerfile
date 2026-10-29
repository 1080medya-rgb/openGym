# 1. Aşama: Frontend projesini derleme (Build)
FROM node:18-alpine AS builder
WORKDIR /app

# Frontend klasörünün içindeki package.json dosyalarını kopyala ve paketleri yükle
COPY frontend/package*.json ./
RUN npm install

# Tüm frontend dosyalarını kopyala ve build al
COPY frontend/ ./
RUN npm run build

# 2. Aşama: Derlenen dosyaları hafif bir sunucu ile yayınlama
FROM node:18-alpine
WORKDIR /app
RUN npm install -g http-server

# Vite kullanıyorsa 'dist', Create React App kullanıyorsa 'build' klasörünü kopyala
# (Genelde Vite kullanılır, dist çıkar)
COPY --from=builder /app/dist /app/public

EXPOSE 3000
CMD ["http-server", "/app/public", "-p", "3000"]
