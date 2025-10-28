defmodule Productivity.Events do
  defmodule ListAdded do
    defstruct list: nil, log: nil
  end

  defmodule ListUpdated do
    defstruct list: nil, log: nil
  end

  defmodule ListDeleted do
    defstruct list: nil, log: nil
  end

  defmodule ItemAdded do
    defstruct item: nil, log: nil
  end

  defmodule ItemUpdated do
    defstruct item: nil, log: nil
  end

  defmodule ItemDeleted do
    defstruct item: nil, log: nil
  end
end
