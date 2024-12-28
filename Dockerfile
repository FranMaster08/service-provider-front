# Etapa 1: Construcción
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar dependencias
COPY package.json package-lock.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa 2: Producción
FROM node:20-alpine AS runner

WORKDIR /app

# Copiar artefactos de construcción desde el builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public

# Configurar entorno
ENV NODE_ENV production
ENV PORT 3000

# Exponer el puerto
EXPOSE 3000

# Comando de inicio
CMD ["npm", "start"]
