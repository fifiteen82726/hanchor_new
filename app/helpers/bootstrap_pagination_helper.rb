module BootstrapPaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected
    
      def page_number(page)
        unless page == current_page
          link(page, page, :rel => rel_value(page))
        else
          link(page, "#")
        end
      end
      
      def gap
        text = tag(:li, tag(:a, '&hellip;'),class: "inlineblock disabled")
      end
      
      def next_page
        num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
        previous_or_next_page(num, @options[:next_label], 'next')
      end
      
      def previous_or_next_page(page, text, classname)
        if page
          link(text, page, :class => classname)
        else
          link(text, "#", :class => classname + ' disabled')
        end
      end
      
      def html_container(html)
        tag(:nav, tag(:ul, html,class: "tcenter"), container_attributes.merge(class: "page-menu relative"))
      end
    
    private
    
      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          target = url(target)
        end
          
        unless target == "#"
          attributes[:href] = target
        end
        
        classname = attributes[:class]
        attributes.delete(:classname)
        if text == current_page
          tag(:li, tag(:a, text, attributes),class: "active page inlineblock")
        elsif text.is_a? Integer
          tag(:li, tag(:a, text, attributes),class: "page inlineblock")
        else
          tag(:li, tag(:a, text, attributes),class: "inlineblock")
        end
      end
  end
end