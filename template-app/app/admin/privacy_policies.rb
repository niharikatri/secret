ActiveAdmin.register BxBlockAdmin::PrivacyPolicy, as: "Privacy Policies" do
  menu parent: 'App Settings'

  permit_params :description
    
  form do |f|
    f.inputs 'Privacy Policy' do
      f.input :description, as: :quill_editor
    end
    f.actions
  end
    
  index title: "Privacy Policies" do
    selectable_column
    id_column
    column :privacy_policy do |privacy_policy|
      div :class => "quill-editor" do 
        truncate(privacy_policy.description, omision: "...", length: 50)
      end
    end
    actions
  end
 
  show title: "Privacy Policy" do |d|
      attributes_table do
        div :class => "quill-editor" do
          d.description.html_safe
        end
    end
  end
end
