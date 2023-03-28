ActiveAdmin.register BxBlockRolesPermissions::Role, as: "Roles" do
  menu parent: 'App Settings'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name

end
