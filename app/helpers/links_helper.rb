require 'open-uri'

module LinksHelper
  def render_link(link)
    if gist?(link)
      embed_gist(link.url)
    else
      link_to link.name, link.url
    end
  end

  private

  def gist?(link)
    link.url.include?('gist.github.com')
  end

  def embed_gist(url)
    "<script src=\"#{url}.js\"></script>".html_safe
  end
end
