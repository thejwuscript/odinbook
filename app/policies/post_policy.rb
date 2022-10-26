class PostPolicy < ApplicationPolicy
  def update?
    @record.author == current_user
  end
  
  def destroy?
    @record.author == @user
  end
  
end
