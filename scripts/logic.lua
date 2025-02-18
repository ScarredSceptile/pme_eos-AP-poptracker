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
	return latemissionCount > 0
end

function late_outlaws()
	local lateoutlawCount = Tracker:ProviderCountForCode("LateOutlawChecks")
	return lateoutlawCount > 0
end

function darkraiGoal()
	local count = Tracker:ProviderCountForCode("goal_darkrai")
	return count > 0
end

function canClearTemporalTower()
	local tower = Tracker:ProviderCountForCode("Temporal Tower")
	return enoughRelicFragments() and tower == 1
end

function enoughRelicFragments()
	local relicCount = Tracker:ProviderCountForCode("RelicFragmentCount")
	local relicGoal = Tracker:ProviderCountForCode("RequiredRelicFragmentShards")
	return relicCount >= relicGoal
end

function dungeonCleared(dungeonName)
	local dungeon = Tracker:FindObjectForCode("@Dungeons/"..dungeonName.."/Complete "..dungeonName)
	return dungeon.AvailableChestCount == 0
end

function has(item)
    return Tracker:ProviderCountForCode(item) == 1
end

function completed(location)
	return Tracker:FindObjectForCode('@Dungeons\\' + location + '\\Complete ' + location).ChestCount == 1
end