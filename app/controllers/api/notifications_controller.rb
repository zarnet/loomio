class API::NotificationsController < API::RestfulController

  private

  def visible_records
    current_user.notifications.order(created_at: :desc)
    #current_user.notifications.joins(:event).where({events: {kind: 'membership_request_approved'}}).order(created_at: :desc)
  end

end
