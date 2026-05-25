function early_missions()
	local missionCount = Tracker:ProviderCountForCode("EarlyMissionChecks")
	return missionCount > 0
end

function early_outlaws()
	local outlawCount = Tracker:ProviderCountForCode("EarlyOutlawChecks")
	return outlawCount > 0
end

function late_missions()
	local latemissionCount = Tracker:ProviderCountForCode("LateMissionChecks")
	return latemissionCount > 0 and darkraiGoal()
end

function late_outlaws()
	local lateoutlawCount = Tracker:ProviderCountForCode("LateOutlawChecks")
	return lateoutlawCount > 0 and darkraiGoal()
end

function darkraiGoal()
	local count = Tracker:ProviderCountForCode("goal_darkrai")
	return count > 0
end

function enoughRelicFragments()
	local relicCount = Tracker:ProviderCountForCode("RelicFragmentCount")
	local relicGoal = Tracker:ProviderCountForCode("RequiredRelicFragmentShards")
	return relicCount >= relicGoal
end

function canAccessDarkCrater()
	if darkraiGoal() then
		local instrumentCount = Tracker:ProviderCountForCode("Instruments")
		local instrumentGoal = Tracker:ProviderCountForCode("RequiredInstruments")
		return instrumentCount >= instrumentGoal and Tracker:ProviderCountForCode("Complete Temporal Tower")
	end
	return false
end

function canAccessSkyPeak(...)
	if Tracker:ProviderCountForCode("UnlockAllSkyPeakMode") == 1 then
		return Tracker:ProviderCountForCode("Sky Peak")
	end
	if Tracker:ProviderCountForCode("AllRandomSkyPeakMode") == 1 then
		local canAccess = 0
		for i,passNum in ipairs({...}) do
			local pass = tonumber(passNum)
			if pass == 1 then
				canAccess = Tracker:ProviderCountForCode("1st Station Pass")
			end
			if pass == 2 then
				canAccess = Tracker:ProviderCountForCode("2nd Station Pass")
			end
			if pass == 3 then
				canAccess = Tracker:ProviderCountForCode("3rd Station Pass")
			end
			if pass == 4 then
				canAccess = Tracker:ProviderCountForCode("4th Station Pass")
			end
			if pass == 5 then
				canAccess = Tracker:ProviderCountForCode("5th Station Pass")
			end
			if pass == 6 then
				canAccess = Tracker:ProviderCountForCode("6th Station Pass")
			end
			if pass == 7 then
				canAccess = Tracker:ProviderCountForCode("7th Station Pass")
			end
			if pass == 8 then
				canAccess = Tracker:ProviderCountForCode("8th Station Pass")
			end
			if pass == 9 then
				canAccess = Tracker:ProviderCountForCode("9th Station Pass")
			end
			if pass == 10 then
				canAccess = Tracker:ProviderCountForCode("Sky Peak Summit Pass")
			end
			if canAccess == 1 then
				return 1
			end
		end
		return 0
	end
	for i,passNum in ipairs({...}) do
		local pass = tonumber(passNum)
		return Tracker:ProviderCountForCode("Progressive Sky Peak") >= pass
	end
end

function aegisAccess(sealNum)
	local seal = tonumber(sealNum)
	if Tracker:ProviderCountForCode("CursedAegisCave") == 0 then
		return Tracker:ProviderCountForCode("Progressive Seal") >= seal
	end
	return false
end

function specialEpisodeAccess()
	return Tracker:ProviderCountForCode("ExcludeSpecial") == 0
end

function hasBags(num)
	local count = tonumber(num)
	if Tracker:ProviderCountForCode("BagUpgrades") >= count then
		return true
	end
	return false
end

function getPlayerDifficulty()
	local staticAdd = 0.495
	local stage = Tracker:FindObjectForCode("RecruitDifficulty").CurrentStage
	if stage == 0 then
		return 0.175 + staticAdd
	end
	if stage == 1 then
		return 0.125 + staticAdd
	end
	if stage == 2 then
		return 0.05 + staticAdd
	end
	if stage == 3 then
		return 0.001 + staticAdd
	end
	return 0.5
end

