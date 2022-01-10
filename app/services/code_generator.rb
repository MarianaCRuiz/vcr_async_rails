class CodeGenerator
  def self.create
    loop do
      @code = SecureRandom.base58(8)
      break unless Report.exists?(report_code: @code)
    end
    @code
  end
end
