class API::NotificationsController < API::RestfulController

  private

  def visible_records
    current_user.notifications.joins(:event).where(events: {kind: 'motion_closing_soon'}).order(created_at: :desc)
  end

end
