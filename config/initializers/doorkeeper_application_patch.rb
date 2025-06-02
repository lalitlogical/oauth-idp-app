Doorkeeper::Application.class_eval do
  def self.search(term)
    if term.present?
      where("name ILIKE :term OR redirect_uri ILIKE :term OR uid ILIKE :term OR scopes ILIKE :term", term: "%#{term}%")
    else
      all
    end
  end
end
