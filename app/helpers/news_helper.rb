module NewsHelper
  def sanitize_article(content)
    sanitize(content, scrubber: article_scrubber)
  end

  private

  def article_scrubber
    @article_scrubber ||= ArticleScrubber.new
  end

  class ArticleScrubber < Loofah::Scrubber
    ALLOWED_TAGS = %w(figure a p b i em strong blockquote ul ol li dl df dd sup sub)
    ALLOWED_ATTRS = %w(href)
    KILL_TAGS = %w(script style img figure)

    def initialize
      @direction = :bottom_up
    end

    def scrub(node)
      if KILL_TAGS.include?(node.name)
        node.remove
      elsif ALLOWED_TAGS.include?(node.name)
        node.attribute_nodes.each do |attr|
          attr.remove unless ALLOWED_ATTRS.include?(attr.name)
        end
      elsif node.type == Nokogiri::XML::Node::ELEMENT_NODE
        node.before(node.children)
        node.remove
      end
    end
  end
end
