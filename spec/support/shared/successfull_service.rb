# frozen_string_literal: true

shared_examples 'successful service' do
  it 'has success status' do
    expect(call_result).to be_success
  end

  it 'returns service object' do
    expect(call_result).to be_a(ServiceResult)
  end

  it 'has NO errors' do
    expect(call_result.errors).to be_nil
  end
end
