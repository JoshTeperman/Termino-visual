require 'csv'
require 'curses'

class Scatterplot
  attr_reader :transformed_data, :x_scale, :y_scale
  
  def initialize(data)
    @raw_data = data
    @screen_width = get_dimensions[0]
    @screen_height = get_dimensions[1]
    @x_values = get_variable_values(0) #value of x-axis coordinates
    @y_values = get_variable_values(1) #value of y-axis coordinates
    @x_scale = axis_numbers(@x_values).reverse #values of scale printed on x-axis
    @y_scale = axis_numbers(@y_values).reverse #values of scale printed on y-axis
    @transformed_data = produce_array_of_coordinates(@x_values, @y_values)
  end
  
  def produce_array_of_coordinates(variables_array_1, variables_array_2)
    variables_array_1 = scale_to_user_screen_size(variables_array_1, @screen_width)
    variables_array_2 = scale_to_user_screen_size(variables_array_2, @screen_height)
    return variables_array_1.zip(variables_array_2)
  end
  
  def get_variable_values(index)
    variable_array = []
    @raw_data.each do |row|
      variable_array << row[index]
    end
    return variable_array
  end
  
  def convert_all_values_to_floats(array)
    return array.map(&:to_f)
  end
  
  def convert_all_values_to_integers(array)
    return array.map(&:to_i)
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
  include Curses
  
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

def get_dimensions
  Curses.init_screen
  width = Curses.cols
  height = Curses.lines
  Curses.close_screen
  return [width, height]
end

def is_file_formatted_correctly?(csv_data)
  csv_data.each do |row|
    return row.length == 2
  end
end

def file_is_CSV?()
  if ARGV[0].strip.match(/\w+\.csv$/)
    return true
  end
  return false
end

def main()
  include Curses
  
  if ARGV.length == 1 && file_is_CSV?()
    filename = ARGV[0].strip()
  else
    puts "Usage: ruby tv.rb *.csv"
    abort
  end
  
  if !File.exist?(filename)
    puts "That file does not exist at the specified path. Please check spelling."
    abort
  end
  
  csv_text = File.read(filename)
  csv_data = CSV.parse(csv_text)
  
  if !is_file_formatted_correctly?(csv_data)
    puts "Formatting error (more than two columns in csv)"
    abort
  end
  
  dimensions = get_dimensions
  screen_height, screen_width = dimensions[1], dimensions[0]
  
  scatter = Scatterplot.new(csv_data, screen_width, screen_height)
  scatter_data = scatter.transformed_data
  
  new_visualisation = Visualiser.new(filename, scatter_data, [], scatter.y_scale)
  new_visualisation.draw_scatterplot()
  
  refresh()
  getch()
  close_screen()
end

main()
