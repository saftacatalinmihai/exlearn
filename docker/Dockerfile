FROM elixir:1.2.4

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

RUN DEBIAN_FRONTEND=noninteractive                          && \
                                                               \
    echo 'Creating notroot user and group from host'        && \
    groupadd -g $HOST_USER_GID notroot                      && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID notroot

ADD mix.* /work/

RUN DEBIAN_FRONTEND=noninteractive                          && \
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

USER notroot

WORKDIR /work

CMD iex -S mix
