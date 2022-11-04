defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "prepago.txt", :pospago => "pospago.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes(), do: read(:prepago) ++ read(:pospago)
  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    with true <- validar_plano(plano),
         nil <- buscar_assinante(numero) do
      (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
      |> :erlang.term_to_binary()
      |> write(plano)

      {:ok, "Assinante #{nome}, cadastrado com sucesso"}
    else
      false ->
        {:error, "Plano não cadastrado"}

      _assinante ->
        {:error, "Assinante/Número já cadastrado"}
    end
  end

  defp write(lista_assinantes, plano), do: File.write!(@assinantes[plano], lista_assinantes)

  def read(plano) do
    with true <- validar_plano(plano),
         {:ok, assinantes} <- File.read(@assinantes[plano]) do
      assinantes
      |> :erlang.binary_to_term()
    else
      _ ->
        {:error, "PLANO NÃO CADASTRADO"}
    end
  end

  defp validar_plano(plano), do: plano in Map.keys(@assinantes)
end
