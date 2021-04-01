function RegisterMod(modname, apiversion)
  local mod = {
    Name = modname,
    AddCallback = function(self, callbackId, fn, entityId)
      if entityId == nil then entityId = -1; end
      
      Isaac.AddCallback(self, callbackId, fn, entityId)
    end,
	RemoveCallback = function(self, callbackId, fn)
	  Isaac.RemoveCallback(self, callbackId, fn)
	end,
    SaveData = function(self, data)
      Isaac.SaveModData(self, data)
    end,
    LoadData = function(self)
      return Isaac.LoadModData(self)
    end,
    HasData = function(self)
      return Isaac.HasModData(self)
    end,
    RemoveData = function(self)
      Isaac.RemoveModData(self)
    end
  }
  Isaac.RegisterMod(mod, modname, apiversion)
  return mod
end

function StartDebug()
  local ok, m = pcall(require, 'mobdebug') 
  if ok and m then
    m.start()
  else
    Isaac.DebugString("Failed to start debugging.")
    -- m is now the error 
    -- Isaac.DebugString(m)
  end
end

------------------------------------------------------------
-- Compatibility wrappers begin here

local META, META0
local function BeginClass(T)
	META = {}
	if type(T) == "function" then
		META0 = getmetatable(T())
	else
		META0 = getmetatable(T).__class
	end
end

local function EndClass()
	local oldIndex = META0.__index
	local newMeta = META
	
	rawset(META0, "__index", function(self, k)
		return newMeta[k] or oldIndex(self, k)
	end)
end

-- Isaac -----------------------------------------------

local Isaac_GetPlayer = Isaac.GetPlayer
function Isaac.GetPlayer(i)
	return Isaac_GetPlayer(i or 0)
end

---------------------------------------------------------
BeginClass(ItemPool)

--.addFunction("GetCollectible", (s32(ItemPool::*)(s32, u32, u32, u32))&ItemPool::GetCollectible) //	 eCollectibleType GetCollectible ( eItemPoolType PoolType , bool Decrease , u32 Seed ) ;
local ItemPool_GetCollectible = META0.GetCollectible
function META:GetCollectible(poolType, decrease, seed, defaultItem)
	return ItemPool_GetCollectible(self, poolType, seed or Random(), (decrease and 0) or 1, defaultItem or 0)
end

--.addFunction("GetTrinket", (s32(ItemPool::*)(bool))&ItemPool::GetTrinket) //	 eTrinketType 	 GetTrinket ( void ) ;
local ItemPool_GetTrinket = META0.GetTrinket
function META:GetTrinket(noAdvance)
	return ItemPool_GetTrinket(self, noAdvance)
end

--.addFunction("GetPillEffect", (s32(ItemPool::*)(s32, Entity_Player*))&ItemPool::GetPillEffect) //	 ePillEffect GetPillEffect ( ePillColor PillColor ) ;
local ItemPool_GetPillEffect = META0.GetPillEffect
function META:GetPillEffect(pillColor, player)
	return ItemPool_GetPillEffect(self, pillColor, player)
end

EndClass()

---------------------------------------------------------
BeginClass(SFXManager)

--.addFunction("Play", (void (SoundEffects::*)(eSoundEffect, float, s32, bool, float, float))&SoundEffects::Play) //	 void Play ( eSoundEffect ID , float Volume , s32 FrameDelay , bool Loop = false , float Pitch = 1.0 f ) ;
local SFXManager_Play = META0.Play
function META:Play(sound, volume, frameDelay, loop, pitch, pan)
	SFXManager_Play(self, sound, volume or 1, frameDelay or 2, loop, pitch or 1, pan or 0)
end

EndClass()

---------------------------------------------------------
BeginClass(TemporaryEffects)

--.addFunction<void (TemporaryEffects::*)(s32, bool)>("AddCollectibleEffect", (void (TemporaryEffects::*)(eCollectibleType, bool, u32))&TemporaryEffects::AddEffect)
local TemporaryEffects_AddCollectibleEffect = META0.AddCollectibleEffect
function META:AddCollectibleEffect(id, addCostume, num)
	TemporaryEffects_AddCollectibleEffect(self, id, addCostume or addCostume == nil, num or 1)
end

--.addFunction<void (TemporaryEffects::*)(s32, bool)>("AddTrinketEffect", (void (TemporaryEffects::*)(eTrinketType, bool, u32))&TemporaryEffects::AddEffect)
local TemporaryEffects_AddTrinketEffect = META0.AddTrinketEffect
function META:AddTrinketEffect(id, addCostume, num)
	TemporaryEffects_AddTrinketEffect(self, id, addCostume or addCostume == nil, num or 1)
