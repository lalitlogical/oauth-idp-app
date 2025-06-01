Warden::Manager.after_authentication do |user, auth, opts|
  request = auth.request

  ip_address = request.remote_ip
  device_name = request.user_agent
  login_time = Time.current

  if user.is_a?(User)
    Rails.logger.info "User #{user.email} logged in from #{ip_address}, #{device_name}"

    KafkaProducer.new.publish("user.logged_in", {
      user_id: user.id,
      name: user.name,
      email: user.email,
      ip_address: ip_address,
      device_name: device_name,
      login_time: login_time
    })
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  if user.is_a?(User)
    Rails.logger.info "👋 User #{user.email} logged out — raising Kafka event"

    KafkaProducer.new.publish("user.logged_out", {
      user_id: user.id,
      email: user.email,
      name: user.name
    })
  end
end
