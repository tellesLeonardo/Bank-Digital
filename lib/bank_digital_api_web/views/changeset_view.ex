defmodule BankDigitalApiWeb.ChangesetView do
  use BankDigitalApiWeb, :view

  def render("error.json", %{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end
end
