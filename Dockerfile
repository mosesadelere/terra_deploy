FROM python:3.9-slim AS build

ENV CONTAINER_HOME=/var/www

COPY app.py requirements.txt ${CONTAINER_HOME}

WORKDIR ${CONTAINER_HOME}

RUN pip install -r ${CONTAINER_HOME}/requirements.txt

##EXPOSE  8080

CMD ["python", "app.py"]


FROM nginx:alpine

COPY --from=build /var/www /usr/share/nginx/html

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;" ]
