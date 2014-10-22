file = "/Users/igor/learning/daily-programmer/string-transposition/stuff.in"
myFile = new File(file)

print_line = { println "File line: " + it }

lines = myFile.readLines()
num_words = lines[0].toInteger()

list_of_words = [] 
lines[1..-1].each {line -> 
    list_of_words << line.split("")[1..-1]
}

longest_word = list_of_words.inject(0, { max, next -> next.size() > max ? next.size() : max })

inverted = new Object[longest_word][list_of_words.size()]

(0..<list_of_words.size()).each{i ->
    def word = list_of_words[i]
    (0..<word.size()).each {j->
        inverted[j][i] = word[j]
    }
}

(0..<inverted.size()).each{i ->
    def word = inverted[i]
    (0..<word.size()).each {j->
        def the_char = word[j] == null ? " " : word[j]
        print "${the_char}"
    }
    println ""
}