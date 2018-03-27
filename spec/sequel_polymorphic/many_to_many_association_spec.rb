require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "many-to-many association" do
    before do
      Post.dataset.delete
      Tagging.dataset.delete
      Tag.dataset.delete

      @post = Post.create(:name => 'test post')
      @tag1 = Tag.create(:name => "post's first tag")
      @tag2 = Tag.create(:name => "post's second tag")
    end

    describe "#associations" do
      it "should return the list of associated objects" do
        @post.add_tag(@tag1)
        assert_equal @post.tags, [@tag1]

        @post.add_tag(@tag2)
        assert_equal @post.tags, [@tag1, @tag2]
      end

      # TODO: add tests of merging options
    end

    describe "#association_join" do
      it "allows joining a :through association" do
        @post.add_tag(@tag1)
        @post.add_tag(@tag2)

        assert_equal 2, Post.association_join(:tags).all.size
      end
    end

    describe "#eager" do
      it "allows eager loading a :through association" do
        @post.add_tag(@tag1)
        @post.add_tag(@tag2)

        assert_equal 2, Post.eager(:tags).all.first.tags.size
      end
    end

    describe "#add_association" do
      it "should associate an object" do
        @post.add_tag(@tag1)
        assert_equal @post.tags, [@tag1]

        @post.add_tag(@tag2)
        assert_equal @post.tags, [@tag1, @tag2]
      end
    end

    describe "#remove_association" do
      it "should remove a single association" do
        @post.add_tag(@tag1)
        @post.add_tag(@tag2)
        @post.remove_tag(@tag1)
        assert_equal @post.tags, [@tag2]
      end
    end

    describe "#remove_all_associations" do
      it "should remove all associations" do
        @post.add_tag(@tag1)
        @post.add_tag(@tag2)
        @post.remove_all_tags
        assert_empty @post.tags
      end
    end

    # TODO: add tests for standard #many_to_many association fallback
  end # "many-to-many association"
end # Sequel::Plugins::Polymorphic


