require_relative 'spec_helper'
require_relative '../hubble_bubble'

describe HubbleBubble do

  let(:xml)       { File.open('brief/works.xml', 'rb') }
  let(:all_makes) {
    [
      "Canon",
      "FUJI PHOTO FILM CO., LTD.",
      "FUJIFILM",
      "LEICA",
      "NIKON CORPORATION",
      "Panasonic",
      "Unknown"
    ]
  }
  let(:all_models) {
    [
      'Canon EOS 20D',
      'Canon EOS 400D DIGITAL',
      'D-LUX 3',
      'DMC-FZ30',
      'FinePix S6500fd',
      'NIKON D80',
      'SLP1000SE',
      'Unknown'
    ]
  }

  describe HubbleBubble::WorksReader do

    it "can read an XML file without errors" do
      skip "Not yet implemented"
    end

  end
  
  describe HubbleBubble::WorksWriter do

    output_folder = 'tmp'

    let(:filename)      { "test.html" }
    let(:output_file)   { File.join(output_folder, filename) }
    let(:test_string)   { "<p>This is a test</p>" }
    let(:text_read_in)  { File.read(output_file)  }

    before :all do
      FileUtils::mkdir_p output_folder unless File.exists?(output_folder)
    end

    after :all do
      FileUtils.rm_rf(output_folder, secure: true)
    end

    it "emits a file without errors" do
      skip "Not yet implemented"
    end

  end

  describe HubbleBubble::WorksPresenter do
    let(:make_name)  { 'NIKON CORPORATION' }
    let(:model_name) { 'NIKON D80' }

    describe "rendering partial" do

      it "renders a valid partial" do
        skip "Not yet implemented"
      end
    end

    describe "rendering view" do

      it "renders a valid view" do
        skip "Not yet implemented"
      end
    end

    describe "generating titles" do
      let(:title_text) { 'This is a test'                        }
      let(:expected)   { "RedBubble | #{title_text}"             }
    
      it "can build a consistent title" do
        skip "Not yet implemented"
      end
    end
    
    describe "model names with no make supplied" do

      it "can extract an alphabetically sorted list of model names" do
        skip "Not yet implemented"
      end

    end

    describe "model names with known make supplied" do
      let(:expected)    { [model_name] }
      it "can extract a list of model names" do
        skip "Not yet implemented"
      end
    end

    describe "make names" do

      it "can extract an alphabetically sorted list of make names" do
        skip "Not yet implemented"
      end
    end

    describe "given a name with a mix of cases, letters, punctuation, spaces, and numbers" do
      let(:name)     { 'This is!: #Entirely-0--unsuitable.' }
      let(:expected) { 'this-is-entirely-0-unsuitable'      }
      
      it "generates a sensible slug" do
        skip "Not yet implemented"
      end
    end

    describe "given a work with a filename" do
      let(:expected)   { '162042'                 }
      let(:f_expected) { "#{expected}.jpg"        }
      
      it "generates a sensible name" do
        skip "Not yet implemented"
      end

      it "returns the filename" do
        skip "Not yet implemented"
      end
    end

    describe "given 'unknown' as a make name" do
    
      it "returns a list of works with nil as a make name" do
        skip "Not yet implemented"
      end

    end

    describe "given a known make name" do
    
      it "returns a list of works with the correct make name" do
        skip "Not yet implemented"
      end

    end

    describe "given 'unknown' as a make and model name" do
      let(:junk)                      { 'this is not a known model name'     }

      it "returns a list of works with nil as a model name and nil and a make name" do
        skip "Not yet implemented"
      end

      it "returns 'unknown' given an the model name 'unknown'" do
        skip "Not yet implemented"
      end

      it "returns 'unknown' given an unknown the model name" do
        skip "Not yet implemented"
      end
    end

    describe "given a known make and model name" do
      
      it "returns a list of works with the correct model name" do
        skip "Not yet implemented"
      end

      it "returns the correct camera make for a known model name" do
        skip "Not yet implemented"
      end

    end

    describe "given a work with multiple urls" do
      let(:expected)  { 'http://ih1.redbubble.net/work.31820.1.flat,135x135,075,f.jpg' }

      it "can extract the small one" do
        skip "Not yet implemented"
      end
    end

    describe "wrapping it all up" do
      describe "render_index" do
        let(:expected_filename) { 'index' }

        it "renders the index" do
          skip "Not yet implemented"
        end
      end

      describe "render_camera_makes" do

        it "renders the right number of camera make pages" do
          skip "Not yet implemented"
        end
      end

      describe "render_camera_models" do

        it "renders the right number of camera model pages" do
          skip "Not yet implemented"
        end
      end
    end

  end
  
end
