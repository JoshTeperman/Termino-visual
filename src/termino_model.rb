# frozen_string_literal: true

# Class which transforms CSV data for visualisation
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

  def produce_array_of_coordinates(variables_array_x, variables_array_y)
    # Input --> Two arrays, each containing values of a particular data set
    # Output --> An array with two-index arrays composed of an x and a y value.
    # These correspond to single observations to be plotted later.
    variables_array_x = scale_to_user_screen_size(
      variables_array_x,
      @screen_width
    )
    variables_array_y = scale_to_user_screen_size(
      variables_array_y,
      @screen_height
    )
    variables_array_x.zip(variables_array_y)
  end

  def get_variable_values(index)
    # Input --> Iterates through the raw_data (CSV file)
    # Output --> Returns an array of variables at selected by index
    variable_array = []
    @raw_data.each do |row|
      variable_array << row[index]
    end
    variable_array
  end

  def convert_all_values_to_floats(array)
    # Converts all values in an array to floats
    array.map(&:to_f)
  end

  def convert_all_values_to_integers(array)
    # Converts all values in an array to integers
    array.map(&:to_i)
  end

  def scale_to_user_screen_size(array, screen_dimension)
    # Input --> An array of variable values
    # Output --> transformed array scaled to the size of the user screen (int)
    # so that they fit on line and column numbers.
    array = convert_all_values_to_floats(array)

    # Find the ratio between the range of the variable spread and the screen
    range_to_screen_ratio = screen_dimension / array.max

    # Expand variable values according to this ratio
    array = array.map do |variable_value|
      variable_value * range_to_screen_ratio
    end
    convert_all_values_to_integers(array)
  end

  def axis_numbers(array)
    # Input --> An array (x or y variable)
    # Output --> An array of 10 numbers, evenly spaced and which will be used
    # to display on the screen by the Visualiser
    array = convert_all_values_to_integers(array)
    increment_between_numbers = array.range / 10
    # This takes the numbers between 1 and 10 and creates an array that takes
    # each number (1-10), multiplies it to the increment, and adds it to the
    # minimum value in the array. This gives us the numbers to be displayed
    # to screen by the Visualizer.
    (1..10).map do |item|
      (array.min + (increment_between_numbers * item)).round
    end
  end
end