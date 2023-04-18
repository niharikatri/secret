ActiveAdmin.register BxBlockAdmin::ContactUs, as: "Contact Us" do
  menu parent: 'App Settings'
  CONTACT_US = "Contact Us"
  permit_params :full_name, :email_address, :mobile_no, :message

  index title: CONTACT_US do
    selectable_column
    id_column
    column :full_name
    column :email_address
    column :mobile_no
    column :message
    actions
  end
end
