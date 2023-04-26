ActiveAdmin.register BxBlockAdmin::AboutUs, as: "About Us" do
  menu parent: 'App Settings'
  ABOUT_US = "About Us"
  permit_params :description
  actions :index, :show, :edit, :update
  breadcrumb do
      [
         link_to( ABOUT_US, "/admin/about_us/:id")
       ]
     end
  
  form do |f|
    f.inputs 'AboutUs' do
      f.input :description, as: :quill_editor, input_html: { class: "description_about_us"}
    end
    f.actions
  end
  
  index title: ABOUT_US do
    selectable_column
    id_column
    column :about_us do |about_us|
      strip_tags(about_us.description).truncate(50)
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
