class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope
    end
  end
end
