alias BrainTonic.NeuralNetwork, as: NN

network_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, size: 2}],
    output:  %{activity: :logistic, size: 1}
  },
  objective: :quadratic,
  random:    %{distribution: :uniform, range: {-1, 1}}
}

network = NN.initialize(network_parameters)

configuration = %{
  dropout:        0.5,
  learning_rate:  0.5,
  regularization: :L2
}

NN.configure(configuration, network)

data = [
  {[0, 0], [0]},
  {[0, 1], [1]},
  {[1, 0], [1]},
  {[1, 1], [1]}
]

input = %{
  batch_size: 2,
  data:       data,
  data_size:  4,
  epochs:     1000
}

NN.feed(network, input)

result = NN.ask(data, network)

IO.inspect result
