require_relative 'disc'

class Board
  attr_accessor :num_rows, :num_cols, :grid, :sizes, :over, :status, :winner

  def initialize(num_rows = 6, num_cols = 7)
    @num_rows = num_rows
    @num_cols = num_cols
    @grid = Array.new(num_rows) { Array.new(num_cols) }
    @sizes = {}
    @status = {}
    @over = false
    @winner = nil
  end

  def over?
    self.over
  end

  def winner_is
    self.winner
  end

  def is_full?(col)
    self[0, col]
  end

  def drop_disc(col, disc)
    (1..num_rows).each do |idx|
      if idx == num_rows || self[idx, col]
        self[idx - 1, col] = disc
        update(idx - 1, col, disc)
        break
      end
    end

    render

  end

  def render
    system("clear")
    grid.each do |row|
      puts row.map { |el| el ? el.color[0] : "." }.join(" ")
    end
  end

  def update(row, col, disc)
    directions =
    {
      "horizontal" => row.to_s + ", " + col.to_s + " H",
      "vertical" => row.to_s + ", " + col.to_s + " V",
      "positive_diagonal" => row.to_s + ", " + col.to_s + " P",
      "negative_diagonal" => row.to_s + ", " + col.to_s + " N"
    }
    status[[row, col]] = directions
    directions.values.each do |value|
      self.sizes[value] = 1
    end

    neighbors(row, col).each do |pos|
      merge([row, col], pos) if same_color?([row, col], pos)
    end
  end

  def merge(original_pos, neighbor_pos)
    if original_pos[0] == neighbor_pos[0]
      merger(original_pos, neighbor_pos, "horizontal")
    elsif original_pos[1] == neighbor_pos[1]
      merger(original_pos, neighbor_pos, "vertical")
    elsif (neighbor_pos[1] - original_pos[1] == 1 && neighbor_pos[0] - original_pos[0] == 1) || (neighbor_pos[1] - original_pos[1] == -1 && neighbor_pos[0] - original_pos[0] == -1)
      merger(original_pos, neighbor_pos, "positive_diagonal")
    else
      merger(original_pos, neighbor_pos, "negative_diagonal")
    end
  end

  def merger(original_pos, neighbor_pos, axis_key)
    #sizes[original_pos].delete(axis_key)
    self.sizes[status[neighbor_pos][axis_key]] += self.sizes[status[original_pos][axis_key]]
    self.status[original_pos][axis_key] = self.status[neighbor_pos][axis_key]
    if self.sizes[status[neighbor_pos][axis_key]] == 4
      self.over = true
      self.winner = self[*original_pos].color
    end
  end

  def same_color?(original_pos, neighbor_pos)
    return false if self[*original_pos].nil? || self[*neighbor_pos].nil?
    self[*original_pos].color == self[*neighbor_pos].color
  end

  def neighbors(row, col)
    positions = []
    positions << [row-1, col]
    positions << [row+1, col]
    positions << [row, col-1]
    positions << [row, col+1]
    positions << [row-1, col-1]
    positions << [row-1, col+1]
    positions << [row+1, col-1]
    positions << [row+1, col+1]

    positions.select { |pos| (0...num_rows).include?(pos[0]) && (0...num_cols).include?(pos[1]) }
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, disc)
   grid[row][col] = disc
  end

end
