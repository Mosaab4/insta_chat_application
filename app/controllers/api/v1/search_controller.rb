module Api
  module V1
    class SearchController < ApplicationController
      before_action :set_application
      before_action :set_chat

      def index
        query = params['query']

        if query == nil || query == ""
          validation_error "query"
          return
        end

        @messages = Message.search(query, @chat.id)

        success_response SearchableMessagesRepresenter.new(@messages).as_json, {},:ok,"Search Results"
      end

      private

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