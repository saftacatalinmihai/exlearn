FROM elixir:1.3.1

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

ADD mix.* /work/

RUN set -ex                                                 && \
                                                               \
    echo 'Creating notroot user and group from host'        && \
    groupadd -g $HOST_USER_GID notroot                      && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID notroot && \
                                                               \
    echo 'Giving notroot permissions to /work'              && \
    chown -R notroot:notroot /work                          && \
                                                               \
    echo 'Installing mix packages as notroot'               && \
    runuser notroot -c "                                       \
      mix local.hex --force                                 && \
      mix local.rebar --force                               && \
      cd /work                                              && \
      mix deps.get                                          && \
      mix dialyzer.plt                                         \
    "

CMD iex -S mix
