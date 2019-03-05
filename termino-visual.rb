
require 'csv'
require 'curses'
require 'descriptive_statistics'

# def single_argument_specified?()
#     if ARGV.length == 1
#         return true
#     end
#     return false
# end

# def file_is_CSV?()
#     if ARGV[0].match(/\w+\.csv/)
#         return true
#     end
#     return false
# end

# def main()

#     if single_argument_specified?() && file_is_CSV?()
#         filename = ARGV[0].scan(/\w+\.csv/)[0]
#     else
#         puts "Usage: ruby termino-visual.rb [*.csv]"

# end




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
    new_coordinate << x_coordinate.to_i
    new_coordinate << y_coordinate.to_i
    return new_coordinate
end

test_array_of_xy_coordinates = create_array_of_xy_coordinates(months_array, temp_array)

# p create_array_of_xy_coordinates(months_array, temp_array)


class Visualiser
    # include 'Curses'

    attr_reader :array_of_observations

    def initialize(array_of_observations)
        @array_of_observations = array_of_observations
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
        screen_height = Curses.lines #retreive number of lines (height) of user screen 'stdscr'
        screen_width = Curses.cols ##retreive number of columns (width) of user screen 'stdscr' 
        x_midpoint = Curses.cols / 2 # save coordinate of midpoint of x axis
        y_midpoint = Curses.lines / 2 # save coordinate of midpoint of y axis

        Curses.curs_set(0) # Make cursor invisible.

        @array_of_observations.each do |array|
            array.each do |observation|
                draw_single_observation(observation)
            end
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
        Curses.setpos(y_coordinate, x_coordinate)
        Curses.addch("*")
    end


end

vistest = Visualiser.new(test_array_of_xy_coordinates)
p vistest.array_of_observations
vistest.draw_scatterplot








