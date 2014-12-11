require 'did_paginate/view_helpers'

module DidPaginate
  class Railtie < Rails::Railtie

    initializer "did_paginate.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

  end
end