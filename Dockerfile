# 1. Aşama: Derleme (Builder)
FROM node:20 AS workspace
WORKDIR /app

# Önce tüm proje kökünü kopyala (api ve diğer modüller dahil olması için)
COPY . .

# Frontend klasörüne geçip paketleri yükle ve build al
WORKDIR /app/frontend
RUN npm install --include=optional
RUN npm run build

# 2. Aşama: Canlı Sunucu
FROM node:20
WORKDIR /app
RUN npm install -g http-server

# Sadece derlenen statik dosyaları builder aşamasından al
COPY --from=workspace /app/frontend/dist /app/public

EXPOSE 3000
CMD ["http-server", "/app/public", "-p", "3000"]
