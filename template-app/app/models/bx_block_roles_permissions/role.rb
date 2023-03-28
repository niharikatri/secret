module BxBlockRolesPermissions
  class Role < ApplicationRecord
    self.table_name = :roles

    has_many :accounts, class_name: 'AccountBlock::Account', dependent: :destroy

    validates :name, presence: true, uniqueness: { message: 'Role already present' }
  end
end
