defmodule Mix.Tasks.Generate do
  # For this example we are going to assume the domain of sin to be
  # between 0 and 2 * pi
  @spec sin_samples(integer) :: [] # +
  def sin_samples(number) do
    lower_bound = 0
    upper_bound = :math.pi * 2
    step = upper_bound / number
    # @spec (float) :: {} | nil # +
    sin_generator = fn x ->
      if x > upper_bound do
        nil
      else
        {{x, :math.sin(x)}, x + step}
      end
    end
    Stream.unfold(lower_bound, sin_generator)
    |> Stream.take(number)
    |> Enum.to_list
  end

  @spec write_to_file([tuple]) :: any # !
  def write_to_file(list) do
    {:ok, file} = File.open "samples.list", [:write]
    # @spec ({}) :: any # !
    writer = fn pair ->
      IO.write file, elem(pair, 0)
      IO.write file, " "
      IO.write file, elem(pair, 1)
      IO.write file, "\n"
    end
    list |> Enum.map writer
    File.close file
  end

  @spec run([]) :: any # !
  def run(args) do
    File.mkdir "samples"
    File.cd "samples"
    args
    |> List.first
    |> Integer.parse
    |> elem(0)
    |> sin_samples
    |> write_to_file
  end
end