end

--.addFunction<void (TemporaryEffects::*)(s32, bool)>("AddNullEffect", (void (TemporaryEffects::*)(ItemConfig::eNullItemID, bool, u32))&TemporaryEffects::AddEffect)
local TemporaryEffects_AddNullEffect = META0.AddNullEffect
function META:AddNullEffect(id, addCostume, num)
	TemporaryEffects_AddNullEffect(self, id, addCostume or addCostume == nil, num or 1)
end

--.addFunction<void (TemporaryEffects::*)(s32)>("RemoveCollectibleEffect", (void (TemporaryEffects::*)(eCollectibleType, u32))&TemporaryEffects::RemoveEffect)
local TemporaryEffects_RemoveCollectibleEffect = META0.RemoveCollectibleEffect
function META:RemoveCollectibleEffect(id, num)
	TemporaryEffects_RemoveCollectibleEffect(self, num or 1)
end

--.addFunction<void (TemporaryEffects::*)(s32)>("RemoveTrinketEffect", (void (TemporaryEffects::*)(eTrinketType, u32))&TemporaryEffects::RemoveEffect)
local TemporaryEffects_RemoveTrinketEffect = META0.RemoveTrinketEffect
function META:RemoveTrinketEffect(id, num)
	TemporaryEffects_RemoveTrinketEffect(self, num or 1)
end

--.addFunction<void (TemporaryEffects::*)(s32)>("RemoveNullEffect", (void (TemporaryEffects::*)(ItemConfig::eNullItemID, u32))&TemporaryEffects::RemoveEffect)
local TemporaryEffects_RemoveNullEffect = META0.RemoveNullEffect
function META:RemoveNullEffect(id, num)
	TemporaryEffects_RemoveNullEffect(self, num or 1)
end
		
EndClass()

---------------------------------------------------------
BeginClass(Room)

--.addFunction("FindFreePickupSpawnPosition", (Vector2 (Room::*)(const Vector2&, float, bool, bool) const)&Room::FindFreePickupSpawnPosition)
local Room_FindFreePickupSpawnPosition = META0.FindFreePickupSpawnPosition
function META:FindFreePickupSpawnPosition(pos, initStep, avoidActive, allowPits)
	return Room_FindFreePickupSpawnPosition(self, pos, initStep or 0, avoidActive, allowPits)
end

--.addFunction("CheckLine", (bool (Room::*)(const Vector2 &, const Vector2 &, s32, s32, bool, bool, Vector2*) const)&Room::CheckLine) //	 	 bool CheckLine ( const Vector2 & Pos1 , const Vector2 & Pos2 , eLinecheckMode Mode , s32 GridPathThreshold = 0 , bool IgnoreWalls = false , bool IgnoreCrushable = false ) const ;
local Room_CheckLine = META0.CheckLine
function META:CheckLine(pos1, pos2, mode, gridPathThreshold, ignoreWalls, ignoreCrushable)
	local out = Vector(0, 0)
	local ok = Room_CheckLine(self, pos1, pos2, mode, gridPathThreshold or 0, ignoreWalls, ignoreCrushable, out)
	return ok, out
end

EndClass()

---------------------------------------------------------
BeginClass(MusicManager)

--.addFunction<void (Music::*)(s32, float)>("Fadein", (void (Music::*)(eMusic, float, float))&Music::Fadein) //	 void Fadein ( eMusic ID , float Volume ) ;
local MusicManager_Fadein = META0.Fadein
function META:Fadein(id, volume, fadeRate)
	MusicManager_Fadein(self, id, volume or 1, fadeRate or 0.08)
end

--.addFunction("Crossfade", (void (Music::*)(s32, float))&Music::Crossfade) //	 void Crossfade ( eMusic ID ) ;
local MusicManager_Crossfade = META0.Crossfade
function META:Crossfade(id, fadeRate)
	MusicManager_Crossfade(self, id, fadeRate or 0.08)
end

--.addFunction("Fadeout", &Music::Fadeout) //	 void Fadeout ( void ) ;
local MusicManager_Fadeout = META0.Fadeout
function META:Fadeout(id, fadeRate)
	MusicManager_Fadeout(self, id, fadeRate or 0.08)
end

--.addFunction("EnableLayer", &Music::EnableLayer) //	 void EnableLayer ( void ) {
local MusicManager_EnableLayer = META0.EnableLayer
function META:EnableLayer(id, instant)
	MusicManager_EnableLayer(self, id or 0, instant)
end

--.addFunction("DisableLayer", &Music::DisableLayer) //	 void DisableLayer ( void ) {
local MusicManager_DisableLayer = META0.DisableLayer
function META:DisableLayer(id)
	MusicManager_DisableLayer(self, id or 0)
