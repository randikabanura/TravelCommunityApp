class WelcomeController < ApplicationController
  def index
    @trips = Trip.order('RANDOM()').limit(4)
    if current_user.has_role? :pro_user_1
      MembershipValidation.perform_async(current_user.id)
    elsif current_user.has_role? :pro_user_2
      MembershipValidation.perform_async(current_user.id)
    elsif current_user.has_role? :pro_user_3
      MembershipValidation.perform_async(current_user.id)
    end
  end
end
