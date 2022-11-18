local hero_data = {
	"centaur",
	{1, 2, 2, 3, 2, 5, 2, 1, 1, 3, 1, 5, 3, 3, 9, 6, 5, 11, 7, 13},
	{
		"item_tango","item_magic_stick","item_quelling_blade","item_flask","item_branches","item_branches","item_magic_wand","item_ring_of_health","item_boots","item_chainmail","item_phase_boots","item_hood_of_defiance","item_blink","item_fluffy_hat","item_ring_of_basilius","item_buckler","item_lifesteal","item_blades_of_attack","item_vladmir","item_wraith_pact","item_force_staff","item_reaver","item_overwhelming_blink","item_aghanims_shard",
	},
	{ {3,3,3,3,3,}, {3,3,3,3,3,}, 0.1 },
	{
		"Hoof Stomp","Double Edge","Retaliate","Hitch A Ride","Stampede","+5 Health Regen","+20 Movement Speed","+15 Strength","+40% Double Edge Strength Damage","+45 Retaliate Damage","-25s Stampede Cooldown","Gains Retaliate Aura","+1.0s Hoof Stomp Duration",
	}
}
--@EndAutomatedHeroData
if GetGameState() <= GAME_STATE_STRATEGY_TIME then return hero_data end

local abilities = {
		[0] = {"centaur_hoof_stomp", ABILITY_TYPE.NUKE + ABILITY_TYPE.STUN},
		{"centaur_double_edge", ABILITY_TYPE.NUKE},
		{"centaur_return", ABILITY_TYPE.PASSIVE},
		[5] = {"centaur_stampede", ABILITY_TYPE.MOBILITY + ABILITY_TYPE.SLOW},
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
