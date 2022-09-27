# frozen_string_literal: true

class TestsController < ApplicationController
  include Request::History::Recording

  # The possible options are same as any rails callback options + params to record, storages and
  # async
  # recording except: :show, params: [:name], async: true, storages: [StorageClass], if: -> { true }
  #
  # https://api.rubyonrails.org/v7.0.3.1/classes/AbstractController/Callbacks/ClassMethods.html
  recording only: :index, params: :say, storages: Request::History::IOStorage

  def index
    render json: { some: :thing }
  end
end
