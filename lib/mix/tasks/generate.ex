defmodule Mix.Tasks.Generate do
  # For this example we are going to assume the domain of sin to be
  # between [0, 2 * pi]
  # + sin_samples :: Integer -> []
  def sin_samples(number) do
    lower_bound = 0
    upper_bound = :math.pi * 2
    step = upper_bound / number
    # + :: Float -> {{Float, Float}, Float} | Nil
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

  # ! write_to_file :: [{Float, Float}] -> ()
  def write_to_file(list) do
    {:ok, file} = File.open "samples.list", [:write]
    # ! :: {Float, Float} -> ()
    writer = fn pair ->
      IO.write file, elem(pair, 0)
      IO.write file, " "
      IO.write file, elem(pair, 1)
      IO.write file, "\n"
    end
    list |> Enum.map writer
    File.close file
  end

  # ! run :: [] -> ()
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
