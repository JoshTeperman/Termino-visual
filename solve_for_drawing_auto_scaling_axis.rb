require 'curses'

# stdscr
# 192 columns
# 50 rows / lines
# Curses.setpos(y=lines, x=cols)

Curses.init_screen #initialises curses library 
screen_height = Curses.lines #retreive number of lines (height) of user screen 'stdscr'
screen_width = Curses.cols ##retreive number of columns (width) of user screen 'stdscr' 

Curses.curs_set(0) # Make cursor invisible.

x_midpoint = Curses.cols / 2 # save coordinate of midpoint of x axis
y_midpoint = Curses.lines / 2 # save coordinate of midpoint of y axis

# draw a vertical line from y = 0 to y = stdscr.height, centered on x axis
screen_height.times do |i|  
    Curses.setpos(i, x_midpoint)
    Curses.addstr("|")
end

# draw a vertical line from x = 0 to x = stdscr.width, centered on y axis
screen_width.times do |i| 
    Curses.setpos(y_midpoint, i)
    Curses.addstr("-")
end


Curses.refresh
Curses.getch
Curses.close_screen
