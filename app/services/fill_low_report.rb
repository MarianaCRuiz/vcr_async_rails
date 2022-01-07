class FillLowReport
  def self.writing_file(full_address, code)
    @out_file = File.new(full_address, 'w')
    @out_file.puts("<p>Your Low Priority Report Here - code: <b>#{code}</b></p>")
    @out_file.puts('<p>e-Book: Guia de Gems OneBitCode :)</p>')
    @out_file.close
    @out_file
  end
end
