IEx.configure default_prompt: "#{IO.ANSI.magenta}%prefix>#{IO.ANSI.reset}"
IEx.configure alive_prompt: "#{IO.ANSI.cyan}%prefix(%node)>#{IO.ANSI.reset}"
IEx.configure colors: [eval_result: [:cyan, :bright]]
IEx.configure history_size: 50
IEx.configure width: 80
IEx.configure inspect: [pretty: true, limit: :infinity]
