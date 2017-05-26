module V1
  class UserSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :id, :name, :links

    def links
      { self: v1_user_path(object.id) }
    end
  end
end