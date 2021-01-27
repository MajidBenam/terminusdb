FROM terminusdb/terminus_store_prolog:v0.14.3
WORKDIR /app/pack
RUN export BUILD_DEPS="git build-essential make libjwt-dev libssl-dev pkg-config" \
        && apt-get update && apt-get install $BUILD_DEPS -y --no-install-recommends \
        && git clone --single-branch --branch v0.0.3-fix-make https://github.com/terminusdb-labs/jwt_io.git jwt_io \
        && git clone --single-branch --branch v0.0.2 https://github.com/terminusdb/tus.git tus \
        && swipl -g "pack_install('file:///app/pack/jwt_io', [interactive(false)])" \
        && swipl -g "pack_install('file:///app/pack/tus', [interactive(false)])"

FROM terminusdb/terminus_store_prolog:v0.14.3
WORKDIR /app/terminusdb
COPY ./ /app/terminusdb
COPY --from=0 /usr/share/swi-prolog/pack/ /usr/share/swi-prolog/pack
ENV TERMINUSDB_JWT_ENABLED=true
RUN apt-get update && apt-get install -y --no-install-recommends libjwt0 make \
        && swipl -g "ignore(pack_install('https://github.com/terminusdb-labs/jwt_io.git', [interactive(false)]))" \
    && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && make
CMD ["/app/terminusdb/distribution/init_docker.sh"]
