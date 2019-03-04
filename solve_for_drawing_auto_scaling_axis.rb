require 'curses'

# stdscr
# 192 columns
# 50 rows / lines
# Curses.setpos(y=lines, x=cols)

Curses.init_screen #initialises curses library 
nb_lines = Curses.lines #retreive number of lines (height) of user screen 'stdscr'
nb_cols = Curses.cols ##retreive number of columns (width) of user screen 'stdscr' 

x = Curses.cols / 2 # save coordinate of midpoint of x axis
y = Curses.lines / 2 # save coordinate of idpoint of y axis

# draw a vertical line from y = 0 to y = stdscr.height, centered on x axis
(0).upto(nb_lines-1) do |i| #for some reason (nb_lines) without -1 always draws an extra character
    Curses.setpos(i, x)
    Curses.addstr("|")
end

# draw a vertical line from x = 0 to x = stdscr.width, centered on y axis
(0).upto(nb_cols-1) do |i| 
    Curses.setpos(y, i)
    Curses.addstr("-")
end


Curses.refresh
Curses.getch
Curses.close_screen
