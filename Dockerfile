FROM alpine:3.10

RUN apk add --no-cache python3 git && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools prometheus-client && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    git clone  https://github.com/igzivkov/tinyproxy_exporter.git && \
    cp tinyproxy_exporter/tinyproxy_exporter / && \
    rm -r /root/.cache

ENV LISTEN=":9240" \
	STATHOST="tinyproxy.stats" \
	TINYPROXY="127.0.0.1:8888"

CMD python3 /tinyproxy_exporter -l ${LISTEN} -s ${STATHOST} -t ${TINYPROXY}