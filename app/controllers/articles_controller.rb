class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :unauthorized_status

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
session[:page_views] ||= 0
session[:page_views] = session[:page_views] + 1
if session[:page_views] <= 3
  article = Article.find(params[:id])
  render json: article
else
  unauthorized_status
end
end

  private

 def unauthorized_status
  render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
 end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
