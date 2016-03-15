FROM alpine

ADD ./server.sh /etc/server.sh
RUN chmod +x /etc/server.sh

EXPOSE 8080

CMD ["nc", "-lvkp", "8080", "-e", "/etc/server.sh"]