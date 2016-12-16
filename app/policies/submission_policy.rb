class SubmissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    user.try(:admin?) || record.survey.customer.has_member?(user)
  end

  def create?
    user.try(:admin?) || record.survey.customer.has_member?(user)
  end
end
