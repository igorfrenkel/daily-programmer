def parse_words_with_snake_case words
  words.map { |word| word.downcase }
    .join("_")
end

def parse_words_with_upcase_snake_case words
  words.map { |word| word.upcase }
    .join("_")
end

def parse_words_with_camel_case words
  words = words.map { |word| word.downcase }
  words = [words[0]] + words[1..-1].map { |chars| chars[0].upcase + chars[1..-1] }
  words.join("")
end

def parse_input_file file
  output = []
  File.open(file).each do |line| 
    line.strip!
    output << line unless line.length == 0
  end

  result = []
  while output.length > 0 
    result << output.slice!(0,2) 
  end
  result
end

def process_input_file file
  data = parse_input_file(file)
  data.map do |pair| 
    words = pair[1].split(" ")
    type = pair[0]
    output = nil
    case type
    when "0"
      output = parse_words_with_camel_case(words)
    when "1"
      output = parse_words_with_snake_case(words)
    when "2"
      output = parse_words_with_upcase_snake_case(words)
    end
    [type, output]
  end
end
