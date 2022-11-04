defmodule AssinantesTest do
  use ExUnit.Case

  doctest Assinante

  setup do
    File.write("prepago.txt", :erlang.term_to_binary([]))
    File.write("pospago.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepago.txt")
      File.rm("pospago.txt")
    end)
  end

  describe "teste referente as regras de cadastro de assinantes" do
    test "deve retornar estrutura de assinante" do
      assert %Assinante{nome: "Teste1", numero: "1", cpf: "1", plano: :prepago}.nome == "Teste1"
    end

    test "cria uma conta prepago" do
      assert Assinante.cadastrar("Edilberto", "123", "123") ==
               {:ok, "Assinante Edilberto, cadastrado com sucesso"}
    end

    test "cria uma conta pospago" do
      assert Assinante.cadastrar("Edilberto", "123", "123", :pospago) ==
               {:ok, "Assinante Edilberto, cadastrado com sucesso"}
    end

    test "deve retornar erro dizendo que assinante já esta cadastrado" do
      Assinante.cadastrar("Edilberto", "123", "123")

      assert Assinante.cadastrar("Edilberto", "123", "123") ==
               {:error, "Assinante/Número já cadastrado"}
    end

    test "deve retornar erro quando o plano não for cadastrado" do
      assert Assinante.cadastrar("Edilberto", "123", "123", :planonaocadastrado) ==
               {:error, "Plano não cadastrado"}
    end
  end

  describe "testes responsaveis por buscar assinantes" do
    test "busca por assinante pospago" do
      Assinante.cadastrar("Edilberto", "123", "123", :pospago)

      assert Assinante.buscar_assinante("123", :pospago) == %Assinante{
               nome: "Edilberto",
               numero: "123",
               cpf: "123",
               plano: :pospago
             }
    end

    test "busca por assinante prepago" do
      Assinante.cadastrar("Edilberto", "123", "123", :prepago)

      assert Assinante.buscar_assinante("123", :prepago) == %Assinante{
               nome: "Edilberto",
               numero: "123",
               cpf: "123",
               plano: :prepago
             }
    end

    test "busca por todos os assinantes em prepago e pospago" do
      Assinante.cadastrar("Teste1", "1", "1", :prepago)
      Assinante.cadastrar("Teste2", "2", "2", :prepago)
      Assinante.cadastrar("Teste3", "3", "3", :pospago)

      assert Assinante.assinantes() == [
               %Assinante{nome: "Teste1", numero: "1", cpf: "1", plano: :prepago},
               %Assinante{nome: "Teste2", numero: "2", cpf: "2", plano: :prepago},
               %Assinante{nome: "Teste3", numero: "3", cpf: "3", plano: :pospago}
             ]
    end

    test "retorna um erro quando o plano buscado não estiver cadastrado" do
      assert Assinante.read(:naocadastrado) == {:error, "PLANO NÃO CADASTRADO"}
    end
  end
end
