require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/pagarme/**/*_test.rb']
end

task :default => :test

task :clean_vcr do
  sh 'rm -rf test/vcr_cassettes'
end

# task :all do
#   Rake::Task['test'].invoke
#   require 'active_support/all'
#   Rake::Task['test'].reenable
#   Rake::Task['test'].invoke
# end
