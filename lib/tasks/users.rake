namespace :users do
  desc "Create super admin"
  task :create_super_admin => :environment do
	password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
	super_admin = SuperAdmin.new(email: 'super_admin@test.com', password: password)
	if super_admin.save
		puts password
	else
		puts "Super Admin already existing"
	end
  end

  desc "Update super admin password"
  task :update_password => :environment do
	password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
	super_admin = SuperAdmin.where(email: 'super_admin@test.com').first
	unless super_admin
		puts "Super admin user doesn't exists"	
		return
	end
	super_admin.password = password
	if super_admin.save
		puts password
	else
		puts "Not able to update"
	end
  end
end