require 'rspec'
require_relative '../src/multimethods'

RSpec.describe 'Multimethods' do
    it 'crear un PB falla si tiene distinta acntidad de'
        expect do
            partial_block = PartialBlock.new([]) {|who| "Hello #{who}"}
        end
        expect(hello_block.matches?("a")).to be_trueT
    end
end