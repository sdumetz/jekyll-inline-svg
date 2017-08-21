require 'svg_optimizer'
require 'shellwords'
require 'jekyll/liquid_extensions'
class RemoveSize < SvgOptimizer::Plugins::Base
  def process
    xml.root.remove_attribute("height")
    xml.root.remove_attribute("width")
  end
end
PLUGINS_BLACKLIST = [
  SvgOptimizer::Plugins::CleanupId,
]

PLUGINS = SvgOptimizer::DEFAULT_PLUGINS.delete_if {|plugin|
  PLUGINS_BLACKLIST.include? plugin
}+[
  RemoveSize
]

#logger.info(PLUGINS)
module Jekyll
  module Tags
    class JekyllInlineSvg < Liquid::Tag

      include Jekyll::LiquidExtensions #import lookup_variable function
      # https://github.com/jekyll/jekyll/blob/master/lib/jekyll/liquid_extensions.rb
      # For interpoaltion, look for liquid variables
      VARIABLE = /\{\{\s*([\w]+\.?[\w]*)\s*\}\}/i
      PATH_SYNTAX = %r!
        ^(?<path>[^\s"']+|"[^"]*"|'[^']*')
        (?<params>.*)
      !x

      def initialize(tag_name, input, tokens)
        super

        #@logger = Logger.new(STDOUT)
        #@logger.level = Logger::INFO
        @svg, @params = JekyllInlineSvg.parse_params(input)
        #@logger.info(@svg +", "+@width)
      end
      def interpolate(markup, context)
        markup.scan VARIABLE do |variable|
          markup = markup.gsub(VARIABLE, lookup_variable(context, variable.first))
        end
        markup
      end
      def self.parse_params(input)
        matched = input.strip.match(PATH_SYNTAX)
        return matched["path"].strip.gsub("\"","").gsub("'",""), matched["params"].strip
      end
      def render(context)
        #global site variable
        site = context.registers[:site]
        #check if given name is a variable. Otherwise use it as a file name
        svg_file = Jekyll.sanitized_path(site.source, interpolate(@svg,context))
        params = interpolate(@params,context)

        xml = File.open(svg_file, "rb")
        optimized = SvgOptimizer.optimize(xml.read, PLUGINS)
  	    "#{optimized.sub("<svg ","<svg #{params} ")}"
      end
    end
  end
end
Liquid::Template.register_tag('svg', Jekyll::Tags::JekyllInlineSvg)
