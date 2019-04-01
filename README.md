# Termino-Visual: CLI for generating scatterplots from CSV data
### Version 0.1
### Andrew Sims and Josh Teperman
## Purpose
This is a command line application which accepts .csv files as arguments at the command line and renders  scatterplots at the command line. For the present iteration, these .csv files must be formatted so that they consist only of 2 columns, and without headers. More sophisticated functionality will be added in later versions.

## Installation
For usage of Termino-Visual, the following gemfiles must be installed on your system:
* [Curses](https://github.com/ruby/curses)
* [Descriptive Statistics](https://github.com/ruby/curses)

## Usage
Termino-Visual is written in Ruby 2.5.1 and therefore requires the Ruby interpreter to be installed on your machine. Instructions on how to do this can be found [here](https://www.ruby-lang.org/en/documentation/installation/).

When both Ruby and Termino-Visual is installed, navigate to the correct folder and run it by typing
`ruby termino-visual.rb` followed by the name of your .csv file. This will generate a scatterplot with labelled x and y axes and a title that is inferred from the filename. Following these steps for the sample datasets that we include in our repo yields the following results:

![bundoora](./docs/bundoora.png)
![NT](./docs/nt.png)

## Known issues
We suspect that both of the issues below have to do with eccentricities associated with the Curses gem, and we are looking into alternatives for rendering to screen that are "native" to Ruby.
* Regionalisation: currently, there is an issue correctly rendering negative temperatures, which may result in problems for users in parts of the northern hemisphere or extreme southern hemisphere. We have included the Antarctica dataset so that this bug can be reproduced easily.

![antarctica_plot](./docs/AntarcticaScreenshot.png)

* Some filenames do not render correctly as titles for the plots, and are missing letters, particularly the letter 'c' tends to disappear from the titles for some reason (see title in above screenshot).