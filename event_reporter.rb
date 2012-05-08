require 'csv'

class EventReporter
	INVALID_ZIPCODE = "00000"
	
	def initialize
		#put code here
	end

	def open_prompt
		@mega_array = []
		puts "Welcome to the Event Reporter command line."
		command = ""
		while command != "quit"
			printf("Enter command here:")
			input = gets.chomp
			sections = input.split(" ")
			#can I combine the two above lines into one?
			command = sections[0]
			case command
				when "quit" then puts "Goodbye"
			
				when "help"
					help_question = sections[1]
					case help_question
						when nil
							puts "The available commands are:\n\n"
							puts "load <filename>\nhelp\nhelp <command_name>\n"
							puts "queue count\nqueue clear\nqueue print\n"
							puts "queue print by <attribute>\nqueue save to <filename.csv>\n"
							puts "find <attribute> <criteria>\n\n"
							puts "You can enter 'help <command_name>' for details.\n\n"
					end
			
				when "load"
					if sections[2] != nil
						puts "Remember, you're only supposed to put in the command and the filename."
					elsif sections[1].nil?
						loads('event_attendees')
					else
						loads(sections[1])
					end
			
				when "queue"
					if sections[1] == "clear"
						@mega_array = []
				 	elsif sections[1] == "count"
						puts @mega_array
						puts @mega_array.length
				 	elsif sections[1] == "print"
						if sections[2] == "by"
				 			#put code here
						else puts @mega_array
				 		end
				 	elsif sections[1] == "count"
				 		#put code here
				 	else puts "Queue by itself doesn't do anything. You need an additional command word.
				 		Type 'help' into the command prompt to see more."
				 	end
			
				when "find" then find(sections[1], sections[2])
			
				else
					puts "Sorry, I don't know how to do #{command}. Enter 'help' to see what I can do."
			end
		end

	end

#-------------- Find -------------

	def find(attribute, value)
		@mega_array = []
		@clean_file.each do |line|
			if line[attribute.to_sym] == value
				@mega_array << line
			end
		end
		puts @mega_array
	end

#------------ Load and subprocesses ---------

	def loads(filename)
		#need to add something for removing and re-adding .csv to end
		@file = CSV.open(filename+".csv", {:headers => true, :header_converters => :symbol})
		puts "Raw file loaded."
		output_data(filename+"_clean.csv")
		puts "Clean file created."
		@clean_file = CSV.open(filename+"_clean.csv", {:headers => true, :header_converters => :symbol})
		puts "Clean file loaded."
	end

  def output_data(filename)
    output = CSV.open(filename, "w")
    @file.each do |line|
    	if @file.lineno == 2
    		output << line.headers
     	end
      line[:homephone] = clean_number(line[:homephone])
      line[:zipcode] = clean_zipcode(line[:zipcode])
      output << line
    end
  end

	def clean_number(original)
		number = original.delete("-.() ")

		if number.length == 10
		  return number #I think this saves a small small amount of time here
		elsif number.length == 11
		  if number.start_with?("1")
		    number = number[1..-1]
		  else
		    number = "0000000000"
		  end
		else
		  number = "0000000000"
		end
#		return number 
#      ^this had been here, but I put it under if number.length == 10, since that
# seems like it would save a teeny little bit of time
	end

	def clean_zipcode(original)
		if original.nil?
			zipcode = INVALID_ZIPCODE
		elsif original.length < 5
			zipcode = original
			while zipcode.length < 5
				zipcode = "0" + zipcode
			end
			return zipcode	
		else
			zipcode = original
		end
	end

# ------ /Load and subprocesses ------

# -------- Queue managment -----------

end

reporter = EventReporter.new
reporter.open_prompt