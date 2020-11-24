FROM node:12 AS Builder

# ARG from .gitub/workflows/main.yml --build-arg
ARG QENV

# Close npm warning
ENV NPM_CONFIG_LOGLEVEL error

# Create, set folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . .

RUN npm install && \
    npm run $QENV

FROM nginx

# Copy dist project into nginx static folder
COPY --from=Builder /usr/src/app/dist/spa /usr/share/nginx/html

# Initial nginx proxy
COPY --from=Builder /usr/src/app/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
