class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  def display_time_elapsed
    elapsed_time = Time.current - updated_at
    if elapsed_time < 60
      "#{elapsed_time.in_seconds.round}s"
    elsif elapsed_time < 3600
      "#{elapsed_time.in_minutes.round}m"
    elsif elapsed_time < 86400
      "#{elapsed_time.in_hours.round}h"
    elsif elapsed_time < 604800
      "#{elapsed_time.in_days.round}d"
    elsif elapsed_time < 220752000
      "#{elapsed_time.in_weeks.round}w"
    else
      "#{elapsed_time.in_years.round}y"
    end
  end
end