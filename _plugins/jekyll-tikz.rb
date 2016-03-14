# Authored my Maxfan http://github.com/Maxfan-zone http://maxfan.org
# This is used to convert tikz code into svg file and load in you jekyll site
#
# Install:
#
#   1. Copy this file in your _plugins/ directory. You can customize it, of course.
#   2. Make sure texlive and pdf2svg are installed on your computer.
#
# Input:
#   
#   {% tikz filename %}
#     \tikz code goes here 
#   {% endtikz %}
#
# This will generate a /img/post-title-from-filename/filename.svg in your jekyll directory
# 
# And then return this in your HTML output file:
#   
#   <embed src="/img/post-title-from-filename/tikz-filename.svg" type="image/svg+xml" />
#   
# Note that it will generate a /_tikz_tmp directory to save tmp files.
#

module Jekyll
  module Tags
    class Tikz < Liquid::Block
      def initialize(tag_name, markup, tokens)
        super
        begin
          @file_name = markup.match(/([^\s]+)/)[1]

          # TODO: do differentitaion between (1) no options added and (2) tried
          # to add options but failed the syntax
          if m = markup.match(/options\=(\[[^\[]*\])/)
            @options = m[1]
          else
            @options = ""
          end

          @header = <<-'END'
          \documentclass{standalone}
          \usepackage{tikz}
          \begin{document}
          END

          @footer = <<-'END'
          \end{document}
          END
        rescue NoMethodError => e
          # happens when matching the markup with regexp fails
          puts "[jekyll-tikz]: Error when parsing tag block 'tikz'!" \
               "Syntax: {% tikz <file_name> [options=\[thick, ->, etc\]] %} "
        end
      end      

      def render(context)
        tikz_code = @header + "\\begin\{tikzpicture\}" + @options + super + \
                    "\\end\{tikzpicture\}" + @footer

        tmp_directory = File.join(Dir.pwd, "_tikz_tmp", File.basename(context["page"]["url"], ".*"))
        tex_path = File.join(tmp_directory, "#{@file_name}.tex")
        pdf_path = File.join(tmp_directory, "#{@file_name}.pdf")
        FileUtils.mkdir_p tmp_directory

        dest_directory = File.join(Dir.pwd, "public/img", File.basename(context["page"]["url"], ".*"))
        dest_path = File.join(dest_directory, "#{@file_name}.png")
        FileUtils.mkdir_p dest_directory


        # if the file doesn't exist or the tikz code is not the same with the file, then compile the file
        if !File.exist?(tex_path) or !tikz_same?(tex_path, tikz_code) or !File.exist?(dest_path)
          File.open(tex_path, 'w') { |file| file.write("#{tikz_code}") }
          system("pdflatex -output-directory #{tmp_directory} #{tex_path}")
          system("/usr/bin/sips -s format png #{pdf_path} --out #{dest_path}")
        end

        web_dest_path = File.join("/public/img", File.basename(context["page"]["url"], ".*"), "#{@file_name}.png")
        "<img src=\"#{web_dest_path}\"/>"
      end

      private

      def tikz_same?(file, code)
        File.open(file, 'r') do |file|
          file.read == code
        end
      end

    end
  end
end

Liquid::Template.register_tag('tikz', Jekyll::Tags::Tikz)