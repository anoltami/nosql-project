require 'redis'
require 'json'
require './job'
require './utils'

$r = Redis.new

def addJob job
	$r.rpush('jobsUnDo', job.toJson)
end

$r.del('jobsUnDo')
$r.del('jobsDone')

terminated = 'O'

while terminated == 'O'
	
	method = prompt('GET', 'Méthode (GET par défaut) > ')
	url = ''
	while url == ''
		url = prompt('', 'URL > ')
	end

	type = ''
	while type == ''
		type = prompt('', 'TYPE (GithubAccount, GithubOrg, etc...) > ')
	end

	addJob Job.new(method, url, type)

	terminated = prompt('O', 'Ajouter un autre job ? (O/n) > ')

end
#addJob Job.new('GET', 'http://fr.linkedin.com/in/felixwattez')
puts $r.lrange('jobsUnDo',0,-1)