module ApplicationHelper
  def highlight_text(text, query)
    return text unless query.present?

    query = Regexp.escape(query)  # Escape any special characters in the search query
    highlighted = text.gsub(/(#{query})/i) { |match| "<span class='bg-yellow-300'>#{match}</span>" }
    highlighted.html_safe
  end

  def highlight_fields(notice, full_name_query, content_query)
    highlighted_full_name = highlight_text(notice.full_name, full_name_query)
    highlighted_content = highlight_text(notice.content, content_query)
    { full_name: highlighted_full_name, content: highlighted_content }
  end
end
