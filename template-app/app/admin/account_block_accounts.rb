ActiveAdmin.register AccountBlock::Account, as: "User Management" do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :first_name, :last_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :device_id, :unique_auth_id, :password_digest, :type, :user_name, :platform, :user_type, :app_language_id, :last_visit_at, :is_blacklisted, :suspend_until, :status, :role_id, :character_id, :voice_id, :date_of_birth, :gender, :autoplay_setting, :reply_audio_setting, :language_id, :is_terms_and_conditions_accepted, :unique_code, :profile_pic

  json_editor

  scope :all
  scope("Papa") { |scope| scope.where(role_id: BxBlockRolesPermissions::Role.find_by_name("Papa")&.id) }
  scope("Mumma") { |scope| scope.where(role_id: BxBlockRolesPermissions::Role.find_by_name("Mumma")&.id) }
  scope("Child") { |scope| scope.where(role_id: BxBlockRolesPermissions::Role.find_by_name("Child")&.id) }
  scope :deactivated

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :activated
    column :status
    column :gender
    column :role
    column :date_of_birth
    column :is_blacklisted
    column :language
    actions
  end

  form do |f|
    f.inputs  do
      f.input :profile_pic, as: :file
      f.input :email
      f.input :first_name
      f.input :activated
      f.input :status
      f.input :gender
      f.input :role
      f.input :date_of_birth
      f.input :is_blacklisted
      f.input :equalizer_profile, as: :jsonb
    end
    f.actions
  end
    
  show do
    attributes_table do
      row :profile_pic do |ad|
        image_tag ad.profile_pic , size: "200x200" if ad.profile_pic.present?
      end
      row :email
      row :first_name
      row :activated
      row :status
      row :gender
      row :role
      row :date_of_birth
      row :is_blacklisted
      row :equalizer_profile, as: :jsonb
    end
  end
end
