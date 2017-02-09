class ImagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope
    end
  end

  def destroy?
    user.try(:admin?) || record.imageable.customer.has_editor?(user)
  end
end
