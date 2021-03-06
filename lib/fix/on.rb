require_relative 'it'
require 'defi'

module Fix
  # Wraps the target of challenge.
  #
  # @api private
  #
  class On
    # Initialize the on class.
    #
    # @param front_object   [BasicObject] The front object of the test.
    # @param results        [Array]       The list of collected results.
    # @param challenges     [Array]       The list of challenges to apply.
    # @param helpers        [Hash]        The list of helpers.
    # @param configuration  [Hash]        Settings.
    def initialize(front_object, results, challenges, helpers, configuration)
      @front_object   = front_object
      @results        = results
      @challenges     = challenges
      @helpers        = helpers
      @configuration  = configuration
    end

    # @!attribute [r] results
    #
    # @return [Array] The results.
    attr_reader :results

    # Add it method to the DSL.
    #
    # @api public
    #
    # @example It must eql "FOO"
    #   it { MUST Equal: 'FOO' }
    #
    # @param spec [Proc] A spec to compare against the computed actual value.
    #
    # @return [Array] List of results.
    def it(&spec)
      i = It.new(@front_object, @challenges, @helpers.dup)

      result = begin
                 i.instance_eval(&spec)
               rescue Spectus::Result::Fail => f
                 f
               end

      if @configuration.fetch(:verbose, true)
        print result.to_char(@configuration.fetch(:color, false))
      end

      results << result
    end

    # Add on method to the DSL.
    #
    # @api public
    #
    # @example On +2, it must equal 44.
    #   on(:+, 2) do
    #     it { MUST Equal: 44 }
    #   end
    #
    # @param method_name [Symbol] The identifier of a method.
    # @param args        [Array]  A list of arguments.
    # @param block       [Proc]   A spec to compare against the computed value.
    #
    # @return [Array] List of results.
    def on(method_name, *args, &block)
      o = On.new(@front_object,
                 results,
                 (@challenges + [Defi.send(method_name, *args)]),
                 @helpers.dup,
                 @configuration)

      o.instance_eval(&block)
    end

    # @api public
    #
    # @example Let's define the answer to the Ultimate Question of Life, the
    #   Universe, and Everything.
    #
    #   let(:answer) { 42 }
    #
    # @param method_name [Symbol] The identifier of a method.
    # @param block       [Proc]   A spec to compare against the computed value.
    #
    # @return [BasicObject] List of results.
    def let(method_name, &block)
      @helpers.update(method_name => block)
    end
  end
end
