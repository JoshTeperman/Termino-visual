
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
        @x_values = get_variable_values(0) #value of x-axis coordinates
        @y_values = get_variable_values(1) #value of y-axis coordinates
        @x_scale = axis_numbers(@x_values).reverse #values of scale printed on x-axis
        @y_scale = axis_numbers(@y_values).reverse #values of scale printed on y-axis
        @transformed_data = produce_array_of_coordinates(@x_values, @y_values)
    end

    def produce_array_of_coordinates(variables_array_1, variables_array_2)
    # Input --> Two arrays, each containing values of a particular data set (temperature, month etc)
    # Output -->  An array with many two-index arrays composed of an x and a y value.
    # These correspond to single observations to be plotted later.
        variables_array_1 = scale_to_user_screen_size(variables_array_1, @screen_width)
        variables_array_2 = scale_to_user_screen_size(variables_array_2, @screen_height)
        return variables_array_1.zip(variables_array_2)
    end

    def get_variable_values(index)
    # Input --> Iterates through the raw_data (CSV file) 
    # Output --> Returns an array of variables at selected by index
    # Each variable will form either the x or y axis coordinate for the scatterplot
        variable_array = []
        @raw_data.each do |row|
            variable_array << row[index]
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
    # Input --> An array of variable values 
    # Output --> transformed array scaled to the size of the user screen in integers format 
    # so that they fit on line and column numbers.
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
    # Input --> An array (x or y variable)  
    # Output --> An array of 10 numbers, evenly spaced and which will be used to display on the screen by the Visualiser
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
        # Input -> List of numbers to be used for the y-axis key
        # Output -> Uses Curses to draw the keys on the y-axis 
        increment = (@screen_height / numbers.length).round
        locations_on_axis = (1..numbers.length).map { |number| 0 + (increment * number) } 
        numbers.length.times do |number|
            # Set cursor coordinate and draw a string to screen
            setpos(locations_on_axis[number - 1], 0)
            addstr(numbers[number - 1].to_s)
        end
    end

    def draw_x_axis_numbers(numbers)
        # Input -> List of numbers to be used for the x-axis key
        # Output -> Uses Curses to draw the keys on the y-axis 
        increment = (@screen_width / numbers.length).round
        locations_on_axis = (1..numbers.length).map { |number| 0 + (increment * number) }
        numbers.length.times do |number|
            # Set cursor coordinate and draw a string to screen
            setpos(@screen_height - 5, locations_on_axis[number - 1])
            addstr(numbers[number - 1].to_s)
        end
    end

    def draw_x_axis(screen_width, y_midpoint)
        # Input -> receives screen width from Curses.init_screen call 
        # Output -> draw spaced numbers to screen

        # draw a vertical line from x = 0 to x = stdscr.width, centered on y axis
        screen_width.times do |x_position| 
            setpos(y_midpoint, x_position)
            addstr("-")
        end
    end

    def draw_y_axis(screen_height, x_midpoint)
        # Input -> receives screen width from Curses.init_screen call
        # Output -> draw spaced numbers to screen

        # draw a vertical line from y = 0 to y = stdscr.height, centered on x axis
        screen_height.times do |y_position|  
            setpos(y_position, x_midpoint)
            addstr("|")
        end
    end

    def draw_scatterplot()
        # Input -> array of observations
        # Output -> iterate through array_of_observations and print each one to screen using draw_single_observation method

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
        # In this case our x-axis values are months, so we have specificed the months directly below:
        months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        draw_x_axis_numbers(months)
    end

    def draw_single_observation(array_of_coordinate_pair)
        # Input -> single pair of coordinates contained in an array
        # Output -> use curse methods to print coordinate to screen
        x_coordinate = array_of_coordinate_pair[0]
        y_coordinate = array_of_coordinate_pair[1]
        setpos(@screen_height - y_coordinate, x_coordinate)
        addch("*")   
    end

    def format_filename_for_printing(filename)
        # Input -> *.csv filename 
        # Output -> filname concatenated to a new string with spaces
        formatted_filename = filename.delete(".csv")
        if formatted_filename.include?("_")
            split_string = formatted_filename.split("_")
            return split_string.join(" ")
        else
            return formatted_filename
        end
    end

    def draw_file_name_to_screen(formatted_filename, x_midpoint)
        # Input -> Formatted filename ready for printing
        # Output -> Curses draw commands
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
    
def file_is_CSV?()
# Checks if the first argument passed at CL is "*.csv"
    if ARGV[0].strip.match(/\w+\.csv$/)
        return true
    end
    return false
end

# main() is called to run the program:
def main()
    ## Section 1: INPUT & HANDLING -->

    # Check there is only one argument passed at Command Line, and that argument is a CSV file.
    # If true, save argument to variable 'filename'.
    # Else, return error and show user correct format for starting the program and exit.
    if ARGV.length == 1 && file_is_CSV?()
        filename = ARGV[0].strip()
    else
        puts "Input Error: \nCorrect format to use Termino: 'ruby termino-visual.rb *.csv', where * == filename"
        abort
    end

    # Check the file exists at the specified path
    # If not, return error and suggest the user check for spelling errors and exit.
    if !File.exist?(filename)
        puts "PATH Error: \nThat file does not exist at the specified path. Please check for spelling errors."
        abort
    end

    # Take the file specified by the user and give it to the Scatterplot
    csv_text = File.read(filename)
    csv_data = CSV.parse(csv_text)

    # After CSV file is opened, confirm there are only two columns of data, as Termino only prints scatterplot format.
    # Future versions of Termino could allow for more columns with different graph types
    # If columns != 2, return error message and exit. 
    if !is_file_formatted_correctly?(csv_data)
        puts "CSV Format Error: \nFile not formatted correctly. Termino v0.1 only supports CSV files formatted to 2 columns."
        abort
    end

    ## Section 2: CREATE SCATTERPLOT -->

    # Initialise the Curses Module, which takes a snapshot of user Terminal screen and saves height and width
    init_screen()
    screen_height = lines()
    screen_width = cols()

    # Initialise instance of Scatterplot class
    scatter = Scatterplot.new(csv_data, screen_width, screen_height)
    # Transform CSV data and save coordinates in variable scatter_data, ready for printing to screen
    scatter_data = scatter.transformed_data

    ## Section 3: VISUALISE SCATTERPLOT ON TERMINAL -->

    # Initialise instance of Visualiser class with data to be printed to screen
    # Note - x_scale in this case is left as an empty array because we are using month-names rather than integers
    new_visualisation = Visualiser.new(filename, scatter_data, [], scatter.y_scale)
    # Call method to draw scatterplot to screen
    new_visualisation.draw_scatterplot()

    # Curses methods to refresh screen, get characters. Close screen is called on any keypress.
    refresh()
    getch()
    close_screen()
end

# RUN PROGRAM -->

main()
