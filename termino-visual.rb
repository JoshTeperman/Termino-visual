
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
    def initialize(data, screen_width, screen_height)
        @raw_data = data
        @screen_width = screen_width
        @screen_height = screen_height
        @x_values = get_dimension_values(0)
        @y_values = get_dimension_values(1)
        @transformed_data = produce_array_of_coordinates
    end

    def produce_array_of_coordinates(variable_arr1, variable_arr2)
    # This method takes in two arrays
    # It outputs an array with many two-index arrays composed of an X and a Y value.
    # These correspond to single observations to be plotted.
        return variable_arr1.zip(variable_arr2)
    end

    def get_variable_values(variable)
        variable_array = []
        @raw_data.each do |row|
            variable_array << row[dimension]
        end
        return variable_array
    end

    def convert_all_values_to_floats()
    # This converts all the values in the observations array to floats
    end

    def convert_all_values_to_integers()
    # This converts all the values in the observation array to integers
    end

    def scale_to_user_screen_size()
    # This scales the dataset to the size of the user screen and makes all
    # values integers so that they fit on line and column numbers.
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

    Curses.init_screen # Check user's screen and establishes constant height and widths of entire terminal
    screen_height = Curses.lines
    screen_width = Curses.cols
    
    Curses.curs_set(0) # Make cursor invisible

    # Take the file specified by the user and give it to the Scatterplot
    csv_text = File.read(filename)
    csv_data = CSV.parse(csv_text)
end

main()


temp_array = get_temperature(weather_csv)

def create_xy_coordinate(x_array, y_array, index)
    new_coordinate = []
    x_coordinate = x_array.slice(index)
    y_coordinate = y_array.slice(index)
    new_coordinate << x_coordinate
    new_coordinate << y_coordinate
    return new_coordinate
end

def create_array_of_xy_coordinates(x_array, y_array)
#input -> array of data for x coordinate and array of data for y coordinates
#ouptu -> array of arrays, each containing a datapoint to be plotted on scatterplot
    counter = 0
    array_of_coordinates = []

    for data in (0..x_array.length-1) # need to add if statement to check for shortest array as range
        new_coordinate = create_xy_coordinate(x_array, y_array, counter)
        array_of_coordinates << new_coordinate
        counter += 1
    end
    return array_of_coordinates
end


p create_array_of_xy_coordinates(months_array, temp_array)

