defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write("prepago.txt", :erlang.term_to_binary([]))
    File.write("pospago.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepago.txt")
      File.rm("pospago.txt")
    end)
  end

  describe "Funções de ligação" do
    test "fazer uma ligação" do
      Assinante.cadastrar("Teste1", "1", "2", :prepago)

      assert Prepago.fazer_chamada("1", DateTime.utc_now(), 3) == {:ok, "Custo da chamada 4.35"}
    end
  end
end
