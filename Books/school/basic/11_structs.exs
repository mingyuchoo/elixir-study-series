defmodule Example.User do
  @derive {Inspect, only: [:name]}

  defstruct name: nil, roles: []
end

%Example.User{name: "Sean"} |> IO.inspect()
