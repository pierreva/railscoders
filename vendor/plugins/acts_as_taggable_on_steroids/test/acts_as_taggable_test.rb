require File.dirname(__FILE__) + '/abstract_unit'

class ActsAsTaggableOnSteroidsTest < Test::Unit::TestCase
  fixtures :tags, :taggings, :posts, :users, :photos
  
  def test_find_tagged_with
    assert_equivalent [posts(:jonathan_sky), posts(:sam_flowers)], Post.find_tagged_with('"Very good"')
    assert_equal Post.find_tagged_with('"Very good"'), Post.find_tagged_with(['Very good'])
    assert_equal Post.find_tagged_with('"Very good"'), Post.find_tagged_with([tags(:good)])
    
    assert_equivalent [photos(:jonathan_dog), photos(:sam_flower), photos(:sam_sky)], Photo.find_tagged_with('Nature')
    assert_equal Photo.find_tagged_with('Nature'), Photo.find_tagged_with(['Nature'])
    assert_equal Photo.find_tagged_with('Nature'), Photo.find_tagged_with([tags(:nature)])
    
    assert_equivalent [photos(:jonathan_bad_cat), photos(:jonathan_dog), photos(:jonathan_questioning_dog)], Photo.find_tagged_with('"Crazy animal" Bad')
    assert_equal Photo.find_tagged_with('"Crazy animal" Bad'), Photo.find_tagged_with(['Crazy animal', 'Bad'])
    assert_equal Photo.find_tagged_with('"Crazy animal" Bad'), Photo.find_tagged_with([tags(:animal), tags(:bad)])
  end
  
  def test_find_tagged_with_nothing
    assert_equal [], Post.find_tagged_with("")
    assert_equal [], Post.find_tagged_with([])
  end
  
  def test_find_tagged_with_nonexistant_tags
    assert_equal [], Post.find_tagged_with('ABCDEFG')
    assert_equal [], Photo.find_tagged_with(['HIJKLM'])
    assert_equal [], Photo.find_tagged_with([Tag.new(:name => 'unsaved tag')])
  end
  
  def test_find_tagged_with_matching_all_tags
    assert_equivalent [photos(:jonathan_dog)], Photo.find_tagged_with('Crazy animal, "Nature"', :match_all => true)
    assert_equivalent [posts(:jonathan_sky), posts(:sam_flowers)], Post.find_tagged_with(['Very good', 'Nature'], :match_all => true)
  end
  
  def test_find_options_for_tagged_with_no_tags_returns_empty_hash
    assert_equal Hash.new, Post.find_options_for_tagged_with("")
    assert_equal Hash.new, Post.find_options_for_tagged_with([nil])
  end
  
  def test_include_tags_on_find_tagged_with
    assert_nothing_raised do
      Photo.find_tagged_with('Nature', :include => :tags)
      Photo.find_tagged_with("Nature", :include => { :taggings => :tag })
    end
  end
  
  def test_basic_tag_counts_on_class
    assert_tag_counts Post.tag_counts, :good => 2, :nature => 5, :question => 1, :bad => 1
    assert_tag_counts Photo.tag_counts, :good => 1, :nature => 3, :question => 1, :bad => 1, :animal => 3
  end
  
  def test_tag_counts_on_class_with_date_conditions
    assert_tag_counts Post.tag_counts(:start_at => Date.new(2006, 8, 4)), :good => 1, :nature => 3, :question => 1, :bad => 1
    assert_tag_counts Post.tag_counts(:end_at => Date.new(2006, 8, 6)), :good => 1, :nature => 4, :question => 1
    assert_tag_counts Post.tag_counts(:start_at => Date.new(2006, 8, 5), :end_at => Date.new(2006, 8, 8)), :good => 1, :nature => 2, :bad => 1
    
    assert_tag_counts Photo.tag_counts(:start_at => Date.new(2006, 8, 12), :end_at => Date.new(2006, 8, 17)), :good => 1, :nature => 1, :bad => 1, :question => 1, :animal => 2
  end
  
  def test_tag_counts_on_class_with_frequencies
    assert_tag_counts Photo.tag_counts(:at_least => 2), :nature => 3, :animal => 3
    assert_tag_counts Photo.tag_counts(:at_most => 2), :good => 1, :question => 1, :bad => 1
  end
  
  def test_tag_counts_with_limit
    assert_equal 2, Photo.tag_counts(:limit => 2).size
    assert_equal 1, Post.tag_counts(:at_least => 4, :limit => 2).size
  end
  
  def test_tag_counts_with_limit_and_order
    assert_equal [tags(:nature), tags(:good)], Post.tag_counts(:order => 'count desc', :limit => 2)
  end
  
  def test_tag_counts_on_association
    assert_tag_counts users(:jonathan).posts.tag_counts, :good => 1, :nature => 3, :question => 1
    assert_tag_counts users(:sam).posts.tag_counts, :good => 1, :nature => 2, :bad => 1
    
    assert_tag_counts users(:jonathan).photos.tag_counts, :animal => 3, :nature => 1, :question => 1, :bad => 1
    assert_tag_counts users(:sam).photos.tag_counts, :nature => 2, :good => 1
  end
  
  def test_tag_counts_on_association_with_options
    assert_equal [], users(:jonathan).posts.tag_counts(:conditions => '1=0')
    assert_tag_counts users(:jonathan).posts.tag_counts(:at_most => 2), :good => 1, :question => 1
  end
  
  def test_tag_list_reader
    assert_equivalent ["Very good", "Nature"], posts(:jonathan_sky).tag_list.names
    assert_equivalent ["Bad", "Crazy animal"], photos(:jonathan_bad_cat).tag_list.names
  end
  
  def test_reassign_tag_list
    assert_equivalent ["Nature", "Question"], posts(:jonathan_rain).tag_list.names
    posts(:jonathan_rain).taggings.reload
    
    # Only an update of the posts table should be executed
    assert_queries 1 do
      posts(:jonathan_rain).update_attributes!(:tag_list => posts(:jonathan_rain).tag_list.to_s)
    end
    
    assert_equivalent ["Nature", "Question"], posts(:jonathan_rain).tag_list.names
  end
  
  def test_new_tags
    assert_equivalent ["Very good", "Nature"], posts(:jonathan_sky).tag_list.names
    posts(:jonathan_sky).update_attributes!(:tag_list => "#{posts(:jonathan_sky).tag_list}, One, Two")
    assert_equivalent ["Very good", "Nature", "One", "Two"], posts(:jonathan_sky).tag_list.names
  end
  
  def test_remove_tag
    assert_equivalent ["Very good", "Nature"], posts(:jonathan_sky).tag_list.names
    posts(:jonathan_sky).update_attributes!(:tag_list => "Nature")
    assert_equivalent ["Nature"], posts(:jonathan_sky).tag_list.names
  end
  
  def test_remove_and_add_tag
    assert_equivalent ["Very good", "Nature"], posts(:jonathan_sky).tag_list.names
    posts(:jonathan_sky).update_attributes!(:tag_list => "Nature, Beautiful")
    assert_equivalent ["Nature", "Beautiful"], posts(:jonathan_sky).tag_list.names
  end
  
  def test_tags_not_saved_if_validation_fails
    assert_equivalent ["Very good", "Nature"], posts(:jonathan_sky).tag_list.names
    assert !posts(:jonathan_sky).update_attributes(:tag_list => "One, Two", :text => "")
    assert_equivalent ["Very good", "Nature"], Post.find(posts(:jonathan_sky).id).tag_list.names
  end
  
  def test_tag_list_accessors_on_new_record
    p = Post.new(:text => 'Test')
    
    assert p.tag_list.blank?
    p.tag_list = "One, Two"
    assert_equal "One, Two", p.tag_list.to_s
  end
  
  def test_clear_tag_list_with_nil
    p = photos(:jonathan_questioning_dog)
    
    assert !p.tag_list.blank?
    assert p.update_attributes(:tag_list => nil)
    assert p.tag_list.blank?
    
    assert p.reload.tag_list.blank?
  end
  
  def test_clear_tag_list_with_string
    p = photos(:jonathan_questioning_dog)
    
    assert !p.tag_list.blank?
    assert p.update_attributes(:tag_list => '  ')
    assert p.tag_list.blank?
    
    assert p.reload.tag_list.blank?
  end
  
  def test_tag_list_reset_on_reload
    p = photos(:jonathan_questioning_dog)
    assert !p.tag_list.blank?
    p.tag_list = nil
    assert p.tag_list.blank?
    assert !p.reload.tag_list.blank?
  end
  
  def test_tag_list_populated_when_cache_nil
    assert_nil posts(:jonathan_sky).cached_tag_list
    posts(:jonathan_sky).save!
    assert_equal posts(:jonathan_sky).tag_list.to_s, posts(:jonathan_sky).cached_tag_list
  end
  
  def test_cached_tag_list_used
    posts(:jonathan_sky).save!
    posts(:jonathan_sky).reload
    
    assert_no_queries do
      assert_equivalent ["Very good", "Nature"], posts(:jonathan_sky).tag_list.names
    end
  end
  
  def test_cached_tag_list_not_used
    # Load fixture and column information
    posts(:jonathan_sky).taggings(:reload)
    
    assert_queries 1 do
      # Tags association will be loaded
      posts(:jonathan_sky).tag_list
    end
  end
  
  def test_cached_tag_list_updated
    assert_nil posts(:jonathan_sky).cached_tag_list
    posts(:jonathan_sky).save!
    assert_equivalent ["Very good", "Nature"], TagList.from(posts(:jonathan_sky).cached_tag_list).names
    posts(:jonathan_sky).update_attributes!(:tag_list => "None")
    
    assert_equal 'None', posts(:jonathan_sky).cached_tag_list
    assert_equal 'None', posts(:jonathan_sky).reload.cached_tag_list
  end
end

class ActsAsTaggableOnSteroidsFormTest < Test::Unit::TestCase
  fixtures :tags, :taggings, :posts, :users, :photos
  
  include ActionView::Helpers::FormHelper
  
  def test_tag_list_contents
    fields_for :post, posts(:jonathan_sky) do |f|
      assert_match /Very good, Nature/, f.text_field(:tag_list)
    end
  end
end
