defmodule Scanner.StreamScannerTest do
  use ExUnit.Case
  alias Scanner.StreamScanner

  describe "clean_line/1" do
    test "returns a clean line unchanged" do
      assert StreamScanner.clean_line("this is a normal line") == "this is a normal line"
    end

    test "trims outside whitespace" do
      assert StreamScanner.clean_line("  i think this works   ") == "i think this works"
    end

    test "lowercases letters" do
      assert StreamScanner.clean_line("I think this WORKS") == "i think this works"
    end
  end

  describe "clean_word/1" do
    test "strips everything that's not alphanumeric or a hyphen" do
      assert StreamScanner.clean_word("_last-ward–ed—ly_.") == "last-ward–ed—ly"
   end
  end

  describe "filter_words/1" do
    test "strips empty words" do
      result = ["hello", "", "world", ""]
               |> StreamScanner.filter_words()
               |> Enum.to_list()
      assert result == ["hello", "world"]
    end
  end

  describe "filter_lines/1" do
    test "drops lines until \"CHAPTER 1. Loomings\"" do
      lines = [
        "Beep\n",
        "Boop\n",
        "Hello\n",
        "CHAPTER 1. Loomings\n",
        "Yolo\n"
      ]

      results = lines
                |> StreamScanner.filter_lines()
                |> Enum.to_list()
      assert results == [
        "CHAPTER 1. Loomings\n",
        "Yolo\n"
      ]
    end

    test "drops empty lines" do
      lines = [
        "CHAPTER 1. Loomings\n",
        "Yolo\n",
        "\n",
        "Call me Ishmael.\n",
        ""
      ]

      results = lines
                |> StreamScanner.filter_lines()
                |> Enum.to_list()
      assert results == [
        "CHAPTER 1. Loomings\n",
        "Yolo\n",
        "Call me Ishmael.\n"
      ]
    end

    test "takes lines until the end cap" do
      lines = [
        "CHAPTER 1. Loomings\n",
        "Call me Ishmael.\n",
        "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville\n",
        "Yolo\n"
      ]

      results = lines
                |> StreamScanner.filter_lines()
                |> Enum.to_list()
      assert results == [
        "CHAPTER 1. Loomings\n",
        "Call me Ishmael.\n"
      ]
    end
  end

  describe "stream_words/1" do
    test "returns the expected list of words" do
      lines = [
        "Beep\n",
        "Boop\n",
        "Hello\n",
        "CHAPTER 1. Loomings\n",
        "Call me Ishmael. :)\n",
        "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville\n",
        "Yolo\n"
      ]

      result = lines
               |> StreamScanner.stream_words()
               |> Enum.to_list()

      assert result == [
        "chapter",
        "1",
        "loomings",
        "call",
        "me",
        "ishmael"
      ]
    end
  end

  describe "count_words/1" do
    test "returns the expected word counts" do
      lines = [
        "Boop\n",
        "CHAPTER 1. Loomings\n",
        "Call me Ishmael. :)\n",
        "Hello\n",
        "me name Michael. Hello!\n",
        "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville\n",
        "Yolo\n"
      ]

      result = StreamScanner.count_line_words(lines)

      assert result == %{
        "1" => 1,
        "call" => 1,
        "chapter" => 1,
        "hello" => 2,
        "ishmael" => 1,
        "loomings" => 1,
        "me" => 2,
        "michael" => 1,
        "name" => 1
      }
    end
  end
end
