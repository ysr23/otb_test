class JobsProcessor
  attr_accessor :jobs

  def initialize
    @jobs = []
    @dependencies = []
  end

  def add_job(newjob)
    if newjob == ""
      return
    end
    if newjob.values[0] == newjob.keys[0]
      raise Exception
    end
    if (!has_dependency(newjob))
      @jobs << newjob
    end
  end

  def has_dependency(newjob)
    found_dependency = false
    @jobs.each { |job|
      if !found_dependency 
        if job.values[0] == newjob.keys[0]
          found_dependency = true
          if @dependencies.include? newjob.values[0]
            raise Exception
          end
        @dependencies << job.keys[0]
        @jobs.unshift(newjob)
      end
    end
    }    
    return found_dependency
  end
end

