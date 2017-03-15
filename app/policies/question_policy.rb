class QuestionPolicy < ApplicationPolicy
  def new?
    user.try(:admin?) || record.survey.customer.has_editor?(user)
  end

  def create?
    user.try(:admin?) || record.survey.customer.has_editor?(user)
  end

  def edit?
    user.try(:admin?) || record.survey.customer.has_editor?(user)
  end

  def update?
    user.try(:admin?) || record.survey.customer.has_editor?(user)
  end

  def destroy?
    user.try(:admin?) || record.survey.customer.has_editor?(user)
  end
end
