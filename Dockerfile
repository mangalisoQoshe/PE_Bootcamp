FROM python:3.15.0a5-trixie

WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py extentions.py models.py /usr/src/app

EXPOSE 5000

CMD ["flask","run","--host","0.0.0.0","--port","8080]


