class PostPolicy < ApplicationPolicy
  def destroy?
    @record.author == @user
  end
  
end
