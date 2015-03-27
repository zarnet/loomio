require 'rails_helper'
describe API::FayeController do

  let(:user) { create :user }
  let(:group) { create :group }
  let(:discussion) { create :discussion, group: group }
  let(:another_discussion) { create :discussion }

  before do
    group.members << user
    sign_in user
  end

  describe 'subscribe' do
    context 'success' do
      it 'subscribes to a discussion channel' do
        get :subscribe, channel: "discussion-#{discussion.key}"
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json['channel']).to eq "discussion-#{discussion.key}"
      end

      it 'subscribes to a group channel' do
        get :subscribe, channel: "group-#{group.key}"
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json['channel']).to eq "group-#{group.key}"
      end
    end

    context 'failure' do
      it 'returns a bad request when the channel is invalid' do
        get :subscribe, channel: 'wark-101'
        expect(response.status).to eq 400
      end

      it 'returns a 404 when the model is not found' do
        get :subscribe, channel: 'discussion-imnothere'
        expect(response.status).to eq 404
      end

      it 'returns an unauthorized error when the user does not have access' do
        get :subscribe, channel: "discussion-#{another_discussion.key}"
        expect(response.status).to eq 403
      end
    end
  end

end
