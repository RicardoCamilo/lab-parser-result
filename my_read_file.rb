class LaboratoryTestResult
	# columns 
	#   :code :string
	#   :result :float
	#   :format :string
	#   :comment :strint

	def initialize(map)

		resultMap = {
			"NEGATIVE" => {"format" => "boolean", "value" => -1.0},
			"POSITIVE" => {"format" => "boolean", "value" => -2.0},
			"NIL" => {"format" => "nil_3plus", "value" => -1.0},
			"+" => {"format" => "nil_3plus", "value" => -2.0},
			"++" => {"format" => "nil_3plus", "value" => -2.0},
			"+++" => {"format" => "nil_3plus", "value" => -3.0}
		}

    	@code = map["OBX"]["code"]
    	@result = Float map["OBX"]["value"] rescue resultMap[map["OBX"]["value"]]["value"]
    	@format = (@result.is_a? Float) ? "float" : resultMap[map["OBX"]["value"]]["format"]
    	@comment = map["NTE"].join("\n")
 	end
end

class LabParser
	def initialize(fileName)
		@fileName = fileName
	end

	def mapped_results()
		lines = {}
		File.foreach(@fileName) { |line| 
			type, id, *remainder = line.split("|").delete_if {|val| val == "\n"}
			if not (lines.key?(id))
				lines[id] = {"NTE" => []}	
			end
			
			if (type == "OBX")
				code, value = remainder
				lines[id]["OBX"] = {"code" => code, "value" => value}
			else
				comment, _ = remainder
				lines[id]["NTE"] << comment
			end
		}
		results = []
		lines.each_value do |map|
		  results << LaboratoryTestResult.new(map)
		end
		results
	end
end

p LabParser.new("results.txt").mapped_results[3]


