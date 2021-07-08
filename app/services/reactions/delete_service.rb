# frozen_string_literal: true

module Reactions
  class DeleteService < BaseService
    def initialize(reaction_id, user_id)
      @reaction_id = reaction_id
      @user_id = user_id
    end

    def call
      execute(rescue_list: [ActiveRecord::RecordInvalid]) do
        reaction = find_reaction
        reaction_type = reaction.reaction_type
        validate_owner!(reaction)
        delete_reaction!(reaction)

        add_result({
                     deleted: true,
                     reaction_type: reaction_type
                   })
      end
    end

    private

    def find_reaction
      Reaction.find(@reaction_id)
    end

    def validate_owner!(reaction)
      save_and_raise!(ActiveRecord::RecordInvalid, ownership_error) unless owner_of_reaction?(reaction)
    end

    def owner_of_reaction?(reaction)
      reaction.user_id == @user_id
    end

    def ownership_error
      reaction = Reaction.new
      reaction.errors.add(:Unauthorized, ', you are not the owner of this reaction')
    end

    def delete_reaction!(reaction)
      save_and_raise!(ActiveRecord::RecordInvalid, reaction.errors) unless reaction.destroy
    end
  end
end
