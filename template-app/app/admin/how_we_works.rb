ActiveAdmin.register BxBlockAdmin::HowWeWork, as: "How We Work" do
  permit_params :description
    
  form do |f|
    f.inputs 'How We Work' do
      f.input :description, as: :quill_editor
    end
    f.actions
  end
    
  index title: "How We Work" do
    selectable_column
    id_column
    column :how_we_work do |how_we_work|
      div :class => "quill-editor" do 
        truncate(how_we_work.description, omision: "...", length: 50)
      end
    end
    actions
  end
  
  show title: "How We Work" do |d|
      attributes_table do
        div :class => "quill-editor" do
          d.description.html_safe
        end
    end
  end  
end
