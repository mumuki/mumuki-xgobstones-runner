require 'spec_helper'
require 'yaml'

require_relative '../lib/test_hook'

describe TestHook do
  context '#compile' do
    let(:compiler) { TestHook.new }
    let(:output) { compiler.compile({test: test_file, extra: 'extra', content: 'content'}) }

    context 'when check_head_position is true' do
      let(:test_file) {
  '
  check_head_position: true

  examples:
   - initial_board: initial
     final_board: final'
      }

      it {
        expect(output).to eq({
          source: "content\nextra",
          examples: [{initial_board: 'initial', final_board: 'final'}],
          check_head_position: true })
      }
    end

    context 'when check_head_position is false' do
      let(:test_file) {
        '
  check_head_position: false

  examples:
   - initial_board: initial
     final_board: final'
      }

      it {
        expect(output).to eq({
          source: "content\nextra",
          examples: [{initial_board: 'initial', final_board: 'final'}],
          check_head_position: false })
      }
    end

    context 'when check_head_position is not defined' do
      let(:test_file) {
        '
  examples:
   - initial_board: initial
     final_board: final'
      }

      it {
        expect(output).to eq({
          source: "content\nextra",
          examples: [{initial_board: 'initial', final_board: 'final'}],
          check_head_position: false })
      }
    end

    context 'when arguments are given' do
      let(:test_file) {
        '
  subject: PonerN

  examples:
   - initial_board: initial
     final_board: final
     arguments:
      - 3
      - Rojo'
      }

      it {
        expect(output).to eq({
          source: "content\nextra",
          subject: 'PonerN',
          examples: [{initial_board: 'initial', final_board: 'final', arguments: [3, 'Rojo']}],
          check_head_position: false })
      }
    end
  end
end
