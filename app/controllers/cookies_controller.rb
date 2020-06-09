class CookiesController < ApplicationController
  before_action :authenticate_user!
  before_action :sanitize_total_cookies, only: :create

  def new
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    if @oven.cookies.any?
      redirect_to @oven, alert: "Cookies are already in the oven! (Total: #{@oven.cookies.size})"
    else
      @cookie = @oven.cookies.new
    end
  end

  def create
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
    prepare_batch
    redirect_to oven_path(@oven)
  end

  def empty
    @oven = current_user.ovens.find(params[:oven_id])
    @cookie = @oven.cookies.find(params[:id])
    if @cookie.ready?
      @cookie.update(storage: current_user)
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end

  private

  def prepare_batch
    params[:total_cookies].to_i.times do
      Cookie.create(cookie_params.merge(storage: @oven))
    end
  end

  def cookie_params
    params.require(:cookie).permit(:fillings)
  end

  def sanitize_total_cookies
    params[:total_cookies] = 1 if params[:total_cookies].to_i < 1
  end
end
