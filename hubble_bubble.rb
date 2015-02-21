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
      Slim::Engine.set_options(pretty: true, format: :html)
      @works = works
      @layout = Slim::Template.new { File.read("views/page.slim") }
      @title = ''
      @thumbnails = []
      @navigation = []
    end

    # The index HTML page must contain:
    # - Thumbnail images for the first 10 work
    # - Navigation that allows the user to browse to all camera makes
    def render_index
      @title = build_title('Index')
      @thumbnails = @works.first(10)
      @navigation = make_names
      {html: render(:index), filename: 'index'}
    end

    # Each Camera Make HTML page must contain:
    # - Thumbnail images of the first 10 works for that camera make
    # - Navigation that allows the user to browse to the index page and to all camera models of that make
    def render_camera_makes
      make_names.map do |make|
        @title = build_title("Camera maker #{make}")
        @thumbnails = works_with_make(make).first(10)
        @navigation = model_names(make)
        {html: render(:make), filename: slug(make)}
      end
    end
    
    # Each Camera Model HTML page must contain:
    # - Thumbnail images of all works for that camera make and model
    # - Navigation that allows the user to browse to the index page and the camera make
    def render_camera_models
      [{html: "<p>This is just a test</p>", filename: 'model'}]
    end

    def slug(name)
      name.downcase.gsub(/[^a-z0-9]+/,'-').chomp('-')
    end

    def name(work)
      filename(work).gsub(/\.[^.]*\Z/, '')
    end

    def filename(work)
      work['filename']['$']
    end

    def url(work, size)
      url_array = work['urls']['url']
      url_index = url_array.find_index { |url| url['@type'] == size }
      url_array[url_index]['$']
    end

    def partial(name)
      file_path = File.join('views', "_#{name.to_s}.slim")
      return unless File.exists?(file_path)
      content = File.read(file_path)
      Slim::Template.new { content }.render(self)
    end

    private
    
    def render(view)
      @layout.render(self) { "navigation_#{view.to_s}".to_sym }
    end

    def works_with_make(a_make)
      @works.select { |w| make(w) == a_make }
    end

    def model_names(a_make =  nil)
      if a_make
        (works_with_make(a_make).map {|w| model(w)}).uniq.sort
      else
        (@works.map {|w| model(w)}).uniq.sort
      end
    end

    def make_names
      (@works.map {|w| make(w)}).uniq.sort
    end

    def build_title(text)
      "RedBubble | #{text}"
    end

    def make(work)
      return UNKNOWN unless has_make?(work)
      work['exif']['make']['$']
    end

    def has_make?(work)
      has_exif?(work) && !work['exif']['make'].nil?
    end

    def has_exif?(work)
      !work['exif'].nil?
    end

  end

end

if __FILE__ == $0
  $stdout.sync = true
  app = HubbleBubble::App.new(ARGV)
end
