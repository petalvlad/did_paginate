module DidPaginate
  
  class PageItem
    
    ACTIVE_CLASS = 'active'
    DISABLED_CLASS = 'disabled'
    NULL_URL = '#'

    attr_accessor :url, :content

    def initialize(url, content, is_current)
      @url = url || NULL_URL
      @content = content
      @is_current = is_current
    end    

    def is_current?
      @is_current
    end

    def is_linkable?
      @url != NULL_URL
    end

    def render(template)
      template.content_tag(:li, template.link_to(@content, @url), class: item_class)
    end

  protected

    def item_class    
      return ACTIVE_CLASS if is_current?
      DISABLED_CLASS unless is_linkable?
    end   

  end

  class PreviousPageItem < PageItem
    
    def initialize(url, content = previous_span, is_current = false)
      super(url, content, is_current)
    end

  private

    def previous_span
      '<span aria-hidden="true">&laquo;</span>'.html_safe
    end

  end

  class NextPageItem < PageItem
    
    def initialize(url, content = next_span, is_current = false)
      super(url, content, is_current)
    end

  private

    def next_span
      '<span aria-hidden="true">&raquo;</span>'.html_safe
    end

  end

  class GapPageItem < PageItem
    
    def initialize(url = nil, content = '…', is_current = false)
      super(url, content, is_current)
    end

  end
end