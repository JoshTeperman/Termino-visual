# frozen_string_literal: true

# Class for drawing scatterplots to screen
class Visualiser
  attr_reader :filename, :array_of_observations
  include Curses

  def initialize(filename, array_of_observations, x_scale = [], y_scale = [])
    @filename = filename
    @array_of_observations = array_of_observations
    @screen_height = lines
    @screen_width = cols
    @x_scale = x_scale
    @y_scale = y_scale
  end

  def draw_y_axis_numbers(numbers)
    # Input -> List of numbers to be used for the y-axis key
    # Output -> Uses Curses to draw the keys on the y-axis
    increment = (@screen_height / numbers.length).round
    locations_on_axis = (1..numbers.length).map do |number|
      0 + (increment * number)
    end
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
    locations_on_axis = (1..numbers.length).map do |number|
      0 + (increment * number)
    end
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
      addstr('-')
    end
  end

  def draw_y_axis(screen_height, x_midpoint)
    # Input -> receives screen width from Curses.init_screen call
    # Output -> draw spaced numbers to screen

    # draw a vertical line from y = 0 to y = stdscr.height, centered on x axis
    screen_height.times do |y_position|
      setpos(y_position, x_midpoint)
      addstr('|')
    end
  end

  def draw_scatterplot
    # Input -> array of observations
    # Output -> iterate through array_of_observations and print
    # each one to screen using draw_single_observation method

    x_midpoint = cols / 2
    curs_set(0) # Make cursor invisible.

    draw_x_axis(@screen_width, @screen_height - 1)
    draw_y_axis(@screen_height, 0)
    draw_file_name_to_screen(
      format_filename_for_printing(@filename),
      x_midpoint
    )

    @array_of_observations.each do |observation|
      draw_single_observation(observation)
    end

    draw_y_axis_numbers(@y_scale)
    months = %w[JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC]
    draw_x_axis_numbers(months)
  end

  def draw_single_observation(array_of_coordinate_pair)
    # Input -> single pair of coordinates contained in an array
    # Output -> use curse methods to print coordinate to screen
    x_coordinate = array_of_coordinate_pair[0]
    y_coordinate = array_of_coordinate_pair[1]
    setpos(@screen_height - y_coordinate, x_coordinate)
    addch('*')
  end

  def format_filename_for_printing(filename)
    # Input -> *.csv filename
    # Output -> filname concatenated to a new string with spaces
    formatted_filename = filename.delete('.csv')
    if formatted_filename.include?('_')
      split_string = formatted_filename.split('_')
      return split_string.join(' ')
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