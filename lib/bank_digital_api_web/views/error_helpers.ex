defmodule BankDigitalApiWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # The Gettext module must be available for this to work.
    # Ensure you have the :gettext dependency and BankDigitalApiWeb.Gettext module.

    if count = opts[:count] do
      Gettext.dngettext(BankDigitalApiWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(BankDigitalApiWeb.Gettext, "errors", msg, opts)
    end
  end
end
