require './main.rb'

print "Solves snake case: ", parse_words_with_snake_case(["hello", "world"]) == "hello_world", "\n"
print "Solves snake case with caps: ", parse_words_with_snake_case(["Hello", "world"]) == "hello_world", "\n"
print "Solves upcase case: ", parse_words_with_upcase_snake_case(["Hello", "world"]) == "HELLO_WORLD", "\n"
print "Solves camsel case: ", parse_words_with_camel_case(["Hello", "World", "Third"]) == "helloWorldThird", "\n"
