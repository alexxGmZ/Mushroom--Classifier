#!/usr/bin/env lua
local inspect = require("inspect")

----------- Historical Data ------------
-- Read the training data file and store the data in a table
local TRAINING_DATA = {}
local HISTORICAL_DATA_FILE = io.open("MushroomCSV.csv", "r")

-- terminate the program if file historical data file not found
if not HISTORICAL_DATA_FILE then
	print("Historical Data file not found")
	os.exit()
end

-- read the HEADER line and split it into column names
local COLUMN_NAMES = {}
local HEADER = HISTORICAL_DATA_FILE:read()
for column in string.gmatch(HEADER, "[^,]+") do
	-- print(column)
	table.insert(COLUMN_NAMES, column)
end

-- read the data lines and split them into columns
for line in HISTORICAL_DATA_FILE:lines() do
	local data = {}
	local i = 1
	for column in string.gmatch(line, "[^,]+") do
		-- remove "\r", it causes a bug
		column = string.gsub(column, "\r", "")
		COLUMN_NAMES[i] = string.gsub(COLUMN_NAMES[i], "\r", "")

		-- kinda preprocessing for "b'w'" and "b'y'"
		if string.find(column, "b'w'") or string.find(column, "b'y'") then
			column = string.gsub(column, "b'w'", "unknown")
			column = string.gsub(column, "b'y'", "unknown")
		end

		data[COLUMN_NAMES[i]] = column

		i = i + 1
	end
	table.insert(TRAINING_DATA, data)
end
-- print(inspect(TRAINING_DATA))

HISTORICAL_DATA_FILE:close()
----------- Historical Data ------------


----------- Input Data -----------
local INPUT_DATA = {}
local INPUT_CSV_FILE = io.open("input.csv", "r")
if not INPUT_CSV_FILE then
	print("Input Data File not found")
	os.exit()
end

-- store the input.csv data inside INPUT_DATA table
-- loop over each line in the file
for line in INPUT_CSV_FILE:lines() do
	local row = {}
	for value in line:gmatch("[^,]+") do
		-- add each value to the row table
		table.insert(row, value)
	end

	-- add the row table to the csv_data table
	table.insert(INPUT_DATA, row)
end

INPUT_CSV_FILE:close()  -- close the file
----------- Input Data -----------


-- count total class counts
-- local CLASS_COUNTS = {0, 0}
local CLASS_COUNTS = {
	edible = 0,
	poisonous = 0
}
for _, data in ipairs(TRAINING_DATA) do
	if data.CLASS == "edible" then
		-- CLASS_COUNTS[1] = CLASS_COUNTS[1] + 1
		CLASS_COUNTS.edible = CLASS_COUNTS.edible + 1
	end

	if data.CLASS == "poisonous" then
		-- CLASS_COUNTS[2] = CLASS_COUNTS[2] + 1
		CLASS_COUNTS.poisonous = CLASS_COUNTS.poisonous + 1
	end
end
-- print("edible: " .. CLASS_COUNTS[1] .. "   poisonous: " .. CLASS_COUNTS[2])

-- local class_priors = {}
-- for class, count in ipairs(CLASS_COUNTS) do
-- 	class_priors[class] = count / TOTAL_COUNT
-- end
-- print(inspect(class_priors))


-------------- Probability table ---------------
local LIKELIHOODS = {}
for _, column_name in ipairs(COLUMN_NAMES) do
	if column_name ~= "CLASS" then
		LIKELIHOODS[column_name] = {}

		for class_name, _ in pairs(CLASS_COUNTS) do
			-- print(class_name, class_count)
			LIKELIHOODS[column_name][class_name] = {}

			local feature_values = {}
			for _, data in ipairs(TRAINING_DATA) do
				if data.CLASS == class_name then
					local feature_value = data[column_name]
					if not feature_values[feature_value] then
						feature_values[feature_value] = 1
					else
						feature_values[feature_value] = feature_values[feature_value] + 1
					end
				end
			end
			-- print(inspect(feature_values))

			for feature_value, count in pairs(feature_values) do
				local likelihood = count / CLASS_COUNTS[class_name]
				LIKELIHOODS[column_name][class_name][feature_value] = likelihood
			end

			-- Check if any feature value was missing for this class and set its likelihood to 0
			for feature_value, _ in pairs(feature_values) do
				if not LIKELIHOODS[column_name][class_name][feature_value] then
					LIKELIHOODS[column_name][class_name][feature_value] = 0
				end
			end
		end
	end
end

-- write the LIKELIHOODS in a table file
local TABLE_FILE = io.open("table.log", "w")
TABLE_FILE:write(inspect(LIKELIHOODS))
TABLE_FILE:close()
-- print(inspect(LIKELIHOODS))
-------------- Probability table ---------------


-------------- Classifier ---------------
-- define the function to classify a mushroom as "edible" or "poisonous"
function classify_mushroom(test_data)
	-- initialize with values for both classes
	local class_scores = {
		edible = 1,
		poisonous = 1
	}

	for class, _ in pairs(CLASS_COUNTS) do
		for i, feature_value in ipairs(test_data) do
			local feature_likelihood = LIKELIHOODS[COLUMN_NAMES[i]][class][feature_value]
			if feature_likelihood ~= nil then
				class_scores[class] = class_scores[class] * feature_likelihood
			else
				-- if the feature value is not in the training data, assume a small probability
				class_scores[class] = class_scores[class] * 0.00000000000000000001
			end
		end
	end
	return class_scores
end
-------------- Classifier ---------------


local RESULT_FILE = io.open("result.log", "w")
local OUTPUT_CSV_FILE = io.open("output.csv", "w")
-- test the classifier on the test data
for i, test_case in ipairs(INPUT_DATA) do
	local class_scores = classify_mushroom(test_case)
	local edible_prob = (class_scores.edible * CLASS_COUNTS.edible) / #TRAINING_DATA
	local poisonous_prob = (class_scores.poisonous * CLASS_COUNTS.poisonous) / #TRAINING_DATA

	local classification = "poisonous"
	if edible_prob > poisonous_prob then
		classification = "edible"
	end

	-- write to result.log
	RESULT_FILE:write(i .. " INPUT: " .. table.concat(test_case, ", ") .. "\n")
	RESULT_FILE:write(i .. " EDIBLE PROBABILITY: " .. edible_prob .. "\n")
	RESULT_FILE:write(i .. " POISONOUS PROBABILITY: " .. poisonous_prob .. "\n")
	RESULT_FILE:write(i .. " CLASS: " .. classification .. "\n\n")

	-- write to output.csv
	OUTPUT_CSV_FILE:write(table.concat(test_case, ",") .. "," .. classification .. "\n")

	-- output to terminal
	print(i .. " INPUT: " .. table.concat(test_case, ", "))
	print(i .. " EDIBLE PROBABILITY: " .. edible_prob)
	print(i .. " POISONOUS PROBABILITY: " .. poisonous_prob)
	print(i .. " CLASS: " .. classification .. "\n")
end

RESULT_FILE:close()
OUTPUT_CSV_FILE:close()
