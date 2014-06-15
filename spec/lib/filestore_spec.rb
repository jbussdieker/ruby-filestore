require 'spec_helper'

describe FileStore do
  let(:filestore) { FileStore.new(@dir) }
  let(:key) { "foo" }
  let(:value) { "bar" }
  let(:keypath) { File.join(@dir, key) }

  subject { filestore }

  it { should be_kind_of FileStore }

  describe "set" do
    subject { filestore.set(key, value) }

    context "simple key" do
      context "when key is present" do
        before { factory(keypath, "wrong") }

        it "should overwrite the value" do
          subject
          File.read(keypath).should == value
        end
      end

      context "when key is missing" do
        it "should create the key" do
          subject
          File.exists?(keypath).should == true
        end

        it "should write the value" do
          subject
          File.read(keypath).should == value
        end
      end
    end

    context "multilevel key" do
      let(:key) { "foo/bar" }

      context "when key is present" do
        before { factory(keypath, "wrong") }

        it "should overwrite the value" do
          subject
          File.read(keypath).should == value
        end
      end

      context "when key is missing" do
        it "should create the path" do
          subject
          File.exists?(File.dirname(keypath)).should == true
        end

        it "should create the key" do
          subject
          File.exists?(keypath).should == true
        end

        it "should write the value" do
          subject
          File.read(keypath).should == value
        end
      end
    end
  end

  describe "get" do
    subject { filestore.get(key) }

    context "simple key" do
      context "when key is present" do
        before { factory(keypath, value) }

        it "should read the value" do
          subject.should == value
        end
      end

      context "when key is missing" do
        it "should return nil" do
          subject.should == nil
        end
      end
    end

    context "multilevel key" do
      let(:key) { "foo/bar" }

      context "when key is present" do
        before { factory(keypath, value) }

        it "should read the value" do
          subject.should == value
        end
      end

      context "when key is missing" do
        it "should not create the path" do
          subject
          File.exists?(File.dirname(keypath)).should == false
        end

        it "should return nil" do
          subject.should == nil
        end
      end
    end
  end

  describe "delete" do
    subject { filestore.delete(key) }

    context "simple key" do
      context "when key is present" do
        before { factory(keypath, value) }

        it "should delete the key" do
          subject
          File.exists?(keypath).should == false
        end
      end

      context "when key is missing" do
        it "should do nothing" do
          subject
        end
      end
    end

    context "multilevel key" do
      let(:key) { "foo/bar" }

      context "when key is present" do
        before { factory(keypath, value) }

        it "should delete the key" do
          subject
          File.exists?(keypath).should == false
        end
      end

      context "when key is missing" do
        it "should do nothing" do
          subject
        end
      end
    end
  end

  describe "exists?" do
    subject { filestore.exists?(key) }

    context "simple key" do
      context "when key is present" do
        before { factory(keypath, value) }

        it { should == true }
      end

      context "when key is missing" do
        it { should == false }
      end
    end

    context "multilevel key" do
      let(:key) { "foo/bar" }

      context "when key is present" do
        before { factory(keypath, value) }

        it { should == true }
      end

      context "when key is missing" do
        it { should == false }
      end
    end
  end
end
