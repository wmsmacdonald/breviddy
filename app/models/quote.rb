class Quote < ActiveRecord::Base
  self.primary_key = :id

  # It returns the articles whose titles contain one or more words that form the query
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("caption like ?", "%#{query}%")
  end

  belongs_to :user

  def setUsername(username)
    @username = username
  end
  def getUsername
    @username
  end

end