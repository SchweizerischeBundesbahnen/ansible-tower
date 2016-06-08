FROM ubuntu:trusty

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && \
    apt-get install -y curl binutils

RUN gpg --keyserver pgp.mit.edu --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

RUN locale-gen en_US.UTF-8 &&\
    update-locale

ENV LANG en_US.UTF-8

ENV LANGUAGE en_US:en

ENV LC_ALL en_US.UTF-8

RUN curl -SL "http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.73-linux-x86_64-glibc23.tar.gz" -o mysql.tar.gz && \
    curl -SL "http://mysql.he.net/Downloads/MySQL-5.1/mysql-5.1.73-linux-x86_64-glibc23.tar.gz.asc" -o mysql.tar.gz.asc && \
    gpg --verify mysql.tar.gz.asc && \
    mkdir /usr/local/mysql && \
    tar -xzf mysql.tar.gz -C /usr/local/mysql --strip-components=1 && \
    rm mysql.tar.gz* && \
    rm -rf /usr/local/mysql/mysql-test /usr/local/mysql/sql-bench && \
    rm -rf /usr/local/mysql/bin/*-debug /usr/local/mysql/bin/*_embedded && \
    find /usr/local/mysql -type f -name "*.a" -delete && \
    { find /usr/local/mysql -type f -executable -exec strip --strip-all '{}' + || true; } && \
    apt-get purge -y --auto-remove binutils && \
    rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

# replicate some of the way the APT package configuration works
# this is only for 5.5 since it doesn't have an APT repo, and will go away when 5.5 does
RUN mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'datadir = /var/lib/mysql'; \
                echo 'user=mysql'; \
		echo '!includedir /etc/mysql/conf.d/'; \
	} > /etc/mysql/my.cnf

WORKDIR /usr/local/mysql

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]
