module AnswersHelper
  def display_rates(arr)
    rates = arr.map do |a|
      if !a.response.nil?
        "#{a.raiting.name}: #{a.response}"
      end
    end
  end
end
