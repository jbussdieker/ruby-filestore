class FileStore
  def initialize(root)
    @root = root
  end

  def get(key)
    read_key(key)
  end

  def set(key, value)
    write_key(key, value)
  end

  def delete(key)
    delete_key(key)
  end

  def exists?(key)
    check_key(key)
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def check_key(key)
    File.exists?(key_path(key))
  end

  def delete_key(key)
    return unless check_key(key)
    File.unlink(key_path(key))
  end

  def write_key(key, value)
    File.open(key_path_ensure_present(key), "w") do |f|
      f.write(value)
    end
  end

  def read_key(key)
    return unless check_key(key)
    File.read(key_path(key))
  end

  def key_path(key)
    File.join(@root, key)
  end

  def key_path_ensure_present(key)
    key_path(key).tap do |path|
      FileUtils.mkdir_p(File.dirname(path))
    end
  end
end
