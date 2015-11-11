gh_users             = node['securize']['sshkeys']['gh_users']
keys_file            = "#{Dir.mktmpdir}/gh.keys"
authorized_keys_file = "/home/#{node['securize']['deploy_user']}/.ssh/authorized_keys"

unless gh_users.empty?

  Array(gh_users).each do |user|
    remote_file keys_file do
      source "#{node['securize']['sshkeys']['gh_url']}/#{user}.keys"
    end

    ruby_block "add_key" do
      block do
        IO.readlines(keys_file).each do |line|
          file = Chef::Util::FileEdit.new(authorized_keys_file)
          file.insert_line_if_no_match(/#{line}/, line)
          file.write_file
        end
      end
      notifies :run, "ruby_block[remove_duplicates]", :immediately
      only_if { File.exists?(authorized_keys_file) }
    end
  end

  ruby_block "remove_duplicates" do
    block do
      # TODO: must be a better way
      uniq_keys = File.readlines(authorized_keys_file).uniq
      FileUtils.cp(authorized_keys_file, authorized_keys_file + ".bak")
      File.open(authorized_keys_file, "w+") { |f| f.puts uniq_keys  }
    end
    action :nothing # This run only if add_key is succeful
  end
  
else
  log "gh_users empty" do
    level :warn
    message "gh_users key is empty, please add some Github users to populate"
  end
end

