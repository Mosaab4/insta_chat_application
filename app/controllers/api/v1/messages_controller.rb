module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_message, only: %i[ show update destroy ]
      before_action :set_application
      before_action :set_chat, only: %i[show destroy create]

      # GET /messages
      def index
        @messages = Message.all
        success_response MessagesRepresenter.new(@messages).as_json
      end

      # GET /messages/1
      def show
        render json: @message
      end

      # POST /messages
      def create
        if !params[:body] || params[:body] == ""
          validation_error "body"
          return
        end

        message_number = @chat.messages.count
        @message = Message.create(body: params[:body], chat: @chat, message_number: message_number + 1)

        if @message.save
          success_response MessageRepresenter.new(@message).as_json
          return
        end

        error_response @message.errors.full_messages[0]
      end

      # PATCH/PUT /messages/1
      def update
        if !params[:body] || params[:body] == ""
          validation_error "body"
          return
        end

        if @message.update(body: params[:body])
          success_response MessageRepresenter.new(@message).as_json
          return
        end

        error_response @message.errors.full_messages[0]
      end

      # DELETE /messages/1
      def destroy
        @message.destroy
        render json: { status: true, message: "Deleted Successfully" }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_message
          @message = Message.find(params[:id])
        end

        def set_chat
          @chat = !@application.nil? ? Chat.where(application: @application.id, chat_number: params[:chat_id]).first : nil
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