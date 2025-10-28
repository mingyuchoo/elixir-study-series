defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %{image | grid: grid}
  end

  def mirror_row([a, b, c]), do: [a, b, c, b, a]
def mirror_row([a, b]), do: [a, b, b, a, a]
def mirror_row([a]), do: [a, a, a, a, a]

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {code, _index} -> rem(code, 2) == 0 end)

    %{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %{image | pixel_map: pixel_map}
  end

  def draw_image(%{color: {r, g, b}, pixel_map: pixel_map}) do
  alias Image, as: Img

  # 250x250 흰색 배경 이미지 생성
  {:ok, img} = Img.new(250, 250, color: :white)

  # 각 사각형을 배경 위에 합성
  img =
    Enum.reduce(pixel_map, img, fn {{x1, y1}, {x2, y2}}, acc_img ->
      width = x2 - x1
      height = y2 - y1
      {:ok, rect} = Img.Shape.rect(width, height, color: {r, g, b})
      {:ok, composed} = Img.compose(acc_img, rect, at: {x1, y1})
      composed
    end)

  # 바이너리 PNG로 변환
  {:ok, binary} = Img.write(img, format: :png)
  binary
end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
