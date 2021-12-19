require 'open-uri'
require 'readability'

TAGS_ALLOWED = %w[
div p img a h1 h2 h3 h4 h5 h6 ol ul li figure b strong i code span pre table thead tbody tr th td
]

ATTRS_ALLOWED = %w[src href colspan rowspan]

class ReadController < ApplicationController
  def show
    @url = params[:url]
    if @url.nil?
      render :empty
    else
      begin
        html = open(@url).read
        doc = Readability::Document.new(html,  tags: TAGS_ALLOWED, attributes: ATTRS_ALLOWED)
        @title = doc.title
        @content = doc.content
        render :show
      rescue
        render :failure
      end
    end
  end
end
