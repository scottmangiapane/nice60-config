FROM zmkfirmware/zmk-build-arm:2.5

WORKDIR /
RUN git clone https://github.com/zmkfirmware/zmk.git

WORKDIR /zmk
RUN west init -l app && \
    west update

COPY config /config
RUN mkdir /build && \
    west build -p -s app -b nice60 -- -DZMK_CONFIG="/config" && \
    cp build/zephyr/zmk.hex /build && \
    cp build/zephyr/zmk.uf2 /build

WORKDIR /build
ENTRYPOINT [ "bash" ]
