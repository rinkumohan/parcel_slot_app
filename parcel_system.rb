$parcel_slot_details = []
$parcel_slots = []

class ParcelSystem
 
  class << self

      #To find whether file or interactive mode
      def initiate
        params = ARGV.first
        if is_file_mode? params  
          init_file_mode(params)
        else
          init_interactive_mode
        end
      end

      #Function to check mode
      def is_file_mode?(input=nil)
        input ? input.include?(">") : false
      end

      #To initiate file mode
      def init_file_mode input
        $mode = "file"
        give_welcome_msg
        @output_file = input.split(">")[1].strip
        clean_output_file
        File.open("input_file.txt", "r") do |f|
          f.each_line do |line|
           @array = line.split(' ')
           find_output_function_from_array
          end
        end
      end
    
      #To initiate interactive mode
      def init_interactive_mode
        $mode = "interactive"
        puts give_welcome_msg
        receive_input
      end

      #To receive input
      def receive_input
        command = STDIN.gets.strip
        @array = command.split(' ')
        find_output_function_from_array
      end

      #To print welcome message
      def give_welcome_msg
        puts "Welcome to parcel system"
        puts "------------------------"
      end

      #To find output according to the command given
      def find_output_function_from_array
        case @array[0]
        when "park"
             allocate_parcel_slot(@array[1],@array[2])
        when "create_parcel_slot_lot"
             create_parcel_slot(@array[1])
        when "leave"
             leave_parking_slot(@array[1])
        when "status"
             show_status
        when "parcel_code_for_parcels_with_weight"
             find_parcel_code_with_weight(@array[1])
        when "slot_numbers_for_parcels_with_weight"
             find_slot_number_with_weight(@array[1])
        when "slot_number_for_registration_number"
             find_slot_number_with_reg_num(@array[1])
        end
      end
     
      #To create parcel slots according to given number
      def create_parcel_slot(number)
        find_parcel_slots(number.to_i)
        @output = "created parcel slot with #{number} slots"
        puts_output_and_text_in_file
        receive_input_if_interactive
      end
     
      #To allocate slot number to parcel
      def allocate_parcel_slot(reg_no,wt)
        if !$parcel_slots .empty?
          $parcel_slot_details << [$parcel_slots.first,reg_no,wt]
          @output = "allocated slot number -- #{$parcel_slots .first}"
          find_next_slot_number
        else
          @output = "Sorry!, parcel slot is full"
        end
        puts_output_and_text_in_file
        receive_input_if_interactive
      end

      #To print status
      def show_status
        @output = "slot_number  reg_no  weight"
        puts_output_and_text_in_file
        $parcel_slot_details.each do |a|
          @output=  "  " + a[0].to_s + "           " +a[1].to_s + "    " + a[2].to_s
          puts_output_and_text_in_file
        end
       
        receive_input_if_interactive
      end

      #To leave parking slot
      def leave_parking_slot(number)
        $parcel_slot_details = $parcel_slot_details.map{|i| i if i[0].to_i != number.to_i}.compact
        $parcel_slots << number
        @output = "slot number #{number} is free"
        puts_output_and_text_in_file
        receive_input_if_interactive
      end
    
      #To find next slot number
      def find_next_slot_number
        $parcel_slots.shift
      end
   
      #To find parcel slots array
      def find_parcel_slots(number)
        current_slot = 1
        $max_slots = number
        $parcel_slots  << current_slot
        (number - 1).times do
          next_slot = (current_slot <= $max_slots/2) ? ($max_slots - current_slot + 1) : ($max_slots - current_slot + 2)
        $parcel_slots  << next_slot
        current_slot = next_slot
        end
      end
   
      #Finds parcel codes with given weight
      def find_parcel_code_with_weight(weight)
        parcel_code = $parcel_slot_details.map{|i| i[1] if i[2] == weight}.compact
        display_output(parcel_code)
      end
     
      #Finds parcel slots with given weight
      def find_slot_number_with_weight(weight)
        slot_num = $parcel_slot_details.map{|i| i[0] if i[2] == weight}.compact
        display_output(slot_num)
      end
   
      #Finds parcel slots with given Register number
      def find_slot_number_with_reg_num(number)
        reg_num = $parcel_slot_details.map{|i| i[0] if i[1] == number}.compact
        display_output(reg_num)
      end
   
      #Method to display output
      def display_output(array)
        if array.empty?
           @output = "No record found"
        else
           @output = array.join(', ')
        end
        puts_output_and_text_in_file
        receive_input_if_interactive
      end
     
      #To receive input if the mode is interactive
      def receive_input_if_interactive
        receive_input if $mode == "interactive"
      end
   
      #Function to create output file
      def create_output_file
        File.open("#{@output_file}", "a+") do |f|
          f.puts @output
        end
      end

      #Truncate output file before write
      def clean_output_file
        file = File.open("#{@output_file}", "a+")
        file.truncate(0)
      end
     
      #To text output in file
      def text_output_if_file
        create_output_file if $mode == "file"
      end
     
      #To print output and text in file
      def puts_output_and_text_in_file
        puts @output
        text_output_if_file
      end
   
   end
end

