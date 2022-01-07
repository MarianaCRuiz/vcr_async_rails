class DefaultReportGenerator
  def self.writing_file(full_address, code)
    return false unless data_source

    @out_file = File.new(full_address, 'w')
    @out_file.puts("<p>Your ReportExample Here - code: <b>#{code}</b></p>")
    @out_file.puts("<p>Titulo - #{@parsed[:title]}</b></p>")
    @out_file.puts("<p>Conteudo - #{@parsed[:body]}</p>")
    @out_file.close
    @out_file
  end

  def self.data_source
    @data_typicode = Faraday.get('https://jsonplaceholder.typicode.com/posts/2')
    @parsed = JSON.parse(@data_typicode.body, symbolize_names: true)
    return true if @data_typicode.status == 200
  end
end
