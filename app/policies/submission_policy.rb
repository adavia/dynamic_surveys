class SubmissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope
    end
  end

  def show?
    user.try(:admin?) || record.survey.customer.has_editor?(user)
  end

  def new?
    user.try(:admin?) || record.survey.customer.has_member?(user)
  end

  def create?
    user.try(:admin?) || record.survey.customer.has_member?(user)
  end
end
