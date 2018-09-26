class StaticPagesController < ApplicationController
  def home
    fill_items if logged_in?
  end

  def fill_items
    @micropost  = current_user.microposts.build
    # @feed_items = User.feed(current_user.id).paginate(page: params[:page])
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help; end

  def about; end

  def contact; end
end
