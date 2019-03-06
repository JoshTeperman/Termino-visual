
# DEPENDENCIES -->

require 'csv'
require 'curses'
require 'descriptive_statistics'
include Curses

# CLASSES --> 

class Scatterplot

    attr_reader :transformed_data, :x_scale, :y_scale

    def initialize(data, screen_width, screen_height)
        @raw_data = data
        @screen_width = screen_width
        @screen_height = screen_height
        @x_values = get_variable_values(0)
        @y_values = get_variable_values(1)
        @x_scale = axis_numbers(@x_values).reverse
        @y_scale = axis_numbers(@y_values).reverse
        @transformed_data = produce_array_of_coordinates(@x_values, @y_values)
    end

    def produce_array_of_coordinates(variable_arr1, variable_arr2)
    # This method takes in two arrays, each of a particular data set (temperature, month etc)
    # It outputs an array with many two-index arrays composed of an X and a Y value.
    # These correspond to single observations to be plotted.
        variable_arr1 = scale_to_user_screen_size(variable_arr1, @screen_width)
        variable_arr2 = scale_to_user_screen_size(variable_arr2, @screen_height)
        return variable_arr1.zip(variable_arr2)
    end

    def get_variable_values(variable)
    # Takes an index to extract either 0th, 1st, column from raw_data
        variable_array = []
        @raw_data.each do |row|
            variable_array << row[variable]
        end
        return variable_array
    end

    def convert_all_values_to_floats(array)
    # Converts all values in an array to floats
        return array.map { |value| value.to_f }
    end

    def convert_all_values_to_integers(array)
    # Converts all values in an array to integers
        return array.map { |value| value.to_i }
    end

    def scale_to_user_screen_size(array, screen_dimension)
    # This scales an array of variable values to the size of the user screen and makes all
    # values integers so that they fit on line and column numbers.
        array = convert_all_values_to_floats(array)

        # Find the ratio between the range of the variable spread and the user's screen
        range_to_screen_ratio = screen_dimension / array.max

        # Expand variable values according to this ratio
        array = array.map do |variable_value|
            variable_value *= range_to_screen_ratio
        end
        return convert_all_values_to_integers(array)
    end

    def axis_numbers(array)
    # This function takes an array (x or y variable) and returns an array of 10 numbers that
    # are evenly spaced and which will be used to display on the screen by the Visualiser
        array = convert_all_values_to_integers(array)
        increment_between_numbers = array.range / 10
        # This takes the numbers between 1 and 10 and creates an array that takes
        # each number (1-10), multiplies it to the increment, and adds it to the
        # minimum value in the array. This gives us the numbers to be displayed
        # to screen by the Visualizer.
        return (1..10).map { |item| (array.min + (increment_between_numbers * item)).round }
    end
end

