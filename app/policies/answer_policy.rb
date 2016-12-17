class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope
    end
  end

  def index?
    user.try(:admin?) || record.submission.survey.customer.has_editor?(user)
  end
end
