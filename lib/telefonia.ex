defmodule Telefonia do
  @moduledoc """
    Modulo que inicia os arquivos, `prepago.txt` e `pospago.txt` e

    que contem os parametros estruturais de um cadastro de assinante

  """
  @doc """
  Função para gerar os arquivos onde serão armazenados os dados dos assinantes

  ##  Parametros da função

  - esta função não recebe nenhum parametro

  ## Informações Adicionais

  - Função é chamada antes da criação do cadastro do assinante

  ## Exemplos
      #criando os arquivos `prepago.txt` e `pospago.txt`
      iex> Telefonia.start
      :ok

  """
  def start do
    File.write("prepago.txt", :erlang.term_to_binary([]))
    File.write("pospago.txt", :erlang.term_to_binary([]))
  end

  @doc """
  Função para cadastro de assinantes

  ##  Parametros da função

  - nome: parametro do nome do assinantes
  - numero: numero de telefone único e caso exista pode retornar um erro
  - cpf: parametro do cpf do assinantes
  - plano: opcional e caso não sejá informado, será cadastrado um assinante `prepago`

  ## Informações Adicionais

    A função cadastrar_assinante invoca a função cadastrar do modulo Assinante,\n
    onde foram implementados as regras para cadastro.

  - Caso o numero já exista ele exibira uma mensagem de erro\n
    `{:error, "Assinante/Número já cadastrado"}`

  ## Exemplo
      iex> Telefonia.cadastrar_assinante("Edilberto", "123", "123", :pospago)
      {:ok, "Assinante Edilberto, cadastrado com sucesso"}
  """
  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end
end
