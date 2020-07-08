module ApplicationHelper
  def full_title _page_titles
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
