module Cookies
  class CookWorker
    include Sidekiq::Worker

    def perform(cookie_id)
      cookie = Cookie.find(cookie_id)
      cookie.cook!
    end
  end
end
