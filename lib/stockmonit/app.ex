defmodule Stockmonit.App do
  @behaviour Ratatouille.App

  import Ratatouille.View
  alias Ratatouille.Runtime.Subscription

  def init(_context), do: %{}

  def update(model, msg) do
    case msg do
      :check_stocks ->
        Stockmonit.Server.get_data()

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
        for header <- ["Name", "Current", "Close", "Open", "Low", "High"] do
          column(size: 5) do
            label do
              text(content: "#{header}", color: :yellow)
            end
          end
        end
      end

      for {name, data} <- model do
        row do
          column(size: 5) do
            label(content: "#{name}")
          end

          column(size: 5) do
            label(content: "#{data["current_price"]}")
          end

          column(size: 5) do
            label(content: "#{data["close_price"]}")
          end

          column(size: 5) do
            label(content: "#{data["open_price"]}")
          end

          column(size: 5) do
            label(content: "#{data["low_price"]}")
          end

          column(size: 5) do
            label(content: "#{data["high_price"]}")
          end
        end
      end
    end
  end
end
