local hero_data = {
	"luna",
	{1, 3, 3, 3, 3, 2, 2, 2, 2, 5, 4, 4, 1, 1, 7, 1, 4, 9, 11},
	{
		"item_quelling_blade","item_circlet","item_slippers","item_tango","item_branches","item_branches","item_wraith_band","item_magic_wand","item_boots","item_boots_of_elves","item_power_treads","item_lifesteal","item_mask_of_madness","item_blade_of_alacrity","item_dragon_lance","item_mithril_hammer","item_ogre_axe","item_black_king_bar","item_lesser_crit","item_staff_of_wizardry","item_fluffy_hat","item_hurricane_pike","item_claymore","item_satanic","item_ultimate_orb","item_ultimate_orb","item_skadi","item_silver_edge","item_blink","item_swift_blink","item_monkey_king_bar","item_staff_of_wizardry","item_ogre_axe","item_blade_of_alacrity","item_ultimate_scepter_2",
	},
	{ {1,1,1,1,2,}, {1,1,1,1,2,}, 0.1 },
	{
		"Lucent Beam","Moon Glaives","Lunar Blessing","Eclipse","-8% Moon Glaives Damage Reduction","+0.4s Lucent Beam Ministun","-2.0s Lucent Beam Cooldown","-25.0s Eclipse Cooldown","+500 Moon Glaives fired on Lucent Beam","+100 Lucent Beam Damage","+35 Lunar Blessing Damage","+0.25s Eclipse Lucent Ministun",
	}
}
--@EndAutomatedHeroData
if GetGameState() <= GAME_STATE_STRATEGY_TIME then return hero_data end

local abilities = {
		[0] = {"luna_lucent_beam", ABILITY_TYPE.STUN + ABILITY_TYPE.NUKE},
		{"luna_moon_glaive", ABILITY_TYPE.PASSIVE},
		{"luna_lunar_blessing", ABILITY_TYPE.PASSIVE + ABILITY_TYPE.BUFF},
		[5] = {"luna_eclipse", ABILITY_TYPE.NUKE},
}

local ZEROED_VECTOR = ZEROED_VECTOR
local playerRadius = Set_GetEnemyHeroesInPlayerRadius
local ENCASED_IN_RECT = Set_GetEnemiesInRectangle
local currentTask = Task_GetCurrentTaskHandle
local GSI_AbilityCanBeCast = GSI_AbilityCanBeCast
local USE_ABILITY = UseAbility_RegisterAbilityUseAndLockToScore
local VEC_UNIT_DIRECTIONAL = Vector_UnitDirectionalPointToPoint
local ACTIVITY_TYPE = ACTIVITY_TYPE
local currentActivityType = Blueprint_GetCurrentTaskActivityType

local fight_harass_handle = FightHarass_GetTaskHandle()

local t_player_abilities = {}

local d = {
	["ReponseNeeds"] = function()
		return nil, REASPONSE_TYPE_DISPEL, nil, {RESPONSE_TYPE_KNOCKBACK, 4}
	end,
	["Initialize"] = function(gsiPlayer)
		AbilityLogic_CreatePlayerAbilitiesIndex(t_player_abilities, gsiPlayer, abilities)
		AbilityLogic_UpdateHighUseMana(gsiPlayer, t_player_abilities[gsiPlayer.nOnTeam])
	end,
	["InformLevelUpSuccess"] = function(gsiPlayer)
		AbilityLogic_UpdateHighUseMana(gsiPlayer, t_player_abilities[gsiPlayer.nOnTeam])
	end,
	["AbilityThink"] = function(gsiPlayer) 
		if AbilityLogic_PlaceholderGenericAbilityUse(gsiPlayer, t_player_abilities) then
			return
		elseif false then -- TODO generic item use (probably can use same func for finished heroes)

		end
	end,
}

local hero_access = function(key) return d[key] end

do
	HeroData_SetHeroData(hero_data, abilities, hero_access)
end
