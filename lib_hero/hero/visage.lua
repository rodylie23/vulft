local hero_data = {
	"visage",
	{2, 3, 1, 3, 1, 4, 1, 2, 3, 5, 3, 4, 2, 2, 7, 1, 4, 10, 12},
	{
		"item_branches","item_magic_stick","item_enchanted_mango","item_tango","item_branches","item_branches","item_magic_wand","item_null_talisman","item_boots","item_blight_stone","item_medallion_of_courage","item_crown","item_wind_lace","item_solar_crest","item_ancient_janggo","item_wind_lace","item_boots_of_bearing","item_cloak","item_headdress","item_pipe","item_hyperstone","item_buckler","item_assault","item_aghanims_shard","item_shivas_guard","item_point_booster","item_staff_of_wizardry","item_ogre_axe","item_ultimate_scepter","item_aghanims_shard",
	},
	{ {2,2,2,3,3,}, {2,2,2,3,3,}, 0.1 },
	{
		"Grave Chill","Soul Assumption","Gravekeeper's Cloak","Summon Familiars","-3.0s Grave Chill Cooldown","+6.0 Visage and Familiars Attack Damage","+1.0 Armor Corruption to Visage and Familiars","Soul Assumption Hits 2 Targets","+20 Soul Assumption Damage Per Charge","+20 Visage and Familiars Movement Speed","Gravekeeper's Cloak  grants +10 Armor","+1 Familiar",
	}
}
--@EndAutomatedHeroData
if GetGameState() <= GAME_STATE_STRATEGY_TIME then return hero_data end

local abilities = {
		[0] = {"template_hurt1", ABILITY_TYPE.NUKE},
		{"template_ouch", ABILITY_TYPE.NUKE},
		{"template_slow", ABILITY_TYPE.NUKE},
		[5] = {"template_big_slow", ABILITY_TYPE.NUKE},

}

local ZEROED_VECTOR = ZEROED_VECTOR
local playerRadius = Set_GetEnemyHeroesInPlayerRadius
local ENCASED_IN_RECT = Set_GetEnemiesInRectangle
local currentTask = Task_GetCurrentTaskHandle
local GSI_AbilityCanBeCast = GSI_AbilityCanBeCast
local CROWDED_RATING = Set_GetCrowdedRatingToSetTypeAtLocation
local USE_ABILITY = UseAbility_RegisterAbilityUseAndLockToScore
local INCENTIVISE = Task_IncentiviseTask
local VEC_UNIT_DIRECTIONAL = Vector_UnitDirectionalPointToPoint
local VEC_UNIT_FACING_DIRECTIONAL = Vector_UnitDirectionalFacingDirection
local ACTIVITY_TYPE = ACTIVITY_TYPE
local currentActivityType = Blueprint_GetCurrentTaskActivityType
local currentTask = Task_GetCurrentTaskHandle
local HIGH_USE = AbilityLogic_HighUseAllowOffensive
local min = math.min

local fight_harass_handle = FightHarass_GetTaskHandle()
local push_handle = Push_GetTaskHandle()

local t_player_abilities = {}

local d
d = {
	["ReponseNeeds"] = function()
		return nil, REASPONSE_TYPE_DISPEL, nil, {RESPONSE_TYPE_KNOCKBACK, 4}
	end,
	["Initialize"] = function(gsiPlayer)
		AbilityLogic_CreatePlayerAbilitiesIndex(t_player_abilities, gsiPlayer, abilities)
		AbilityLogic_UpdateHighUseMana(gsiPlayer, t_player_abilities[gsiPlayer.nOnTeam])
		gsiPlayer.InformLevelUpSuccess = d.InformLevelUpSuccess
	end,
	["InformLevelUpSuccess"] = function(gsiPlayer)
		AbilityLogic_UpdateHighUseMana(gsiPlayer, t_player_abilities[gsiPlayer.nOnTeam])
		AbilityLogic_UpdatePlayerAbilitiesIndex(gsiPlayer, t_player_abilities[gsiPlayer.nOnTeam], abilities)
	end,
	["AbilityThink"] = function(gsiPlayer)  
		if AbilityLogic_PlaceholderGenericAbilityUse(gsiPlayer, t_player_abilities) then
			return
		elseif false then

		end
	end,
}

local hero_access = function(key) return d[key] end

do
	HeroData_SetHeroData(hero_data, abilities, hero_access, true)
end
