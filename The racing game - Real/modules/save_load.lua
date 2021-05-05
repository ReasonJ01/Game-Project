-- require "modules.save_load"


-- Saves supplied data
-- Save file should be a string,the name of the file.
-- data is a table of values.
-- verbose is a boolean. Whether or not to display saving info, false by default.
function save(save_file, data, verbose)
	-- set defaults
	verbose = verbose or false
	
	-- Check if data provided and that data is a table.
	if data and type(data) == "table" then
		
		-- Get the file_path to the save file
		file_path = sys.get_save_file("Boat_Racer",save_file)
		-- load saved data and add new data to it in order to prevent old data from being overwritten.
		loaded_table = sys.load(file_path)
		
		for k, v in pairs(data) do
			loaded_table[tostring(k)] = v
		end
		
		-- Save data
		sys.save(file_path, loaded_table)
	else 
		print("No data supplied or data was not of type 'table'")
		-- No need for saving info if no data to be saved
		verbose = false
	end

	if verbose then
		-- print newly saved data
		print("saved following data to:", file_path)
		pprint(data)
		-- print contents of the whole file
		print(file_path, "now contains:")
		pprint(loaded_table)
	end
end


--loads data from specified file and returns specified value if key given otherwise it returns the full table
-- Save_file should be a string, is the file to load data from.
-- key is the key for a corresponding value in the table.
-- verbose is a boolean, whether or not to include loading info, false by default.
function load(save_file, key, verbose)
	-- Set defaults
	local verbose = verbose or false
	
	-- load data from the specified file
	local file_path = sys.get_save_file("Boat_Racer",save_file)
	local table = sys.load(file_path)
	-- load info
	if verbose then
		print("loading", key or "all", "from", file_path)
		pprint(table)
	end
	-- if a specific value is required return that value otherwise return the whole table
	if key then 
		return table[tostring(key)]
	else
		return table
	end
end

-- removes a specified key from the specified save file.
-- Save_file should be a string, is the file to delete data from.
-- key is the key for a corresponding value in the table.
-- verbose is a boolean, whether or not to include loading info, false by default.
function removeData(save_file, key, verbose)
	-- Set default
	local verbose = verbose or false
	
	-- load data from specific file into a table
	local file_path = sys.get_save_file("Boat_Racer",save_file)
	local loaded_table = sys.load(file_path)
	
	-- if a key given then delete the associated value and overwrite the old table with the new one
	if key then
		if verbose then
			print("deleting", key, ":", loaded_table[key], "from", file_path)
		end
		loaded_table[key] = nil
		sys.save(file_path, loaded_table)
	else
		print("no key provided")
	end
	-- print data about what value is being deleted from which file. Show contents of new file.
	if verbose then
		print(file_path, "now contains:")
		pprint(loaded_table)
	end
end

--Used to either create/overwrite player_data.
-- takes 2 bools, verbose for extra infomation, overwrite to specify if an existing file should be overwritten
function init_player_data(verbose, overwrite)
	-- Try to load the strafe_speed, if it does not exist it returns nil.
	if not load("player_data", "strafe_speed", false) or overwrite then

		if verbose then
			print("Player data not found/ being overwritten, creating file.")
		end

		-- Create new file with default values
		save("player_data", {strafe_speed = 100, ram_durability = 0, score_mult = 1, currency = 300}, verbose or false)
	end
end

-- Checks to see if score data exists and creates it if not.
-- Takes bool overwrite: whether to overwrite existing data.
-- Bool rand: Whether to initialise as scores as random values (for testing sort)
-- Bool verbose: whether to print extra information
function init_score_data(overwrite, rand,verbose)
	scores = load("score_data")
	if not scores[1] or overwrite then
		if verbose then
			print("Score data not found/ being overwritten, creating file.")
		end
		for i=1, 11 do
			if rand then
				table.insert(scores, math.random(1, 1000))
			else
				table.insert(scores, 0)
			end
		end
		save("score_data", scores, verbose)
	end
end

-- Bubble sort
-- Scores should be a table of length 11
--Sort the list of scores high -low
function sort(scores)
	--for every position in the list
	for j=1,11 do
		--Compare the value of each position to the one before it
		for i=2,11 do

			a = scores[tostring(i-1)]
			b = scores[tostring(i)]

			--Set the earlier position i.e. the position of the bigger number to the biggest of the two values
			scores[tostring(i-1)] = math.max(a,b)
			--Set the later, i.e. the position of the lower number to the smaller of the two values
			scores[tostring(i)] = math.min(a,b)
		end
	end
end