defmodule Scanner do
  @moduledoc """
  Documentation for Scanner.
  """

  @start_line "CHAPTER 1. Loomings"
  @end_line "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville"

  def stream_words(lines) do
    lines
    |> filter_lines()
    |> process_lines()
    |> process_words()
    |> filter_words()
  end

  def filter_lines(lines) do
    lines
    |> Stream.drop_while(&(&1 != @start_line))
    |> Stream.reject(&(String.length(&1) == 0))
    |> Stream.take_while(&(&1 != @end_line))
  end

  def filter_words(words) do
    Stream.reject(words, &(String.length(&1) == 0))
  end

  def process_lines(lines) do
    lines
    |> Stream.map(&clean_line/1)
    |> Stream.flat_map(&String.split/1)
  end

  def process_words(words) do
    Stream.map(words, &clean_word/1)
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
