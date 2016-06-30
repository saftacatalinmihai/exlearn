# ExLearn

[![Build Status](https://travis-ci.org/sdwolf/exlearn.svg?branch=master)](https://travis-ci.org/sdwolf/exlearn)

Elixir artificial intelligence library. (Extreemly early pre pre alpha!!!)

## Example

```elixir
alias ExLearn.NeuralNetwork, as: NN

# Define the network structure
structure = %{
  layers: %{
    input:   %{size: 1},
    hidden: [%{activity: :identity, size: 1}],
    output:  %{activity: :identity, size: 1}
  },
  objective: :quadratic,
  random:    %{distribution: :uniform, range: {-1, 1}}
}

# Initialize the network
network = NN.initialize(structure)

# Define the learning configuration
configuration = %{
  dropout:        0.5,
  learning_rate:  0.5,
  regularization: :L2
}

# Configure the network
NN.configure(configuration, network)

# Define the training data
data = [
  {[0, 0], [0]},
  {[0, 1], [0]},
  {[1, 0], [0]},
  {[1, 1], [1]}
]

# Define the network input
input = %{
  batch_size: 2,
  data:       data,
  data_size:  4,
  epochs:     1000
}

# Feed the input into the network
NN.feed(input, network)

# Ask the network to predict values
result = NN.ask(data, network)

IO.inspect result
```

## Jupyter Notebook

1. Build the notebook container
    ```bash
    docker build                        \
      -t exlearn-jupyter                \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/notebook/Dockerfile     \
      "$PWD"
    ```

2. Run the server
    ```bash
    docker run --rm -it -p 8888:8888 -v "$PWD":/work exlearn-jupyter
    ```

## Development

1. Add the following alias to `~/.bash_profile` and source it
    ```bash
    alias docker-here='docker run --rm -it -u `id -u`:`id -g` -v "$PWD":/work -w /work'
    alias docker-root-here='docker run --rm -it -v "$PWD":/work -w /work'
    ```

2. Build the project container
    ```bash
    docker build                        \
      -t exlearn                        \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/project/Dockerfile      \
      "$PWD"

    # OR the short version if you are user 1000:1000

    docker build -t exlearn -f docker/project/Dockerfile "$PWD"
    ```

3. Run an interactive shell
    ```bash
    docker-here exlearn iex -S mix
    ```

4. Update dependencies
    ```bash
    docker-here exlearn mix deps.get
    ```

5. Run tests
    ```bash
    docker-here exlearn mix test
    ```

6. Run dialyzer
    ```bash
    docker-here exlearn mix dialyzer
    ```

## LICENSE

This plugin is covered by the BSD license, see [LICENSE](LICENSE) for details.
