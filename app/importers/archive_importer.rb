class ArchiveImporter
  vattr_initialize :path, [:output_root]

  attr_accessor :archive

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
    self.archive = Archive.find_or_create_by!(
      published_on: published_on,
      year: year
    )
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
