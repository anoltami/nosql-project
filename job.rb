:method
:url

class Job
	def initialize(method, url)
		@method = method
		@url = url
	end

	def method
		@method
	end

	def url
		@url
	end

	def toJson
		{method: @method, url: @url}.to_json
	end
end