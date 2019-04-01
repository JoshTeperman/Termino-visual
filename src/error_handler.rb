module Handler
  def self.file_formatted_correctly?(csv_data)
    # checks is the CSV file is formatted to 2 columns only
    csv_data.each do |row|
      return row.length == 2
    end
  end

  def self.file_is_csv?
    # Checks if the first argument passed at CL is "*.csv"
    return true if ARGV[0].strip =~ /\w+\.csv$/
  
    false
  end
end