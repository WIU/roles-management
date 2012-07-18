class Api::ApplicationsController < Api::BaseController
  require 'digest/md5'

  def index
    @applications = Application.all

    respond_to do |format|
      format.xml { render :text => @applications.to_xml( :except => [:api_key, :created_at, :id, :updated_at] ) }
    end
  end

  def show
    logger.info "API application/show requesting #{params[:id]}"
    @application = Application.find_by_name(params[:id])

    logger.info "Application '#{@application.name}' successfully retrieved" unless @application.nil?

    if params[:person_id].nil?
      logger.info "No specific individual specified. Returning generic API application/show"
      # No person specified
      @people = resolve_uids(@application.uids, true)

      respond_to do |format|
        format.xml { render :text => @application.to_xml( :except => [:api_key, :created_at, :id, :updated_at] ) }
        format.json
        format.text
      end
    else
      # Person specified
      @person = Person.find_by_loginid(params[:person_id])

      @roles = []

      # Search for roles specific to this person
      r = Role.includes(:role_assignments, :people).where( :people => { :loginid => @person.loginid }, :application_id => Application.find_by_name(@application.name) )
      unless r.length == 0
        @roles = @roles + r.flatten
      end
      # Add in any applicable default roles
      r << Role.where(:default => true, :application_id => @application.id)
      unless r.length == 0
        @roles = @roles + r.flatten
      end

      respond_to do |format|
        format.xml
      end
    end
  end

  def new
    @application = Application.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @application = Application.find(params[:id])
  end

  def create
    @application = Application.new(params[:application])

    @application.api_key = generate_api_key(@application)

    respond_to do |format|
      if @application.save
        format.html { redirect_to(@application, :notice => 'Application was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @application = Application.find(params[:id])

    respond_to do |format|
      if @application.update_attributes(params[:application])
        format.html { redirect_to(@application, :notice => 'Application was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @application = Application.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to(applications_url) }
    end
  end

  private

  def generate_api_key(application)
    api_key_settings = YAML.load_file("#{Rails.root.to_s}/config/api_keys.yml")['development']

    Digest::MD5.hexdigest(application.name + application.hostname + api_key_settings['key']) # last string should be unique to
  end
end
