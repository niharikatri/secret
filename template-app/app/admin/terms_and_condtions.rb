ActiveAdmin.register BxBlockTermsandconditions::TermsAndCondition,as:"Terms And Conditions" do

  permit_params :description
  
    form do |f|
      f.inputs 'TermsAndCondition' do
        f.input :description
      end
      f.actions
    end
  
  index title: "Terms & Conditions" do
    selectable_column
    id_column
    column :terms_and_condition do |term|
      div do 
        truncate(term.description, omision: "...", length: 50)
      end
    end
    actions
  end
 
  show title: "Terms & Conditions" do |d|
      attributes_table do
        div do
          d.description.html_safe
        end
    end
  end
end
