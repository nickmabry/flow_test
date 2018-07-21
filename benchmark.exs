Benchee.run(%{
  "EnumScanner" => fn -> Scanner.EnumScanner.run("./priv/mobydick.txt") end,
  "StreamScanner" => fn -> Scanner.StreamScanner.run("./priv/mobydick.txt") end
})
