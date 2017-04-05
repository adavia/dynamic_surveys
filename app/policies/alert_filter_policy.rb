class AlertFilterPolicy < ApplicationPolicy
  def new?
    user.try(:admin?) || record.alert.survey.customer.has_editor?(user)
  end

  def create?
    user.try(:admin?) || record.alert.survey.customer.has_editor?(user)
  end

  def edit?
    user.try(:admin?) || record.alert.survey.customer.has_editor?(user)
  end

  def update?
    user.try(:admin?) || record.alert.survey.customer.has_editor?(user)
  end

  def destroy?
    user.try(:admin?) || record.alert.survey.customer.has_editor?(user)
  end
end
