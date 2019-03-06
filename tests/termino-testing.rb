test_array_of_filenames = [
    "Bureau_of_Meteorology_Antarctica_Mean_Maximum_Temperature.csv"
    "Bureau_of_Meteorology_NT_Mean_Maximum_Temperature.csv"
    "Bureau_of_Meteorology_Bundoora_Mean_Maximum_Temperature.csv"
    "Meteorology_Antarctica_Mean_Maximum_Temperature.csv"
    "Bureau_of_Meteorology_Antarctica_Mean_Maximum_Temperature.txt"
    "~/fake_folder/Bureau_of_Meteorology_Antarctica_Mean_Maximum_Temperature.csv"
]

test_array_of_filenames.each do |test_filename|
    if ARGV.length == 1 && file_is_CSV?()
        test_filename = ARGV[0].strip()
        puts "TEST SUCCESSFUL"
    else
        puts "Input Error: \nCorrect format to use Termino: 'ruby termino-visual.rb *.csv', where * == filename"
        abort
    end
end

if !File.exist?(filename)
    puts "PATH Error: \nThat file does not exist at the specified path. Please check for spelling errors."
    abort
end

csv_text = File.read(filename)
csv_data = CSV.parse(csv_text)


if !is_file_formatted_correctly?(csv_data)
    puts "CSV Format Error: \nFile not formatted correctly. Termino v0.1 only supports CSV files formatted to 2 columns."
    abort
end



