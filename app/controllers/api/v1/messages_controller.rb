module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_application
      before_action :set_chat, only: %i[show destroy create index]
      before_action :set_message, only: %i[ show update destroy]

      # GET /messages
      def index
        @messages = Message.where(chat_id: @chat.id).all
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

        message_number = Message.where(chat_id: @chat.id).count
        @message = Message.create(body: params[:body], chat: @chat, message_number: message_number + 1)

        if @message.save
          UpdateChatMessagesCountJob.perform_in(2.seconds, @chat.id)
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
        UpdateChatMessagesCountJob.perform_in(2.seconds, @chat.id)
        render json: { status: true, message: "Deleted Successfully" }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_message
          @message = !@chat.nil? ? Message.where(chat: @chat.id, message_number: params[:id]).first : nil
          if @message.nil?
            not_found_response
          end
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