FROM python:3.12.1-slim-bullseye

WORKDIR courseCatalog/

ADD . /courseCatalog/

RUN apt update; apt install -y python3-mysqldb libmariadb-dev gcc

RUN pip install -r requirements.txt

EXPOSE 5000

CMD python3 app.py