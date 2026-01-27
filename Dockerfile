FROM python:3.15.0a5-trixie

WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py extensions.py models.py /usr/src/app

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PWD}@db:5432/${POSTGRES_DB}

EXPOSE 8080

CMD ["flask","run","--port","8080"]


