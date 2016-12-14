module UsersHelper
  def display_avatar(user)
    if !user.image.blank?
      image_tag(user.image.url(:thumb), class: "img-responsive center-block img-thumbnail")
    else
      image_tag("default_user.png", class: "img-responsive center-block")
    end
  end
end
