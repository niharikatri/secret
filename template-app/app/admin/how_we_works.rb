ActiveAdmin.register BxBlockAdmin::HowWeWork, as: "How We Work" do
  menu parent: 'App Settings'
  HOW_WE_WORK = "How We Work"
  permit_params :description
  actions :index, :show, :edit, :update
    
  form do |f|
    f.inputs HOW_WE_WORK do
      f.input :description, as: :quill_editor, input_html: { class: "description_how_we_work"}
    end
    f.actions
  end
    
  index title: HOW_WE_WORK do
    selectable_column
    id_column
    column :how_we_work do |how_we_work|
      div :class => "quill-editor" do 
        truncate(how_we_work.description.html_safe, omision: "...", length: 50)
      end
    end
    actions
  end
  
  show title: HOW_WE_WORK do |d|
      attributes_table do
        div :class => "quill-editor" do
          d.description.html_safe
        end
    end
  end  
end
