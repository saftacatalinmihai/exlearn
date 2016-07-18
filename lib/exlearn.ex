defmodule ExLearn do
  @moduledoc """
  Machine Learning
  """

  @major_version "0"
  @minor_version "1"
  @patch_version "0"
  @pre_release   ""

  def version do
    @major_version <> "." <>
    @minor_version <> "." <>
    @patch_version <>
    @pre_release
  end
end
