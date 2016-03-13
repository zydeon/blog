class Solution < Liquid::Block
  def initialize(tag_name, markup, tokens)
     super
  end

  def render(context)
    site      = context.registers[:site]
    converter = site.find_converter_instance(Jekyll::Converters::Markdown)

    content = super.strip
    content = converter.convert(content)

    '<div class="hidden-solution">' + content + "</div>"
  end
end

Liquid::Template.register_tag('solution', Solution)