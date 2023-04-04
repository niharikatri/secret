module Dashboard
  class Load
    @@loaded_from_gem = false
    def self.is_loaded_from_gem
      @@loaded_from_gem
    end

    def self.loaded
    end

    # Check if this file is loaded from gem directory or not
    # The gem directory looks like
    # /template-app/.gems/gems/bx_block_custom_user_subs-0.0.7/app/admin/subscription.rb
    # if it has block's name in it then it's a gem
    @@loaded_from_gem = Load.method('loaded').source_location.first.include?('bx_block_')
  end
end

unless Dashboard::Load.is_loaded_from_gem
  ActiveAdmin.register_page "Dashboard" do
    menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

    content title: proc { I18n.t("active_admin.dashboard") } do
      # div class: "blank_slate_container", id: "dashboard_default_message" do
      #   span class: "blank_slate" do
      #     span I18n.t("active_admin.dashboard_welcome.welcome")
      #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
      #   end
      # end
      
      columns do
        column  do
          panel "Total Users" do
            h5 do
              link_to AccountBlock::Account.count, "/admin/user_managements"
            end
          end
        end
        column  do
          panel "Deactivated Accounts" do
            h5 do
              link_to AccountBlock::Account.deactivated.count, '/admin/user_managements?scope=deactivated'
            end
          end
        end
        column  do
          panel "Blacklisted Accounts" do
            h5 do
              link_to AccountBlock::Account.where(is_blacklisted: true).count, '/admin/user_managements?q[is_blacklisted_eq]=true&commit=Filter&order=id_desc'
            end
          end
        end
        column  do
          panel "User Groups" do
            h5 do
              AccountBlock::Account.pluck(:unique_code).uniq.compact.count
            end
          end
        end
      end
    end # content
  end
end
