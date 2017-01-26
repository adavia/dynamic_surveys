class SurveyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope
    end
  end

  def show?
    user.try(:admin?) || record.customer.has_editor?(user) || record.customer.has_member?(user)
  end

  def create?
    user.try(:admin?) || record.customer.has_editor?(user)
  end

  def update?
    user.try(:admin?) || record.customer.has_editor?(user)
  end

  def archive?
    user.try(:admin?) || record.customer.has_editor?(user)
  end
end
