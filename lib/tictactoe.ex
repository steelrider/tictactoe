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
    def put_x_helper(_,_,_,"X") do
      nil
    end
    def put_x_helper(_,_,_,"O") do
      nil
    end
    def put_x(game,row,col), do: put_x_helper(game,row,col,get_elem(get_elem(game.board.state,row),col))
    #####
    def put_o_helper(game,row,col,"_"), do: %Tictactoe{board: %{state: List.replace_at(game.board.state,row,List.replace_at(get_elem(game.board.state,row),col,"O")), nextSym: "X"}}
    def put_o_helper(_,_,_,"X") do
      nil
    end
    def put_o_helper(_,_,_,"O") do
      nil
    end
    def put_o(game,row,col), do: put_o_helper(game,row,col,get_elem(get_elem(game.board.state,row),col))

    def has_kids(game), do: Enum.member?(List.flatten(game.board.state),"_")


    def gen_kids_helper(_,_,false), do: IO.puts "here"

    def gen_kids_helper(game,"X",true) do
    Enum.filter(List.flatten(
      for i <- 0..2 do
        for j <- 0..2 do
          put_x(game,i,j)
        end
      end), fn(x) -> x != nil end)
    end

    def gen_kids_helper(game,"O",true) do
    Enum.filter(List.flatten(
      for i <- 0..2 do
        for j <- 0..2 do
          put_o(game,i,j)
        end
      end), fn(x) -> x != nil end)
    end

    def gen_kids(game), do: gen_kids_helper(game,game.board.nextSym,has_kids(game))

    def xwins([["X","X","X"],[_,_,_],[_,_,_]]), do: true
    def xwins([[_,_,_],["X","X","X"],[_,_,_]]), do: true
    def xwins([[_,_,_],[_,_,_],["X","X","X"]]), do: true
    def xwins([["X",_,_],["X",_,_],["X",_,_]]), do: true
    def xwins([[_,"X",_],[_,"X",_],[_,"X",_]]), do: true
    def xwins([[_,_,"X"],[_,_,"X"],[_,_,"X"]]), do: true
    def xwins([["X",_,_],[_,"X",_],[_,_,"X"]]), do: true
    def xwins([[_,_,"X"],[_,"X",_],["X",_,_]]), do: true
    def xwins(_), do: false

    def owins([["O","O","O"],[_,_,_],[_,_,_]]), do: true
    def owins([[_,_,_],["O","O","O"],[_,_,_]]), do: true
    def owins([[_,_,_],[_,_,_],["O","O","O"]]), do: true
    def owins([["O",_,_],["O",_,_],["O",_,_]]), do: true
    def owins([[_,"O",_],[_,"O",_],[_,"O",_]]), do: true
    def owins([[_,_,"O"],[_,_,"O"],[_,_,"O"]]), do: true
    def owins([["O",_,_],[_,"O",_],[_,_,"O"]]), do: true
    def owins([[_,_,"O"],[_,"O",_],["O",_,_]]), do: true
    def owins(_), do: false

    def draw(game), do: !xwins(game.board.state) and !owins(game.board.state) and !has_kids(game)

    def minimax(_,_,_,_,_,true,_,_), do: 1
    def minimax(_,_,_,_,_,_,true,_), do: -1
    def minimax(_,0,_,_,_,_,_,_), do: 0
    def minimax(_,_,_,_,_,_,_,true), do: 0

    def minimax(game,depth,a,b,maxPlayer,_,_,_) do
      case maxPlayer do
        true -> 
               v = -1000000000000000000000
               kids = gen_kids(game)
               max_eval(kids,0,depth,a,b,v)
        false -> 
               v = 1000000000000000000000
               kids = gen_kids(game)
               min_eval(kids,0,depth,a,b,v)
      end
    end

    def eval(b,a), do: b<=a

    def max_eval(kids,idx,_,_,_,v) when length(kids) - 1 == idx, do: v
    def max_eval(kids,idx,depth,a,b,v) do
      kid = get_elem(kids,idx)
      v = max(v,minimax(kid,depth,a,b,false,xwins(kid.board.state),owins(kid.board.state),draw(kid)))
      a = max(a,v)
      case eval(b,a) do
        true -> v
        false -> max_eval(kids,idx+1,depth-1,a,b,v)
      end
    end

    def min_eval(kids,idx,_,_,_,v) when length(kids) - 1 == idx, do: v
    def min_eval(kids,idx,depth,a,b,v) do
      kid = get_elem(kids,idx)
      v = min(v,minimax(kid,depth,a,b,true,xwins(kid.board.state),owins(kid.board.state),draw(kid)))
      b = min(b,v)
      case eval(b,a) do
        true -> v
        false -> min_eval(kids,idx+1,depth-1,a,b,v)
      end
    end

  def play(game,true,_,_) do
    print_board(game)
    IO.puts "You win!"
  end
  def play(game,_,true,_) do
    print_board(game)
    IO.puts "You lose!"
  end
  def play(game,_,_,true) do
    print_board(game)
    IO.puts "Draw!"
  end
  def play(game,_,_,_) do
    IO.puts "you play with X, good luck!"
    print_board(game)
    rRow = IO.gets "enter row: "
    rCol = IO.gets "enter col: "
    {row, _} = Integer.parse(String.slice(rRow,0,1))
    {col, _} = Integer.parse(String.slice(rCol,0,1))
    row = row - 1
    col = col - 1
    game = put_x(game,row,col)
    print_board(game)
    case xwins(game.board.state) do
      true -> IO.puts "You win!"
      false -> case draw(game) do
        true -> IO.puts "Draw!"
        false -> kids = gen_kids(game)
                 bestKids = populateBest(kids,0,[])
                 mediocreKids = populateMediocre(kids,0,[])
                 len = length(bestKids)
                 game = case len do
                     0 -> get_elem(mediocreKids,Enum.random(0..length(mediocreKids)-1)) 
                     _ -> get_elem(bestKids,Enum.random(0..len-1))
                 end
                 play(game,xwins(game.board.state),owins(game.board.state),draw(game))
      end
    end
  end

  def populateBest(kids,idx,bestKids) when length(kids) == idx, do: bestKids
  def populateBest(kids,idx,bestKids) do
    kid = get_elem(kids,idx)
    value = minimax(kid,10000,-1000000000000000000000,1000000000000000000000,true,xwins(kid.board.state),owins(kid.board.state),draw(kid))
    case value do
      -1 -> populateBest(kids,idx+1,[kid|bestKids])
       _ -> populateBest(kids,idx+1,bestKids)
    end
  end

  def populateMediocre(kids,idx,mediocreKids) when length(kids) == idx, do: mediocreKids
  def populateMediocre(kids,idx,mediocreKids) do
    kid = get_elem(kids,idx)
    value = minimax(kid,10000,-1000000000000000000000,1000000000000000000000,true,xwins(kid.board.state),owins(kid.board.state),draw(kid))
    case value do
       0 -> populateMediocre(kids,idx+1,[kid|mediocreKids])
       _ -> populateMediocre(kids,idx+1,mediocreKids)
    end
  end

  def bot(), do: play(start_new(),xwins(start_new()),owins(start_new()),draw(start_new()))

  def user_play(game) do
    IO.puts "Go player X"
    rRow = IO.gets "enter row: "
    rCol = IO.gets "enter col: "
    {row, _} = Integer.parse(String.slice(rRow,0,1))
    row = row - 1
    {col, _} = Integer.parse(String.slice(rCol,0,1))
    col = col - 1
    game = put_x(game,row,col)
    print_board(game)
    case xwins(game.board.state) do
      true -> IO.puts "X wins!"
      false -> case draw(game) do
        true -> IO.puts "Draw!"
        false -> IO.puts "Go player O"
                 rRow = IO.gets "enter row: "
                 rCol = IO.gets "enter col: "
                 {row, _} = Integer.parse(String.slice(rRow,0,1))
                 row = row - 1
                 {col, _} = Integer.parse(String.slice(rCol,0,1))
                 col = col - 1
                 game = put_o(game,row,col)
                 print_board(game)
                 case owins(game.board.state) do
                   true -> IO.puts "O wins!"
                   false -> case draw(game) do
                     true -> IO.puts "Draw"
                     false -> user_play(game)
                   end
                 end
      end
    end
  end

  def player(), do: user_play(start_new())

  # помощна
  def get_elem_helper([first|_],idx,current) when idx == current, do: first
  def get_elem_helper([_|rest],idx,current) when idx != current, do: get_elem_helper(rest,idx,current+1)
  def get_elem(list,idx), do: get_elem_helper(list,idx,0)

end
