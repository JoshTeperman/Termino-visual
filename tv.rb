# TERMINO-VISUAL: A ruby script for generating scatterplots
# Written by Josh Teperman and Andrew Sims

require 'curses'
require 'csv'
require 'descriptive_statistics'

# Command-line Argument Parser
#
# Required functions:
# - Check that right amount of arguments have been passed
# - Check that the argument is a valid .csv filename/path
# - Check that the file exists at the specified path
# - Send that filename to the CSV Processor if no errors

# CSV Processor
#
# Required functions:
# - parse CSV file into CSV object
# - identify headers if present (X and Y variable names)
# - create an array of [X,Y] array "observations"
# - scale these to fit the screen and send to plot renderer along with "meta-information" like variable names

def scale_to_screen(dataset)
    terminal_width = Curses.cols
    terminal_height = Curses.lines

    # What is the ratio between the screen and the range of the dataset?
    range_x = Scatter.x_var.max - Scatter.x_var.min
    range_y = Scatter.y_var.max - Scatter.y_var.min
    x_ratio = range_x / terminal_width
    y_ratio = range_y / terminal_height

    # Each variable in each observation is expanded by this ratio 
    return dataset.each do |observation|
        observation[0] *= x_ratio
        observation[1] *= y_ratio
    end
end

# Scatterplot renderer
#
# Required functions:
# - Use curses to create a wholescreen window
# - Render axes and variable names
# - Render datapoints to the screen at correct X,Y coordinates
