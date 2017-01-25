class Role < ApplicationRecord
  belongs_to :user
  belongs_to :customer

  #def self.available_roles
    #%w(editor viewer)
  #end
end
