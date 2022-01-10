class AsyncReportGenerator
  def self.create
    a1 = [ReportCriticalJob.perform_now, ReportExampleJob.perform_later, ReportLowPriorityWorker.perform_async]
    a1.each { |elem| elem }
  end
end
