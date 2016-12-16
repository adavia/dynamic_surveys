class CustomerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope.includes(:user).all if user.admin?

      scope.joins(:roles).where(roles: {user_id: user})
    end
  end

  def show?
    user.try(:admin?) || record.has_editor?(user)
  end
end
