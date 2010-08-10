# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_table(record_set = [], options = {}, &block)
    if record_set.kind_of?(Hash)
      options = record_set 
      record_set = []
    end
    render :partial => ( options[:template] || "shared/tables/default" ), :locals => TableHelper::Builder.new(record_set, @template, &block).html_helper.merge(options)
  end

  def paginate(object, opts={})
    opts[:position] = :top unless opts.has_key?(:position)
    opts[:renderer] ||= "PaginatorCustomRenderer"
    page_entries_opts = {}
    page_entries_opts[:entry_name] = opts.delete(:entry_name) if opts.has_key?(:entry_name)
    output = ""
    output << "#{will_paginate(object, {:container=>true, :renderer=>opts[:renderer]}.merge(opts))}"
    output << content_tag(:div, page_entries_info(object, page_entries_opts), :class=>"page_entries") unless opts[:page_entries] == false
    content_tag(:div, output, :class=>"pagination #{opts[:position].to_s}") 
  end
end
