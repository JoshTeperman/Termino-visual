# Termino-Visual: CLI for generating scatterplots from CSV data
### Version 0.1
## Purpose
This is a command line application which accepts .csv files as arguments at the command line and renders  scatterplots at the command line. For the present iteration, these .csv files must be formatted so that they consist only of 2 columns, and without headers. More sophisticated functionality will be added in later versions.

## Installation
For usage of Termino-Visual, the following gemfiles must be installed on your system:
* [Curses](https://github.com/ruby/curses)
* [Descriptive Statistics](https://github.com/ruby/curses)

## Usage
When Termino-Visual is installed, navigate to the correct folder and run it by typing
`ruby termino-visual.rb` followed by the name of your .csv file.

## Design and Planning Process

### Brainstorming
We wanted to create an application to visualise data in the terminal. In the early stages of brainstorming, it was not clear exactly what the scope of this project would be. One of us had an antecedent project in the works concerning histograms, but was convinced by the other that it would be more prudent to build the first iteration of the application to render scatterplots. To draw scatterplots involves rendering a single character to the screen for each datapoint, where rendering histograms would require processing the data into bins that are rendered to different heights at constant widths, and would therefore be more complex. We settled on the scatterplot generator, and once we received approval we got to planning.

![just_begun](./docs/justbegun.png)

### Planning program structure
We thought it made most sense to write the program to incorporate three distinct components or stages of processing. These would involve:
1. Accepting and parsing a .csv file as an argument at command line, while handling potential errors.
2. Processing the contents of this file into a form appropriate for visualisation.
3. Doing the actual visualisation; i.e., rendering a scatterplot to the user's screen.

![three_stages](./docs/notebook2.jpg)

This program looked as though it would have a highly serial structure, where the data would flow from one component to the other without doubling back. Given this, we decided to pursue an object-oriented framework for building the application, where each of these processing stages would be implemented as classes. Each object of the class would contain the dataset as an attribute, and would be transformed appropriately for the next stage of processing using instance classes. That way, we could break up the required operations into many smaller methods without sacrificing readability, and it would make it easier for us to allocate work between us (i.e., we each work on one class).

Finally, we decided on an independent set of methods to accept and parse the file when the application loads, a Scatterplot object which would be initialised with the data when loaded, and which would transform that data into a form appropriate to visualisation--and finally, a Visualiser class that would call build on the Curses methods in order to render the data and associated labelling to screen.

### Implementing each component

## Testing
We adopted a manual and ad-hoc testing process. As methods and classes were completed, we would try to call them on a .csv that we had downloaded from the Australian Bureau of Meterology and formatted into a form appropriate to our application. Some record of this can be found in `/tests`.

## Known issues
We suspect that both of the issues below have to do with eccentricities associated with the Curses gem, and we are looking into alternatives for rendering to screen that are "native" to Ruby.
* Regionalisation: currently, there is an issue correctly rendering negative temperatures, which may result in problems for users in parts of the northern hemisphere or extreme southern hemisphere.

![antarctica_plot](./docs/AntarcticaScreenshot.png)

* Some filenames do not render correctly as titles for the plots, and are missing letters, particularly the letter 'c' tends to disappear from the titles for some reason (see title in above screenshot).

## Ethical issues
Termino-visual may not be appropriate for the plotting of sensitive data. However, given that it works in the terminal, it is computationally inexpensive and therefore environmentally friendly way of rendering plots when high resolution is not a priority.

## Extensibility and Improvements
We conceive that the application can be extended and improved along the following lines.
* API
* Automatic formatting
* Headers for axis titles