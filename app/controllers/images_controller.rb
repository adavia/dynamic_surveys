class ImagesController < ApplicationController
  before_action :authenticate_user
  before_action :set_image

  def destroy
    authorize @image, :destroy?
    @image = @image.destroy
  end

  private

  def set_image
    @image = Image.find(params[:id])
  end
end
