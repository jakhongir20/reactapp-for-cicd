FROM node:19.5.0-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .
RUN npm run build
FROM nginx:1.23-alpine
# WORKDIR /usr/share/nginx/html
# RUN rm -rf *
COPY --from=build /app/build .
COPY --from=build /app/build /usr/share/nginx/html


# Expose port 3000 (assuming your Next.js app runs on port 3000)
# port 80 because nginx  uses that by default for its HTTP server
EXPOSE 80
# ENTRYPOINT [ "nginx", "-g", "daemon off" ]
CMD ["nginx", "-g", "daemon off;"]

