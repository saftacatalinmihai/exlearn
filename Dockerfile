FROM sdwolf/elixir:1.2.1

ADD mix.* /work/

RUN DEBIAN_FRONTEND=noninteractive && \
                                      \
    runuser notroot -c "              \
      mix deps.get                 && \
      mix dialyzer.plt                \
    "

CMD iex -S mix
