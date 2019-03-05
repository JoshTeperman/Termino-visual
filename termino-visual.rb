
require 'csv'
require 'curses'
require 'descriptive_statistics'

def single_argument_specified?()
# Checks if there is a single argument passed at CL
    if ARGV.length == 1
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

class Scatterplot

    attr_reader :transformed_data

    def initialize(data, screen_width, screen_height)
        @raw_data = data
        @screen_width = screen_width
        @screen_height = screen_height
        @x_values = get_variable_values(0)
        @y_values = get_variable_values(1)
        @transformed_data = produce_array_of_coordinates(@x_values, @y_values)
        
    end

    def produce_array_of_coordinates(variable_arr1, variable_arr2)
    # This method takes in two arrays
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
end

def main()
    # Check if a single .csv file is passed as single argument
    # If so save it as a filename, else show user correct usage
    if single_argument_specified?() && file_is_CSV?()
        filename = ARGV[0].strip
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

    Curses.init_screen
    screen_height = Curses.lines
    screen_width = Curses.cols
    Curses.close_screen

    scatter = Scatterplot.new(csv_data, screen_width, screen_height)
    scatter_data = scatter.transformed_data

    drawn_graph = Visualiser.new(scatter_data)
    drawn_graph.draw_scatterplot
end


class Visualiser
    # include 'Curses'

    attr_reader :array_of_observations

    def initialize(array_of_observations)
        @array_of_observations = array_of_observations
        @screen_height = Curses.lines
        @screen_width = Curses.cols
    end

    def draw_x_axis(screen_width, y_midpoint)
        #input -> receives screen width from Curses.init_screen call 
        #output -> draw x axis to screen

        # draw a vertical line from x = 0 to x = stdscr.width, centered on y axis
        screen_width.times do |x_position| 
            Curses.setpos(y_midpoint, x_position)
            Curses.addstr("-")
        end
    end

    def draw_y_axis(screen_height, x_midpoint)
        #input -> receives screen width from Curses.init_screen call
        #output -> draw y axis to screen

        # draw a vertical line from y = 0 to y = stdscr.height, centered on x axis
        screen_height.times do |y_position|  
            Curses.setpos(y_position, x_midpoint)
            Curses.addstr("|")
        end
    end

    def draw_scatterplot()
        #Input -> array of obersvations
        #Output -> iterate through array_of_observations and print each one to screen using draw_single_observation method

        Curses.init_screen #initialises curses library 
        x_midpoint = Curses.cols / 2 # save coordinate of midpoint of x axis
        y_midpoint = Curses.lines / 2 # save coordinate of midpoint of y axis

        Curses.curs_set(0) # Make cursor invisible.

        draw_x_axis(@screen_width, @screen_height - 1)
        draw_y_axis(@screen_height, 0)

        @array_of_observations.each do |observation|
            draw_single_observation(observation)
        end
    
        Curses.refresh
        Curses.getch
        Curses.close_screen
    end

    def draw_single_observation(array_of_coordinate_pair)
        #Input -> single pair of coordinates contained in an array
        #Output -> use curse methods to print coordinate to screen
        x_coordinate = array_of_coordinate_pair[0]
        y_coordinate = array_of_coordinate_pair[1]
        Curses.setpos(@screen_height - y_coordinate, @screen_width - x_coordinate)
        Curses.addch("*")   
    end


end

main()
