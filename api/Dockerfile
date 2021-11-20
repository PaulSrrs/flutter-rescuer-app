FROM python:3.8

WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt update

COPY . .
RUN pip3 install -r requirements.txt

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
