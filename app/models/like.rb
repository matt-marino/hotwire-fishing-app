# frozen_string_literal: true

class Like < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :fish_catch, counter_cache: true

  after_create_commit lambda {
    broadcast_update_later_to 'activity',
                              target: "#{dom_id(fish_catch)}_likes_count",
                              html: fish_catch.likes_count
  }

  after_destroy_commit lambda {
    broadcast_update_later_to 'activity',
                              target: "#{dom_id(fish_catch)}_likes_count",
                              html: fish_catch.likes_count,
                              # has to be nil as the like is already deleted and will automatically be included
                              # and attempt to deserialize because we're broadcasting in a background job after
                              # the like is deleted
                              locals: { like: nil }
  }
end
