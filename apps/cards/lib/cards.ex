defmodule Cards do
  @moduledoc """
  Documentation for `Cards`.
  """
  use Application

  # OTP application callback to run CLI and halt
  def start(_type, _args) do
    main(System.argv())
    System.halt()
  end

  @doc """
  Entry point for CLI. Usage: mix run -- <hand_size>
  """
  def main(args) do
    case args do
      [size_str] ->
        case Integer.parse(size_str) do
          {size, _} ->
            hand = create_hand(size)
            IO.inspect(hand)
          :error ->
            IO.puts("Invalid hand size: #{size_str}")
        end
      _ ->
        IO.puts("Usage: mix run -- <hand_size>")
    end
  end

  @doc """
  Create hand
  """
  def create_hand(hand_size) do
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end

  def create_deck() do
    values = [:Ace, :Two, :Three, :Four, :Five, :Six, :Seven, :Eight, :Nine, :Ten]
    suites = [:Spades, :Clubs, :Hearts, :Diamonds]

    for suite <- suites, value <- values do
      "#{value} of #{suite}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divides a deck into a hand and the remainer of the deck.
  The `hand_size` argument indicates how many cards should
  be in the hand.
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file does not exist"
    end
  end
end
