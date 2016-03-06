# BrainTonic

Elixir artificial intelligence library. (Extreemly early pre pre alpha!!!)

## Neural Network

### Parameters

Example:

```elixir
%{
  layers: %{
    hidden: [
      %{
        activation: :identity,
        size: 1
      }
    ],
    input: %{
      size: 1
    },
    output: %{
      activation: :identity,
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

## Development

1. Install the latest version of the following:
    * Docker
    * Docker Compose
    * Git

2. Clone the repository
    ```
    git clone git@github.com:sdwolf/braintonic.git
    ```

3. Change into the project directory
    ```
    cd braintonic
    ```

4. Build the project container
    ```
    docker build -t braintonic .
    ```

5. Run an interactive shell
    ```
    docker run --rm -it -u 1000 -v "$PWD":/work braintonic iex -S mix
    ```

6. Update dependencies
    ```
    docker run --rm -it -u 1000 -v "$PWD":/work braintonic mix deps.get
    ```

7. Run tests:
    ```
    docker run --rm -it -u 1000 -v "$PWD":/work braintonic mix test
    ```

8. Run dialyzer
    ```
    docker run --rm -it -u 1000 -v "$PWD":/work braintonic mix dialyzer
    ```

## Misc
Generate X samples with `mix do generate X`

## LICENSE

This plugin is covered by the BSD license, see [LICENSE](LICENSE) for details.
