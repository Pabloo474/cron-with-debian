# Usa Debian Bookworm como base
FROM debian:bookworm

# Actualiza la lista de paquetes e instala dependencias
RUN apt-get update && \
    apt-get install -y python3 python3-pip cron && \
    apt-get clean

# Copia el script main.py al contenedor
COPY main.py /usr/src/app/main.py

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Da permisos de ejecución al script main.py
RUN chmod +x main.py

# Configura el cron job
RUN echo "* * * * * /usr/bin/python3 /usr/src/app/main.py >> /var/log/cron.log 2>&1" > /etc/cron.d/my-cron-job

# Da los permisos adecuados para el archivo de cron
RUN chmod 0644 /etc/cron.d/my-cron-job

# Aplica el cron job
RUN crontab /etc/cron.d/my-cron-job

# Crea el archivo de log para cron
RUN touch /var/log/cron.log

# Configura el comando de entrada para iniciar cron y mantener el contenedor en ejecución
CMD cron && tail -f /var/log/cron.log
