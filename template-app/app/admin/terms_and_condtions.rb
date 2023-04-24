ActiveAdmin.register BxBlockTermsandconditions::TermsAndCondition,as:"Terms And Conditions" do
  menu parent: 'App Settings'

  permit_params :description
  actions :index, :show, :edit, :update
  
    form do |f|
      f.inputs 'TermsAndCondition' do
        f.input :description, as: :quill_editor, input_html: { class: "description_terms_and_conditions"}
      end
      f.actions
    end
  
  index title: "Terms & Conditions" do
    selectable_column
    id_column
    column :terms_and_condition do |term|
      div :class => "quill-editor" do 
        truncate(term.description.html_safe, omision: "...", length: 50)
      end
    end
    actions
  end
 
  show title: "Terms & Conditions" do |d|
      attributes_table do
        div :class => "quill-editor" do
          d.description.html_safe
        end
    end
  end
end
