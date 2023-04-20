ActiveAdmin.register BxBlockAdmin::ContactUs, as: "Contact Us" do
  menu parent: 'App Settings'
  permit_params :full_name, :email_address, :mobile_no, :message
  actions :index, :show, :destroy
end
