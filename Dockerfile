FROM docker:1.12

# Install JQ
ADD https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

CMD ["sh"]
