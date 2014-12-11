module DidPaginate
  class Pager
    
    def initialize(current_page, total_pages, params, url_builder, options = {})
      options = default_options.merge(options)      
      @current_page = current_page
      @total_pages = total_pages      
      @params = params    
      @url_builder = url_builder
      @page_param_name = options[:page_param_name]
      @class = options[:klass]
      @siblings_count = options[:siblings_count]
      @all_items_count = @siblings_count * 2 + 1
    end

    def render(template)
      html = items.map { |item| item.render(template) }.join.html_safe
      template.content_tag(:ul, html, class: @class)
    end

    def items
      @items ||= 
        [ 
          (previous_page_item if previous_page_item.is_linkable?), 
          pages.map { |page| page_item(page) }, 
          (next_page_item if next_page_item.is_linkable?)]          
          .select { |item| item.present? }
          .flatten
    end

  private

    def default_options
      { 
        page_param_name: :page, 
        klass: 'did-paginate-pager', 
        siblings_count: 5
      }
    end

    def previous_page_item
      @previous_page_item ||= PreviousPageItem.new(item_url(@current_page - 1))
    end

    def next_page_item
      @next_page_item ||= NextPageItem.new(item_url(@current_page + 1))
    end

    def pages
      return (1..@total_pages).to_a if @total_pages <= @all_items_count
      
      # for example [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]
      pages = pages_sequence

      # turns above into [1, nil, 26, 27, 28, 29, 30, 31, 32, nil, 100]
      add_gaps!(pages)
      
      pages
    end

    def pages_sequence
      # for example, if @total_pages equals to 21
      # @current_page equals to 2 
      # siblings_count equals to 5            
      # then unshifted_sequence will be equal
      # [-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7]    
      unshifted_sequence = ((@current_page - @siblings_count)..(@current_page + @siblings_count)).to_a 

      # offset will be equal to 4
      offset = offset_of_pages(unshifted_sequence)

      # shifts the above sequence
      # [-3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7] to 
      # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]    
      unshifted_sequence.map {|page| page + offset}
    end

    def offset_of_pages(pages)
      left_offset = 1 - pages.first
      right_offset = @total_pages - pages.last

      if left_offset > 0
        left_offset
      elsif right_offset < 0
        right_offset
      else
        0
      end
    end

    def add_gaps!(pages) 
      # adds gap to the head   
      # [4, 5, 6, 7, 8, 9, 10] -> [1, nil, 6, 7, 8, 9, 10]    
      pages[0], pages[1] = 1, nil if pages[2] != 3
      
      # adds gap to the tail
      # [1, 2, 3, 4, 5, 6, 7] -> [1, 2, 3, 4, 5, nil, 10]
      pages[-2], pages[-1] = nil, @total_pages if pages[-3] != @total_pages - 2
    end

    def page_item(page)
      return GapPageItem.new if page.nil?
      PageItem.new(item_url(page), page, is_page_current?(page))
    end

    def item_url(page)
      return nil unless is_page_linkable?(page)
      url_params = @params.merge({ @page_param_name => page })
      url_params.delete(@page_param_name) if page <= 1
      url_params = url_params.reject {|k,v| v.blank? }
      @url_builder.call(url_params)
    end

    def is_page_linkable?(page)
      is_page_exist?(page) && !is_page_current?(page)
    end

    def is_page_exist?(page)
      page.present? && page > 0 && page <= @total_pages
    end

    def is_page_current?(page)    
      @current_page == page
    end
  
  end
end