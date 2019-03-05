    # TERMINO VISUAL APP: CSV Visualiser for terminal written in Ruby
# Iteration 1: Minimum Viable Product


# 1. Take artificial CSV and print it to screen as scatterplot
# 2. Command Line Interface and error checking
# INPUT: Filename(CSV file only else error)
# OUTPUT: CSV Object (using csv gem)
# 3. interpretation of the CSV into something renderable (i.e. points) (scaling to screen)
# IN: CSV file
# OUT: a set of x,y coordinates ready to be rendered to screen (scaled)
# 4. rendering itself
# IN: the coordinates
# OUT: image on screen; at least the x and y coordinates in the correct positions, perhaps also basic axes


# PARSING .CSV FILE:

require 'csv'
require 'curses'

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

