class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(link_params)
    if @link.save
      redirect_to @link, notice: 'Link criado com sucesso!'
    else
      render :new
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :slug, :user_id)
  end
endend