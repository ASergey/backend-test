class ValidationError < StandardError
  def initialize(msg = 'Validation failed')
    super(msg)
  end
end