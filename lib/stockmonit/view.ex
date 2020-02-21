defmodule Stockmonit.View do
  @behaviour Ratatouille.App
  @headers ["Name", "Current", "Prev Close", "Open", "Low", "High"]

  import Ratatouille.View
  alias Ratatouille.Runtime.Subscription

  def init(_context), do: %{}

  def update(model, msg) do
    case msg do
      :check_stocks ->
        Stockmonit.Results.get()

      _ ->
        model
    end
  end

  def subscribe(_model) do
    Subscription.interval(1000, :check_stocks)
  end

  def render(model) do
    view do
      row do
        for header <- @headers do
          column(size: 5) do
            label do
              text(content: "#{header}", color: :yellow)
            end
          end
        end
      end

      for {name, data} <- model do
        print_row(name, data)
      end
    end
  end

  defp print_row(name, {:error, err}) do
    row do
      column(size: 5) do
        label(content: "#{name}")
      end

      column(size: 5) do
        label(content: err, color: :red)
      end

      column(size: 5) do
        label(content: "")
      end

      column(size: 5) do
        label(content: "")
      end
    end
  end

  defp print_row(name, {:ok, stock_quote}) do
    row do
      column(size: 5) do
        label(content: "#{name}")
      end

      column(size: 5) do
        label(content: "#{stock_quote.current_price}")
      end

      column(size: 5) do
        label(content: "#{stock_quote.close_price}")
      end

      column(size: 5) do
        label(content: "#{stock_quote.open_price}")
      end

      column(size: 5) do
        label(content: "#{stock_quote.low_price}")
      end

      column(size: 5) do
        label(content: "#{stock_quote.high_price}")
      end
    end
  end
end
