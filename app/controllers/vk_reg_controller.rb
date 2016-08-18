class VkRegController < ApplicationController
  def index
    param = {client_id: '5396761', client_secret: 'parfenov23',
             first_name: 'оля', last_name: 'тобакова', phone: '89222277865'}
    url = "https://api.vk.com/method/auth.signup"
    agent = Mechanize.new
    page = agent.get(url, param)
    JSON.parse(page.body.force_encoding("UTF-8"))
  end
end