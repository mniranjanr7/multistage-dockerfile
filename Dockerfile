FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json .
RUN npm install

# Stage 2 #Testing phase
FROM base AS test
COPY . .
RUN npm test

# Stage 3 #Production build phase
FROM node:18-alpine AS release
WORKDIR /app
COPY --from=base /app/node_modules  ./node_modules
COPY . .
EXPOSE 3000
CMD [ "npm", "start" ]