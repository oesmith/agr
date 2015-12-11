class StreamProperty
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  def attributes
    instance_values
  end

  def attributes=(hash)
    hash.each do |k, v|
      send("#{k}=", v)
    end
  end

  def self.dump(obj)
    obj.as_json
  end

  def self.load(data)
    return nil if data.nil?
    obj = new
    obj.from_json(data)
    obj
  end
end