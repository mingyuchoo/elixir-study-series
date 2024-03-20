defmodule DemoWeb.HelloHTML do
  use DemoWeb, :html

  embed_templates "hello_html/*"
end
