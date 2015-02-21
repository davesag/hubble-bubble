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
    end

  end

  class WorksReader

    def initialize(file)
      @file = file
    end

  end

  class WorksWriter

    def initialize(presenter, output_folder)
      @presenter = presenter
      @output_folder = output_folder
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
