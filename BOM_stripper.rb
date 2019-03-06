require 'csv'

filename = ARGV[0]

if File.exists?(filename)
    csv_unparsed = File.read(filename)
    csv_parsed = CSV.parse(csv_unparsed)

    reformatted_csv = []

    csv_parsed.each do |row|
        formatted_row = []
        formatted_row << row[3]
        formatted_row << row[4]
        reformatted_csv << formatted_row
    end

    reformatted_csv.each do |row|
        CSV.open(filename, "a") do |csv|
            csv << row
        end
    end
else
    puts "File does not exist."
end