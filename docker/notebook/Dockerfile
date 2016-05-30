FROM elixir:1.2.5

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

RUN DEBIAN_FRONTEND=noninteractive                          && \
                                                               \
    echo 'Creating notroot user and group from host'        && \
    groupadd -g $HOST_USER_GID notroot                      && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID notroot && \
                                                               \
    echo 'Creating the /work directory for notroot'         && \
    mkdir /work                                             && \
    chown -R notroot:notroot /work                          && \
                                                               \
    echo 'Installing python libraries'                      && \
    apt-get update                                          && \
    apt-get install -y --no-install-recommends                 \
      python-pip                                               \
      python-dev                                            && \
                                                               \
    echo 'Installing jupyter'                               && \
    pip install jupyter                                     && \
                                                               \
    echo 'Installing mix packages and kernel as notroot'    && \
    runuser notroot -c "                                       \
    cd ~                                                    && \
    git clone https://github.com/pprzetacznik/ielixir.git   && \
    cd ielixir                                              && \
    mix local.hex --force                                   && \
    mix local.rebar --force                                 && \
    mix deps.get                                            && \
    ./install_script.sh                                        \
    "

USER notroot

WORKDIR /work

CMD jupyter notebook --ip=0.0.0.0
