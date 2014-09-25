require "bundler/gem_tasks"

task :default => [:all]

task :test, :test_file do |t, args| 
  ret = true
  test_file = args[:test_file]

  if args[:test_file]
	f = "test/pagarme/#{args[:test_file]}.rb"
	ret = ret && ruby(f, '')
  else
	Dir["test/**/*.rb"].each do |f|
    ret = ret && ruby(f, '')
  end
  end
end

task :all do
  Rake::Task["test"].invoke
  require 'active_support/all'
  Rake::Task["test"].reenable
  Rake::Task["test"].invoke
end
