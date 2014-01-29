module Api
  module V1
    class PeopleController < ApplicationController
      before_filter :load_person, :only => :show
      filter_access_to :all, :attribute_check => true
      filter_access_to :index, :attribute_check => true, :load_method => :load_people
      respond_to :json

      def index
        logger.tagged('API') { logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded or searched people index." }
        
        @cache_key = (params[:q] ? params[:q] : '') + '/' + Digest::MD5.hexdigest(@people.map(&:cache_key).to_s)
        
        render "api/v1/people/index"
      end

      def show
        if @person and @person.active
          logger.tagged('API') { logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded person view (show) for #{@person.loginid}." }
          
          @cache_key = @person.updated_at.try(:utc).try(:to_s, :number)
          
          render "api/v1/people/show"
        elsif @person and @person.active == false
          logger.tagged('API') { logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded person view (show) for #{@person.loginid} but person is disabled. Returning 404." }
          render :json => "", :status => 404
        else
          logger.tagged('API') { logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Attempted to load person view (show) for invalid ID #{params[:id]}." }
          render :text => "Invalid person ID '#{params[:id]}'.", :status => 404
        end
      end
  
      private
  
      def load_person
        @person = Person.with_permissions_to(:read).find_by_loginid(params[:id])
        @person = Person.with_permissions_to(:read).find_by_id(params[:id]) unless @person
      end
      
      def load_people
        if params[:q]
          people_table = Person.arel_table
      
          # Search login IDs in case of an entity-search but looking for person by login ID
          @people = Person.with_permissions_to(:read).where(:active => true).where(people_table[:name].matches("%#{params[:q]}%").or(people_table[:loginid].matches("%#{params[:q]}%")).or(people_table[:first].matches("%#{params[:q]}%")).or(people_table[:last].matches("%#{params[:q]}%")))
        else
          @people = Person.with_permissions_to(:read).where(:active => true).all
        end
      end
    end
  end
end
