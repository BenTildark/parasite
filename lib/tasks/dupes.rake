require 'task_helpers/application_helper'

namespace :video do
	desc "Find & destory duplicate videos from each site"
	task :dupes => :environment do
		begin
			before_kat = Video.where(site: "kat.tv").group(:title).having("count(title) > 1").count(:title)
			if before_kat.count > 0
				puts "Kat dupes found: #{before_kat.count}"
				before_kat.each do |k,v|
					dupes = Video.where(site: "kat.tv").where(title: k)[1..v-1]
					puts "Destroying #{dupes.count} dupes from kat where title: #{k}"
					dupes.each(&:destroy)
				end
				after_kat = Video.where(site: "kat.tv").group(:title).having("count(title) > 1").count(:title)
				puts "Clean completed, now seeing: #{after_kat.count} dupes for kat.tv"
			else
				puts "No dupes found for kat.tv"
			end

			before_primewire = Video.where(site: "primewire.ag").group(:title).having("count(title) > 1").count(:title)
			if before_primewire.count > 0
				puts "primewire dupes found: #{before_primewire.count}"
				before_primewire.each do |k,v|
					dupes = Video.where(site: "primewire.ag").where(title: k)[1..v-1] # take away all bar first.
					puts "Destroying #{dupes.count} dupes from primewire where title: #{k}"
					dupes.each(&:destroy)
				end
				after_primewire = Video.where(site: "primewire.ag").group(:title).having("count(title) > 1").count(:title)
				puts "Clean completed, now seeing: #{after_primewire.count} dupes for primewire.ag"
			else
				puts "No dupes found for primewire.ag"
			end

			before_watchepisodeseries = Video.where(site: "watchepisodeseries.com").group(:title).having("count(title) > 1").count(:title)
			if before_watchepisodeseries.count > 0
				puts "watchepisodeseries dupes found: #{before_watchepisodeseries.count}"
				before_watchepisodeseries.each do |k,v|
					dupes = Video.where(site: "watchepisodeseries.com").where(title: k)[1..v-1]
					puts "Destroying #{dupes.count} dupes from watchepisodeseries where title: #{k}"
					dupes.each(&:destroy)
				end
				after_watchepisodeseries = Video.where(site: "watchepisodeseries.com").group(:title).having("count(title) > 1").count(:title)
				puts "Clean completed, now seeing: #{after_watchepisodeseries.count} dupes for watchepisodeseries.com"
			else
				puts "No dupes found for watchepisodeseries.com"
			end

			before_watchfree = Video.where(site: "watchfree.to").group(:title).having("count(title) > 1").count(:title)
			if before_watchfree.count > 0
				puts "watchfree dupes found: #{before_watchfree.count}"
				puts before_watchfree.count + " dupes found for watchfree.to".to_s
				before_watchfree.each do |k,v|
					dupes = Video.where(site: "watchfree.to").where(title: k)[1..v-1]
					puts "Destroying #{dupes.count} dupes from watchfree where title: #{k}"
					dupes.each(&:destroy)
				end
				after_watchfree = Video.where(site: "watchfree.to").group(:title).having("count(title) > 1").count(:title)
				puts "Clean completed, now seeing: #{after_watchfree.count} dupes for watchfree.to"
			else
				puts "No dupes found for watchfree.to"
			end
		rescue Exception => e
			puts "Dupes task ran error: " + e.message.to_s
		end
	end
end


