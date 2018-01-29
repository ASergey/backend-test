require 'rails_helper'

RSpec.describe 'Publishers Shops API', type: :request do
  let(:publisher_1) { create(:publisher) }
  let(:publisher_2) { create(:publisher) }

  describe 'GET /api/v1/publishers/:id/shops' do

    before { get "/api/v1/publishers/#{publisher_1.id}/shops" }

    context 'when the publisher exists without books in shops' do
      it 'returns empty shops' do
        expect(json).not_to be_empty
        expect(json['shops']).to be_empty
      end

      it 'responds with a 200 status' do
        expect(response.status).to eq 200
      end
    end
  end
end
