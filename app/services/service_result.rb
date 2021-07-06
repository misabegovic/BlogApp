# frozen_string_literal: true

class ServiceResult
  attr_reader :errors, :value

  def initialize(errors: nil, value: nil)
    @errors = errors
    @value = value
  end

  def success?
    !failure?
  end

  def failure?
    !errors.blank?
  end
end
