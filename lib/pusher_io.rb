class PusherIo
  require 'pusher'

  def self.pusher_client
    Pusher::Client.new(
      app_id: '474602',
      key: '1a55ade886312565bd6d',
      secret: 'c9dcd3d853484f15b49e',
      cluster: 'eu',
      encrypted: true
      )
  end

  def self.sender(channel, event, data)
    pusher_client.trigger(channel, event, data)
  end
end