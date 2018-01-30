require 'rails_helper'

RSpec.describe 'routing to shops books', type: :routing do
  it 'routes /shops/:id/books/:book_id/sell to shops/books#sell for shop id and book id' do
    expect(put: '/api/v1/shops/11/books/12/sell').to route_to(
      format:     :json,
      controller: 'api/v1/shops/books',
      action:     'sell',
      id:         '11',
      book_id:    '12'
    )
  end

  it 'does not expose a list of shops' do
    expect(get: '/api/v1/shops').not_to be_routable
  end

  it 'does not show specific shop' do
    expect(get: '/api/v1/shops/21').not_to be_routable
  end

  it 'does not expose a list of shop books' do
    expect(get: '/api/v1/shops/21/books').not_to be_routable
  end

  it "does not show shop's specific book" do
    expect(get: '/api/v1/shops/21/books/12').not_to be_routable
  end  
end
