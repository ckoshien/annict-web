# frozen_string_literal: true

class TracksController < ApplicationController
  include TrackableEpisodeListSettable

  before_action :authenticate_user!

  def show
    set_trackable_episode_list
  end
end
