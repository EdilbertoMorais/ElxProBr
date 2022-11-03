defmodule Telefonia do
  def start do
    File.write("prepago.txt", :erlang.term_to_binary([]))
    File.write("pospago.txt", :erlang.term_to_binary([]))
  end

  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end
end
