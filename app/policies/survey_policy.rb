class SurveyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.try(:admin?) || record.customer.has_member?(user)
  end
end
