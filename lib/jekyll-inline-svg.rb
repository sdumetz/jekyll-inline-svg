require 'svg_optimizer'
require 'shellwords'

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

      VARIABLE_SYNTAX = %r!
        ^(?<variable>[^\s"']+|"[^"]*"|'[^']*')
        (?<params>.*)
      !x

      def initialize(tag_name, input, tokens)
        super

        #@logger = Logger.new(STDOUT)
        #@logger.level = Logger::INFO
        @svg, @params = JekyllInlineSvg.parse_params(input)
        #@logger.info(@svg +", "+@width)
      end
      def self.parse_params(input)
        matched = input.strip.match(VARIABLE_SYNTAX)
        return matched["variable"].strip.gsub("\"","").gsub("'",""), matched["params"].strip
      end
      def render(context)
        #global site variable
        site = context.registers[:site]
        #check if given name is a variable. Otherwise use it as a file name
        varname = @svg.match(%r{\{\{(?<name>[^\}]+)\}\}})
        if varname
          svg_name = context[varname["name"]]
        else
          svg_name = @svg
        end
        svg_file = Jekyll.sanitized_path(site.source, svg_name.strip)
        xml = File.open(svg_file, "rb")
        optimized = SvgOptimizer.optimize(xml.read, PLUGINS)
  	    "#{optimized.sub("<svg ","<svg #{@params} ")}"
      end
    end
  end
end
Liquid::Template.register_tag('svg', Jekyll::Tags::JekyllInlineSvg)
