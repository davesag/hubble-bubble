require_relative 'spec_helper'
require_relative '../hubble_bubble'

describe HubbleBubble do

  let(:xml)       { File.open('brief/works.xml', 'rb') }
  let(:reader)    { HubbleBubble::WorksReader.new(xml) }
  let(:works)     { reader.to_works }
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
      pending "The test is implemented but the code to pass it is not."
      expect(works).not_to be_nil
      expect(works).to be_instance_of Array
      expect(works[0]).to be_instance_of Hash
      expect(works.length).to be 14
    end

  end
  
  describe HubbleBubble::WorksWriter do

    output_folder = 'tmp'

    let(:filename)      { "test.html" }
    let(:output_file)   { File.join(output_folder, filename) }
    let(:writer)        { HubbleBubble::WorksWriter.new(works, output_folder) }
    let(:test_string)   { "<p>This is a test</p>" }
    let(:text_read_in)  { File.read(output_file)  }

    before :all do
      FileUtils::mkdir_p output_folder unless File.exists?(output_folder)
    end

    after :all do
      FileUtils.rm_rf(output_folder, secure: true)
    end

    it "emits a file without errors" do
      pending "The test is implemented but the code to pass it is not."
      writer.send :emit, test_string, output_file
      expect(File.exists?(output_file)).to eq true
      expect(text_read_in).to eq test_string
    end

  end

  describe HubbleBubble::WorksPresenter do
    let(:presenter)  { HubbleBubble::WorksPresenter.new(works) }
    let(:make_name)  { 'NIKON CORPORATION' }
    let(:model_name) { 'NIKON D80' }

    describe "rendering partial" do
      let(:partial) { presenter.partial(:thumbnails) }

      it "renders a valid partial" do
        pending "The test is implemented but the code to pass it is not."
        expect(partial).to include "No thumbnails"
      end
    end

    describe "rendering view" do
      let(:view) { presenter.send :render, :index }

      it "renders a valid view" do
        pending "The test is implemented but the code to pass it is not."
        expect(view).to include "!DOCTYPE html"
      end
    end

    describe "generating titles" do
      let(:title_text) { 'This is a test'                        }
      let(:expected)   { "RedBubble | #{title_text}"             }
      let(:title)      { presenter.send :build_title, title_text }
    
      it "can build a consistent title" do
        pending "The test is implemented but the code to pass it is not."
        expect(title).to eq expected
      end
    end
    
    describe "model names with no make supplied" do
      let(:model_names) { presenter.send :model_names }

      it "can extract an alphabetically sorted list of model names" do
        pending "The test is implemented but the code to pass it is not."
        expect(model_names).to eq all_models
      end

    end

    describe "model names with known make supplied" do
      let(:model_names) { presenter.send :model_names, make_name }
      let(:expected)    { [model_name] }
      it "can extract a list of model names" do
        pending "The test is implemented but the code to pass it is not."
        expect(model_names).to eq expected
      end
    end

    describe "make names" do
      let(:make_names) { presenter.send :make_names }

      it "can extract an alphabetically sorted list of make names" do
        pending "The test is implemented but the code to pass it is not."
        expect(make_names).to eq all_makes
      end
    end

    describe "given a name with a mix of cases, letters, punctuation, spaces, and numbers" do
      let(:name)     { 'This is!: #Entirely-0--unsuitable.' }
      let(:slug)     { presenter.slug(name)                 }
      let(:expected) { 'this-is-entirely-0-unsuitable'      }
      
      it "generates a sensible slug" do
        pending "The test is implemented but the code to pass it is not."
        expect(slug).to eq expected
      end
    end

    describe "given a work with a filename" do
      let(:work)       { works[0]                 }
      let(:name)       { presenter.name(work)     }
      let(:expected)   { '162042'                 }
      let(:filename)   { presenter.filename(work) }
      let(:f_expected) { "#{expected}.jpg"        }
      
      it "generates a sensible name" do
        pending "The test is implemented but the code to pass it is not."
        expect(name).to eq expected
      end

      it "returns the filename" do
        pending "The test is implemented but the code to pass it is not."
        expect(filename).to eq f_expected
      end
    end

    describe "given 'unknown' as a make name" do
      let(:works_with_make) { presenter.send :works_with_make,  HubbleBubble::UNKNOWN }
    
      it "returns a list of works with nil as a make name" do
        pending "The test is implemented but the code to pass it is not."
        expect(works_with_make.length).to eq 2
        works_with_make.each { |w| expect(w['exif']['make']).to be_nil }
      end

    end

    describe "given a known make name" do
      let(:works_with_make) { presenter.send :works_with_make,  make_name }
    
      it "returns a list of works with the correct make name" do
        pending "The test is implemented but the code to pass it is not."
        expect(works_with_make.length).to eq 1
        expect(works_with_make[0]['exif']['make']['$']).to eq make_name
      end

    end

    describe "given 'unknown' as a make and model name" do
      let(:works_with_make_and_model) { presenter.send :works_with_make_and_model,  HubbleBubble::UNKNOWN, HubbleBubble::UNKNOWN }
      let(:make_for_model)            { presenter.send :make_for_model, HubbleBubble::UNKNOWN }
      let(:junk)                      { 'this is not a known model name'     }
      let(:make_for_junk_model)       { presenter.send :make_for_model, junk }

      it "returns a list of works with nil as a model name and nil and a make name" do
        pending "The test is implemented but the code to pass it is not."
        expect(works_with_make_and_model.length).to eq 2
        works_with_make_and_model.each do |w|
          expect(w['exif']['make']).to  be_nil
          expect(w['exif']['model']).to be_nil
        end
      end

      it "returns 'unknown' given an the model name 'unknown'" do
        pending "The test is implemented but the code to pass it is not."
        expect(make_for_model).to eq HubbleBubble::UNKNOWN
      end

      it "returns 'unknown' given an unknown the model name" do
        pending "The test is implemented but the code to pass it is not."
        expect(make_for_junk_model).to eq HubbleBubble::UNKNOWN
      end
    end

    describe "given a known make and model name" do
      let(:works_with_make_and_model) { presenter.send :works_with_make_and_model,  make_name, model_name }
      let(:make_for_model)            { presenter.send :make_for_model, model_name }
      
      it "returns a list of works with the correct model name" do
        pending "The test is implemented but the code to pass it is not."
        expect(works_with_make_and_model.length).to eq 1
        expect(works_with_make_and_model[0]['exif']['make']['$']).to  eq make_name
        expect(works_with_make_and_model[0]['exif']['model']['$']).to eq model_name
      end

      it "returns the correct camera make for a known model name" do
        pending "The test is implemented but the code to pass it is not."
        expect(make_for_model).to eq make_name
      end

    end

    describe "given a work with multiple urls" do
      let(:work)      { works[0] }
      let(:small_url) { presenter.url(work, 'small') }
      let(:expected)  { 'http://ih1.redbubble.net/work.31820.1.flat,135x135,075,f.jpg' }

      it "can extract the small one" do
        pending "The test is implemented but the code to pass it is not."
        expect(small_url).to eq expected
      end
    end

    describe "wrapping it all up" do
      describe "render_index" do
        let(:page_info)         { presenter.send :render_index }
        let(:expected_filename) { 'index' }

        it "renders the index" do
          pending "The test is implemented but the code to pass it is not."
          expect(page_info[:filename]).to eq expected_filename
        end
      end

      describe "render_camera_makes" do
        let(:page_info) { presenter.send :render_camera_makes }

        it "renders the right number of camera make pages" do
          pending "The test is implemented but the code to pass it is not."
          expect(page_info.length).to eq all_makes.length
        end
      end

      describe "render_camera_models" do
        let(:page_info) { presenter.send :render_camera_models }

        it "renders the right number of camera model pages" do
          pending "The test is implemented but the code to pass it is not."
          expect(page_info.length).to eq all_models.length
        end
      end
    end

  end
  
end
