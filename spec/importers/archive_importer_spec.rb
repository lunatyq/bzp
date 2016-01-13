require 'spec_helper'

describe ArchiveImporter do
  let(:path) { 'spec/fixtures/archives/2015/20151208.exe' }
  let(:importer) { ArchiveImporter.new(path, :output_root => tmpdir) }
  let(:tmpdir) { Dir.mktmpdir }

  it 'imports publications' do
    importer.run
  end
end
