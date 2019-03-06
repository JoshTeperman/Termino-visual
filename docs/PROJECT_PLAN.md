# Project plan

Purpose: This is an application that takes a CSV file as input and visualises it as a scatterplot.

Method: Use curses for visualisation and typical programming operations in the OOP paradigm to do the CLI and data transformation

## Dependencies

* Curses (draw freely to terminal)
* CSV (parse the file)
* descriptive_statistics (calculate the range of the dataset for scaling purposes)

## Application structure

Broadly speaking there are three main components.

### Input and error handling

* User will specify a path and filename when running the script at CL
* ARGV array that contains CL arguments

* Program will check that the path and file exists, and that it is CSV
* File.exist?
* String.match for csv filename

* Program will parse the file using the csv module, and pass it to the next component
* CSV and File modules

### Data handling

* We want to do data handling inside an object called a ScatterPlot, which contains the values in an attribute and instance methods to transform it.
* CSV file is composed of rows and columns. MVP will not bother with headers.
* The ScatterPlot class interprets the CSV: each row as a different observation and each column as a variable associated with that observation
* Each observation is an x/y pair to be plotted to the screen on the x/y axis. E.g., below, observation 1 is the pair [3,1]. That will be plotted at this location in a later stage.
    --------------
    |  x   |   y  |
    |   3   |   1  |
    |   5       6
    |   2       0

* These values need to be scaled to the screen of the user using a ScatterPlot instance method because screen sizes differ between users.
* Each observation is stored in a 2-value array. All of these arrays are kept in a big array of all the observations. We pass this to the visualiser as integers because you can't have e.g., line 2.3 on the screen.

### Visualisation

* We use a gem called 'curses' to draw to the terminal freely. 
* We intend to produce a class called a Visualiser which will contain the observation array as an attribute and include Curses-based instance methods to draw axes and parts of the dataset to screen i.e., methods we build that draw upon Curses functions like getch and addchr and addstr
* QUESTION: Is it a good idea to "include" Curses into the class, or shall we call it more explicitly to aid readability of source code?
* We draw axes by looping over all x or y values in a particular row or column and drawing characters to these location to create straight lines.
* Each observation consists of an x and y value. These can be straightforwardly mapped to x y positions on the terminal screen.
* We loop through each observation in an instance method and print to screen
* We use curses methods to await user input which closes the screen.


