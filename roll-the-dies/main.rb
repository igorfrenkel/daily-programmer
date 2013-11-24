inputs = ["2d20", "4d6"]

def parse_input input
  input.split("d").map { |char| char.to_i }
end

def roll_the_die range_of_the_die
  r = Random.new
  r.rand(range_of_the_die)+1 
end

inputs.each do |input|
  number_of_rolls, range_of_the_dice = parse_input(input)

  output = []
  Range.new(1, number_of_rolls).each do |roll|
    output << roll_the_die(range_of_the_dice)
  end

  puts output.join(" ")
end
