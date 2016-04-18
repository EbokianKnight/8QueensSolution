class Queens
  attr_reader :board, :diagonals, :col

  def initialize(size)
    @board = Array.new(size) { |i| Array.new(size) { |j| [i,j] }}
    @size = size
    @col = 0
    make_diagonals
  end

  def render
    @board.each { |row| p row }
  end

  def [](*pos)
    row, col = pos
    @board[row][col]
  end

  def []=(*pos, mark)
    row, col = pos
    @board[row][col] = mark
  end

  def set_queens
    until @col == @size
      pos = place_queen
      unless pos.is_a? Integer
        unless row_dupe_queens? || col_dupe_queens? || diag_dupe_queens?
          @col += 1
        end
      end
    end
    render
  end

  def place_queen
    row = find_queen
    if row
      self[row, @col] = [row, @col]
      return @col -= 1 if row + 1 == @size
      self[row + 1, @col] = :queen
      [row + 1, @col]
    else
      self[0, @col] = :queen
      [0, @col]
    end
  end

  def find_queen
    @board.each_index do |row|
      return row if self[row, @col] == :queen
    end
    nil
  end

  def make_diagonals
    diagonals = []
    @board.first.each do |pos|
      diagonals << right_down_diagonal(pos)
      diagonals << left_down_diagonal(pos)
    end

    @board.transpose.first.each do |pos|
      diagonals << right_down_diagonal(pos)
    end

    @board.transpose.last.each do |pos|
      diagonals << left_down_diagonal(pos)
    end
    @diagonals = diagonals.uniq
  end

  def row_dupe_queens?
    @board.any? { |row| row.count(:queen) > 1 }
  end

  def col_dupe_queens?
    @board.transpose.any? { |col| col.count(:queen) > 1 }
  end

  def diag_dupe_queens?
    @diagonals.any? do |diag|
      temp_diag = diag.map { |pos| pos = self[pos[0], pos[1]] }
      temp_diag.count(:queen) > 1
    end
  end

  def right_down_diagonal(edge_pos)
    diagonal = [edge_pos]
    until diagonal.last.any? { |el| el >= @size.pred }
      diagonal << [diagonal.last[0] + 1, diagonal.last[1] + 1]
    end
    diagonal
  end

  def left_down_diagonal(edge_pos)
    diagonal = [edge_pos]
    until diagonal.last[0] >= @size.pred || diagonal.last[1] < 1
      diagonal << [diagonal.last[0] + 1, diagonal.last[1] - 1]
    end
    diagonal
  end

end

if __FILE__ == $PROGRAM_NAME
  q = Queens.new(8)
  q.set_queens
end
