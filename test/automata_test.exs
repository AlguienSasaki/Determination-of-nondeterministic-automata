defmodule AutomataTest do
  use ExUnit.Case
  alias Automata 

  test "determinización del autómata de la Parte 1 (Página 2)" do
    nfa_delta = %{
      {0, "a"} => [0, 1],
      {0, "b"} => [0],
      {1, "b"} => [2],
      {2, "b"} => [3]
    }
    nfa = {[0, 1, 2, 3], ["a", "b"], nfa_delta, 0, [3]}

    dfa = Automata.determinize(nfa)
    {_q_prime, _sigma, delta_prime, start_prime, f_prime} = dfa

    assert MapSet.equal?(start_prime, MapSet.new([0]))

    assert MapSet.equal?(Map.get(delta_prime, {MapSet.new([0]), "a"}), MapSet.new([0, 1]))

    for state <- f_prime do
      assert MapSet.member?(state, 3)
    end
  end
end
