:name
:surname

class Job
	def initialize(name, surname)
		@name = name
		@surname = surname
	end

	def name
		@name
	end

	def surname
		@surname
	end

	def toJson
		{name: @name, surname: @surname}.to_json
	end
end