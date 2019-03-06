# Termino-Visual: CLI for generating scatterplots from CSV data
### Version 0.1
## Purpose
This is a command line application which accepts .CSV files as arguments at the command line and renders  scatterplots at the command line. For the present iteration, these CSV files must be formatted so that they consist only of 2 columns, and without headers. More sophisticated functionality will be added in later versions.

## Installation
For usage of Termino-Visual, the following gemfiles must be installed on your system:
* [Curses](https://github.com/ruby/curses)
* [Descriptive Statistics](https://github.com/ruby/curses)

## Design and Planning Process
### Brainstorming


## Known issues
* Regionalisation: currently, there is an issue correctly rendering negative temperatures, which may result in problems for users in parts of the Northern hemisphere.

![antarctica_plot](./docs/AntarcticaScreenshot.png)

* Some filenames do not render correctly as titles for the plots, and are missing letters, particularly the letter 'c' tends to disappear from the titles for some reason (see above screenshot).

## Ethical issues

Termino-visual may not be appropriate for the plotting of sensitive data. However, given that it works in the terminal, it is computationally inexpensive and therefore environmentally friendly way of rendering plots when high resolution is not a priority.

## Extensibility and Improvements
We conceive that the application can be extended and improved along the following lines.
* API
* Automatic formatting
* Headers for axis titles
