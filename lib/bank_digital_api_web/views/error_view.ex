defmodule BankDigitalApiWeb.ErrorView do
  use BankDigitalApiWeb, :view

  def render("404.json", _assigns) do
    %{
      error: "Not Found"
    }
  end

  def render("500.json", _assigns) do
    %{
      errors: %{
        detail: "Internal Server Error"
      }
    }
  end
end
