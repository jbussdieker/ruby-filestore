require 'filestore'
require 'tmpdir'

RSpec.configure do |c|
  c.around(:each) do |example|
    Dir.mktmpdir do |dir|
      @dir = dir
      example.run
    end
  end
end

def factory(path, value)
  dirname = File.dirname(path)
  FileUtils.mkdir_p dirname
  File.open(path, "w") {|f| f.write(value) }
end
