class TasksController < ApplicationController

	def kat
		system "rake scrape:kat &"
		@response = "running kat"
	end

	def primewire
		system "rake scrape:primewire &"
		@response = "running primewire"
	end

	def watchepisodeseries
		system "rake scrape:watchepisodeseries &"
		@response = "running watchepisodeseries"
	end

	def watchfree
		system "rake scrape:watchfree &"
		@response = "running watchfree"
	end

	def watchfree_tv
		system "rake scrape:watchfree_tv &"
		@response = "running watchfree_tv"
	end

	def featured
		system "rake scrape:featured &"
		@response = "running featured"
	end

	def duplicates
		system "rake video:dupes &"
		@response = "running duplicates"
	end

	def tasks
	end
end