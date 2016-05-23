FROM ubuntu:16.04

# Cache buster
ENV CREATED_AT 2016-05-22T16:25:00
# No interactive sesions
ENV DEBIAN_FRONTEND noninteractive
# Regenerate locale (language) info
RUN locale-gen en_US en_US.UTF-8 \
  && dpkg-reconfigure locales

# Note: We use ``&&\`` to run commands one after the other - the ``\``
# allows the RUN command to span multiple lines.

# Instalamos algunas utilerias
RUN apt-get update && apt-get -y install \
      curl \
      wget \
      unzip \
      software-properties-common \
      python-software-properties \
      language-pack-en \
      apt-utils \
      autossh \
      openssh-client \
      openssh-server \
  && rm -rf /var/lib/apt/lists/*


# Default American enlglish language for locales
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV JAVA_HOME /usr/jdk1.8.0_31
ENV KAFKA_HOME /opt/apache-kafka
ENV PATH $PATH:$JAVA_HOME/bin:$KAFKA_HOME/bin

## Descargamos Java 8
RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/server-jre-8u31-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $JAVA_HOME /usr/java \
  && rm -rf $JAVA_HOME/man


# Descargamos Apache Kafka
RUN mkdir -p /opt \
  && cd /opt \
  && curl -O -J "http://www-us.apache.org/dist/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz" \
  && tar -xvf kafka_2.11-0.9.0.1.tgz \
  && mv kafka_2.11-0.9.0.1 apache-kafka

# Asumiremos que el zookeper ya esta andando en el puerto 2181

# Asumiremos que el broker estara andando en el puerto default (9092)
EXPOSE 9092

# Asumiremos que pueden sobreescribir la configuracion en la carpeta default
VOLUME /opt/apache-kafka/config

ADD entrypoint.sh $KAFKA_HOME/

WORKDIR $KAFKA_HOME

CMD ["/bin/bash", "entrypoint.sh"]

