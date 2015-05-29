module ApplicationHelper
  # reference for this snipppet is http://m.onkey.org/nested-layouts-in-rails-3
  # see comment of Verestiuc Vlad Ovidiu
  def parent_layout(layout)
    @view_flow.set(:layout, self.output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def error_tag(error, html)
    unless error.nil?
      raw("<div class='field_with_errors'>#{html}</div>")
    else
      raw(html)
    end
  end
end