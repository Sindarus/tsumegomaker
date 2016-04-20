class Group
  def initialize(id, color, first_stone_pos)
    @id = id
    @color = color
    @stones = [first_stone_pos]
  end
  def add_stone(stone_pos)
    @stones.append(stone_pos)
  end
  def get_color
    @color
  end
  def is_dead
    @liberty == 0
  end
end