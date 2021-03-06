class Admin::BaseController < ApplicationController
  filter_access_to :all, :attribute_check => true

  def permission_denied
    respond_to do |format|
      format.json { render json: {}, status: :forbidden }
    end
  end

  private

  # Ensure /admin/ operations authorize against the actual user,
  # not an impersonated user.
  def current_user
    actual_user
  end
end
