defmodule RepoMonitorTest do
  use ExUnit.Case
  doctest RepoMonitor

  test "greets the world" do
    assert RepoMonitor.hello() == :world
  end
end
