Warden::Manager.after_authentication do |user, auth, opts|
  if user.is_a?(User)
    Rails.logger.info "🔐 User #{user.email} logged in — raising Kafka event"

    KafkaProducer.new.publish("user.logged_in", {
      user_id: user.id,
      email: user.email
    })
  end
end
