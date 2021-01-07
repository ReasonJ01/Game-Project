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
-- Save_file should be a string, is the file to load data from, default is "save_file"
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

-- This will check to see if a player_data file exists, if not a new one is created. Takes boolean for extra info printed to console.
function init_player_data(verbose)
	-- Find where save file should be
	local file_path = sys.get_save_file("Boat_Racer","player_data")
	-- Try to open the save file in read mode
	exists = io.open(file_path, "r")
	-- io.read returns nil if the file can't be found
	if exists then
		-- If the file exists then close it and no further action is needed
		io.close(exists)
		if verbose then
			print("player_data found at", file_path)
		end
	else
		if verbose then
			print("player_data not found at", file_path, "creating player_data \n")
		end
		-- Create a player_data file with starting values
		save("player_data", {strafe_speed = 50, ram_durability = 0, score_mult = 1, currency = 0}, verbose or false)
	end
end

-- Will create either a zerod table or a table of random ints 1-1000. Tables have 10 elements. Takes 3 bools.
-- rand will create the random table, verbose will print extra info.Overwrite will overwrite existing score_data.
function init_score_data(overwrite, rand,verbose)
	overwrite = overwrite or false
	rand = rand or false
	verbose = verbose or false
	scores = {}

	-- Find where save file should be
	local file_path = sys.get_save_file("Boat_Racer","score_data")
	-- Try to open the save file in read mode
	exists = io.open(file_path, "r")
	-- io.read returns nil if the file can't be found
	if exists and not overwrite then
		-- If the file exists then close it and no further action is needed
		io.close(exists)
		if verbose then
			print("score_data found at", file_path)
		end
	else
		-- File needs to be closed if being overwritten
		io.close(exists)
		if verbose then
			print("creating score_data at ", file_path)
		end
		-- Create a player_data file with starting values
		for i=1, 11 do
			if rand then
				scores[i] = math.random(1, 1000)
			else
				scores[i] = 0
			end
		end
		save("score_data", scores, verbose)
	end
end

