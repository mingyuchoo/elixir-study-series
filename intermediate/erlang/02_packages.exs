demodule Packages do
  def deps do
    [{:png, github: "yuce/png"}]
  end

  png =
    :png.create(%{:size => {30, 30}, :mode => {:indexed, 8}, :file => file, :palette => palette})
end
