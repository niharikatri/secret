ActiveAdmin.register AccountBlock::Character, as: "Characters" do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :image
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  show do 
    attributes_table do 
      row :name
      row :image do |object|
        image_tag object.image, size: "200x200" if object.image.present?
      end
    end
  end

  form do |f|
    f.inputs
    f.inputs do 
      f.input :image, as: :file, required: true, input_html: {accept: ".gif, .jpg, .png, .jpeg"}
    end
    f.actions
  end

  controller do
    def create 
      super do |format| 
        redirect_to(
          admin_characters_path,
          notice: 'Character Successfully Created '
        ) and return
      end
    end

    def update 
      super do |format| 
        redirect_to(
          admin_characters_path,
          notice: 'Character Successfully Updated '
        ) and return
      end
    end

    def destroy 
      super do |format| 
        redirect_to(
          admin_characters_path,
          notice: 'Character Successfully Destroyed'
        ) and return
      end
    end
  end
end
