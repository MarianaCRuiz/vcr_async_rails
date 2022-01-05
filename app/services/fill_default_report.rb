class FillDefaultReport
  def self.writing_file(address, code)
    data_source
    @out_file = File.new(address, 'w')
    @out_file.puts("<p>Your ReportExample Here - code: <b>#{code}</b></p>")
    @out_file.puts("<p>Titulo - #{@parsed[:title]}</b></p>")
    @out_file.puts("<p>Conteudo - #{@parsed[:body]}</p>")
    @out_file.close
  end

  def self.data_source
    @data_typicode = Faraday.get('https://jsonplaceholder.typicode.com/posts/2')
    @parsed = JSON.parse(@data_typicode.body, symbolize_names: true)
  end
end
