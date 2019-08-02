# frozen_string_literal: true

class MadekErrors
  class NotPublic
    def initialize(object)
      raise GraphQL::ExecutionError,
            "This #{object.class.name.downcase} is not public."
    end
  end

  class NotFound
    def initialize
      raise GraphQL::ExecutionError,
            'Record not found'
    end
  end
end
