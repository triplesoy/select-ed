class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    record.community.user_id == user.id
  end

  def create?
    new?
  end

  def edit?
    record.community.user == user
  end

  def update?
    edit?
  end

  def destroy?
    record.community.user == user
  end
end
