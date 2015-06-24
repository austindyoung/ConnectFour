require_relative 'human_player'
require_relative 'board'

class Game
  attr_accessor :num_rows, :num_cols, :player_one, :player_two, :board, :current_player

  def initialize(num_rows = 6, num_cols = 7)
    @num_rows = num_rows
    @num_cols = num_cols
    @player_one = HumanPlayer.new("b")
    @player_two = HumanPlayer.new("r")
    @board = Board.new
    @current_player = self.player_one
  end

  def valid_input?(input)
      if !input.match(/\A\d+\Z/)
        puts "Invalid Syntax"
        return false
      else
        col = parse(input)
        if !(0...num_cols).include?(col)
          puts "Column index must be in the range 0 to #{num_cols}"
          return false
        elsif self.board.is_full?(col)
          puts "Column #{col} is full."
          return false
        end
      end

      true
  end


  def get_col
    input = nil

    until input && valid_input?(input)
      prompt
      input = gets.chomp
    end

    parse(input)
  end

  def prompt
    puts "Please enter the column you want to put your #{self.current_player.color} disk"
    print "> "
  end

  def parse(string)
    string.to_i
  end

  def play
    play_turn until board.over?
    puts "Congratulations, #{board.winner_is} wins!"
  end

  def play_turn
    board.render
    col = get_col
    drop_disc(col)
    switch_player
  end

  def switch_player
    self.current_player = (self.current_player == self.player_one ? self.player_two : self.player_one)
  end

  def drop_disc(col)
    board.drop_disc(col, Disc.new(current_player.color))
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
