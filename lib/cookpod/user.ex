defmodule Cookpod.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email()
    |> validate_pass()
    |> encrypt_password()
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
  end

  def new_changeset() do
    changeset(%Cookpod.User{}, %{})
  end

  def encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, password} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
      :error ->
        changeset
    end
  end

  defp validate_email(changeset) do
    changeset
    |> get_field(:email)
    |> check_email(changeset)
  end

  defp check_email(nil, changeset), do: changeset

  defp check_email(email, changeset) do
    case EmailChecker.valid?(email) do
      true -> changeset
      false -> add_error(changeset, :email, "has invalid format email", validation: :format)
    end
  end

  defp validate_pass(changeset) do
    changeset
    |> get_field(:password)
    |> check_pass(changeset)
  end

  defp check_pass(nil, changeset), do: changeset

  defp check_pass(password, changeset) do
    opts = [
      length: [min: 5, max: 30],
        character_set: [
          lower_case: 1,  # at least one lower case letter
        #  upper_case: [3, :infinity], # at least three upper case letters
        #  numbers: [0, 4],  # at most 4 numbers
        #  special: [0, 0],  # no special characters allowed
        ]
    ]    

    case PasswordValidator.validate_password(password, opts) do
      :ok -> changeset
      :error -> add_error(changeset, :password, "String is too long", validation: :format)
    end
  end
end