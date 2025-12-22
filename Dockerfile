FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json .
RUN npm install

# Stage 2 #Testing phase
FROM base AS test
COPY . .
RUN npm test

# This stage builds npm build 
FROM test AS builder
RUN npm run build

# Stage 3 #Production build phase
FROM node:18-alpine AS release
WORKDIR /app
COPY --from=base /app/node_modules  ./node_modules
COPY --from=builder /app/build ./build
COPY . .
EXPOSE 3000
CMD [ "npm", "start" ]