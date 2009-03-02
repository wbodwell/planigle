# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

@@Windows = RUBY_PLATFORM.include? "mswin32"

if @@Windows
  require 'win32/sound'
  include Win32
end

namespace :build do
  desc "Build the Flex components in test mode"
  task(:test) do
    puts %x[mxmlc.exe -compiler.debug --services=src/services-config.xml -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -link-report=report.xml --include-libraries libs\\FunFXAdapter.swc libs\\automation_agent.swc libs\\automation.swc libs\\automation_agent_rb.swc -output=public\\Main.swf src\\Main.mxml]
    puts %x[mxmlc.exe -compiler.debug --services=src/services-config.xml -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -load-externs=report.xml -output=public\\modules\\Core.swf src\\modules\\Core.mxml]
    puts %x[mxmlc.exe -compiler.debug --services=src/services-config.xml -compiler.source-path=src -compiler.source-path+=public -library-path+=libs --include-libraries libs\\FunFXAdapter.swc libs\\automation_agent.swc libs\\automation.swc libs\\automation_agent_rb.swc -output=public\\Survey.swf src\\Survey.mxml]
    puts %x[del report.xml]
    if @@Windows
      Sound.play('tada.wav')
    end
  end

  desc "Build the Flex components in debug mode"
  task(:debug) do
    puts %x[mxmlc.exe -compiler.debug --services=src/services-config.xml -compiler.incremental -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -link-report=report.xml -output=public\\Main.swf src\\Main.mxml]
    puts %x[mxmlc.exe -compiler.debug --services=src/services-config.xml -compiler.incremental -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -load-externs=report.xml -output=public\\modules\\Core.swf src\\modules\\Core.mxml]
    puts %x[mxmlc.exe -compiler.debug --services=src/services-config.xml -compiler.incremental -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -output=public\\Survey.swf src\\Survey.mxml]
    puts %x[del report.xml]
    if @@Windows
      Sound.play('tada.wav')
    end
  end

  desc "Build the Flex components in production mode"
  task(:production) do
    puts %x[mxmlc.exe -show-unused-type-selector-warnings=false --services=src/services-config.xml -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -link-report=report.xml -output=public\\Main.swf src\\Main.mxml]
    puts %x[mxmlc.exe --services=src/services-config.xml -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -load-externs=report.xml -output=public\\modules\\Core.swf src\\modules\\Core.mxml]
    puts %x[mxmlc.exe -show-unused-type-selector-warnings=false --services=src/services-config.xml -compiler.source-path=src -compiler.source-path+=public -library-path+=libs -output=public\\Survey.swf src\\Survey.mxml]
    puts %x[del report.xml]
    if @@Windows
      Sound.play('tada.wav')
    end
  end
end

namespace :test do
  desc "Run the Flex tests in test/flex"
  Rake::TestTask.new(:flex => "db:test:prepare") do |t|
    t.libs << "test" 
    t.pattern = 'test/flex/**/*_test.rb'
    t.verbose = true
  end
end