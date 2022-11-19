module Api
  module V1
    class ApplicationsController < ApplicationController
      before_action :set_application, only: %i[ show update destroy ]

      # GET /applications
      def index
        @applications = paginate Application.order('id DESC')

        success_response ApplicationsRepresenter.new(@applications).as_json, {
          total_pages: @applications.total_pages,
          total_entries: @applications.total_entries
        }
      end

      # GET /applications/1
      def show
        success_response ApplicationRepresenter.new(@application).as_json
      end

      # POST /applications
      def create
        if !params[:name] || params[:name] == ""
          validation_error "name"
          return
        end

        @application = Application.create(name: params[:name], token: SecureRandom.uuid)

        if @application.valid?
          success_response ApplicationRepresenter.new(@application).as_json, {}, :created
          return
        end

        error_response @application.errors.full_messages[0]
      end

      # PATCH/PUT /applications/1
      def update
        if !params[:name] || params[:name] == ""
          validation_error "name"
          return
        end

        if @application.update(name: params[:name])
          redis_key = Application.redis_key(@application.token)
          $redis.set(redis_key, @application.to_json)
          success_response ApplicationRepresenter.new(@application).as_json
          return
        end

        error_response @application.errors.full_messages[0]
      end

      # DELETE /applications/1
      def destroy
        @application.destroy
        $redis.del(Application.redis_key(@application.token))
        render json: { status: true, message: "Deleted Successfully" }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_application
        token = params[:id]
        redis_key = Application.redis_key(token)
        application = $redis.get(redis_key)

        if application.nil? || request.delete? || request.put? || request.put?
          @application = Application.find_by(token: token)
          $redis.set(redis_key, @application.to_json)
        else
          @application = JSON.load application
        end

        if @application.nil?
          not_found_response
        end
      end
    end
  end
end