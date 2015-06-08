require 'redis'
require 'json'
require 'mongo'
require 'mongoid'
require 'rubygems'
require 'nokogiri'   
require 'open-uri'
require './job'
require './utils'


$r = Redis.new

def getJobsUndo
	nbJobsToDo = $r.llen 'jobsUnDo'

	i = 0
	while i < nbJobsToDo
		statusJobs

		job = JSON.parse $r.lpop('jobsUnDo')
		job = Job.new(job['method'], job['url'], job['type'])
		doJob job

		i += 1
	end

	statusJobs
end

def addJob job
	$r.rpush('jobsUnDo', job.toJson)
end

def doJob job
	puts "#{job.method} sur #{job.url}"

	
	begin
	  	webPage = Nokogiri::HTML(open(job.url))
	rescue Exception => e
	  	puts "Impossible d'exploiter \"#{ job.url }\" : #{ e }"
	else

		#GITHUB Jobs
		
		if job.type == "GithubAccount"

			githubAccount = JSON.parse webPage
			nameInfos = githubAccount["name"].split();
			data = {
				pseudo: githubAccount["login"],
				githubUrl: githubAccount["url"],
				blog: githubAccount["blog"],
				location: githubAccount["location"],
				name: nameInfos[1],
				firstname: nameInfos[0],
				email: githubAccount["email"]
			}.to_json

			`curl -XPOST localhost:9200/helloeverybody/persons/ -d'#{data}'`

		elsif job.type == "GithubOrg"

			githubOrgMembers = JSON.parse webPage
			githubOrgMembers.each do |githubOrgMember| 
				if githubOrgMember["organizations_url"] != ""
					addJob Job.new('GET', githubOrgMember["organizations_url"], 'GithubOrg')
				end
				if githubOrgMember["url"] != ""
					addJob Job.new('GET', githubOrgMember["url"], 'GithubAccount')
				end
			end

		end
		#sleep 1
		puts "#{job.url} traité"
	ensure
		$r.rpush('jobsDone', job.toJson)
	end


	

end

def statusJobs
	jobsUndoCount = $r.llen 'jobsUnDo'
	jobsDoneCount = $r.llen 'jobsDone'

	puts "Nombre de job(s) non traités : #{jobsUndoCount}"

	puts "Nombre de job(s) traités : #{jobsDoneCount}"
end

getJobsUndo

