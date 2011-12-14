require 'spec_helper'

describe Mrapper::MrEmitBase do
  context "putting a model through it's setters'" do
    let(:mr_emit_base) { Mrapper::MrEmitBase.new("key", "value") }

    it "should set an Infinity value to 0" do
      mr_emit_base.value = Float::INFINITY
      mr_emit_base.value.should == 0
    end

    it "should set an NaN value to 0" do
      mr_emit_base.value = Float::NAN
      mr_emit_base.value.should == 0
    end
  end
end