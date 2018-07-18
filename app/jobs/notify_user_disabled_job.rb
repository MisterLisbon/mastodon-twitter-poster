class NotifyUserJob < ApplicationJob
  queue_as :default

  def perform(id)
    NotifyUserDisabledService.new.notify(id) if notifying_users_enabled?
  end

  def notifying_users_enabled?
    true # TODO: get from an env var?
  end
end
