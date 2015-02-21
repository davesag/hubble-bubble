require 'fileutils'
require 'nokogiri'
require 'cobravsmongoose'
require 'slim'

module HubbleBubble
  
  UNKNOWN = 'Unknown'
  
  class App
    
    DEFAULTS = {
      input_file:    'brief/works.xml',
      output_folder: 'output'
    }

    def initialize(paths)
      @input_file    = path_to_file(paths[0])
      @output_folder = path_to_folder(paths[1])
      run
    end

    private

    def run
      create_folder 'makes'
      create_folder 'models'
      reader    = WorksReader.new(@input_file)
      presenter = WorksPresenter.new(reader.to_works)
      writer    = WorksWriter.new(presenter, @output_folder)
      writer.write
    end

    def path_to_file(path)
      path ||= DEFAULTS[:input_file]
      raise ArgumentError, "No file at path #{path}" unless File.exists?(path)
      File.open(path, "r")
    end

    def path_to_folder(path)
      path ||= DEFAULTS[:output_folder]
      FileUtils::mkdir_p path unless File.exists?(path)
      path
    end
    
    def create_folder(path)
      FileUtils::mkdir_p File.join(@output_folder, path) unless File.exists?(path)
    end
    
  end

  class WorksReader

    def initialize(file)
      @file = file
    end

    def to_works
      doc = Nokogiri::XML(@file) do |config|
        config.strict.nonet
      end
      doc.xpath("//work").map do |work|
        # http://stackoverflow.com/questions/26380935/convert-xml-to-ruby-hash-with-attributes
        CobraVsMongoose.xml_to_hash(work.to_s)['work']
      end
    end

  end

  class WorksWriter

    def initialize(presenter, output_folder)
      @presenter = presenter
      @output_folder = output_folder
    end

    def write
      page = @presenter.render_index
      emit page[:html], File.join(@output_folder, "#{page[:filename]}.html")
      @presenter.render_camera_makes.each do |page|
        emit page[:html], File.join(@output_folder, 'makes', "#{page[:filename]}.html")
      end
      @presenter.render_camera_models.each do |page|
        emit page[:html], File.join(@output_folder, 'models', "#{page[:filename]}.html")
      end
    end

    private
    
    def emit(html, to_path)
      File.open(to_path, 'w') { |file| file.write html }
    end
  end

  class WorksPresenter

    attr_reader :title, :thumbnails, :navigation

    def initialize(works)
      @works = works
      @title = ''
      @thumbnails = []
      @navigation = []
    end

    # The index HTML page must contain:
    # - Thumbnail images for the first 10 work
    # - Navigation that allows the user to browse to all camera makes
    def render_index

    end

    # Each Camera Make HTML page must contain:
    # - Thumbnail images of the first 10 works for that camera make
    # - Navigation that allows the user to browse to the index page and to all camera models of that make
    def render_camera_makes

    end
    
    # Each Camera Model HTML page must contain:
    # - Thumbnail images of all works for that camera make and model
    # - Navigation that allows the user to browse to the index page and the camera make
    def render_camera_models

    end

  end

end

if __FILE__ == $0
  $stdout.sync = true
  app = HubbleBubble::App.new(ARGV)
end
