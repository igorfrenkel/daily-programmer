require "./main.rb"

print "Parses the input file correctly: ", parse_input_file("input.txt") == [ ["0", "hello world"], ["1", "user id"], ["2", "map controller delegate manager"] ], "\n"
print "Works in the snake_case case: ", process_input_file("input.txt")[1] == ["1", "user_id"], "\n"
print "Works in the snake_case case: ", process_input_file("input.txt") == [ ["0", "helloWorld"], ["1", "user_id"], ["2", "MAP_CONTROLLER_DELEGATE_MANAGER"] ]
