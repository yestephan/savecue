module ApplicationHelper

  def emoji_for_category(category)
    case category
    when "rain"
      "🌧"
    when "coffee"
      "☕️"
    when "sunny"
      "☀️"
    when"burger"
      "🍔"
    else
      "💰"
    end
  end
end
