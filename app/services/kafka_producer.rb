require "kafka"

class KafkaProducer
  def initialize(topic = "doorkeeper-events")
    @kafka = Kafka.new([ "localhost:9092" ])
    @topic = topic
  end

  def publish(event, payload)
    message = { event: event, payload: payload, timestamp: Time.now.to_s }.to_json
    @kafka.deliver_message(message, topic: @topic)
  end
end
