class Events::MotionClosedByUser < Events::MotionClosed
  after_create :notify_users!

  def self.publish!(motion, closer)
    create!(kind: "motion_closed_by_user",
            eventable: motion,
            user: closer)
  end

  def motion
    eventable
  end
end
