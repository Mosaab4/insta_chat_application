module Api
  module V1
    class ChatsController < ApplicationController
      before_action :set_application
      before_action :set_chat, only: %i[show destroy]

      # GET /chats
      def index
        @chats = @application.chats
        success_response ChatsRepresenter.new(@chats).as_json
      end

      # GET /chats/1
      def show
        render json: @chat
      end

      # POST /chats
      def create
        chats_count = @application.chats.count

        @chat = Chat.create(application: @application, chat_number: chats_count + 1)

        if @chat.valid?
          success_response ChatRepresenter.new(@chat).as_json, {}, :created
          return
        end

        error_response @chat.errors.full_messages[0]
      end

      # DELETE /chats/1
      def destroy
        @chat.destroy
        render json: { status: true, message: "Deleted Successfully" }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_chat
        @chat = !@application.nil? ? Chat.where(application: @application.id, chat_number: params[:id]).first : nil
        if @chat.nil?
          not_found_response
        end
      end

      def set_application
        @application = Application.find_by(token: params[:application_id])
        if @application.nil?
          not_found_response
        end
      end
    end
  end
end
