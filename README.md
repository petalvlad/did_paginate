# Overview

This gem provides Rails view helper for rendering pagination component. It doesn't make any data queries to split data collection on pages, instead it assumes that collection has been already paginated and total pages count is known.

Basically it gerenates html list of pagination items, where each item might link to certain page. There are several types of pagination item:
 * previous page
 * general page
 * current page
 * next page
 * gap
 
Previous page item and next page item are presented only if it's possible to go to those pages. General page item contains link to certain page. The items for the first and the last pages are always visible. Current page item doesn't link to current page (no sense to go from current page to current). Gap item contains `…` symbol and also doesn't link anywhere.

This is how the rendered component looks like

![Pagination component render](https://www.dropbox.com/s/du116n5vrzunc9f/Screenshot%202014-12-11%2018.38.56.png?dl=1)


## Installation

Add this line to your application's Gemfile:

    gem 'did_paginate'

And then execute:

    $ bundle install

## Usage

To render pagination component you should use `did_paginate` helper

    <%= did_paginate(self,
                    @current_page, 
                    @total_pages,                 
                    params, 
                    ->(url_params) { refinery.brands_admin_brands_path(url_params) },
                    page_param_name: :page,
                    klass: 'did-paginate-pager',
                    siblings_count: 7) 
                    %>
                    
This is the signature of this helper method

    did_paginate(template, current_page, total_pages, params, url_builder, options = {})
    
The `params` parameter is a hash of request parameters used to keep other url query parameters in each generated pagination item, e.g. search query or category parameter.

When it needs to create a url for certain pagination item, it calls the `url_builder` lambda parameter passing into a hash of all needed parameters for creating a url.

The `options` parameter contains following settings:
 * page_param_name
 * klass
 * siblings_count

The `page_param_name` parameter is a name of the key of your `params` hash representing page query parameter in the url. Default values is `:page`.

The `klass` parameter used for setting a CSS class on the root `ul` element of pagination component. Default value is `did-paginate-pager`. This is the HTML structure of entire component

    <ul class="did-paginate-pager">
        <li>
            <a href="/products?page=5">previous</a>
        </li>
        <li>
            <a href="/products?page=1">1</a>
        </li>
        <li class="disabled">
            <a href="#">…</a>
        </li>
        ...
        <li class="active">
            <a href="#">6</a>
        </li>
        ...
        <li>
            <a href="/products?page=10">10</a>
        </li>
        <li>
            <a href="/products?page=7">next</a>
        </li>
    </ul>
    
**NOTE**: if you want to use default style you need to require it in you application.css manifest file

    *= require did_paginate
    
The `siblings_count` parameter determines how many items to show at each side of the current page item. Default value is `5`. Note that for each side this number includes two first items (first page and gap) and two last items (gap and last page), but doesn't include previous page and next page items.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
