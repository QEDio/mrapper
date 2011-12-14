require 'spec_helper'

describe Mrapper::MrEmitBase do
  context "putting a model through it's setters'" do
    let(:mr_emit_base) { Mrapper::MrEmitBase.new }

    it "should set an Infinity value to 0" do
      mr_emit_base.value = 1.0/0

      mr_emit_base.value.should == 0
    end
  end
end