module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_application
      before_action :set_chat, only: %i[show destroy create index update]
      before_action :set_message, only: %i[ show update destroy]

      # GET /messages
      def index
        redis_key = Chat.messages_redis_key(@chat['id'])
        messages = $redis.get(redis_key)

        if messages.nil?
          @messages = Message.where(chat_id: @chat['id'])
          $redis.set(redis_key, @messages.to_json)
        else
          @messages = JSON.load messages
        end

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

        message_number = 0
        last_message_entry = Message.where(chat_id: @chat['id']).order('id DESC').first

        unless last_message_entry.nil?
          message_number = last_message_entry.message_number
        end

        @message = Message.create(body: params[:body], chat_id: @chat['id'], message_number: message_number + 1)

        if @message.save
          UpdateChatMessagesCountJob.perform_in(2.seconds, @chat['id'])

          $redis.del(Chat.messages_redis_key(@chat['id']))
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
          $redis.del(Chat.messages_redis_key(@chat['id']))
          success_response MessageRepresenter.new(@message).as_json
          return
        end

        error_response @message.errors.full_messages[0]
      end

      # DELETE /messages/1
      def destroy
        @message.destroy
        $redis.del(Chat.messages_redis_key(@chat['id']))
        UpdateChatMessagesCountJob.perform_in(2.seconds, @chat['id'])
        render json: { status: true, message: "Deleted Successfully" }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_message
          @message = !@chat.nil? ? Message.where(chat_id: @chat['id'], message_number: params[:id]).first : nil
          if @message.nil?
            not_found_response
          end
        end

        def set_chat
          chat_number = params[:chat_id]
          redis_key = Chat.redis_key(chat_number)
          chat = $redis.get(redis_key)

          if chat.nil?
            @chat = Chat.where(application: @application['id'], chat_number: params[:chat_id]).first
            $redis.set(redis_key, @chat.to_json)
          else
            @chat = JSON.load chat
          end

          if @chat.nil?
            not_found_response
          end
        end

        def set_application
          token = params[:application_id]
          redis_key = Application.redis_key(token)
          application = $redis.get(redis_key)

          if application.nil?
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