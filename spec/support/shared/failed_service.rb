# frozen_string_literal: true

shared_examples 'failed service' do |errors|
  it 'has failed status' do
    expect(call_result).to be_failure
  end

  it 'returns service object' do
    expect(call_result).to be_a(ServiceResult)
  end

  it 'has correct errors' do
    expect(call_result.errors.full_messages).to match_array(errors)
  end
end
