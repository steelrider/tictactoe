defmodule Tictactoe do
  @moduledoc """
  this is the Tictactoe module, where you can play vs bot or vs player
  """
  @doc """
  this is the carrier of the game board
  """
  defstruct board: %{state: nil, nextSym: nil}

  @doc """
  gives us a new, empty board

  Returns `%Tictactoe{board: %{state: [["_","_","_"],["_","_","_"],["_","_","_"]], nextSym: nil}}`

  ## Examples
          iex> Tictactoe.start_new()
          %Tictactoe{board: %{state: [["_","_","_"],["_","_","_"],["_","_","_"]], nextSym: nil}}
  """
  def start_new(),
    do: %Tictactoe{
      board: %{state: [["_", "_", "_"], ["_", "_", "_"], ["_", "_", "_"]], nextSym: nil}
    }

  @doc """
  prints the board so its more visually acceptable
  """
  def print_board(game), do: print_helper(game.board.state)

  defp print_helper([]), do: IO.puts("")

  defp print_helper([row | rows]) do
    IO.inspect(row)
    IO.puts("\n")
    print_helper(rows)
  end

  defp get_elem_helper([first | _], idx, current) when idx == current, do: first

  defp get_elem_helper([_ | rest], idx, current) when idx != current,
    do: get_elem_helper(rest, idx, current + 1)

  defp get_elem(list, idx), do: get_elem_helper(list, idx, 0)

  @doc """
  puts an X symbol in the given place; returns nil if the space is already taken
  """
  def put_x(game, row, col),
    do: put_x_helper(game, row, col, get_elem(get_elem(game.board.state, row), col))

  defp put_x_helper(game, row, col, "_"),
    do: %Tictactoe{
      board: %{
        state:
          List.replace_at(
            game.board.state,
            row,
            List.replace_at(get_elem(game.board.state, row), col, "X")
          ),
        nextSym: "O"
      }
    }

  defp put_x_helper(_, _, _, "X") do
    nil
  end

  defp put_x_helper(_, _, _, "O") do
    nil
  end

  @doc """
  puts an O symbol in the given place; returns nil if the space is already taken

  ## Examples
          iex> Tictactoe.put_o(Tictactoe.start_new(),0,0)
          %Tictactoe{board: %{state: [["O","_","_"],["_","_","_"],["_","_","_"]], nextSym: "X"}}
  """
  def put_o(game, row, col),
    do: put_o_helper(game, row, col, get_elem(get_elem(game.board.state, row), col))

  defp put_o_helper(game, row, col, "_"),
    do: %Tictactoe{
      board: %{
        state:
          List.replace_at(
            game.board.state,
            row,
            List.replace_at(get_elem(game.board.state, row), col, "O")
          ),
        nextSym: "X"
      }
    }

  defp put_o_helper(_, _, _, "X") do
    nil
  end

  defp put_o_helper(_, _, _, "O") do
    nil
  end

  defp has_kids(game), do: Enum.member?(List.flatten(game.board.state), "_")

  @doc """
  generates all possible kids for a given board, but only the first generation of kids, i.e. all boards which come from adding only 1 symbol to the current board
  """
  def gen_kids(game), do: gen_kids_helper(game, game.board.nextSym, has_kids(game))

  defp gen_kids_helper(_, _, false), do: IO.puts("here")

  defp gen_kids_helper(game, "X", true) do
    Enum.filter(
      List.flatten(
        for i <- 0..2 do
          for j <- 0..2 do
            put_x(game, i, j)
          end
        end
      ),
      fn x -> x != nil end
    )
  end

  defp gen_kids_helper(game, "O", true) do
    Enum.filter(
      List.flatten(
        for i <- 0..2 do
          for j <- 0..2 do
            put_o(game, i, j)
          end
        end
      ),
      fn x -> x != nil end
    )
  end

  defp xwins([["X", "X", "X"], [_, _, _], [_, _, _]]), do: true
  defp xwins([[_, _, _], ["X", "X", "X"], [_, _, _]]), do: true
  defp xwins([[_, _, _], [_, _, _], ["X", "X", "X"]]), do: true
  defp xwins([["X", _, _], ["X", _, _], ["X", _, _]]), do: true
  defp xwins([[_, "X", _], [_, "X", _], [_, "X", _]]), do: true
  defp xwins([[_, _, "X"], [_, _, "X"], [_, _, "X"]]), do: true
  defp xwins([["X", _, _], [_, "X", _], [_, _, "X"]]), do: true
  defp xwins([[_, _, "X"], [_, "X", _], ["X", _, _]]), do: true
  defp xwins(_), do: false

  defp owins([["O", "O", "O"], [_, _, _], [_, _, _]]), do: true
  defp owins([[_, _, _], ["O", "O", "O"], [_, _, _]]), do: true
  defp owins([[_, _, _], [_, _, _], ["O", "O", "O"]]), do: true
  defp owins([["O", _, _], ["O", _, _], ["O", _, _]]), do: true
  defp owins([[_, "O", _], [_, "O", _], [_, "O", _]]), do: true
  defp owins([[_, _, "O"], [_, _, "O"], [_, _, "O"]]), do: true
  defp owins([["O", _, _], [_, "O", _], [_, _, "O"]]), do: true
  defp owins([[_, _, "O"], [_, "O", _], ["O", _, _]]), do: true
  defp owins(_), do: false

  defp draw(game), do: !xwins(game.board.state) and !owins(game.board.state) and !has_kids(game)

  # minimax algorithm with alpha/beta pruning; used to evaluate the current state's heuristic value
  defp minimax(_, _, _, _, _, true, _, _), do: 1
  defp minimax(_, _, _, _, _, _, true, _), do: -1
  defp minimax(_, 0, _, _, _, _, _, _), do: 0
  defp minimax(_, _, _, _, _, _, _, true), do: 0

  defp minimax(game, depth, a, b, maxPlayer, _, _, _) do
    case maxPlayer do
      true ->
        v = -1_000_000_000_000_000_000_000
        kids = gen_kids(game)
        max_eval(kids, 0, depth, a, b, v)

      false ->
        v = 1_000_000_000_000_000_000_000
        kids = gen_kids(game)
        min_eval(kids, 0, depth, a, b, v)
    end
  end

  defp eval(b, a), do: b <= a

  defp max_eval(kids, idx, _, _, _, v) when length(kids) == idx, do: v

  defp max_eval(kids, idx, depth, a, b, v) do
    kid = get_elem(kids, idx)

    v =
      max(
        v,
        minimax(
          kid,
          depth,
          a,
          b,
          false,
          xwins(kid.board.state),
          owins(kid.board.state),
          draw(kid)
        )
      )

    a = max(a, v)

    case eval(b, a) do
      true -> v
      false -> max_eval(kids, idx + 1, depth - 1, a, b, v)
    end
  end

  defp min_eval(kids, idx, _, _, _, v) when length(kids) == idx, do: v

  defp min_eval(kids, idx, depth, a, b, v) do
    kid = get_elem(kids, idx)

    v =
      min(
        v,
        minimax(kid, depth, a, b, true, xwins(kid.board.state), owins(kid.board.state), draw(kid))
      )

    b = min(b, v)

    case eval(b, a) do
      true -> v
      false -> min_eval(kids, idx + 1, depth - 1, a, b, v)
    end
  end

  defp play(game, true, _, _) do
    print_board(game)
    IO.puts("You win!")
  end

  defp play(game, _, true, _) do
    print_board(game)
    IO.puts("You lose!")
  end

  defp play(game, _, _, true) do
    print_board(game)
    IO.puts("Draw!")
  end

  defp play(game, _, _, _) do
    print_board(game)
    game = try_input_x(game)
    print_board(game)

    case xwins(game.board.state) do
      true ->
        IO.puts("You win!")

      false ->
        case draw(game) do
          true ->
            IO.puts("Draw!")

          false ->
            kids = gen_kids(game)
            bestKids = populateBest(kids, 0, [])
            mediocreKids = populateMediocre(kids, 0, [])
            len = length(bestKids)

            game =
              case len do
                0 -> get_elem(mediocreKids, Enum.random(0..(length(mediocreKids) - 1)))
                _ -> get_elem(bestKids, Enum.random(0..(len - 1)))
              end

            play(game, xwins(game.board.state), owins(game.board.state), draw(game))
        end
    end
  end

  defp populateBest(kids, idx, bestKids) when length(kids) == idx, do: bestKids

  defp populateBest(kids, idx, bestKids) do
    kid = get_elem(kids, idx)

    value =
      minimax(
        kid,
        10000,
        -1_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000,
        true,
        xwins(kid.board.state),
        owins(kid.board.state),
        draw(kid)
      )

    case value do
      -1 -> populateBest(kids, idx + 1, [kid | bestKids])
      _ -> populateBest(kids, idx + 1, bestKids)
    end
  end

  defp populateMediocre(kids, idx, mediocreKids) when length(kids) == idx, do: mediocreKids

  defp populateMediocre(kids, idx, mediocreKids) do
    kid = get_elem(kids, idx)

    value =
      minimax(
        kid,
        10000,
        -1_000_000_000_000_000_000_000,
        1_000_000_000_000_000_000_000,
        true,
        xwins(kid.board.state),
        owins(kid.board.state),
        draw(kid)
      )

    case value do
      0 -> populateMediocre(kids, idx + 1, [kid | mediocreKids])
      _ -> populateMediocre(kids, idx + 1, mediocreKids)
    end
  end

  @doc """
  the main function to call to play against the unbeatable bot
  this function calls all of the above functions to calculate the heuristic value of each node by generating a list of its kids and choosing the best kid to play
  """
  def bot(), do: play(start_new(), xwins(start_new()), owins(start_new()), draw(start_new()))

  defp user_play(game) do
    game = try_input_x(game)
    print_board(game)

    case xwins(game.board.state) do
      true ->
        IO.puts("X wins!")

      false ->
        case draw(game) do
          true ->
            IO.puts("Draw!")

          false ->
            game = try_input_o(game)
            print_board(game)

            case owins(game.board.state) do
              true ->
                IO.puts("O wins!")

              false ->
                case draw(game) do
                  true -> IO.puts("Draw")
                  false -> user_play(game)
                end
            end
        end
    end
  end

  defp try_input_x(game) do
    IO.puts("Go player X")
    rRow = IO.gets("enter row: ")
    rCol = IO.gets("enter col: ")
    {row, _} = Integer.parse(String.slice(rRow, 0, 1))
    row = row - 1
    {col, _} = Integer.parse(String.slice(rCol, 0, 1))
    col = col - 1

    case put_x(game, row, col) do
      nil ->
        IO.puts("invalid field, try again")
        try_input_x(game)

      _ ->
        put_x(game, row, col)
    end
  end

  defp try_input_o(game) do
    IO.puts("Go player O")
    rRow = IO.gets("enter row: ")
    rCol = IO.gets("enter col: ")
    {row, _} = Integer.parse(String.slice(rRow, 0, 1))
    row = row - 1
    {col, _} = Integer.parse(String.slice(rCol, 0, 1))
    col = col - 1

    case put_o(game, row, col) do
      nil ->
        IO.puts("invalid field, try again")
        try_input_o(game)

      _ ->
        put_o(game, row, col)
    end
  end

  @doc """
  the main function to call to play against another player by taking turns; doesnt use any algorithm, only the try_input_x and try_input_o functions, so that players cant place a symbol on an occupied space
  """
  def player(), do: user_play(start_new())
end
