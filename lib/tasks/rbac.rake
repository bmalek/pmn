namespace :db do

  desc "Load rights from controllers in FS"
  task :populate_rights => :environment do

    controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries

    controllers.each do |controller|
      if controller =~ /_controller/
      controller_name = controller.camelize.gsub(".rb","")
      (
        eval("#{controller_name}.new.methods") -
        ApplicationController.methods -
        Object.methods -
        ApplicationController.new.methods).sort.each { |action|
        name_short = controller_name.gsub("Controller","").downcase
        Right.create(:name => "#{name_short}.#{action}", :controller => name_short, :action => action)
        }
      end

    end
    
  end

  desc 'sets the roles and rights for the admin and user'
  task :rbac => 'db:populate_rights' do

    #create the basic roles
    ['superadmin', 'admin', 'user'].each { |r| Role.create(:name => r) }

    #create the admin user
    User.create( :username => 'superadmin', :password => 'pass20', :primarynumber => '0000' )

    #create the admin role and assign all the rights to it
    User.find_by_username('superadmin').roles << Role.find_by_name('superadmin')

    #add all the rights to the admin role
    #Right.synchronize
    Right.find(:all).each { |right| Role.find_by_name('superadmin').rights << right }
    
  end
end