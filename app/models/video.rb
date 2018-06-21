class Video < ApplicationRecord
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings

	def self.search_title(search_title)
		query = "%#{search_title}%" #+ "%".to_s
		videos = Video.arel_table
      	Video.where(videos[:title].matches(query)).order("created_at DESC")	
	end

	def self.search_tag(search_tag)
		query = "%#{search_tag}%" #+ "%".to_s
		tags = Tag.arel_table
      	Video.joins(:tags).where(tags[:name].matches(query)).order("created_at DESC")
	end

	def self.featured
		featured = FeaturedVideo.pluck(:title)
    	Video.where(title: featured).order("RANDOM()").limit(20)	
	end
	  
	def self.tagged_with(name)
		Tag.find_by!(name: name).videos
	end
	  
	def self.tag_counts
	  Tag.where.not(name: '').select("tags.id, tags.name,count(taggings.tag_id) as count").
	    joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
	end
	  
	def tag_list
	    tags.map(&:name).join(', ')
	end
	  
	def tag_list=(names)
	    self.tags = names.split(',').map do |n|
	      Tag.where(name: n.strip).first_or_create!
	    end
	end
end


# def self.tag_counts
#     Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
# end


# def tag_list=(names)
#     self.tags = names.split(',').map do |n|
#       Tag.where(name: n.strip).first_or_create!
#     end
# end





