FROM nginx:alpine
COPY . /usr/share/nginx/html
COPY nginx-decidir.conf /etc/nginx/conf.d/default.conf
RUN rm -f /usr/share/nginx/html/nginx-decidir.conf
