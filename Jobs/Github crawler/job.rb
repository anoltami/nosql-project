:method
:url

class Job
	def initialize(method, url, type)
		@method 	= method
		@url 		= url
		@type 		= type
	end

	def method
		@method
	end

	def url
		@url
	end

	def type
		@type
	end

	def toJson
		{method: @method, url: @url, type: @type}.to_json
	end
end