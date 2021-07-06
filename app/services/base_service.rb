# frozen_string_literal: true

class BaseService
  protected

  def execute(rescue_list:, &block)
    raise_rollback_on_error = -> { raise ActiveRecord::Rollback }

    ActiveRecord::Base.transaction do
      guard_process(rescue_list: rescue_list, on_error: raise_rollback_on_error, &block)
    end

    @result
  end

  def save_and_raise!(exception, errors)
    @result = ServiceResult.new(errors: errors)
    raise exception
  end

  def add_result(value)
    @result = ServiceResult.new(value: value)
  end

  private

  def guard_process(rescue_list:, on_error: -> {})
    yield
  rescue *rescue_list
    on_error.call
  end
end
