require_relative 'jobs_processor'
require 'test/unit'

class TestJobs < Test::Unit::TestCase

  def setup
    @jobs_processor = JobsProcessor.new
  end

  def test_add_empty_string_gives_empty_sequence
    @jobs_processor.add_job('')
    assert_equal([], @jobs_processor.jobs)
  end

  def test_add_single_job
    @jobs_processor.add_job({:a=>''})
    assert_equal([{:a=>''}], @jobs_processor.jobs)
  end

  def test_add_three_unordered_jobs
    job_a = {:a=>''}
    job_b = {:b=>''}
    job_c = {:c=>''}
    @jobs_processor.add_job(job_a)
    @jobs_processor.add_job(job_b)
    @jobs_processor.add_job(job_c)
    assert_equal(3, @jobs_processor.jobs.length)
    assert(@jobs_processor.jobs.include?(job_a))
    assert(@jobs_processor.jobs.include?(job_b))
    assert(@jobs_processor.jobs.include?(job_c))
  end

  def test_add_three_ordered_jobs
    job_a = {:a=>''}
    job_b = {:b=>:c}
    job_c = {:c=>''}
    @jobs_processor.add_job(job_a)
    @jobs_processor.add_job(job_b)
    @jobs_processor.add_job(job_c)
    assert(@jobs_processor.jobs.index(job_c) < @jobs_processor.jobs.index(job_b))
  end

  def test_add_six_ordered_jobs
    job_a = {:a=>''}
    job_b = {:b=>:c}
    job_c = {:c=>:f}
    job_d = {:d=>:a}
    job_e = {:e=>:b}
    job_f = {:f=>''}
    @jobs_processor.add_job(job_a)
    @jobs_processor.add_job(job_b)
    @jobs_processor.add_job(job_c)
    @jobs_processor.add_job(job_d)
    @jobs_processor.add_job(job_e)
    @jobs_processor.add_job(job_f)
    assert(@jobs_processor.jobs.include?(job_a))
    assert(@jobs_processor.jobs.include?(job_b))
    assert(@jobs_processor.jobs.include?(job_c))
    assert(@jobs_processor.jobs.include?(job_d))
    assert(@jobs_processor.jobs.include?(job_e))
    assert(@jobs_processor.jobs.include?(job_f))
    assert(@jobs_processor.jobs.index(job_f) < @jobs_processor.jobs.index(job_c))
    assert(@jobs_processor.jobs.index(job_c) < @jobs_processor.jobs.index(job_b))
    assert(@jobs_processor.jobs.index(job_b) < @jobs_processor.jobs.index(job_e))
    assert(@jobs_processor.jobs.index(job_a) < @jobs_processor.jobs.index(job_d))
  end

  def test_add_circular_dependency
    job_a = {:a=>''}
    job_b = {:b=>''}
    job_c = {:c=>:c}
    @jobs_processor.add_job(job_a)
    @jobs_processor.add_job(job_b)
    assert_raise(Exception) {
      @jobs_processor.add_job(job_c)
    }
  end

  def test_add_multiple_job_circular_dependency
    job_a = {:a=>''}
    job_b = {:b=>:c}
    job_c = {:c=>:f}
    job_d = {:d=>:a}
    job_e = {:e=>''}
    job_f = {:f=>:b}
    assert_raise(Exception) {
      @jobs_processor.add_job(job_a)
      @jobs_processor.add_job(job_b)
      @jobs_processor.add_job(job_c)
      @jobs_processor.add_job(job_d)
      @jobs_processor.add_job(job_e)
      @jobs_processor.add_job(job_f)
    }
  end

end
