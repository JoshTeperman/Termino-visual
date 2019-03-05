
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
    def initialize(data)
        @raw_data = data
        @transformed_data = data
    end

    def convert_CSV_to_array()
    # This method takes the raw data from the CSV and populates 
    # an array with many arrays composed of an X and a Y value.
    # These correspond to single observations to be plotted.

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

csv_text = File.read("BOMWeatherData.csv")
weather_csv = CSV.parse(csv_text, :headers => true)
# GET Data-point A (months):
def get_months(csv_data)
    array_of_results = []
    csv_data.each do |row|
        data_set = row.to_hash
        array_of_results << row['Month']
    end
    return array_of_results
end

months_array = get_months(weather_csv)
# p months_array
# p months.length #421 months

# GET Data-point B (temperature):
def get_temperature(csv_data)
    array_of_results = []
    csv_data.each do |row|
        data_set = row.to_hash
        array_of_results << row['Mean maximum temperature']
    end
    return array_of_results
end

temp_array = get_temperature(weather_csv)

def create_xy_coordinate(x_data_set_array, y_data_set_array)
#input -> One x coordinate (x value) and one y coordinate (y value) sliced from arrays
#output -> Single array in x,y coordinate format to be pushed to array_of_coordinates

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

def create_xy_coordinate(x_array, y_array, index)
    new_coordinate = []
    x_coordinate = x_array.slice(index)
    y_coordinate = y_array.slice(index)
    new_coordinate << x_coordinate
    new_coordinate << y_coordinate
    return new_coordinate
end


p create_array_of_xy_coordinates(months_array, temp_array)

