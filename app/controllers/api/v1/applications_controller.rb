module Api
  module V1
    class ApplicationsController < ApplicationController
      before_action :set_application, only: %i[ show update destroy ]

      # GET /applications
      def index
        @applications = paginate Application.order('id DESC')

        render json: @applications,
               meta: {
                 status: true, message: "Success",
                 total_pages: @applications.total_pages,
                 total_entries: @applications.total_entries
               }
      end

      # GET /applications/1
      def show
        if @application.nil?
          render json: { application: {}, meta: { status: false, message: "Not Found" } }, status: :not_found
        else
          render json: @application, meta: { status: true, message: "Success" }
        end
      end

      # POST /applications
      def create
        if params[:name] == ""
          render json: { error: "Name can not be empty" }, status: :unprocessable_entity
          return
        end

        @application = Application.create(name: params[:name], token: SecureRandom.uuid)

        if @application.valid?
          render json: @application, status: :created
        else
          render json: { error: @application.errors ,meta: { status: false } }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /applications/1
      def update
        if params[:name] == ""
          render json: { error: "Name can not be empty" }, status: :unprocessable_entity
          return
        end

        if @application.update(name: params[:name])
          render json: @application
        else
          render json: @application.errors, status: :unprocessable_entity
        end
      end

      # DELETE /applications/1
      def destroy
        @application.destroy
        render json: { status: true, message: "Deleted Successfully"}
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_application
        @application = Application.find_by(token: params[:id])
      end

      # Only allow a list of trusted parameters through.
      def application_params
        params.require(:application).permit(:name)
      end
    end

  end
end