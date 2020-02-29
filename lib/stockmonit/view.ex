defmodule Stockmonit.View do
  @behaviour Ratatouille.App
  @header ["Name", "Now", "Prev", "Open", "Low", "High", "+/- %"]

  import Ratatouille.View
  import Stockmonit.View.Presenter

  alias Ratatouille.Runtime.Subscription

  def init(_context), do: %{}

  def update(model, msg) do
    case msg do
      {:event, %{ch: ?r}} ->
        Stockmonit.Config.Server.stop()

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
      panel title: "Stockmonit", height: :fill do
        row do
          for header <- @header do
            column(size: 1) do
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
  end

  defp print_row(name, {:error, err}) do
    row do
      column(size: 2) do
        label(content: "#{name}")
      end

      column(size: 1) do
        label(content: err, color: :red)
      end

      column(size: 1) do
        label(content: "")
      end

      column(size: 1) do
        label(content: "")
      end
    end
  end

  defp print_row(name, {:ok, stock_quote}) do
    row do
      column(size: 1) do
        label(content: "#{name}")
      end

      column(size: 1) do
        label do
          text(current_price_column(stock_quote.current_price, stock_quote.close_price))
        end
      end

      column(size: 1) do
        label do
          text(price_column(stock_quote.close_price))
        end
      end

      column(size: 1) do
        label do
          text(price_column(stock_quote.open_price))
        end
      end

      column(size: 1) do
        label do
          text(price_column(stock_quote.low_price))
        end
      end

      column(size: 1) do
        label do
          text(price_column(stock_quote.high_price))
        end
      end

      column(size: 1) do
        label do
          text(change_column(stock_quote.change))
        end
      end
    end
  end
end
