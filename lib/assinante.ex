defmodule Assinante do
  @moduledoc """
    Modulo para cadastro de plano por assinantes dos tipos, `prepago` e `pospago`

    A função mais utilizada é a função `cadastrar/4`
  """
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "prepago.txt", :pospago => "pospago.txt"}

  @doc """
  Função para buscar assinantes

  ##  Parametros da função

  - numero: numero de telefone cadastrado
  - key: chave de busca por plano. Pode ser :prepago ou :pospago, caso a chave não seja informada, a
  busca será realizada em ambas as listas

  ## Informações Adicionais

  - Caso o numero não sejá encontrado, ele retornará o valor\n
    `nil` -> significa que o numero informando não consta no banco de cadastro

  - Se a chave não for informada, o numero será buscado em todas as listas,
    tanto em prepago quanto em pospago.

  ## Exemplos
      #cadastrando assinante
      iex> Assinante.cadastrar("Edilberto", "123", "123", :prepago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #buscando pelo assinante cadastrado
      iex> Assinante.buscar_assinante("123", :prepago)
      %Assinante{nome: "Edilberto", numero: "123", cpf: "123", plano: :prepago}

      #cadastrando assinante
      iex> Assinante.cadastrar("Edilberto", "456", "456", :pospago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #buscando pelo assinante cadastrado
      iex> Assinante.buscar_assinante("456", :pospago)
      %Assinante{nome: "Edilberto", numero: "456", cpf: "456", plano: :pospago}

      #cadastrando assinante
      iex> Assinante.cadastrar("Edilberto", "456", "456", :pospago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #buscando assinante sem informar o plano
      iex> Assinante.buscar_assinante("456")
      %Assinante{nome: "Edilberto", numero: "456", cpf: "456", plano: :pospago}

      #buscando assinante não cadastrado
      iex> Assinante.buscar_assinante ("789")
      nil


  """

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  @doc """
  Função para exibir a lista de assinantes `prepago` e `pospago`

  ##  Parametros da função

  - esta função não recebe nenhum parametro

  ## Informações Adicionais

  - função devolve todos os assinantes nas listas de `prepago` ou `pospago`

  ## Exemplo
      #cadastrando assinantes
      iex> Assinante.cadastrar("Edilberto", "123", "123", :prepago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      iex> Assinante.cadastrar("Edilberto", "456", "456", :pospago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #buscando assinantes cadastrados
      iex> Assinante.assinantes
      [%Assinante{nome: "Edilberto", numero: "123", cpf: "123", plano: :prepago},
      %Assinante{nome: "Edilberto", numero: "456", cpf: "456", plano: :pospago}]

  """
  def assinantes(), do: read(:prepago) ++ read(:pospago)

  @doc """
  Função para exibir a lista de assinantes `prepago`

  ##  Parametros da função

  - esta função não recebe nenhum parametro

  ## Informações Adicionais

  - função devolve todos os assinantes nas listas de `prepago`

  ## Exemplo
      #cadastrando assinante
      iex> Assinante.cadastrar("Edilberto", "123", "123", :prepago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #buscando pelo assinante cadastrado
      iex> Assinante.assinantes_prepago
      [%Assinante{nome: "Edilberto", numero: "123", cpf: "123", plano: :prepago}]
  """
  def assinantes_prepago(), do: read(:prepago)

  @doc """
  Função para exibir a lista de assinantes `pospago`

  ##  Parametros da função

  - esta função não recebe nenhum parametro

  ## Informações Adicionais

  - função devolve todos os assinantes nas listas de `pospago`

  ## Exemplo
      #cadastrando assinantes
      iex> Assinante.cadastrar("Edilberto", "456", "456", :pospago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #buscando por assinante cadastrado
      iex> Assinante.assinantes_pospago
      [%Assinante{nome: "Edilberto", numero: "456", cpf: "456", plano: :pospago}]
  """
  def assinantes_pospago(), do: read(:pospago)

  @doc """
  Função para cadastrar assinante seja ele `prepago` ou `pospago`

  ##  Parametros da função

  - nome: parametro do nome do assinantes
  - numero: numero de telefone único e caso exista pode retornar um erro
  - cpf: parametro do cpf do assinantes
  - plano: opcional e caso não sejá informado, será cadastrado um assinante `prepago`

  ## Informações Adicionais

  - Caso o numero já exista ele exibira uma mensagem de erro\n
    `{:error, "Assinante/Número já cadastrado"}`

  ## Exemplo
      iex> Assinante.cadastrar("Edilberto", "123", "123")
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
  """

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

  @doc """
  Função usada para deletar o assinante.

  ##  Parametros da função

  - numero: parametro do numero que é usado no cadastro do assinante

  ## Informações Adicionais

  - Caso o numero informado nao seja cadastrado, um erro é devolvido\n
    `{:error, "Assinante não encontrado"}`

  ## Exemplo
      #cadastrando assinante
      iex> Assinante.cadastrar("Edilberto", "123", "123")
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
      #deletando assinante
      iex> Assinante.deletar ("123")
      {:ok, "Assinante Edilberto deletado com sucesso!"}

  """

  def deletar(numero) do
    case buscar_assinante(numero) do
      %Assinante{} = assinante ->
        assinantes()
        |> List.delete(assinante)
        |> :erlang.term_to_binary()
        |> write(assinante.plano)

        {:ok, "Assinante #{assinante.nome} deletado com sucesso!"}

      _ ->
        {:error, "Assinante não encontrado"}
    end
  end

  @doc """
  Função que lê os arquivos `prepago.txt` e `pospago.txt`, onde são armazenados
    a lista de assinantes conforme o plano informado.

  ##  Parametros da função

  - plano: parametro do nome do plano `:prepago` ou `:pospago`

  ## Informações Adicionais

  - Caso o pano informado nao seja cadastrado, um erro é devolvido\n
    `{:error, "PLANO NÃO CADASTRADO"}`

  ## Exemplo
      iex> Assinante.read :naocadastrado
      {:error, "PLANO NÃO CADASTRADO"}
  """
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
