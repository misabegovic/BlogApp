# frozen_string_literal: true

module Posts
  class CommentsQuery
    class << self
      delegate :call, to: :new
    end

    def initialize(post_id, include_reactions: true)
      @relation = Comment.none
      @post_id = post_id
      @include_reactions = include_reactions
    end

    def call(_params = {})
      filter_by_post
      sort_relations
      include_reactions

      @relation
    end

    private

    def filter_by_post
      @relation = Comment.where(post_id: @post_id) if @post_id
    end

    def sort_relations
      @relation = @relation.sort_by_created_at
    end

    def include_reactions
      @relation = @relation.includes(:reactions) if @include_reactions
    end
  end
end
