ActiveAdmin.register BxBlockAdmin::AboutUs, as: "About Us" do
  menu parent: 'App Settings'
  ABOUT_US = "About Us"
  permit_params :description
  
  form do |f|
    f.inputs 'AboutUs' do
      f.input :description, as: :quill_editor
    end
    f.actions
  end
  
  index title: ABOUT_US do
    selectable_column
    id_column
    column :about_us do |about_us|
      div :class => "quill-editor" do 
        truncate(about_us.description, omision: "...", length: 50)
      end
    end
    actions
  end
 
  show title: ABOUT_US do |d|
      attributes_table do
        div :class => "quill-editor" do
          d.description.html_safe
        end
    end
  end  
end
