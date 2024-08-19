class Link < ActiveRecord::Base
  validates_presence_of :url
  validates :url, format: URI::regexp(%w[http https])
  validates_uniqueness_of :slug
  validates_length_of :url, within: 3..255, on: :create, message: "too long"
  validates_length_of :slug, within: 3..255, on: :create, message: "too long"

  def short
    Rails.application.routes.url_helpers.short_url(slug: self.slug)
  end

  before_validation :generate_slug

  def generate_slug
    self.slug = SecureRandom.uuid[0..5] if self.slug.nil? || self.slug.empty?
    true
  end

  def self.shorten(url, slug = '')
    # return short when URL with that slug was created before
    link = Link.where(url: url, slug: slug).first
    return link.short if link 

    # create a new
    link = Link.new(url: url, slug: slug)
    return link.short if link.save

    # if slug is taken, try to add random characters
    Link.shorten(url, slug + SecureRandom.uuid[0..2])
  end
end

class Link < ApplicationRecord
  belongs_to :user, optional: true
end