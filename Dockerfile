FROM alpine:3.7

ENV TINYPROXY_VERSION="1.0.1"

RUN apk add --no-cache python3 git && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    git clone -b ${TINYPROXY_VERSION} --depth 1 https://github.com/igzivkov/tinyproxy_exporter.git tinyproxy_exporter_repo && \
    pip install -r ./tinyproxy_exporter_repo/requirements.txt && \
    cp ./tinyproxy_exporter_repo/tinyproxy_exporter / && \
    rm -rf ./tinyproxy_exporter_repo && \
    rm -r /root/.cache

ENV LISTEN=":9240" \
	STATHOST="tinyproxy.stats" \
	TINYPROXY="127.0.0.1:8888"

CMD python3 /tinyproxy_exporter -l ${LISTEN} -s ${STATHOST} -t ${TINYPROXY}