module Api
  module V1
    class ChatsController < ApplicationController
      before_action :set_application
      before_action :set_chat, only: %i[show destroy]

      # GET /chats
      def index
        redis_key = Application.chats_redis_key(@application['token'])

        chats = $redis.get(redis_key)

        if chats.nil?
          @chats = Chat.where(application_id: @application['id'])
          $redis.set(redis_key, @chats.to_json)
        else
          @chats = JSON.load chats
        end

        success_response ChatsRepresenter.new(@chats).as_json
      end

      # GET /chats/1
      def show
        success_response ChatRepresenter.new(@chat).as_json
      end

      # POST /chats
      def create
        chat_number = 0
        last_chat_entry = Chat.where(application_id: @application['id']).order('id DESC').first

        unless last_chat_entry.nil?
          chat_number = last_chat_entry.chat_number
        end

        @chat = Chat.create(application_id: @application['id'], chat_number: chat_number + 1)

        if @chat.save
          $redis.del(Application.chats_redis_key(@application['token']))
          UpdateApplicationChatsCountJob.perform_in(2.seconds, @application['id'])
          success_response ChatRepresenter.new(@chat).as_json, {}, :created
          return
        end

        error_response @chat.errors.full_messages[0]
      end

      # DELETE /chats/1
      def destroy
        @chat.destroy
        UpdateApplicationChatsCountJob.perform_in(2.seconds, @application['id'])
        $redis.del(Application.chats_redis_key(@application['token']))
        render json: { status: true, message: "Deleted Successfully" }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_chat
        @chat = !@application.nil? ? Chat.where(application_id: @application['id'], chat_number: params[:id]).first : nil
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
