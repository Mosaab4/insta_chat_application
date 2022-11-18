module Api
  module V1
    class ChatsController < ApplicationController
      before_action :set_application
      before_action :set_chat, only: %i[show destroy]

      # GET /chats
      def index
        if @application.nil?
          not_found_response
          return
        end

        @chats = @application.chats

        render json: @application
      end

      # GET /chats/1
      def show
        if @application.nil?
          not_found_response
          return
        end

        if @chat.nil?
          not_found_response
          return
        end

        render json: @chat
      end

      # POST /chats
      def create
        if @application.nil?
          not_found_response
          return
        end

        chats_count = @application.chats.count

        @chat = Chat.create(application: @application, chat_number: chats_count + 1)

        if @chat != nil
          render json: @application, status: :created
        else
          render json: @chat.errors, status: :unprocessable_entity
        end
      end

      # DELETE /chats/1
      def destroy
        if @application.nil?
          not_found_response
          return
        end

        if @chat.nil?
          not_found_response
          return
        end

        @chat.destroy
        render json: { status: true, message: "Deleted Successfully"}
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_chat
          if !@application.nil?
            @chat = Chat.where(application: @application.id, chat_number: params[:id]).first
          else
            @chat = nil
          end

        end

        def set_application
          @application = Application.find_by(token: params[:application_id])
        end

        def not_found_response
          render json: { meta: { status: false, message: "Not Found" } }, status: :not_found
        end
    end
  end
end
