module Ui
  # A breadcrumb style navigation to be used with gems like loaf
  class Breadcrumbs < Component
    include Stylable

    Crumbs = Types::Array.of(Types.Interface(:name, :path, :current?))

    def show
      content_tag(:nav, render_group(breadcrumb_links.flatten), class: style)
    end

    private

    def breadcrumbs
      begin
        Crumbs[model]
      rescue Dry::Types::ConstraintError
        raise Ui::Errors::InvalidBreadcrumbs,
          "Breadcrumbs for #{self.class} are invalid. Ensure you are passing " \
          "an array of Ui::Breadcrumbs::Crumb objects. #{model.class} was found instead."
      end
    end

    def breadcrumb_links
      breadcrumbs.map.with_index do |crumb, index|
        [item_renderer.call(crumb)].tap do |array|
          array.unshift(delimiter) unless index.zero?
        end
      end
    end

    def delimiter
      options.fetch(:delimiter, default_delimiter)
    end

    def default_delimiter
      content_tag(:span, '>', class: 'breadcrumb-delimiter')
    end

    def item_renderer
      options[:item_renderer] || default_item_renderer
    end

    def default_item_renderer
      ->(item) {
        cell(
          Ui::Breadcrumbs::Breadcrumb,
          item
        ).()
      }
    end

    def component_style
      'ui-breadcrumbs'
    end
  end
end
