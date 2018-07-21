defmodule ScannerTest do
  use ExUnit.Case

  describe "clean_line/1" do
    test "returns a clean line unchanged" do
      assert Scanner.clean_line("this is a normal line") == "this is a normal line"
    end

    test "trims outside whitespace" do
      assert Scanner.clean_line("  i think this works   ") == "i think this works"
    end

    test "lowercases letters" do
      assert Scanner.clean_line("I think this WORKS") == "i think this works"
    end
  end

  describe "clean_word/1" do
    test "strips everything that's not alphanumeric or a hyphen" do
      assert Scanner.clean_word("_last-ward–ed—ly_.") == "last-ward–ed—ly"
   end
  end

  describe "filter_words/1" do
    test "strips empty words" do
      result = ["hello", "", "world", ""]
               |> Scanner.filter_words()
               |> Enum.to_list()
      assert result == ["hello", "world"]
    end
  end

  describe "filter_lines/1" do
    test "drops lines until \"CHAPTER 1. Loomings\"" do
      lines = [
        "Beep",
        "Boop",
        "Hello",
        "CHAPTER 1. Loomings",
        "Yolo"
      ]

      results = lines
                |> Scanner.filter_lines()
                |> Enum.to_list()
      assert results == [
        "CHAPTER 1. Loomings",
        "Yolo"
      ]
    end

    test "drops empty lines" do
      lines = [
        "CHAPTER 1. Loomings",
        "Yolo",
        "",
        "Call me Ishmael.",
        ""
      ]

      results = lines
                |> Scanner.filter_lines()
                |> Enum.to_list()
      assert results == [
        "CHAPTER 1. Loomings",
        "Yolo",
        "Call me Ishmael."
      ]
    end

    test "takes lines until the end cap" do
      lines = [
        "CHAPTER 1. Loomings",
        "Call me Ishmael.",
        "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville",
        "Yolo"
      ]

      results = lines
                |> Scanner.filter_lines()
                |> Enum.to_list()
      assert results == [
        "CHAPTER 1. Loomings",
        "Call me Ishmael."
      ]
    end
  end

  describe "stream_words/1" do
    test "returns the expected list of words" do
      lines = [
        "Beep",
        "Boop",
        "Hello",
        "CHAPTER 1. Loomings",
        "Call me Ishmael. :)",
        "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville",
        "Yolo"
      ]

      result = lines
               |> Scanner.stream_words()
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
end
