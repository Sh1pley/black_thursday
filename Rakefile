require 'rake'
require 'rake/testtask'
require 'rake'

task default: :test
namespace :sanitation do
  desc "Check line lengths & whitespace with Cane"
  task :lines do
    puts ""
    puts "== using cane to check line length =="
    system("cane --no-abc --style-glob 'lib/**/*.rb' --no-doc")
    puts "== done checking line length =="
    puts ""
  end

  desc "Check method length with Reek"
  task :methods do
    puts ""
    puts "== using reek to check method length =="
    system("reek -n lib/*.rb 2>&1 | grep -v ' 0 warnings'")
    puts "== done checking method length =="
    puts ""
  end

  desc "Check both line length and method length"
  task :all => [:lines, :methods]
  end

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.warning = false
  test.verbose = false
  test.test_files = FileList['test/*_test.rb'].exclude("test/test_helper.rb")
end
task default: :test