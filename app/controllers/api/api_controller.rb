module Api
  class ApiController < ActionController::Base
    require 'vk_message'
    before_action :auth, except: [:find_api_key, :order_payments, :test_blynk, :test_run_alice]


    def index
      render json: {success: true, user_id: current_user.id}
    end

    def company
      render json: current_company.as_json
    end

    def all_magazines
      render json: current_company.magazines.as_json
    end

    def find_api_key
      render json: {api_key: Company.find_by_domain(params[:domain]).magazines.first.api_key}
    end

    def all_content_pages
      render json: ContentPage.where(magazine_id: current_magazine.id).as_json
    end

    def all_top_magazine
      render json: ProductItem.joins(:product_item_top_magazines).where("product_item_top_magazines.magazine_id = ?", current_magazine.id).uniq.transfer_to_json(current_magazine.api_key)
    end

    def current_price_delivery
      render json: {current_price_delivery: current_magazine.current_price_delivery(params[:current_price].to_f)}
    end

    def auth_domen_vk_group
      VkMessage.message_price(params)
      # binding.pry
      
      # render json: VkMessage.keybord
      render text: params[:return]
    end

    def order_payments
      order = OrderPayment.find_by_id(params[:object][:metadata][:order_payment_id])
      if order.present?
        status = params[:object][:paid]
        order.update(payment: status)
        if status
          company = order.company
          demo_time = company.demo_time.to_time 
          demo_time = demo_time < Time.now ? Time.now : demo_time
          curr_access = (demo_time + order.month.month).strftime("%d.%m.%Y")
          company.update(tariff: order.tariff, demo_time: curr_access, demo: false)
        end
      end
      render json: {success: true}
    end

    def update_help
      current_company.update(help_notify: true)
      render json: {success: true}
    end

    def test_blynk
      agent = Mechanize.new
      page = agent.get("http://139.59.206.133/YcHlOoUcS9rii7ghQH2Qw6KttF6c91Uc/update/V10?value=#{params[:v]["0"]}&value=#{params[:v]["1"]}&value=#{params[:v]["2"]}")
      render json: {success: true}
    end

    def test_run_alice
      `curl 'https://iot.quasar.yandex.ru/m/user/scenarios/54548974-4915-4ec7-a380-173b8a96d29b/actions' \
      -X 'POST' \
      -H 'Connection: keep-alive' \
      -H 'Content-Length: 0' \
      -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36' \
      -H 'x-csrf-token: 3345d6fdccf21bbf5f6596745b793c72285d6825:1606038975' \
      -H 'Accept: */*' \
      -H 'Origin: https://yandex.ru' \
      -H 'Sec-Fetch-Site: same-site' \
      -H 'Sec-Fetch-Mode: cors' \
      -H 'Sec-Fetch-Dest: empty' \
      -H 'Referer: https://yandex.ru/' \
      -H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
      -H 'Cookie: _ym_uid=1505490109158057723; my=YwA=; yandexuid=7410774141505218250; mda=0; yuidss=7410774141505218250; ymex=1820578250.yrts.1505218250#1864893649.yrtsi.1549533649; gdpr=0; is_gdpr=0; is_gdpr_b=CKuXThDvBigC; yandex_gid=54; L=AR9nBkJweVJeSmJ8aARXUUEHQwNNR3l4AFEOci0pV1QZEQJUJRVbPh9BEQ==.1604339216.14407.39912.ebfee5de46c85acdd4aa0c61c28c86c9; yandex_login=ceo@tobacco-gold.ru; Session_id=3:1605782704.5.7.1505490135537:LqPiLg:22.1|315585199.0.2|422976415.38.2.2:38|678367579.43296175.2.2:43296175|818667120.44043487.2.2:44043487|1130000022341784.57028312.2.2:57028312|1013578159.75226389.2.2:75226389|1130000044720561.83984501.2.2:83984501|1130000022341770.88718071.2.2:88718071|226071.506740.WTCsAKr0HgjvL0uGPP76tlXqvd0; sessionid2=3:1605782704.5.7.1505490135537:LqPiLg:22.1|315585199.0.2|422976415.38.2.2:38|678367579.43296175.2.2:43296175|818667120.44043487.2.2:44043487|1130000022341784.57028312.2.2:57028312|1013578159.75226389.2.2:75226389|1130000044720561.83984501.2.2:83984501|1130000022341770.88718071.2.2:88718071|226071.312023.HV6SRvuKkmlEDNBaDMLszhcGLIw; _ym_isad=1; computer=1; engineering=1; _ym_d=1606038911; zm=m-white_bender_zen-ssr.gen.webp.css-https%3As3home-static_8iV93J_cHX9-z1TmND7CZ9dg7ec%3Al; yc=1606298112.zen.cacS%3A1606042509; _ym_visorc_50377519=b; yabs-frequency=/5/0G010A0rkb-VDRfV/3WDpS9G0000eFa7cTx1mbG0002i-_F___m00/; i=z/qpgts2LpGLC1gI2pdHtkUlUpAr2VnMf92wbs8MdcbvosfrMjRVUgnO0hMoWK3ufA54YX0vCj8pAUSCYX3E4/1DFO0=; _ym_visorc_55024303=w; _ym_visorc_21930706=w; ys=wprid.1606038964560769-1377271828584382275100163-production-app-host-vla-web-yp-45#bnrd.0899040106; skid=460183271606038966; lsq=%D1%8F%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%20%D1%83%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0; yp=1820850146.multib.1#1919699216.udn.cDpjZW9AdG9iYWNjby1nb2xkLnJ1#1820578250.yrts.1505218250#1864893649.yrtsi.1549533649#1913631010.org_id.681614#1614049398.szm.2%3A1280x800%3A1280x720#1606931212.ygu.1#1606643716.dq.1#1608630970.los.1#1608630970.losc.0; _ym_visorc_47845414=b; _ym_visorc_56213845=b; _ym_visorc_62403583=w; _ym_visorc_49488847=w' \
      --compressed`
      render json: {success: true}
    end

    private

    def auth
      auth_key = params[:api_key].to_s.gsub("?", "").gsub(/(task=send|task=sent|task=result)/, '')
      if auth_key.present?
        @current_user = User.first
        @current_magazine = Magazine.find_by_api_key(auth_key)
      end
      render json: {auth: false, code: '401'} if @current_user.blank?
    end

    def current_user
      @current_user
    end

    def current_magazine
      @current_magazine
    end

    def current_company
      current_magazine.company
    end

    def current_cashbox
      current_magazine.present? ? Cashbox.find_by_magazine_id(current_magazine.id) : nil
    end
  end
end