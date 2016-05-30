# BrainTonic

[![Build Status](https://travis-ci.org/sdwolf/braintonic.svg?branch=master)](https://travis-ci.org/sdwolf/braintonic)

Elixir artificial intelligence library. (Extreemly early pre pre alpha!!!)

## Neural Network

### API

| Function   | Arguments | Return |
| --------   | --------- | ------ |
| ask        |           |        |
| configure  |           |        |
| feed       |           |        |
| load       |           |        |
| initialize |           |        |
| inspect    |           |        |
| save       |           |        |
| test       |           |        |
| train      |           |        |

### Parameters

#### Network Structure

| Key       | Value |
| ---       | ----- |
| layers    |       |
| objective |       |
| random    |       |

#### Layer Structure

| Key    | Value |
| ---    | ---   |
| input  |       |
| hidden |       |
| output |       |

#### Activation Functions

| Name | Arguments | Return |
| ---- | --------- | ------ |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |

#### Objective Functions

| Name | Arguments | Return |
| ---- | --------- | ------ |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |
|      |           |        |

#### Learning

| Key            | Value |
| ---            | ---   |
| dropout        |       |
| learning_rate  |       |
| regularization |       |

#### Data Feed

| Key        | Value |
| ---        | ---   |
| batch_size |       |
| data       |       |
| data_size  |       |
| epochs     |       |

#### Example

```elixir
alias BrainTonic.NeuralNetwork, as: NN

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
NN.feed(network, input)

# Ask the network to predict values
result = NN.ask(data, network)

IO.inspect result
```

## Jupyter Notebook

1. Build the notebook container
    ```bash
    docker build                        \
      -t braintonic-jupyter             \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/notebook/Dockerfile     \
      "$PWD"
    ```

2. Run the server
    ```bash
    docker run --rm -it -p 8888:8888 -v "$PWD":/work braintonic-jupyter
    ```

## Development

1. Build the project container
    ```bash
    docker build                        \
      -t braintonic                     \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/project/Dockerfile      \
      "$PWD"
    ```

2. Run an interactive shell
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic iex -S mix
    ```

3. Update dependencies
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix deps.get
    ```

4. Run tests
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix test
    ```

5. Run dialyzer
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix dialyzer
    ```

6. Run samples
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix run samples/or.exs
    ```

## LICENSE

This plugin is covered by the BSD license, see [LICENSE](LICENSE) for details.
