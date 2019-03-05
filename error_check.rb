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