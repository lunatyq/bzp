class ArchiveImporter
  vattr_initialize :path, [:output_root]

  attr_accessor :archive

  def self.run(year = Date.today.year)
    files = Dir.glob(Rails.root.join("data/ftp.uzp.gov.pl/bzp/xml/#{year}/*.exe"))
    files.sort.each do |file|
      importer = new(file, output_root: Rails.root.join('data/xml'))

      unless importer.archive_exists?
        importer.run
      end
    end
  end

  def run
    find_or_create_archive
    build_publications do |publication|
      if publication.save
        puts publication.name.green
      else
        puts "#{publication.name} #{publication.errors.full_messages}".red
      end
    end
  end

  def archive_exists?
    Archive.where(archive_attributes).exists?
  end

  private

  def build_publications
    each_publication do |publication_attributes|
      yield archive.publications.build(publication_attributes)
    end
  end

  def each_publication
    extract_publications.each do |publication_path|
      xml = File.read(publication_path)
      yield(PublicationParser.new(xml).run)
    end
  end

  def extract_publications
    RarExtractor.new(path, :destination => output_path).run
  end

  def find_or_create_archive
    self.archive = Archive.find_or_create_by!(archive_attributes)
  end

  def archive_attributes
    {
      published_on: published_on,
      year: year
    }
  end

  def output_path
    File.join(output_root, year.to_s, name)
  end

  def published_on
    Date.parse(name)
  end

  def year
    published_on.year
  end

  def filename
    File.basename(path)
  end

  def name
    File.basename(filename, '.*')
  end
end
