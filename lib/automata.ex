defmodule Automata do
  @doc """
  Implement the determinize/1 function, which receives the input non-deterministic finite automaton as a parameter and returns the newly calculated deterministic finite automaton. You are free to choose the representation you consider most appropriate for the automaton (e.g., map, tuple, etc.).
  """
  def determinize({_q, sigma, delta, q0, f}) do
    initial_state = MapSet.new([q0]) 
    
    {new_delta, all_states} = build_dfa_transitions([initial_state], MapSet.new([initial_state]), %{}, delta, sigma)
    
    new_q = MapSet.to_list(all_states)
    
    final_states = Enum.filter(new_q, fn r -> 
      not MapSet.disjoint?(r, MapSet.new(f)) 
    end) 

    {new_q, sigma, new_delta, initial_state, final_states}
  end

  defp build_dfa_transitions([], all_states, dfa_delta, _nfa_delta, _sigma), do: {dfa_delta, all_states}

  defp build_dfa_transitions([current_r | rest], all_states, dfa_delta, nfa_delta, sigma) do
    {updated_delta, new_to_explore, updated_all_states} = 
      Enum.reduce(sigma, {dfa_delta, [], all_states}, fn symbol, {acc_delta, acc_explore, acc_all} ->
        
        next_r = 
          current_r
          |> Enum.flat_map(fn q -> Map.get(nfa_delta, {q, symbol}, []) end)
          |> MapSet.new()

        if MapSet.size(next_r) > 0 do
          new_acc_delta = Map.put(acc_delta, {current_r, symbol}, next_r)
          
          if MapSet.member?(acc_all, next_r) do
            {new_acc_delta, acc_explore, acc_all}
          else
            {new_acc_delta, [next_r | acc_explore], MapSet.put(acc_all, next_r)}
          end
        else
          {acc_delta, acc_explore, acc_all}
        end
      end)

    build_dfa_transitions(rest ++ new_to_explore, updated_all_states, updated_delta, nfa_delta, sigma)
  end

  ## Parte 2 :b
  @doc """
  """
  def e_closure(automata, r) do
    {_q, _sigma, delta, _q0, _f} = automata
    
    do_e_closure(MapSet.to_list(r), r, delta)
  end
  
  defp do_e_closure([], visited, _delta), do: visited
  
  defp do_e_closure([current | rest], visited, delta) do
    eps_transitions = Map.get(delta, {current, :epsilon}, [])
  
    new_states = Enum.filter(eps_transitions, fn s -> not MapSet.member?(visited, s) end)
  

    new_visited = Enum.reduce(new_states, visited, fn s, acc -> MapSet.put(acc, s) end)
  

    do_e_closure(new_states ++ rest, new_visited, delta)
  end

end

