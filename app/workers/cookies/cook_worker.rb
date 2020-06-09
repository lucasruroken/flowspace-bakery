module Cookies
  class CookWorker
    include Sidekiq::Worker

    delegate :cook!, to: :@cookie

    def perform(cookie_id)
      find_cookie(cookie_id)
      cook!
      broadcast_oven
    end

    private

    def find_cookie(cookie_id)
      @cookie = Cookie.find(cookie_id)
    end

    def broadcast_oven
      ActionCable.server.broadcast "oven_#{@cookie.storage.id}_channel", message: {
        oven_id: @cookie.storage.id,
        cookie_id: @cookie.id,
        ready: true
      }
    end
  end
end