end

--.addFunction("IsLayerEnabled", &Music::IsLayerEnabled) //	 bool IsLayerEnabled ( void ) const {
local MusicManager_IsLayerEnabled = META0.IsLayerEnabled
function META:IsLayerEnabled(id)
	return MusicManager_IsLayerEnabled(self, id or 0)
end

EndClass()

---------------------------------------------------------
BeginClass(Level)

--.addFunction("GetRoomByIdx", (RoomDescriptor& (Level::*)(s32, s32))&Level::GetRoomByIdx) //	 RoomDescriptor & GetRoomByIdx ( s32 RoomIdx ) ;
local Level_GetRoomByIdx = META0.GetRoomByIdx
function META:GetRoomByIdx(idx, dim)
	return Level_GetRoomByIdx(self, idx, dim or -1)
end

--.addFunction("QueryRoomTypeIndex", (s32 (Level::*)(s32, bool, RNG &, bool))&Level::QueryRoomTypeIndex) //	 s32 QueryRoomTypeIndex ( eRoomType RoomType , bool Visited , RNG & rng ) ;
local Level_QueryRoomTypeIndex = META0.QueryRoomTypeIndex
function META:QueryRoomTypeIndex(roomType, visited, rng, ignoreGroup)
	return Level_QueryRoomTypeIndex(self, roomType, visited, rng, ignoreGroup)
end

EndClass()

---------------------------------------------------------
BeginClass(Entity)

--.addFunction("IsVulnerableEnemy", &Entity::IsVulnerableEnemy)
local Entity_IsVulnerableEnemy = META0.IsVulnerableEnemy
function META:IsVulnerableEnemy(other)
	return Entity_IsVulnerableEnemy(self, other)
end

EndClass()

---------------------------------------------------------
BeginClass(EntityFamiliar)

--.addFunction("PickEnemyTarget", &Entity_Familiar::pick_enemy_target)
local Entity_Familiar_PickEnemyTarget = META0.PickEnemyTarget
function META:PickEnemyTarget(maxDist, frameInterval, flags, coneDir, coneAngle)
	Entity_Familiar_PickEnemyTarget(self, maxDist, frameInterval or 13, flags or 0, coneDir or Vector(0, 0), coneAngle or 15)
end

EndClass()

---------------------------------------------------------
BeginClass(EntityNPC)

--.addFunction("MakeChampion", &Entity_NPC::MakeChampion)
local Entity_NPC_MakeChampion = META0.MakeChampion
function META:MakeChampion(seed, championType, init)
	Entity_NPC_MakeChampion(self, seed, championType or -1, init)
end
		
EndClass()

---------------------------------------------------------
BeginClass(EntityPickup)

--.addFunction("TryOpenChest", &Entity_Pickup::TryOpenChest)
local Entity_Pickup_TryOpenChest = META0.TryOpenChest
function META:TryOpenChest(player)
	Entity_Pickup_TryOpenChest(player)
end

EndClass()

---------------------------------------------------------
BeginClass(EntityPlayer)

--.addFunction("AddCollectible", (void (Entity_Player::*)(s32, s32, bool, s32, s32))&Entity_Player::AddCollectible)
local Entity_Player_AddCollectible = META0.AddCollectible
function META:AddCollectible(id, charge, addConsumables, activeSlot, varData)
	Entity_Player_AddCollectible(self, id, charge or 0, addConsumables or addConsumables == nil, activeSlot or 0, varData or 0)
end

--.addFunction("AddTrinket", (void (Entity_Player::*)(s32, bool))&Entity_Player::AddTrinket)
local Entity_Player_AddTrinket = META0.AddTrinket
function META:AddTrinket(id, addConsumables)
	Entity_Player_AddTrinket(self, id, addConsumables or addConsumables == nil)
end

--.addFunction("GetActiveItem", (s32 (Entity_Player::*)(s32) const)&Entity_Player::GetActiveItem)
local Entity_Player_GetActiveItem = META0.GetActiveItem
function META:GetActiveItem(id)
	return Entity_Player_GetActiveItem(self, id or 0)
end

--.addFunction("GetActiveCharge", &Entity_Player::GetActiveCharge)
local Entity_Player_GetActiveCharge = META0.GetActiveCharge
function META:GetActiveCharge(id)
	return Entity_Player_GetActiveCharge(self, id or 0)
end

--.addFunction("GetBatteryCharge", &Entity_Player::GetBatteryCharge)
local Entity_Player_GetBatteryCharge = META0.GetBatteryCharge
function META:GetBatteryCharge(id)
	return Entity_Player_GetBatteryCharge(self, id or 0)
