class RarUnpacker
  vattr_initialize :source_path, [:destination]

  def run
    ensure_destination_exists
    result = `#{command}`

    if result.include?('All OK')
      list_files
    else
      puts result
      raise "Error Extractiong #{source_path}"
    end
  end

  def list_files
    Dir.glob(File.join(destination, '**/*'))
  end

  def command
    "unrar x #{safe_source_path} #{safe_destination}"
  end

  def ensure_destination_exists
    FileUtils.mkdir_p(destination)
  end

  def safe_source_path
    Shellwords.escape(source_path)
  end

  def safe_destination
    Shellwords.escape(destination)
  end
end
