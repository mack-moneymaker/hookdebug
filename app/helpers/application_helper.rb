module ApplicationHelper
  def method_color(method)
    case method.to_s.upcase
    when "GET" then "bg-blue-600/30 text-blue-400"
    when "POST" then "bg-emerald-600/30 text-emerald-400"
    when "PUT" then "bg-yellow-600/30 text-yellow-400"
    when "PATCH" then "bg-orange-600/30 text-orange-400"
    when "DELETE" then "bg-red-600/30 text-red-400"
    else "bg-gray-600/30 text-gray-400"
    end
  end
end
