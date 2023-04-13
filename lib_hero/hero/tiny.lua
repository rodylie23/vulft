local hero_data = {
	"tiny",
	{3, 1, 1, 2, 1, 4, 1, 2, 2, 2, 5, 4, 3, 3, 8, 3, 4, 9, 11},
	{
		"item_faerie_fire","item_quelling_blade","item_branches","item_branches","item_tango","item_ward_observer","item_bottle","item_belt_of_strength","item_boots","item_gloves","item_power_treads","item_blink","item_magic_wand","item_quarterstaff","item_oblivion_staff","item_echo_sabre","item_point_booster","item_staff_of_wizardry","item_blade_of_alacrity","item_ultimate_scepter","item_echo_sabre","item_lesser_crit","item_mithril_hammer","item_black_king_bar","item_shadow_amulet","item_blitz_knuckles","item_silver_edge","item_lesser_crit","item_greater_crit","item_aghanims_shard","item_sange_and_yasha",
	},
	{ {2,2,3,4,4,}, {2,2,4,5,5,}, 0.1 },
	{
		"Avalanche","Toss","Tree Grab","Grow","+20 Movement Speed","+10 Strength","+10% Status Resistance","+80 Avalanche Damage","+40% Grow Bonus Damage With Tree","Toss Requires No Target","-8s Avalanche Cooldown","2 Toss Charges",
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
	end,
	["AbilityThink"] = function(gsiPlayer)  
		-- Any spell immune unit cannot be tossed
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