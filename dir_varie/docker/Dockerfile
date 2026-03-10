FROM f69m/ubuntu32:lts

# aggiorna i pacchetti e installa gcc, git, nano
RUN apt-get update && \
    apt-get install -y gcc git nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/home"]
WORKDIR /home
CMD [ "bash" ]

