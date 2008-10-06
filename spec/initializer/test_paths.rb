require File.dirname(__FILE__) + "/../test_helper"

context "Files from config" do
  
  include PathsTestHelper
  
  test "the old way of doing paths should not still be around" do
    should.not.respond_to(:all_helpers)
    should.not.respond_to(:helper_path)
  end
  
  test "should work when only one filename is present" do
    mock_ahnrc_with "paths:\n    init: foobar.rb"
    Adhearsion::AHN_CONFIG.files_from_setting("paths", "init").should.eql ["foobar.rb"]
  end
  
  test "should work when an Array of filenames is present" do
    yaml = <<-YML
paths:
  init:
    - foo.rb
    - bar.rb
    - qaz.rb
    YML
    Adhearsion::AHN_CONFIG.ahnrc = yaml
    Adhearsion::AHN_CONFIG.files_from_setting("paths", "init").should.eql(%w[foo.rb bar.rb qaz.rb])
  end
  
  test "should work when one glob filename is present" do
    files = %w[foo.rb bar.rb qaz.rb]
    flexmock(Dir).should_receive(:glob).once.with("*.rb").and_return files
    yaml = <<-YML
    paths:
      init: *.rb
    YML
    Adhearsion::AHN_CONFIG.ahnrc = yaml
    Adhearsion::AHN_CONFIG.files_from_setting("paths", "init").should.eql(%w[foo.rb bar.rb qaz.rb])
  end
    
  test "should work when an Array of globs are present" do
    files = %w[aaa.rb aba.rb aca.rb]
    yaml = <<-YML
paths:
  init:
#{
    files.map { |f| "    - #{f}" }
}
    YML
    Adhearsion::AHN_CONFIG.files_from_setting("paths", "init").should.eql(%w[foo.rb bar.rb qaz.rb])
  end
  
end

BEGIN {
  module PathsTestHelper
    def mock_ahnrc_with(raw_yaml)
      Adhearsion::AHN_CONFIG.ahnrc = YAML.load raw_yaml
    end
  end
}