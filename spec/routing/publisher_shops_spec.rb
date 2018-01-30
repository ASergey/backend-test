require 'rails_helper'

RSpec.describe 'routing to publisher shops', type: :routing do
  it 'routes /publishers/:id/shops to publishers/shops#index for publisher id' do
    expect(get: '/api/v1/publishers/21/shops').to route_to(
      format:     :json,
      controller: 'api/v1/publishers/shops',
      action:     'index',
      id:         '21'
    )
  end

  it 'does not expose a list of publishers' do
    expect(get: '/api/v1/publishers').not_to be_routable
  end

  it 'does not show specific publisher' do
    expect(get: '/api/v1/publishers/21').not_to be_routable
  end

  it "does not show publisher's specific shop" do
    expect(get: '/api/v1/publishers/21/shops/1').not_to be_routable
  end
end
