require 'spectus/expectation_target'

module Fix
  # Wraps the target of an expectation.
  #
  # @api private
  #
  class It < Spectus::ExpectationTarget
    # Create a new expection target
    #
    # @param subject    [BasicObject] The front object.
    # @param challenges [Array]       The list of challenges.
    # @param helpers    [Hash]        The list of helpers.
    def initialize(subject, challenges, helpers)
      @subject    = subject
      @challenges = challenges
      @helpers    = helpers
    end

    # Override Ruby's method_missing in order to provide let interface.
    #
    # @api private
    #
    # @since 0.11.0
    #
    # @raise [NoMethodError] If doesn't respond to the given method.
    def method_missing(name, *args, &block)
      @helpers.key?(name) ? @helpers.fetch(name).call : super
    end
  end
end
