ActiveAdmin.register AccountBlock::Voice, as: "Voices" do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :audio

  show do 
    attributes_table do 
      row :name
      row :audio do |object|
        audio_tag(url_for(object.audio), controls: true) if object.audio.attached?
      end
    end
  end
 
  form do |f|
    f.inputs
    f.inputs do 
      f.input :audio, as: :file, required: true, input_html: {accept: ".mp3, .wav"}
    end
    f.actions
  end
end
