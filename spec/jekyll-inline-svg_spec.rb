# encoding: UTF-8

require 'spec_helper'
require "nokogiri"

describe(Jekyll::Tags::JekyllInlineSvg) do
  let(:overrides) do
    {
      "source"      => source_dir,
      "destination" => dest_dir,
      "url"         => "http://example.org",
    }
  end
  let(:config) do
    Jekyll.configuration(overrides)
  end
  let(:site)     { Jekyll::Site.new(config) }
  def read(f)
    File.read(dest_dir(f))
  end
  def parse(f)
    Nokogiri::XML(read(f))
  end

  describe "Integration" do
    before(:each) do
      site.process
    end
    it "render site" do
      expect(File.exist?(dest_dir("index.html"))).to be_truthy
    end
    it "exports svg" do
      data = /((?<svg_tag>\<svg[^>]*\>)(?<rest>.*)\<\/svg\>)/m.match(read("index.html"))
      expect(data).to be_truthy
      expect(data["svg_tag"]).to be_truthy
      expect(data["svg_tag"]).to_not include("width=") #width property should be stripped
      expect(data["svg_tag"]).to_not include("height=")
      # Do not strip other width and height attributes
      expect(data["rest"]).to include("width=\"20\"") #width property should be stripped
      expect(data["rest"]).to include("height=\"20\"")
    end
  end

  describe "Parse parameters" do
    it "parse XML root parameters" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("/path/to/foo size=40 style=\"hello\"")
      expect(svg).to eq("/path/to/foo")
      expect(params).to eq("size=40 style=\"hello\"")
    end
    it "accepts double quoted names" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("\"/path/to/foo space\"")
      expect(svg).to eq("/path/to/foo space")
    end
    it "accepts single quoted names" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("'/path/to/foo space'")
      expect(svg).to eq("/path/to/foo space")
    end
    it "don't parse parameters" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("'/path/to/foo space' id='bar' style=\"hello\"")
      expect(params).to eq("id='bar' style=\"hello\"")
    end
  end
end
