module BxBlockRolesPermissions
  class RolesController < ApplicationController
  	def index
  		@roles = Role.all
  		render json: RoleSerializer.new(@roles)
                       .serializable_hash, status: :ok
  	end
  end
end
