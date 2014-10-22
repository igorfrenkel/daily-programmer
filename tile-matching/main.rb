NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

class Tile
  attr_accessor :orientation, :colours
  @@orientations = {0 => "N", 1 => "E", 2 => "S", 3 => "W"}
  def initialize north, east, south, west
    @colours = []
    @colours[0] = north
    @colours[1] = east
    @colours[2] = south
    @colours[3] = west
    @orientation = NORTH
  end

  # rotate 90 deg clockwise
  def rotate!
    tmp = []
    tmp[0] = @colours[3]
    tmp[1] = @colours[0]
    tmp[2] = @colours[1]
    tmp[3] = @colours[2]
    @colours = tmp
    @orientation = (@orientation-1) % 4
  end

  def orientation
    @@orientations[@orientation]
  end

  def colour_at orientation
    @colours[orientation]
  end

  def to_s
    return colours.join("") + "<#{orientation}>"
  end
end

class Puzzle
  attr_accessor :tiles, :dimensions, :grid
  @@opposites = {"C" => "c", "c" => "C", "Y" => "y", "y" => "Y", "M" => "m", "m" => "M", "K" => "k", "k" => "K"}
  def initialize tiles, dimensions
    @tiles = tiles
    @dimensions = dimensions
    @grid = []
  end

  def opposite_colour_of colour
    @@opposites[colour]
  end

  def opposite_orientation_of orientation
    case orientation
    when EAST
      WEST
    when WEST
      EAST
    when SOUTH
      NORTH
    when NORTH
      SOUTH
    end
  end

  def turn_to_match tile, orientation, candidate
    colour = tile.colour_at(orientation)
    candidate_colour = opposite_colour_of(colour)
    puts "tile #{tile}, cand: #{candidate}, or: #{orientation}"
    raise "Invalid candidate supplied!" if !candidate.colours.include?(candidate_colour)
    candidate_orientation = opposite_orientation_of(orientation)
    while candidate.colour_at(candidate_orientation) != candidate_colour
      candidate.rotate!
    end
  end

  def to_s
    result = ""
    for i in 0..8
      result += "i: #{i+1}, t: #{@grid[i].to_s}\n"
    end
    result
  end

  def candidates_for_tile_not_in_list tile, orientation, placed_tiles
    colour = tile.colour_at(orientation)
    candidate_colour = opposite_colour_of(colour)
    result = []
    @tiles.each do |candidate|
      next if candidate == tile
      next if placed_tiles.include?(candidate)
      result << candidate if candidate.colours.include?(candidate_colour)
    end
    result
  end

  def solve
    tile_list = []
    tile_list << @tiles.first
    @grid = solve_tile_list_at_index(tile_list, @grid.count)
    puts "result:\n#{self}"
  end

  @@neighbour_graph = {
                        0 => { 1 => EAST, 3 => SOUTH },
                        1 => { 0 => WEST, 2 => EAST, 4 => SOUTH },
                        2 => { 1 => WEST, 5 => SOUTH },
                        3 => { 0 => NORTH, 4 => EAST },
                        4 => { 1 => NORTH, 5 => EAST, 7 => SOUTH, 3 => WEST },
                        5 => { 2 => NORTH, 4 => WEST, 8 => SOUTH },
                        6 => { 3 => NORTH, 7 => EAST },
                        7 => { 4 => NORTH, 8 => EAST, 6 => WEST },
                        8 => { 5 => NORTH, 7 => WEST }
                      }

  def candidates_for_tile_at_index tile_list, index
    tile = tile_list[index]
    neighbours = @@neighbour_graph[index]
    candidates = []

    5 <- [2, 4]
    # generate candidates in open direction
    candidate_orientation = nil
    neighbours.each_pair do |neighbour_index, orientation|
      next unless tile_list[neighbour_index].nil?
      candidate_orientation = orientation
      candidates = candidates_for_tile_not_in_list(tile, orientation, tile_list)
    end

    neighbours.each_pair do |neighbour_index, orientation|
      next if candidate_orientation == orientation
      next if tile_list[neighbour_index].nil?
      tile = tile_list[neighbour_index]
      neighbour_colour = tile.colour_at(orientation)
      colour_to_match = opposite_colour_of(neighbour_colour)
    end
    result
  end

  def solve_tile_list_at_index tile_list, grid_index
    return tile_list if tile_list.length == @tiles.length
    last_placed_tile = tile_list[grid_index]
    puts "1"
    candidates = candidates_for_tile_at_index(tile_list, grid_index)
    puts "2"
    result = []
    candidates.each do |candidate|
      puts "2a"
      turn_to_match(last_placed_tile, EAST, candidate)
      puts "2b"
      result = solve_tile_list_at_index(tile_list + [candidate], grid_index+1)
    end
    result
  end
end


tiles = []
tiles << Tile.new("C", "Y", "M", "k")
tiles << Tile.new("C", "m", "K", "m")
tiles << Tile.new("c", "K", "y", "M")
tiles << Tile.new("C", "k", "Y", "y")
p = Puzzle.new(tiles, 3)
p.solve
