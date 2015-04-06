require 'redis'
require 'json'
require 'mongo'
require 'mongoid'
require 'rubygems'
require 'nokogiri'   
require 'open-uri'
require './job'


$r = Redis.new
# $c = Mongo::Connection.new
# Mongoid.database = $c['TP_Redis']

# class Page
# 	include Mongoid::Document

# 	field :title			, type: String 		, default: ''
# 	field :url				, type: String
# 	field :keywords			, type: Array 		, default: ''
# 	field :description		, type: String		, default: ''
# end

def getJobsUndo
	nbJobsToDo = $r.llen 'jobsUnDo'

	i = 0
	while i < nbJobsToDo
		statusJobs

		job = JSON.parse $r.lpop('jobsUnDo')
		job = Job.new(job['method'], job['url'])
		doJob job

		i += 1
	end

	statusJobs
end

def doJob job
	puts "#{job.method} sur #{job.url}"

	
	begin
	  webPage = Nokogiri::HTML(open(job.url))
	rescue Exception => e
	  puts "Impossible d'exploiter \"#{ job.url }\" : #{ e }"
	  exit
	end


	#LINKED IN
	# Récupération des localités
	localities = webPage.css('.locality')
	for x in localities
		puts x.text
	end

	

	$r.rpush('jobsDone', job.toJson)
	sleep 3
	puts "#{job.url} traité"
end

def statusJobs
	jobsUndoCount = $r.llen 'jobsUnDo'
	jobsDoneCount = $r.llen 'jobsDone'

	puts "Nombre de job(s) non traités : #{jobsUndoCount}"

	puts "Nombre de job(s) traités : #{jobsDoneCount}"
end

getJobsUndo

