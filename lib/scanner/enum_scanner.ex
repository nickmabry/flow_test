defmodule Scanner.EnumScanner do
  @moduledoc """
  Documentation for Scanner.
  """

  @break_line "  sea.” —_Whale Song_.\n"
  @start_line "CHAPTER 1. Loomings.\n"
  @end_line "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville\n"

  def run(path) do
    path
    |> File.stream!()
    |> count_line_words()
  end

  def count_line_words(lines) do
    lines
    |> stream_words()
    |> count_words()
  end

  def count_words(lines) do
    lines
    |> Enum.reduce(%{}, fn word, acc ->
         Map.update(acc, word, 1, & &1 + 1)
       end)
    |> Enum.sort()
  end

  def stream_words(lines) do
    lines
    |> filter_lines()
    |> process_lines()
    |> process_words()
    |> filter_words()
  end

  def filter_lines(lines) do
    lines
    |> Enum.drop_while(&(&1 != @break_line))
    |> Enum.drop_while(&(&1 != @start_line))
    |> Enum.reject(&(&1 == "\n" || String.length(&1) == 0))
    |> Enum.take_while(&(&1 != @end_line))
  end

  def filter_words(words) do
    Enum.reject(words, &(String.length(&1) == 0))
  end

  def process_lines(lines) do
    lines
    |> Enum.map(&clean_line/1)
    |> Enum.flat_map(&String.split/1)
  end

  def process_words(words) do
    Enum.map(words, &clean_word/1)
  end

  def clean_line(line) do
    line
    |> String.trim()
    |> String.downcase()
  end

  def clean_word(word) do
    word
    |> String.replace(~R/[^[:alnum:]-–—]+/, "")
  end
end