end

--.addFunction("GetActiveSubCharge", &Entity_Player::GetActiveSubCharge)
local Entity_Player_GetActiveSubCharge = META0.GetActiveSubCharge
function META:GetActiveSubCharge(id)
	return Entity_Player_GetActiveSubCharge(self, id or 0)
end

--.addFunction("SetActiveCharge", &Entity_Player::SetActiveCharge)
local Entity_Player_SetActiveCharge = META0.SetActiveCharge
function META:SetActiveCharge(charge, id)
	Entity_Player_SetActiveCharge(self, charge, id or 0)
end

--.addFunction("DischargeActiveItem", &Entity_Player::DischargeActiveItem)
local Entity_Player_DischargeActiveItem = META0.DischargeActiveItem
function META:DischargeActiveItem(id)
	Entity_Player_DischargeActiveItem(self, id or 0)
end

--.addFunction("NeedsCharge", &Entity_Player::NeedsCharge)
local Entity_Player_NeedsCharge = META0.NeedsCharge
function META:NeedsCharge(id)
	return Entity_Player_NeedsCharge(self, id or 0)
end

--.addFunction("FullCharge", &Entity_Player::FullCharge)
local Entity_Player_FullCharge = META0.FullCharge
function META:FullCharge(id, force)
	return Entity_Player_FullCharge(self, id or 0, force)
end

--.addFunction("CheckFamiliar", &Entity_Player::check_familiar) //	 void check_familiar ( u32 FamiliarVariant , s32 TargetCount , RNG & rng ) ;
local Entity_Player_CheckFamiliar = META0.CheckFamiliar
function META:CheckFamiliar(variant, count, rng, sourceItem, subType)
	return Entity_Player_CheckFamiliar(self, variant, count, rng, sourceItem, subType or -1)
end

--.addFunction("UseActiveItem", (void (Entity_Player::*)(s32, u32, s32, s32))&Entity_Player::UseActiveItem)
local Entity_Player_UseActiveItem = META0.UseActiveItem
function META:UseActiveItem(item, showAnim, keepActive, allowNonMain, addCostume, activeSlot)
	local useFlags = 0
	if showAnim == false then useFlags = useFlags + 1 end
	if keepActive == false then useFlags = useFlags + 16 end
	if allowNonMain then useFlags = useFlags + 8 end
	if addCostume == false then useFlags = useFlags + 2 end
	
	return Entity_Player_UseActiveItem(self, item, useFlags, activeSlot or -1, 0)
end

--.addFunction("HasInvincibility", &Entity_Player::HasInvincibility)
local Entity_Player_HasInvincibility = META0.HasInvincibility
function META:HasInvincibility(damageFlags)
	return Entity_Player_HasInvincibility(self, damageFlags or 0)
end

--.addFunction("GetMultiShotParams", (Weapon::MultiShotParams (Entity_Player::*)(s32))&Entity_Player::GetMultiShotParams)
local Entity_Player_GetMultiShotParams = META0.GetMultiShotParams
function META:GetMultiShotParams(weaponType)
	return Entity_Player_GetMultiShotParams(self, weaponType or 1)
end

--.addFunction("GetMaxPocketItems", &Entity_Player::GetMaxPocketItems)
META.GetMaxPoketItems = META0.GetMaxPocketItems

EndClass()

---------------------------------------------------------

--[[
		//.addFunction("GetMultiShotPositionVelocity", &Entity_Player::GetMultiShotPositionVelocity)
		.addStaticFunction("GetMultiShotPositionVelocity", &Entity_Player::GetMultiShotPositionVelocity)
		
		//.addProperty("TheresOptionsPickup", &Entity_Pickup::GetTheresOptionsPickup, &Entity_Pickup::SetTheresOptionsPickup)
		.addProperty("OptionsPickupIndex", &Entity_Pickup::GetOptionsPickupIndex, &Entity_Pickup::SetOptionsPickupIndex)
		
		-- no wrappers needed
		.addFunction("HasPathToPos", (bool (NPCAI_Pathfinder::*)(const Vector2&, bool) const)&NPCAI_Pathfinder::HasPathToPos)
		
		.addFunction("HasCollectible", (bool (Entity_Player::*)(s32, bool) const)&Entity_Player::HasCollectible)
		.addFunction("GetCollectibleNum", (s32 (Entity_Player::*)(s32, bool) const)&Entity_Player::NumCollectibleHeld)
		
		.addFunction("Morph", (void (Entity_Pickup::*)(s32, u32, u32, bool, bool, bool))&Entity_Pickup::Morph)
]]