function isRecruitInLogic(odds)
	odds = tonumber(odds)
	local difficulty = tonumber(getPlayerDifficulty())
	if odds >= difficulty then
		return true -- Logic is handled in the locations
	end
	if odds + 0.100 >= difficulty then
		return recruitEarlyInLogic()
	end
	if odds + 0.225 >= difficulty then
		return recruitMidInLogic()
	end
	if odds + 0.326 >= difficulty then
		return recruitLateInLogic()
	end
	if odds + 0.496 >= difficulty then
		return recruitEndInLogic()
	end
	return false
end

function canBeRecruited(odds)
	odds = tonumber(odds)
	local difficulty = tonumber(getPlayerDifficulty())
	if odds >= difficulty then
		return true
	end
	if odds + 0.100 >= difficulty then
		return true
	end
	if odds + 0.225 >= difficulty then
		return darkraiGoal()
	end
	if odds + 0.326 >= difficulty then
		return darkraiGoal()
	end
	if odds + 0.496 >= difficulty then
		return darkraiGoal() and Tracker:ProviderCountForCode("LongLocations") == 1 and Tracker:ProviderCountForCode("RecruitLongLocations") == 1
	end
	return false
end

function isEvolutionInLogic(odds, level)
	odds = tonumber(odds)
	level = tonumber(odds)
	local difficulty = tonumber(getPlayerDifficulty())
	if odds >= difficulty and level <= 10 then
		return true
	end
	if odds + 0.100 >= difficulty and level ~= 0 and level <= 20 then
		return recruitEarlyInLogic() 
	end
	if odds + 0.225 >= difficulty and level ~= 0 and level <= 30 then
		return recruitMidInLogic()
	end
	if odds + 0.326 >= difficulty and level <= 45 then
		return recruitLateInLogic()
	end
	if odds + 0.496 >= difficulty then
		return recruitEndInLogic()
	end
	return false
end

function canEvolve(odds, level)
	odds = tonumber(odds)
	level = tonumber(level)
	local difficulty = tonumber(getPlayerDifficulty())
	if odds >= difficulty and level <= 10 then
		return true
	end
	if odds + 0.100 >= difficulty and level <= 20 then
		return true
	end
	if odds + 0.225 >= difficulty and level <= 30 then
		return darkraiGoal()
	end
	if odds + 0.326 >= difficulty and level <= 45 then
		return darkraiGoal()
	end
	if odds + 0.496 >= difficulty then
		print("Dragonite and Salamence should be here, so two of em")
		print(level)
		local result = darkraiGoal() and Tracker:ProviderCountForCode("LongLocations") == 1 and Tracker:ProviderCountForCode("RecruitLongLocations") == 1
		print(result)
		return result
	end
	return false
	
end

function recruitEarlyInLogic()
	return (Tracker:ProviderCountForCode("Amber Tear") == 1 or Tracker:ProviderCountForCode("Friend Bow") == 1 or Tracker:ProviderCountForCode("Golden Mask") == 1 or Tracker:ProviderCountForCode("ProgressiveRecruitment") >= 2)
end

function recruitMidInLogic()
	if not darkraiGoal() then
		return false
	end
	return recruitEarlyInLogic() and Tracker:ProviderCountForCode("Complete Temporal Tower") and (Tracker:ProviderCountForCode("Amber Tear") == 1 or Tracker:ProviderCountForCode("Golden Mask") == 1 or Tracker:ProviderCountForCode("ProgressiveRecruitment") >= 3)
end

function recruitLateInLogic()
	if not darkraiGoal() then
		return false
	end
	return recruitMidInLogic() and (Tracker:ProviderCountForCode("Golden Mask") == 1 or Tracker:ProviderCountForCode("ProgressiveRecruitment") >= 4)
end

function recruitEndInLogic()
	if not darkraiGoal() and Tracker:ProviderCountForCode("LongLocations") == 1 and Tracker:ProviderCountForCode("RecruitLongLocations") == 1 then
		return false
	end
	return recruitLateInLogic() and Tracker:ProviderCountForCode("Secret Rank") == 1 and (Tracker:ProviderCountForCode("Secret Slab") == 1 or Tracker:ProviderCountForCode("Mystery Part") == 1 or Tracker:ProviderCountForCode("ProgressiveRecruitment") == 5)
end