class Visualiser
    attr_reader :filename, :array_of_observations
  
    def initialize(filename, array_of_observations, x_scale=[], y_scale=[])
        @filename = filename
        @array_of_observations = array_of_observations
        @screen_height = lines()
        @screen_width = cols()
        @x_scale = x_scale
        @y_scale = y_scale
    end

    def draw_y_axis_numbers(numbers)
        increment = (@screen_height / numbers.length).round
        locations_on_axis = (1..numbers.length).map { |number| 0 + (increment * number) } 
        numbers.length.times do |number|
            setpos(locations_on_axis[number - 1], 0)
            addstr(numbers[number - 1].to_s)
        end
    end

    def draw_x_axis_numbers(numbers)
        increment = (@screen_width / numbers.length).round
        locations_on_axis = (1..numbers.length).map { |number| 0 + (increment * number) }
        numbers.length.times do |number|
            setpos(@screen_height - 5, locations_on_axis[number - 1])
            addstr(numbers[number - 1].to_s)
        end
    end

    def draw_x_axis(screen_width, y_midpoint)
        #input -> receives screen width from Curses.init_screen call 
        #output -> draw spaced numbers to screen

        # draw a vertical line from x = 0 to x = stdscr.width, centered on y axis
        screen_width.times do |x_position| 
            setpos(y_midpoint, x_position)
            addstr("-")
        end
    end

    def draw_y_axis(screen_height, x_midpoint)
        #input -> receives screen width from Curses.init_screen call
        #output -> draw spaced numbers to screen

        # draw a vertical line from y = 0 to y = stdscr.height, centered on x axis
        screen_height.times do |y_position|  
            setpos(y_position, x_midpoint)
            addstr("|")
        end
    end

    def draw_scatterplot()
        #Input -> array of obersvations
        #Output -> iterate through array_of_observations and print each one to screen using draw_single_observation method

        init_screen() #initialises curses library 
        x_midpoint = cols() / 2 # save coordinate of midpoint of x axis
        y_midpoint = lines() / 2 # save coordinate of midpoint of y axis

        curs_set(0) # Make cursor invisible.

        draw_x_axis(@screen_width, @screen_height - 1)
        draw_y_axis(@screen_height, 0)
        draw_file_name_to_screen(format_filename_for_printing(@filename), x_midpoint)

        @array_of_observations.each do |observation|
            draw_single_observation(observation)
        end
    
        draw_y_axis_numbers(@y_scale)
        months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        draw_x_axis_numbers(months)
        
        refresh()
        getch()
        close_screen()
    end

    def draw_single_observation(array_of_coordinate_pair)
        #Input -> single pair of coordinates contained in an array
        #Output -> use curse methods to print coordinate to screen
        x_coordinate = array_of_coordinate_pair[0]
        y_coordinate = array_of_coordinate_pair[1]
        setpos(@screen_height - y_coordinate, x_coordinate)
        addch("*")   
    end

    def format_filename_for_printing(filename)
        #Input -> *.csv filename 
        #Output -> filname concatenated to a new string with spaces
        formatted_filename = filename.delete(".csv")
        if formatted_filename.include?("_")
            split_string = formatted_filename.split("_")
            return split_string.join(" ")
        else
            return formatted_filename
        end
        
    end

    def draw_file_name_to_screen(formatted_filename, x_midpoint)
        #Input -> Formatted filename ready for printing
        #Output -> Curses draw commands
        x_coordinate = x_midpoint - (formatted_filename.length / 2)
        setpos(@screen_height - 3, x_coordinate)
        addstr(formatted_filename)
    end
end

# HELPER METHODS -->

def is_file_formatted_correctly?(csv_data)
# checks is the CSV file is formatted to 2 columns only
    csv_data.each do |row|
        return row.length == 2
    end
end

def single_argument_specified?()
    # ARGV returns any input to the command line after the filename is called
    # This method returns true if there is a single argument passed at CL
        ARGV.length == 1
            return true
        end
        return false
    end
    
def file_is_CSV?()
# Checks if the first argument passed at CL is "*.csv"
    if ARGV[0].strip.match(/\w+\.csv$/)
        return true
    end
    return false
end

def main()
    # Error check the command line input when starting the program --> 

    # Check if a single .csv file is passed as single argument
    # If so save it to variable 'filename', else show user correct format for starting the program.
    if single_argument_specified?() && file_is_CSV?()
        filename = ARGV[0].strip()
    else
        puts "Usage: 'ruby termino-visual.rb *.csv'"
        abort
    end

    # If the file cannot be found then alert the user to check for spelling
    if !File.exist?(filename)
        puts "That file does not exist at the specified path. Please check for spelling errors."
        abort
    end

    # Take the file specified by the user and give it to the Scatterplot
    csv_text = File.read(filename)
    csv_data = CSV.parse(csv_text)

    if !is_file_formatted_correctly?(csv_data)
        puts "File not formatted correctly. Termino v0.1 only supports CSV files formatted to 2 columns."
        abort
    end

    init_screen()
    screen_height = lines()
    screen_width = cols()
    close_screen()

    scatter = Scatterplot.new(csv_data, screen_width, screen_height)
    # binding.pry
    scatter_data = scatter.transformed_data()

    drawn_graph = Visualiser.new(filename, scatter_data, [], scatter.y_scale)
    # binding.pry
    drawn_graph.draw_scatterplot()
end

# RUN PROGRAM -->

main()
