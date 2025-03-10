class Post < ApplicationRecord
  validates :content, presence: true
  validates :title, presence: true

  belongs_to :user

  has_many :comments, as: :commentable
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  scope :published, -> { where(published_at: ..Time.zone.now) }
  scope :published_before, -> (time) { where(published_at: ..time) }
  scope :published_after, -> (time) { where(published_at: time..) }
  scope :empty, -> { where(content: ["", nil]) } # content is null OR content = ""

  enum :status, %i[draft visible archived] # %i defines options as symbols

  before_validation :set_published_at

  private

  def set_published_at
    self.published_at ||= Time.zone.now
  end
end
