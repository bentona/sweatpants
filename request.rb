module ElasticsearchRequest

  def to_bulk
    [bulk_header, @body].join("\n")
  end

  def bulk_header
    throw Exception "bulk_header not defined for #{this.class}"
  end

  def self.create method_name, params
    klass = case method_name
    when :index
      ElasticsearchIndexRequest
    else
      nil
    end
    klass.new(params) if klass
  end

end

class ElasticsearchIndexRequest < ElasticsearchRequest
  
  def initialize params
    @type = params[:type] || nil
    @index = params[:index] || nil
    @id = params[:id] || nil
  end

  def initialize params
    super(params)
    @body = params[:body]
  end

  def bulk_header
    { index: { _index: @index, _type: @type, _id: @id } }
  end
end
