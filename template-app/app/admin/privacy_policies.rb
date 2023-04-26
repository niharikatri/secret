ActiveAdmin.register BxBlockAdmin::PrivacyPolicy, as: "Privacy Policy" do
  menu parent: 'App Settings'
  PRIVACY_POLICY = "Privacy Policy"
  permit_params :description
  actions :index, :show, :edit, :update
  breadcrumb do
    [
       link_to( PRIVACY_POLICY, "/admin/privacy_policies/:id")
     ]
   end
    
  form do |f|
    f.inputs PRIVACY_POLICY do
      f.input :description, as: :quill_editor, input_html: { class: "description_privacy_policies"}
    end
    f.actions
  end
    
  index title: PRIVACY_POLICY do
    selectable_column
    id_column
    column :privacy_policy do |privacy_policy|
      strip_tags(privacy_policy.description).truncate(50)
    end
    actions
  end
 
  show title: PRIVACY_POLICY do |d|
      attributes_table do
        div :class => "quill-editor" do
          d.description.html_safe
        end
    end
  end
end
