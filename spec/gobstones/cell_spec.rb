require 'rspec'

describe Cell do
  context 'the stones can be set by color name' do
    let (:cell) { Cell.new }

    it {
      cell.set :red, 8
      expect(cell.red). to eq 8
    }
  end
end