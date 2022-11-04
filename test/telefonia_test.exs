defmodule TelefoniaTest do
  use ExUnit.Case
  doctest Telefonia

  describe "cria os arquivos .txt onde são armazenado a lista de clientes" do
    test "cria os arquivos .txt" do
      assert Telefonia.start() == :ok
    end
  end

  describe "teste referente as regras de cadastro de assinantes" do
    test "deve retornar estrutura de assinante" do
      Telefonia.start()

      assert Telefonia.cadastrar_assinante("Teste1", "1", "1", :prepago) ==
               {:ok, "Assinante Teste1, cadastrado com sucesso"}
    end
  end
end
