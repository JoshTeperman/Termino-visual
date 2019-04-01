# DEPENDENCIES -->

require 'csv'
require 'curses'
require 'descriptive_statistics'

require_relative 'termino_model'
require_relative 'termino_view'

def file_formatted_correctly?(csv_data)
  # checks is the CSV file is formatted to 2 columns only
  csv_data.each do |row|
    return row.length == 2
  end
end

def file_is_csv?
  # Checks if the first argument passed at CL is "*.csv"
  return true if ARGV[0].strip =~ /\w+\.csv$/

  false
end

if ARGV.length == 1 && file_is_csv?
  filename = ARGV[0].strip
else
  puts 'Usage: ruby termino-visual.rb *.csv'
  abort
end

# Check the file exists at the specified path
unless File.exist?(filename)
  puts "PATH Error: \nThat file does not exist at the specified path."
  abort
end

# Take the file specified by the user and give it to the Scatterplot
csv_text = File.read(filename)
csv_data = CSV.parse(csv_text)

# After CSV file is opened, confirm there are only two columns of data
# If columns != 2, return error message and exit.
unless file_formatted_correctly?(csv_data)
  puts "CSV Format Error: \nFile not formatted correctly."
  abort
end

Curses.init_screen
screen_height = Curses.lines
screen_width = Curses.cols

# Initialise instance of Scatterplot class
scatter = Scatterplot.new(csv_data, screen_width, screen_height)
scatter_data = scatter.transformed_data

# Initialise instance of Visualiser class with data to be printed to screen
# Note - x_scale in this case is left as an empty array because we are using
# month-names rather than integers
new_visualisation = Visualiser.new(
  filename,
  scatter_data,
  [],
  scatter.y_scale
)
# Call method to draw scatterplot to screen
new_visualisation.draw_scatterplot

Curses.refresh
Curses.getch
Curses.close_screen
