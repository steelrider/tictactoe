defmodule Tictactoe do
    defstruct board: %{state: nil ,nextSym: nil}

    def start_new(), do: %Tictactoe{board: %{state: [["_","_","_"],["_","_","_"],["_","_","_"]], nextSym: nil}}

    def print_board(game), do: print_helper(game.board.state)

    def print_helper([]), do: IO.puts ""
    def print_helper([row|rows]) do
      IO.inspect row
      IO.puts "\n"
      print_helper(rows)
    end

    def put_x_helper(game,row,col,"_"), do: %Tictactoe{board: %{state: List.replace_at(game.board.state,row,List.replace_at(get_elem(game.board.state,row),col,"X")), nextSym: "O"}}
    def put_x_helper(game,row,col,"X") do
      IO.puts "invalid move,try again"
      user_move(game)
    end
    def put_x_helper(game,row,col,"O") do
      IO.puts "invalid move,try again"
      user_move(game)
    end
    def put_x(game,row,col), do: put_x_helper(game,row,col,get_elem(get_elem(game.board.state,row),col))

    def put_o_helper(game,row,col,"_"), do: %Tictactoe{board: %{state: List.replace_at(game.board.state,row,List.replace_at(get_elem(game.board.state,row),col,"O")), nexySym: "X"}}
    def put_o_helper(game,row,col,"X") do
      IO.puts "invalid move,try again"
      user_move(game)
    end
    def put_o_helper(game,row,col,"O") do
      IO.puts "invalid move,try again"
      user_move(game)
    end
    def put_o(game,row,col), do: put_o_helper(game,row,col,get_elem(get_elem(game.board.state,row),col))

    def user_move(game) do
      row = IO.gets "enter row: "
      col = IO.gets "enter column: "
      IO.puts "enter symbol: "
      sym = String.slice(IO.read(:line),0,1)
      {row,_} = Integer.parse(row)
      {col,_} = Integer.parse(col)
      case sym do
        "X" -> put_x(game,row,col)
        "O" -> put_o(game,row,col)
      end
    end

    def xwins([["X","_","_"],["X","_","_"],["X","_","_"]]), do: true
    def xwins([["_","X","_"],["_","X","_"],["_","X","_"]]), do: true
    def xwins([["_","_","X"],["_","_","X"],["_","_","X"]]), do: true
    def xwins([["X","_","_"],["_","X","_"],["_","_","X"]]), do: true
    def xwins([["_","_","X"],["_","X","_"],["X","_","_"]]), do: true
    def xwins(_), do: false

    def owins([["O","_","_"],["O","_","_"],["O","_","_"]]), do: true
    def owins([["_","O","_"],["_","O","_"],["_","O","_"]]), do: true
    def owins([["_","_","O"],["_","_","O"],["_","_","O"]]), do: true
    def owins([["O","_","_"],["_","O","_"],["_","_","O"]]), do: true
    def owins([["_","_","O"],["_","O","_"],["O","_","_"]]), do: true
    def owins(_), do: false

    


  # помощна
  
  def get_elem_helper([first|rest],idx,current) when idx == current, do: first
  def get_elem_helper([first|rest],idx,current) when idx != current, do: get_elem_helper(rest,idx,current+1)
  def get_elem(list,idx), do: get_elem_helper(list,idx,0)
end
