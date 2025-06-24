FROM python:3.9-slim AS build

ENV CONTAINER_HOME=/app

WORKDIR ${CONTAINER_HOME}

COPY app.py requirements.txt ${CONTAINER_HOME}

RUN pip install -r ${CONTAINER_HOME}/requirements.txt

##EXPOSE  8080

#CMD ["python", "app.py"]


FROM nginx:alpine

COPY --from=build /app /usr/share/nginx/html

EXPOSE 8080

#CMD [ "nginx", "-g", "daemon off;" ]
CMD ["python", "app.py"]
CMD [ "nginx", "-g", "daemon off;" ]
