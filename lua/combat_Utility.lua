//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// combat_Utility.lua

// Used to send messages to all players.
function SendGlobalChatMessage(message)
	local allPlayers = Shared.GetEntitiesWithClassname("Player")
	if (allPlayers:GetSize() > 0) then
		for index, player in ientitylist(allPlayers) do
			player:SendDirectMessage(message)
		end
	end
	
	// Also output to the console for admins.
	Shared.Message(message)
end

// Gets the time in the format "[m minutes,] s seconds"
function GetTimeText(timeInSeconds)

	local timeLeftText = ""
	timeNumericSeconds = tonumber(timeInSeconds)
	ASSERT(timeNumericSeconds >= 0)
	if (timeNumericSeconds > 60) then
		timeLeftText = math.floor(timeNumericSeconds/60) .." minutes"
	elseif (timeNumericSeconds == 60) then
		timeLeftText = "1 minute"
	end
	
	
	if (timeNumericSeconds > 60 and timeNumericSeconds % 60 ~= 0) then
		timeLeftText = timeLeftText .. ", "
	end
	
	if (timeNumericSeconds % 60 ~= 0) then
		if (timeNumericSeconds % 60 == 1) then
			timeLeftText = timeLeftText .. "1 second"
		else
			timeLeftText = timeLeftText .. (timeNumericSeconds % 60) .." seconds"
		end
	end
	return timeLeftText

end

// Gets the time in the format "mm:ss:ms"
function GetTimeDigital(timeInSeconds)

	local timeLeftText = ""
	timeNumericSeconds = tonumber(timeInSeconds)
	if (timeNumericSeconds < 0) then 
		timeNumericSeconds = 0
	end
	
	local timeLeftMinutes = math.floor(timeNumericSeconds/60)
	if (timeLeftMinutes < 10) then
		timeLeftText = "0" .. timeLeftMinutes
	else
		timeLeftText = timeLeftMinutes
	end
	
	timeLeftText = timeLeftText .. ":"
	
	timeLeftSeconds = math.floor(timeNumericSeconds % 60)
	if (timeLeftSeconds < 10) then
		timeLeftText = timeLeftText .. "0" .. timeLeftSeconds
	else
		timeLeftText = timeLeftText .. timeLeftSeconds
	end
	
	// Disable milliseconds. They are *really* annoying.
	/*timeLeftText = timeLeftText .. ":"
	
	local timeLeftMilliseconds = math.ceil((timeNumericSeconds * 100) % 100)
	if (timeLeftMilliseconds < 10) then
		timeLeftText = timeLeftText .. "0" .. timeLeftMilliseconds
	else
		timeLeftText = timeLeftText .. timeLeftMilliseconds
	end*/
	
	return timeLeftText

end