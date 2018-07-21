defmodule Scanner.EnumScannerTest do
  use ExUnit.Case
  alias Scanner.{EnumScanner, StreamScanner}

  describe "count_words/1" do
    test "behaves like Scanner.StreamScanner" do
      lines = [
        "Boop\n",
        "  sea.” —_Whale Song_.\n",
        "CHAPTER 1. Loomings.\n",
        "Call me Ishmael. :)\n",
        "Hello\n",
        "me name Michael. Hello!\n",
        "End of Project Gutenberg’s Moby Dick; or The Whale, by Herman Melville\n",
        "Yolo\n"
      ]

      result = EnumScanner.count_line_words(lines)
      assert result == StreamScanner.count_line_words(lines)
    end
  end
end
