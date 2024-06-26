FROM node:19.5.0-alpine AS build

# Declare build time environment variables
ARG REACT_APP_NODE_ENV
ARG REACT_APP_SERVER_BASE_URL

# Set default values for environment variables
ENV REACT_APP_NODE_ENV=${REACT_APP_NODE_ENV}
ENV REACT_APP_SERVER_BASE_URL=${REACT_APP_SERVER_BASE_URL}

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

