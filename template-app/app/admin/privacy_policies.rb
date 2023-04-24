ActiveAdmin.register BxBlockAdmin::PrivacyPolicy, as: "Privacy Policies" do
  menu parent: 'App Settings'
  PRIVACY_POLICY = "Privacy Policies"
  permit_params :description
  actions :index, :show, :edit, :update
  breadcrumb do
    [
       link_to( PRIVACY_POLICY, "/admin/privacy_policies/:id")
     ]
   end
    
  form do |f|
    f.inputs 'Privacy Policy' do
      f.input :description, as: :quill_editor, input_html: { class: "description_privacy_policies"}
    end
    f.actions
  end
    
  index title: "Privacy Policies" do
    selectable_column
    id_column
    column :privacy_policy do |privacy_policy|
      div :class => "quill-editor" do 
        truncate(privacy_policy.description.html_safe, omision: "...", length: 50)
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
