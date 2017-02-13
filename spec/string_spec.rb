require_relative './spec_helper'

describe String do
  describe '#ascii?' do
    it { expect('hello'.ascii?).to be true }
    it { expect('Hello World'.ascii?).to be true }
    it { expect('¡Hello World'.ascii?).to be false }
    it { expect('¡Olalá!'.ascii?).to be false }
  end

  describe "#non_ascii_context" do
    it { expect('hello'.non_ascii_context 3).to be nil }
    it { expect('Hello World'.non_ascii_context 3).to be nil }
    it { expect('¡Hello World'.non_ascii_context 3).to eq '...¡Hel...' }
    it { expect('¡Olalá!'.non_ascii_context 3).to eq '...¡Ola...' }
    it { expect('the übermensch is a term coined by Nietzche'.non_ascii_context 5).to eq '...the überme...' }
  end
end
