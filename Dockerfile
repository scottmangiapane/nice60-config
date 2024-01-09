FROM zmkfirmware/zmk-build-arm:3.5-branch

WORKDIR /
RUN git clone https://github.com/zmkfirmware/zmk.git

WORKDIR /zmk
RUN west init -l app && \
    west update

COPY config /config
RUN west build -p -s app -b nice60 -- -DZMK_CONFIG="/config"

WORKDIR /zmk/build/zephyr
ENTRYPOINT [ "bash" ]
