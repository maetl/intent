require 'spec_helper'

describe Intent::Args do
  it 'is empty on zero length array' do
    args = Intent::Args.new([])
    expect(args.empty?).to be true
  end

  it 'is not empty on no-zero length array' do
    args = Intent::Args.new(["help"])
    expect(args.empty?).to be false
  end
end