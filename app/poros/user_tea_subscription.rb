class UserTeaSubscription
  attr_reader :id,
              :title,
              :description,
              :brew_temp,
              :brew_time,
              :box_count,
              :status

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @description = data[:description]
    @brew_temp = data[:temperature]
    @brew_time = data[:brew_time]
    @box_count = data[:box_count]
    @status = data.tea_subscriptions.first.status
  end
end
