class Message < ApplicationRecord
  belongs_to :chat

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping do
    indexes :body, type: :text
    indexes :chat_id, type: :integer
  end

  def self.search(query, chat_id = nil)
    params = {
      query: {
        bool: {
          must: [
            {
              multi_match: {
                query: query,
                fields: [:body]
              }
            },
          ],
          filter: [
            {
              term: { chat_id: chat_id }
            }
          ]
        }
      }
    }

    self.__elasticsearch__.search(params)
  end
end
