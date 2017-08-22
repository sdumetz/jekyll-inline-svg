# encoding: UTF-8

require 'spec_helper'
require "nokogiri"

describe(Jekyll::Tags::JekyllInlineSvg) do

  def read(f)
    File.read(dest_dir(f))
  end
  # return an array of the page's svgs
  def parse(f)
    Nokogiri::HTML(read(f))
  end

  describe "Parse parameters" do
    it "parse XML root parameters" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("/path/to/foo size=40 style=\"hello\"")
      expect(svg).to eq("/path/to/foo")
      expect(params).to eq("size=40 style=\"hello\"")
    end
    it "accepts double quoted path" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("\"/path/to/foo space\"")
      expect(svg).to eq("/path/to/foo space")
    end
    it "accepts single quoted path" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("'/path/to/foo space'")
      expect(svg).to eq("/path/to/foo space")
    end
    it "strip leading and trailing spaces" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params(" /path/to/foo ")
      expect(svg).to eql("/path/to/foo")
    end
    # required when a variable is defined with leading/trailing space then embedded.
    it "strip in-quote leading and trailing spaces" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("'/path/to/foo '")
      expect(svg).to eql("/path/to/foo")
    end
    it "don't parse parameters" do
      svg, params = Jekyll::Tags::JekyllInlineSvg.parse_params("'/path/to/foo space' id='bar' style=\"hello\"")
      expect(params).to eq("id='bar' style=\"hello\"")
    end
  end

  describe "Interpolate variables" do

  end

  describe "Integration" do

    before(:context) do
      config = Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "url"         => "http://example.org",
      })
      site = Jekyll::Site.new(config)
      site.process
      @data = parse("index.html")
      @base = @data.css("#base").css("svg").first
    end
    it "render site" do
      expect(File.exist?(dest_dir("index.html"))).to be_truthy
    end
    it "exports svg" do
      data = @data.xpath("//svg")
      expect(data).to be_truthy
      expect(data.first).to be_truthy
      expect(@base).to be_truthy
      expect(@base["width"]).to be_falsy #width property should be stripped
      expect(@base["height"]).to be_falsy
      # Do not strip other width and height attributes
    end
    it "parse relative paths" do
      data = @data.css("#path").css("svg")
      expect(data.size).to eq(2)
      expect(data[0].to_html).to eq(data[1].to_html) #should use to_xml?
    end
    it "jails to Jekyll source" do
      data = @data.css("#jail").css("svg")
      ref = @base.to_xml
      expect(data.size).to eq(2)
      data.each{ |item| expect(item.to_xml).to eql(ref) }
    end
    it "interpret variables" do
      data = @data.css("#interpret").css("svg")
      ref = @base.to_xml
      expect(data.size).to eq(2)
      expect(data[0].to_xml).to eql(ref)
      expect(data[1].get_attribute("id")).to eql("name-square")
    end
  end
end
