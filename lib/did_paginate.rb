require 'did_paginate/version'
require 'did_paginate/railtie' if defined?(Rails)
require 'did_paginate/page_item'
require 'did_paginate/pager'

module DidPaginate  
  class Engine < ::Rails::Engine
  end
end
