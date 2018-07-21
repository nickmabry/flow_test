Benchee.run(%{
  "EnumScanner" => fn -> Scanner.EnumScanner.run("./priv/mobydick.txt") end,
  "StreamScanner" => fn -> Scanner.StreamScanner.run("./priv/mobydick.txt") end,
  "FlowScanner" => fn -> Scanner.FlowScanner.run("./priv/mobydick.txt") end
  },
  memory_time: 5,
  time: 10,
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ]
)
