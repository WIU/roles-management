class RoleAssignmentsController < ApplicationController
  before_filter :load_role_assignment, :only => :show
  filter_access_to :all, :attribute_check => true
  filter_access_to :index, :attribute_check => true, :load_method => :load_role_assignments
  respond_to :json

  # Optionally takes application_id parameter to filter index to only roles from that application
  def index
    logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded role assignments index (main page)."
    
    @role_assignments = RoleAssignment.with_permissions_to(:read)
    
    @cache_key = current_user.loginid + '/' + @role_assignments.maximum(:updated_at).try(:utc).try(:to_s, :number)
    
    respond_with(@role_assignments) do |format|
      format.html { render 'index', layout: false }
    end
  end

  def show
  end
  
  private
  
  def load_role_assignment
    @role_assignment = RoleAssignment.with_permissions_to(:read).find_by_id(params[:id])
  end
  
  def load_role_assignments
    # if params[:role_assignment_id]
    #   @role_assignments = RoleAssignment.with_permissions_to(:read).find_by_id(params[:role_assignment_id])
    # else
    #   @role_assignments = RoleAssignment.with_permissions_to(:read).all
    # end
    @role_assignments = []
  end
end
