module PuzzleSolver
  NORTH = 0
  EAST = 1
  SOUTH = 2
  WEST = 3
end

module PuzzleSolver
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
end

module PuzzleSolver
  class Puzzle
    attr_accessor :tiles, :dimensions, :grid
    @@opposites = {"C" => "c", "c" => "C", "Y" => "y", "y" => "Y", "M" => "m", "m" => "M", "K" => "k", "k" => "K"}
    def initialize tiles, dimensions
      @tiles = tiles
      @dimensions = dimensions
      @grid = []
    end

    def candidates_for tile, orientation
      colour = tile.colour_at(orientation)
      candidate_colour = opposite_colour_of(colour)
      result = []
      @tiles.each do |candidate|
        next if candidate == tile
        next if already_placed?(candidate)
        result << candidate if candidate.colours.include?(candidate_colour)
      end
      result
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

    def turn_to_match! tile, orientation, candidate
      raise "This is not a valid candidate!" if !candidates_for(tile, orientation).include?(candidate) # sanity check
      colour = tile.colour_at(orientation)
      candidate_colour = opposite_colour_of(colour)
      candidate_orientation = opposite_orientation_of(orientation)
      while candidate.colour_at(candidate_orientation) != candidate_colour
        candidate.rotate!
      end
    end

    def place_tile tile, grid_idx
      @grid[grid_idx] = tile
    end

    def already_placed? tile
      @grid.include?(tile)
    end

    def to_s
      result = ""
      for i in 0..8
        result += "i: #{i+1}, t: #{@grid[i].to_s}\n"
      end
      result
    end

    def solve 
      idx = @grid.length
      if idx > dimensions**2-1
        puts "solved!"
        puts self
      end
      if idx 
    end
  end
end

module PuzzleSolver
  def self.solve
    tiles = []
    tiles << Tile.new("C", "Y", "M", "k")
    tiles << Tile.new("C", "m", "K", "m")
    tiles << Tile.new("c", "K", "y", "M")
    tiles << Tile.new("C", "k", "Y", "y")
    p = Puzzle.new(tiles, 3)
    cands = p.candidates_for(tiles.first, EAST)
    p.turn_to_match!(tiles.first, EAST, cands.first)
    puts "grid:", p
    p.place_tile tiles.first, 0
    puts "grid:", p
    p.place_tile cands.first, 1
    cands = p.candidates_for(p.grid.last, EAST)
    p.place_tile cands.first, 2
    puts "grid:", p
    cands = p.candidates_for(p.grid.first, SOUTH)
    puts "cands:", cands
    p.place_tile cands.first, 3
    puts "grid:", p
  end
end

PuzzleSolver.solve
