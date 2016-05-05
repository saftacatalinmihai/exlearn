# BrainTonic

[![Build Status](https://travis-ci.org/sdwolf/braintonic.svg?branch=master)](https://travis-ci.org/sdwolf/braintonic)

Elixir artificial intelligence library. (Extreemly early pre pre alpha!!!)

## Neural Network

### Parameters

Example:

```elixir
%{
  layers: %{
    hidden: [
      %{
        activity: :identity,
        size: 1
      }
    ],
    input: %{
      size: 1
    },
    output: %{
      activity: :identity,
      size: 1
    }
  },
  learning_rate: 0.5,
  objective: :quadratic,
  random: %{
    distribution: :uniform,
    range:        {-1, 1}
  }
}
```

## Usage

1. Create a network
    ```elixir
    setup = %{
      layers: %{
        hidden: [
          %{
            activity: :identity,
            size: 1
          }
        ],
        input: %{
          size: 1
        },
        output: %{
          activity: :identity,
          size: 1
        }
      },
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    network = BrainTonic.NeuralNetwork.initialize(setup)
    ```

2. Train the network
    ```elixir
    parameters = %{
      batch_size: 2,
      data: [
        {[0],  [0]},
        {[1],  [1]},
        {[2],  [2]},
        {[9],  [9]},
        {[10], [10]},
        {[42], [42]}
      ],
      data_size:      6,
      dropout:        0.5,
      epochs:         50,
      learning_rate:  0.5,
      regularization: :L2
    }

    BrainTonic.NeuralNetwork.Feeder.feed(network, parameters)
    ```

## Development

1. Install the latest version of the following:
    * Docker
    * Docker Compose
    * Git

2. Clone the repository
    ```bash
    git clone git@github.com:sdwolf/braintonic.git
    ```

3. Build the project container
    ```bash
    docker build                        \
      -t braintonic                     \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/Dockerfile              \
      .
    ```

4. Run an interactive shell
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic iex -S mix
    ```

5. Update dependencies
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix deps.get
    ```

6. Run tests
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix test
    ```

7. Run dialyzer
    ```bash
    docker run --rm -it -v "$PWD":/work braintonic mix dialyzer
    ```

## Misc
Generate X samples with `mix do generate X`

## LICENSE

This plugin is covered by the BSD license, see [LICENSE](LICENSE) for details.
