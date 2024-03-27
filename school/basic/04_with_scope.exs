result =
  with {:ok, file} = File.open("/etc/passwd"),
       content = IO.read(file, :all),
       :ok = File.close(file),
       [_, uid, gid] <- Regex.run(~r/^_lp:.*?:(\d+):(=\d+)/m, content) do
    "Group: #{gid}, User: #{uid}"
  end

IO.puts(inspect(result))
