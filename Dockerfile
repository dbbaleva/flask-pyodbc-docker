FROM tiangolo/uwsgi-nginx-flask:python3.7

RUN apt-get update && apt-get install -y --no-install-recommends openssh-server && echo "root:Docker!" | chpasswd
RUN apt-get update && apt-get install -y build-essential unixodbc unixodbc-dev unixodbc-bin freetds-dev freetds-bin tdsodbc && rm -rf /var/lib/apt/lists/*

COPY ./sshd_config /etc/ssh/
COPY ./entrypoint.sh /app/
COPY ./start.sh /app/
COPY ./requirements.txt /app/
COPY ./prestart.sh /app/

WORKDIR /app
RUN python -m pip install --upgrade pip setuptools
RUN pip install -r requirements.txt

ENV FLASK_APP app.main:app
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LISTEN_PORT 8000
ENV UWSGI_READ_TIMEOUT 300
ENV UWSGI_SEND_TIMEOUT 300
EXPOSE 8000 2222

RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/start.sh
RUN chmod +x /app/prestart.sh

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["/app/start.sh"]
