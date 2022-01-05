class FillLowReport
  def self.writing_file(address, code)
    @out_file = File.new(address, 'w')
    @out_file.puts("<p>Your Low Priority Report Here - code: <b>#{code}</b></p>")
    @out_file.puts('<p>e-Book: Guia de Gems OneBitCode :)</p>')
    @out_file.close
  end
end
