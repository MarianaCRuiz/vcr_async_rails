class AsyncReportGenerator
  def self.create
    ReportCriticalJob.perform_later
    ReportExampleJob.perform_later
    ReportLowPriorityWorker.perform_async
  end
end
