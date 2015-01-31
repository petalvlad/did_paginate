module DidPaginate
  module ViewHelpers

    def did_paginate(template, current_page, total_pages, params, url_builder, options = {})
      DidPaginate::Pager.new(current_page, total_pages, params, url_builder, options).render(template) if total_pages > 1
    end

  end
end