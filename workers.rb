
class DummyWorker
  def initialize
  end

  def process jobs
    puts "I'm processing #{jobs.length} jobs!"
  end
end

class ESWorker
  def initialize
    @es_client = nil
  end

  def process jobs
    content = jobs.map{|job| parse_job(job.path, job.body)}.join("\n")
    puts 'processing: '
    puts content
  end

  private
  def parse_job path, body
    components = path.split('/').reject(&:empty?)
    return false if path.size != 3
    header = { index: { _index: path[0], _type: path[1], _id: path[2] } }
    "#{header}\n#{body}"
  end
end