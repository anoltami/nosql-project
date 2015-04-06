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
#terminated = prompt('O', 'Ajouter un autre job ? (O/n) > ')
while terminated == 'O'
	
	method = prompt('GET', 'Méthode (GET par défaut) > ')
	url = ''
	while url == ''
		url = prompt('', 'URL > ')
	end

	addJob Job.new(method, url)

	terminated = prompt('O', 'Ajouter un autre job ? (O/n) > ')

end
#addJob Job.new('GET', 'http://fr.linkedin.com/in/felixwattez')
puts $r.lrange('jobsUnDo',0,-1)