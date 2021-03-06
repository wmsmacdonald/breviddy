include BitsHelper
include ActiveModel::Validations

class Bit < ActiveRecord::Base

  @is_anonymous = false

  self.per_page = 4

  self.primary_key = :id

  # It returns the articles whose titles contain one or more words that form the query
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("title like ?", "%#{query}%")
  end

  belongs_to :user

  validates :url, presence: true
  validates :start, presence: true
  validates :end, presence: true

  validates_with YTLinkValidator, on: :create

  def setUsername(username)
    @username = username
  end
  def getUsername
    @username
  end

  def setUrlId(url)
    @urlId = /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/.match(url)[1]
  end
  def getUrlId
    return @urlId
  end

  def is_anonymous?
    @is_anonymous
  end
  def set_anonymous(bool)
    @is_anonymous = bool
  end

end