defmodule TictactoeTest do
  use ExUnit.Case
  doctest Tictactoe

  test "creates empty board successfully" do
    assert Tictactoe.start_new == %Tictactoe{board: %{state: [["_","_","_"],["_","_","_"],["_","_","_"]], nextSym: nil}}
  end

  test "successfully puts an X and expects an O afterwards" do
    assert Tictactoe.put_x(Tictactoe.start_new(),0,0) == %Tictactoe{board: %{state: [["X","_","_"],["_","_","_"],["_","_","_"]], nextSym: "O"}}
  end

  test "cant put a symbol in a taken place" do
    assert Tictactoe.put_o(Tictactoe.put_x(Tictactoe.start_new(),0,0),0,0) == nil
  end

  test "full board doesnt have kids" do
    assert Tictactoe.gen_kids(%Tictactoe{board: %{state: [["X","O","O"],["O","X","X"],["X","O","O"]], nextSym: "X"}}) == nil
  end

  test "successfully generates kids" do
    assert Tictactoe.gen_kids(%Tictactoe{board: %{state: [["X","O","O"],["O","X","X"],["X","_","_"]], nextSym: "X"}}) == [%Tictactoe{board: %{state: [["X","O","O"],["O","X","X"],["X","X","_"]], nextSym: "O"}},%Tictactoe{board: %{state: [["X","O","O"],["O","X","X"],["X","_","X"]], nextSym: "O"}}]
  end
end
