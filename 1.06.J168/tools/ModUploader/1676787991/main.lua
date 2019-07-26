denpnapi = RegisterMod("dentpack",1)

local Level = Game():GetLevel()
local Room = Game():GetRoom()
local music = MusicManager()
local sound = SFXManager()

denpnapi.musics = {
	MomLastDitch = Isaac.GetMusicIdByName("Mom's Last Ditch")
}
denpnapi.sounds = {
	TVnoise = Isaac.GetSoundIdByName("TV Noise"),
	AngerScream = Isaac.GetSoundIdByName("Anger Scream")
}

----------------------------
--custom functions
----------------------------

function ChaseTarget(speed, npc, slide, count)
	local target = npc:GetPlayerTarget()
	local player = Isaac.GetPlayer(0)
	local d = npc:GetData()
	local path = npc.Pathfinder
	local dist = target.Position:Distance(npc.Position)
	local gin = Room:GetGridIndex
	(npc.Position + Vector.FromAngle((npc.Velocity):GetAngleDegrees()):Resized(5+npc.Size))
	local gen = Room:GetGridEntity(gin)
	local FindTarget

	npc.Velocity = npc.Velocity * slide

	if not d.straightA then
		d.straightA = npc.FrameCount - count
	end

	if npc:HasEntityFlags(1<<9) then
		if npc.FrameCount % 13 == 0 or npc:CollidesWithGrid() then
			d.angle = math.random(0,360)
		end
	else
		d.angle = (target.Position - npc.Position):GetAngleDegrees()
	end

	if npc.State <= 2 and npc:CollidesWithGrid() then
		npc:AddVelocity(Vector.FromAngle(d.angle):Resized(speed))
	end

	if (dist >= 700 or npc.FrameCount <= d.straightA + count
	or not path:HasPathToPos(target.Position, false))
	and not npc:HasEntityFlags(1<<9) and not npc:HasEntityFlags(1<<11)
	and not npc:HasEntityFlags(1<<24) then
		path:FindGridPath(target.Position, speed*1.4, 900, false)
	elseif (dist < 700 and npc.FrameCount > d.straightA + count
	and path:HasPathToPos(target.Position, false))
	or dist < 70 or npc:HasEntityFlags(1<<11) or npc:HasEntityFlags(1<<24) then
		if dist <= 450 and (npc:HasEntityFlags(1<<11) or npc:HasEntityFlags(1<<24)) then
			npc:AddVelocity(Vector.FromAngle(-d.angle):Resized(speed))
		else
			npc:AddVelocity(Vector.FromAngle(d.angle):Resized(speed))
		end
		if gen then
			if gen:GetType() >= 2 and gen:GetType() ~= 10 and gen:GetType() ~= 19
			and gen:GetType() ~= 20 then
				d.straightA = npc.FrameCount
			end
		end
		if npc:CollidesWithGrid() then
			d.straightA = npc.FrameCount
			npc.Velocity = Vector(0,0)
		end
	end

	return FindTarget
end

function SpawnGroundParticle(big, spawner, num, speed, snd, shakeframe)
	if snd >= 3 then
		sound:Play(52, 1, 0, false, 1)
	elseif snd == 2 then
		sound:Play(48, 1, 0, false, 1)
	elseif snd == 1 then
		if Room:GetBackdropType() >= 10 and Room:GetBackdropType() <= 13 then
			sound:Play(77, 1, 0, false, 1)
		else
			sound:Play(138, 1, 0, false, 1)
		end
	end
	if shakeframe > 0 then
		Game():ShakeScreen(shakeframe)
	end
	if Room:GetBackdropType() == 1 or Room:GetBackdropType() == 4
	or Room:GetBackdropType() == 5 or Room:GetBackdropType() == 8
	or Room:GetBackdropType() == 18 or Room:GetBackdropType() == 23
	or Room:GetBackdropType() == 25 or Room:GetBackdropType() == 26 then
		if big then
			Game():SpawnParticles(spawner.Position, 4, num, speed, Color(1,1,1,1,0,0,0), -4)
		else
			Game():SpawnParticles(spawner.Position, 35, num, speed, Color(0.4,0.3,0.3,1,0,0,0), -2)
		end
	elseif Room:GetBackdropType() == 2 or Room:GetBackdropType() == 17
	or (Room:GetBackdropType() >= 19 and Room:GetBackdropType() <= 22)
	or Room:GetBackdropType() == 28 then
		Game():SpawnParticles(spawner.Position, 27, num, speed, Color(1,1,1,1,0,0,0), -2)
	elseif Room:GetBackdropType() == 3 then
		Game():SpawnParticles(spawner.Position, 27, num, speed, Color(1,0.8,0.8,1,0,0,0), -2)
	elseif Room:GetBackdropType() == 6 then
		if big then
			Game():SpawnParticles(spawner.Position, 4, num, speed, Color(0,0.6,0.8,1,0,0,0), -4)
		else
			Game():SpawnParticles(spawner.Position, 35, num, speed, Color(0.3,0.3,0.4,1,0,0,0), -2)
		end
	elseif Room:GetBackdropType() == 7 or Room:GetBackdropType() == 9
	or Room:GetBackdropType() == 14 or Room:GetBackdropType() == 16 then
		Game():SpawnParticles(spawner.Position, 4, num, speed, Color(0.45,0.55,0.6,1,0,0,0), -2)
	elseif Room:GetBackdropType() >= 10 and Room:GetBackdropType() <= 12 then
		if num == 1 then
			Game():SpawnParticles(spawner.Position, 5, 1, speed, Color(1,1,1,1,0,0,0), -2)
		else
			Game():SpawnParticles(spawner.Position, 5, num-1, speed, Color(1,1,1,1,0,0,0), -2)
		end
	elseif Room:GetBackdropType() == 13 then
		if num == 1 then
			Game():SpawnParticles(spawner.Position, 5, 1, speed, Color(0.6,0.6,1,1,0,0,0), -2)
		else
			Game():SpawnParticles(spawner.Position, 5, num-1, speed, Color(0.6,0.6,1,1,0,0,0), -2)
		end
	elseif Room:GetBackdropType() == 15 then
		if big then
			Game():SpawnParticles(spawner.Position, 4, num, speed, Color(0.35,0.7,1,1,0,0,0), -2)
		else
			Game():SpawnParticles(spawner.Position, 35, num, speed, Color(0.25,0.35,0.45,1,0,0,0), -2)
		end
	elseif Room:GetBackdropType() == 24 then
		if big then
			Game():SpawnParticles(spawner.Position, 4, num, speed, Color(1,0,0,1,0,0,0), -2)
		else
			Game():SpawnParticles(spawner.Position, 35, num, speed, Color(1,0,0,1,0,0,0), -2)
		end
	elseif Room:GetBackdropType() == 27 then
		if big then
			Game():SpawnParticles(spawner.Position, 4, num, speed, Color(0.5,0.5,0.7,1,0,0,0), -2)
		else
			Game():SpawnParticles(spawner.Position, 35, num, speed, Color(0.5,0.5,0.7,1,0,0,0), -2)
		end
	end
end

-------------------------------------------------

denpnapi:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider, low)
	local nspr = npc:GetSprite()
	if npc.Type == 552 then
		if collider.Type <= 2 or (collider.Type == 3 and
		(collider.Variant == 3 or collider.Variant == 17 or (collider.Variant >= 30
		and collider.Variant <= 35) or collider.Variant == 42 or (collider.Variant >= 44
		and collider.Variant <= 47) or collider.Variant == 50 or collider.Variant == 51
		or collider.Variant == 60 or collider.Variant == 62 or collider.Variant == 65
		or collider.Variant == 67 or collider.Variant == 68 or (collider.Variant >= 69
		and collider.Variant <= 72) or collider.Variant == 75 or (collider.Variant >= 83
		and collider.Variant <= 85) or (collider.Variant == 87 and collider:ToFamiliar().State == 1)
		or collider.Variant == 95 or collider.Variant == 98 or collider.Variant == 103
		or collider.Variant == 104 or collider.Variant == 107 or collider.Variant == 116
		or collider.Variant == 121)) then
			if collider.Type == 2 then
				if collider:ToTear().TearFlags < TearFlags.TEAR_PIERCING then
					collider:Die()
				end
				npc.Velocity = Vector(npc.Velocity.X+collider.Velocity.X*(collider:ToTear().BaseDamage*0.045),
				npc.Velocity.Y+collider.Velocity.Y*(collider:ToTear().BaseDamage*0.045))
			else
				npc:Remove()
			end
		end
	end
end)

----------------------------
--add Boss Pattern:Mom's Hearts
----------------------------
function denpnapi:wbossHeart(boss)

	if boss.Variant <= 1 and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprht = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local rng = boss:GetDropRNG()
		local data = boss:GetData()

		if boss.I1 == 3 and (sprht:IsPlaying("Heartbeat3") or sprht:IsPlaying("Heartbeat2")) then
			boss.State = 11
			boss.TargetPosition = boss.Position
		end

		if boss.State == 11 and sprht:IsPlaying("Heartbeat3") then
			if boss.FrameCount % math.random(10,50) == 0 then
				local bswirl = Isaac.Spawn(1000, 350, 1, boss.Position, Vector(0,0), boss):ToEffect()
				bswirl:GetSprite().Rotation = rng:RandomInt(72) * 5
				bswirl.Parent = boss
				bswirl.MaxRadius = 200
				bswirl.MinRadius = 110
			end
			if boss.FrameCount % 125 == 0 and not data.isdelirium then
				if boss.Variant == 1 and boss.I2 ~= 4 then
					for i=0, 270, 90 do
						local bswirl = Isaac.Spawn(1000, 350, 2, boss.Position, Vector(0,0), boss):ToEffect()
						bswirl:GetSprite().Rotation = i + (boss.FrameCount % 2) * 45
						bswirl.Parent = boss
					end
				elseif boss.Variant == 0 then
					local bswirl = Isaac.Spawn(1000, 350, 2, boss.Position, Vector(0,0), boss)
					bswirl.Parent = boss
					bswirl:GetSprite().Rotation = (target.Position-boss.Position):GetAngleDegrees()
				end
			end
		end

		if boss.Variant == 1 then
			local angle = (target.Position - boss.Position):GetAngleDegrees()
			local dist = target.Position:Distance(boss.Position)
			if boss.State == 11 then
				boss.Velocity = Vector.FromAngle((boss.TargetPosition-boss.Position):GetAngleDegrees())
				:Resized(boss.TargetPosition:Distance(boss.Position)*0.1)
				boss.ProjectileCooldown = boss.ProjectileCooldown - 1
				if sprht:IsEventTriggered("Heartbeat") then
					Game():ShakeScreen(7)
					boss:PlaySound(323, 1, 0, false, 1)
					boss:PlaySound(72, 0.5, 0, false, 0.21)
				end
				if sprht:IsPlaying("Heartbeat3") and boss.ProjectileCooldown <= 0 then
					sprht:Play("HeartRetracted",true)
					boss:PlaySound(212, 1, 0, false, 1)
					boss.I1 = 7
				end

				if sprht:IsFinished("HeartRetracted") then
					sprht:Play("HeartHidingHeartbeat2",true)
					boss.I2 = math.random(0,4)
					if boss.I2 == 2 then
						boss.ProjectileCooldown = 250
					else
						boss.ProjectileDelay = 60
					end
				end
				if sprht:IsPlaying("Heartbeat3") and boss.ProjectileCooldown <= 230 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.19
					params.Scale = 1.8
					if boss.I2 == 0 then
						if boss.FrameCount % 3 == 0 then
							for i=0, 180, 180 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i-(boss.ProjectileCooldown*1.2)+15):Resized(10), 0, params)
							end
						end
					elseif boss.I2 == 1 then
						if boss.ProjectileCooldown % 45 == 0 then
							for i=50, 80, 5 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle((i+45*(boss.ProjectileCooldown % 2))-22.5):Resized(7), 0, params)
							end
							for i=140, 170, 5 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle((i+45*(boss.ProjectileCooldown % 2))-22.5):Resized(7), 0, params)
							end
							for i=230, 260, 5 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle((i+45*(boss.ProjectileCooldown % 2))-22.5):Resized(7), 0, params)
							end
							for i=320, 350, 5 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle((i+45*(boss.ProjectileCooldown % 2))-22.5):Resized(7), 0, params)
							end
						end
					elseif boss.I2 == 2 then
						if boss.ProjectileCooldown % 35 == 0 then
							params.BulletFlags = 1 << 27
							params.Acceleration = 1.051
							for i=-3, 3 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(angle+(i*4)):Resized(0.6-math.abs(i*0.05)), 0, params)
							end
						end
					end
				end

				if boss.I1 == 7 then
					if not sprht:IsPlaying("HeartStomp") then
						boss.EntityCollisionClass = 0
					end
					if sprht:IsFinished("HeartHidingAttack") then
						sprht:Play("HeartHidingHeartbeat2",true)
					end
					if ((boss.I2 ~= 2 and boss.FrameCount % 90 == 0)
					and sprht:IsPlaying("HeartHidingHeartbeat2") and KilledCloatty < 5)
					or (boss.I2 == 2 and sprht:IsPlaying("HeartHidingHeartbeat2")
					and boss.ProjectileCooldown >= 50) then
						sprht:Play("HeartHidingAttack",true)
					end
					if KilledCloatty >= 5 and boss.I2 ~= 2 then
						boss.ProjectileDelay = boss.ProjectileDelay - 1
						if boss.ProjectileDelay <= 0 and sprht:IsPlaying("HeartHidingHeartbeat2") then
							sprht:Play("HeartStomp",true)
						end
					end
					if boss.ProjectileCooldown >= 50 then
						if boss.I2 ~= 2 then
							if boss.FrameCount % 90 == 0 and sprht:IsPlaying("HeartHidingHeartbeat2") then
								sprht:Play("HeartHidingAttack",true)
							end
							if not sprht:IsPlaying("HeartRetracted") then
								if boss.I2 == 0 or boss.I2 == 3 then
									data.sttposX = 180
									if Room:GetRoomShape() == 6 or Room:GetRoomShape() == 8 then
										data.endposX = 1005
									else
										data.endposX = 555
									end
									data.sttposY = 205
									if Room:GetRoomShape() == 6 or Room:GetRoomShape() == 8 then
										data.endposY = 405
									else
										data.endposY = 605
									end
									data.intervalX = 150
									data.intervalY = 200
									if boss.I2 == 3 then
										data.spawnvel = Vector.FromAngle(125):Resized(4.5)
									else
										data.spawnvel = Vector.FromAngle(55):Resized(4.5)
									end
								elseif boss.I2 == 1 or boss.I2 == 4 then
									data.sttposY = 200
									if Room:GetRoomShape() == 4 or Room:GetRoomShape() == 8 then
										data.endposY = 600
									else
										data.endposY = 400
									end
									data.intervalY = 100
									if boss.I2 == 4 then
										data.spawnvel = Vector(-4.5,0)
									else
										data.spawnvel = Vector(4.5,0)
									end
								end
								if boss.FrameCount % 25 == 0 then
									local params = ProjectileParams()
									params.FallingAccelModifier = -0.195
									params.FallingSpeedModifier = 0.15
									params.Scale = 1.8
									if boss.I2 == 1 or boss.I2 == 4 then
										params.BulletFlags = ProjectileFlags.WIGGLE
									end
									for i=data.sttposY, data.endposY, data.intervalY do
										if math.random(0,7) <= 1 and #Isaac.FindByType(549, -1, -1, true, true) <= 3 then
											boss:PlaySound(72, 1, 0, false, 1)
											if boss.I2 == 3 or boss.I2 == 4 then
												Isaac.Spawn(1000, 2, 3, Vector(Room:GetBottomRightPos().X-8,i), Vector(0,0), boss)
												local cloatty = Isaac.Spawn(549, 100, 0, Vector(Room:GetBottomRightPos().X-8,i),
												data.spawnvel, boss):ToNPC()
												cloatty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
												cloatty.I2 = 1
											else
												Isaac.Spawn(1000, 2, 3, Vector(65,i), Vector(0,0), boss)
												local cloatty = Isaac.Spawn(549, 100, 0, Vector(65,i),
												data.spawnvel, boss):ToNPC()
												cloatty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
												cloatty.I2 = 1
											end
										else
											if boss.I2 == 3 or boss.I2 == 4 then
												boss:FireProjectiles(Vector(Room:GetBottomRightPos().X-8,i), data.spawnvel, 0, params)
											else
												boss:FireProjectiles(Vector(68,i), data.spawnvel, 0, params)
											end
										end
									end
									if boss.I2 == 0 or boss.I2 == 3 then
										for i=data.sttposX, data.endposX, data.intervalX do
											if math.random(0,3) == 2 and #Isaac.FindByType(549, -1, -1, true, true) <= 3 then
												boss:PlaySound(72, 1, 0, false, 1)
												Isaac.Spawn(1000, 2, 3, Vector(i,145), Vector(0,0), boss)
												local cloatty = Isaac.Spawn(549, 100, 0, Vector(i,148),
												data.spawnvel, boss):ToNPC()
												cloatty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
												cloatty.I2 = 1
											else
												boss:FireProjectiles(Vector(i,145), data.spawnvel, 0, params)
											end
										end
									end
								end
							end
						else
							if boss.FrameCount % 41 == 0 then
								local params = ProjectileParams()
								params.FallingAccelModifier = -0.195
								params.FallingSpeedModifier = 0.15
								params.Scale = 1.5
								for i=0+(boss.ProjectileCooldown % 2)*15, 180, 30 do
									boss:FireProjectiles(Vector(boss.Position.X,145), Vector.FromAngle(i):Resized(4.5), 0, params)
								end
							end
							if boss.FrameCount % 55 == 0 and sprht:IsPlaying("HeartHidingHeartbeat2") then
								sprht:Play("HeartHidingAttack",true)
							end
						end
					end
		
					if boss.ProjectileCooldown <= 0
					and sprht:IsPlaying("HeartHidingHeartbeat2") then
						sprht:Play("HeartStomp",true)
					end
		
					if sprht:IsPlaying("HeartHidingAttack") then
						if sprht:IsEventTriggered("Heartbeat") then
							boss:PlaySound(213, 1, 0, false, 1)
							local params = ProjectileParams()
							params.Scale = 2
							params.BulletFlags = ProjectileFlags.EXPLODE
							params.HeightModifier = -80
							params.FallingAccelModifier = 0.65
							boss:FireProjectiles(boss.Position, Vector.FromAngle(angle):Resized(dist*0.039), 0, params)
						end
					end
		
				else
					boss.EntityCollisionClass = 4
				end

				if sprht:IsEventTriggered("Stomp") then
					boss.ProjectileCooldown = 255
					boss.I1 = 3
					if data.Xangle == 45 then
						data.Xangle = 0
					else
						data.Xangle = 45
					end
					boss:PlaySound(52, 2, 0, false, 1)
					Game():ShakeScreen(20)
					Game():BombDamage(boss.Position, 25, 40, false, boss, 0, 1<<2, true)
					for i=0, 270, 90 do
						EntityLaser.ShootAngle(1, boss.Position, i-data.Xangle, 5, Vector(0,0), boss)
					end
					local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
					creep.SpriteScale = Vector(3,3)
					creep:ToEffect():SetTimeout(200)
					local params = ProjectileParams()
					params.HeightModifier = -5
					params.FallingSpeedModifier = -10
					params.FallingAccelModifier = 0.5
					params.Scale = 2
					params.BulletFlags = ProjectileFlags.ACID_RED | ProjectileFlags.EXPLODE
					for i=0, 270, 90 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i+(data.Xangle-45)):Resized(8), 0, params)
					end
				end

				if sprht:IsFinished("HeartStomp") then
					sprht:Play("Heartbeat3",true)
					KilledCloatty = 0
					boss.I2 = math.random(0,2)
				end
				return true
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, denpnapi.wbossHeart, 78)

----------------------------
--Add Boss Pattern:Delirium
----------------------------
function denpnapi:Delirium(npc)

	boss = npc:ToNPC()
	local sprdlr = boss:GetSprite()
	local Entities = Isaac:GetRoomEntities()
	local player = Game():GetPlayer(1)
	local data = boss:GetData()
	local rng = boss:GetDropRNG()
	boss.SplatColor = Color(1,1,1,1,300,300,300)
	Initspeed = boss.Velocity

	data.isdelirium = true

	if (Game().Difficulty == 1 or Game().Difficulty == 3) then

		if boss.State == 0 then
			sound:Stop(denpnapi.sounds.TVnoise)
		end

		if Isaac.GetPlayer(0):HasPlayerForm(11) and 66.66*GetPlayerDps > 10000
		and not AdultForm then
			boss.MaxHitPoints = (66.66*GetPlayerDps) * 1.075
			boss.HitPoints = boss.HitPoints +
			(((66.66*GetPlayerDps) * 1.075)-(66.66*GetPlayerDps))
			AdultForm = true
		end
		if player:HasPlayerForm(13) and boss.FrameCount == 1 then
			local wave = Isaac.Spawn(1000, 61, 0, boss.Position, Vector(0,0), boss)
			wave.Parent = boss
			wave:ToEffect().Timeout = 10
			wave:ToEffect().MaxRadius = 60
		end
		if Room:GetFrameCount() % 8 == 0 then
			if player:HasPlayerForm(4) then
				local creepG = Isaac.Spawn(1000, 23, 0, boss.Position, Vector(0,0), boss)
				if boss.Size*0.075 >= 3 then
					creepG.SpriteScale = Vector(3,3)
				else
					creepG.SpriteScale = Vector(boss.Size*0.075,boss.Size*0.075)
				end
				creepG:ToEffect().Timeout = 50
			end
		end

		if DPhase >= (boss.HitPoints / boss.MaxHitPoints * 5) + 1
		and DPhase > 1 and boss.HitPoints > 1 then
			for i=1, 5 do
				if DPhase >= (boss.HitPoints / boss.MaxHitPoints * 5) + 1 then
					DPhase = DPhase - 1
				end
			end
			if boss.FrameCount > 0 and DPhase <= 6 then
				boss:BloodExplode()
				Game():ShakeScreen(20)
				if sprdlr:GetDefaultAnimation() == "Delirium" then
					boss.State = 25
					boss.StateFrame = 0
				end
				if DPhase == 3 then
					if math.random(1,2) == 1 then
						for i=0, 270, 90 do
							local lwave = Isaac.Spawn(1000, 351, 0, boss.Position, Vector(0,0), boss)
							lwave:ToEffect().Rotation = i
							lwave.Parent = boss
						end
					else
						for i=45, 315, 90 do
							local lwave = Isaac.Spawn(1000, 351, 0, boss.Position, Vector(0,0), boss)
							lwave:ToEffect().Rotation = i
							lwave.Parent = boss
						end
					end
				elseif DPhase == 2 then
					if #Isaac.FindByType(548, -1, -1, true, true) == 0 then
						for i=0, 7 do
							Isaac.Spawn(548, 0, 0, Room:GetDoorSlotPosition(i), Vector(0,0), boss)
						end
					end
				elseif DPhase == 1 then
					if sprdlr:GetDefaultAnimation() ~= "Delirium" then
						Isaac.Spawn(544, 0, 1, boss.Position + Vector(0,5), Vector(0,0), boss)
						for i=0, 3 do
							Isaac.Spawn(1000, 361, 0,
							Vector(120+(rng:RandomInt(11)*80),200+(rng:RandomInt(5)*80)), Vector(0,0), boss)
						end
					end
				end
			end
		end

		if DPhase == 3 and #Isaac.FindByType(551, -1, -1, true, true) == 0 then
			Isaac.Spawn(551, 0, 0, boss.Position, Vector(0,0), boss)
		end

		if (sprdlr:GetDefaultAnimation() == "Delirium" and (Room:GetFrameCount() % 36 == 3)
		or sprdlr:GetDefaultAnimation() ~= "Delirium" and (Room:GetFrameCount() % 60 == 3))
		and DPhase <= 2 and boss.State ~= 0 then
			local params = ProjectileParams()
			params.Variant = 10
			params.FallingAccelModifier = -0.19
			params.Scale = 2.3
			params.BulletFlags = 1 << 36
			boss:FireProjectiles(boss.Position, Vector(4-(math.random(0,1)*8),0), 0, params)
		end

		if Room:GetFrameCount() % 50 == 0 and boss.State > 0
		and player:HasPlayerForm(12) and math.random(1,2) == 1 then
			boss:PlaySound(181, 1, 0, false, 1)
			Isaac.Spawn(85, 0, 0,
			boss.Position+Vector.FromAngle(rng:RandomInt(359)):Resized(50), Vector(0,0), boss)
		end
		if Room:GetFrameCount() % 75 == 0 and math.random(0,6) == 1
		and player:HasPlayerForm(6) and boss.State > 0 then
			boss:PlaySound(252, 1, 0, false, 1)
			Isaac.Spawn(70, 70, 0, player.Position, Vector(0,0), boss)
		end

		if player:HasPlayerForm(7) and boss.FrameCount > 1
		and #Isaac.FindByType(546, -1, -1, true, true) <= 0 then
			for i=0, 1 do
				local triplet = Isaac.Spawn(546, 0, i, boss.Position, Vector(0,0), boss)
				triplet.SpawnerEntity = boss
			end
		end

		if player:HasPlayerForm(3) and Room:GetFrameCount() % 120 == 0
		and boss.EntityCollisionClass ~= 0 then
			local lightwave = Isaac.Spawn(1000, 351, 0, boss.Position, Vector(0,0), boss)
			lightwave.Parent = boss
			lightwave:ToEffect().Rotation = (player.Position - boss.Position):GetAngleDegrees()
		end

		if player:HasPlayerForm(1) and boss.FrameCount > 1
		and #Isaac.FindByType(550, -1, -1, true, true) <= 0 then
			for i=0, 1 do
				local dfly = Isaac.Spawn(550, 0, i, boss.Position, Vector(0,0), boss)
				dfly.SpawnerEntity = boss
			end
		end

		if sprdlr:GetDefaultAnimation() == "Delirium" then
			if boss.HitPoints > 0.5 then
				if (boss.State ~= 3 and not (boss.State >= 8 and boss.State <= 14)
				and boss.State ~= 25 and boss.State ~= 33) or boss.FrameCount <= 10 or Room:GetFrameCount() <= 100 then
					boss.State = 3
				end
			end
			if DPhase == 1 and Room:GetFrameCount() % 300 == 0
			and boss.State <= 4 and #Isaac.FindByType(544, -1, 1, true, true) == 0
			and boss.State ~= 0 and boss.HitPoints > 1 then
				boss.State = 10
			end
			if sprdlr:IsPlaying("Blink") and boss.FrameCount >= 50
			and Room:GetFrameCount() >= 100 then
				if sprdlr:GetFrame() == 1 then
					if math.random(0,18) >= (boss.HitPoints/boss.MaxHitPoints) * 10
					and boss.State ~= 33 then
						if math.random(1,5) == 1 then
							boss.State = 8
						elseif math.random(1,5) == 2 then
							if DPhase <= 2 then
								boss.State = 12
							end
						elseif math.random(1,5) == 3 then
							if DPhase == 4 and boss.Position.Y <= 700
							and Room:GetAliveEnemiesCount() <= 5 then
								boss.State = math.random(13,14)
							end
						elseif math.random(1,5) == 4 then
							if DPhase <= 4 and boss.Position.Y <= 700
							and Room:GetAliveEnemiesCount() <= 5 then
								boss.State = math.random(13,14)
							end
						else
							if math.random(1,2) == 1 then
								if player:HasPlayerForm(13) then
									boss.State = 33
									data.stompcount = 0
								end
							else
								if player:HasPlayerForm(8) then
									boss.State = 11
								end
							end
						end
						boss.StateFrame = 0
					end
					if boss.State == 33 then
						data.stompcount = data.stompcount + 1
						if data.stompcount >= 3 then
							boss.State = 9
							boss.StateFrame = 0
						end
					end
				elseif sprdlr:GetFrame() == 5 then
					if boss.FrameCount % 2 == 0 and DPhase <= 3 then
						local params = ProjectileParams()
						params.Variant = 10
						params.FallingAccelModifier = -0.19
						params.Scale = 2.3
						if math.random(1,2) == 1 then
							params.BulletFlags = 1 << 34
							params.CurvingStrength = 3
						else
							params.BulletFlags = 1 << 35
						end
						if player:HasPlayerForm(10) and math.random(1,2) == 1 then
							boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(3)*90):Resized(4), 1, params)
						else
							boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(3)*90):Resized(4), 0, params)
						end
					end
					if boss.State == 33 then
						boss:PlaySound(48, 1, 0, false, 1)
						Game():SpawnParticles(boss.Position, 88, 10, 16, Color(1,1,1,1,135,126,90), -4)
					end
				end
			end

			if boss.State > 3 then
				boss.StateFrame = boss.StateFrame + 1
			else
				boss.StateFrame = 0
			end

			if boss.StateFrame >= 30 and boss.StateFrame <= 60 then
				if boss.State == 8 and boss.StateFrame % 5 == 0 then
					data.angle = rng:RandomInt(359)
					boss:PlaySound(77, 0.7, 0, false, 1)
					local expl = Isaac.Spawn(1000, 2, 2,
					boss.Position+Vector.FromAngle(data.angle):Resized(70), Vector(0,0), boss)
					expl:SetColor(Color(1.1,1.05,1,1,255,255,255), 99999, 0, false, false)
					local hand = Isaac.Spawn(545, 0, 0,
					boss.Position+Vector.FromAngle(data.angle):Resized(70), Vector(0,0), boss)
					hand:GetSprite().Rotation = data.angle
				elseif boss.State == 12 and boss.StateFrame % 12 == 0 then
					boss:PlaySound(265, 1, 0, false, 1)
					Isaac.Spawn(542, 0, math.random(0,2),
					boss.Position+Vector.FromAngle(rng:RandomInt(359)):Resized(70), Vector(0,0), boss)
				end
			end

			if boss.State == 8 or boss.State == 12 then
				if boss.StateFrame == 1 then
					sprdlr:Play("FallDown", true)
				end
				if sprdlr:IsFinished("FallDown") then
					sprdlr:Play("Idle", true)
					boss.State = 3
				end
				if sprdlr:GetFrame() == 15 then
					boss:PlaySound(118, 1, 0, false, 1)
				elseif sprdlr:GetFrame() == 30 then
					boss:PlaySound(72, 1.5, 0, false, 0.5)
				end
			elseif boss.State == 9 then
				if boss.StateFrame == 1 then
					sprdlr:Play("Stomp", true)
				end
				if sprdlr:GetFrame() == 7 then
					boss:PlaySound(52, 1, 0, false, 1)
					Game():ShakeScreen(10)
					for i=0, 270, 90 do
						local cwave = Isaac.Spawn(1000, 72, 0, boss.Position, Vector(0,0), boss)
						cwave.Parent = boss
						cwave:ToEffect().Rotation = i
					end
				end
				if sprdlr:IsFinished("Stomp") then
					sprdlr:Play("Idle", true)
					boss.State = 3
				end
			elseif boss.State == 10 then
				if boss.StateFrame <= 2 then
					sprdlr:Play("Launch", true)
				end
				if sprdlr:GetFrame() == 5 then
					boss:PlaySound(72, 1.5, 0, false, 0.5)
				elseif sprdlr:GetFrame() == 20 then
					boss:PlaySound(116, 1, 0, false, 1)
					Isaac.Spawn(544, 0, 1, boss.Position, Vector(0,0), boss)
					for i=0, 3 do
						Isaac.Spawn(1000, 361, 0,
						Vector(120+(rng:RandomInt(11)*80),200+(rng:RandomInt(5)*80)), Vector(0,0), boss)
					end
				end
				if sprdlr:IsFinished("Launch") then
					sprdlr:Play("Idle", true)
					boss.State = 3
				end
			elseif boss.State == 11 then
				if boss.StateFrame == 1 then
					sprdlr:Play("Laser", true)
				end
				if sprdlr:GetFrame() == 1 then
					boss:PlaySound(312, 1.5, 0, false, 1)
				elseif sprdlr:GetFrame() == 34 then
					local bloodshot = EntityLaser.ShootAngle(1, boss.Position+Vector(0,20), 90, 25, Vector(0,-70), boss)
					bloodshot.Angle = 90
					bloodshot.Size = 80
				end
				if sprdlr:IsFinished("Laser") then
					sprdlr:Play("Idle", true)
					boss.State = 3
				end
			elseif boss.State == 25 then
				if boss.StateFrame == 1 then
					sprdlr:Play("Hurt", true)
				end
				if sprdlr:IsFinished("Hurt") then
					if DPhase == 4 then
						boss.State = 13+math.random(0,1)
						boss.StateFrame = 1
					elseif DPhase == 1 then
						boss.State = 10
						boss.StateFrame = 1
					else
						sprdlr:Play("Idle", true)
						boss.State = 3
					end
				end
			elseif boss.State == 33 then
				if not sprdlr:IsPlaying("Blink") then
					sprdlr:Play("Blink", true)
				end
			end
			if boss.State == 13 or boss.State == 14 then
				if boss.StateFrame == 1 then
					sprdlr:Play("TVMorph", true)
				end
				if sprdlr:IsPlaying("TVMorph") and sprdlr:GetFrame() == 15 then
					boss:PlaySound(72, 1.5, 0, false, 0.5)
				end
				if sprdlr:IsFinished("TVMorph") then
					sprdlr:Play("Television", true)
					boss:PlaySound(denpnapi.sounds.TVnoise, 2, 0, false, 1)
				end
				if boss.StateFrame >= 41 and sprdlr:IsPlaying("Television") then
					if boss.State == 14 then
						sprdlr:Play("Television2Angel", true)
					else
						sprdlr:Play("Television2Devil", true)
					end
				end
				if (sprdlr:IsPlaying("Television2Angel") or sprdlr:IsPlaying("Television2Devil"))
				and sprdlr:GetFrame() == 26 then
					sound:Stop(denpnapi.sounds.TVnoise)
					Isaac.Explode(boss.Position+Vector(0,80), boss, 40)
					boss:PlaySound(265, 1, 0, false, 1)
					if boss.State == 14 then
						for i=0, 4 do
							Isaac.Spawn(38, 1, 0, boss.Position+Vector(math.random(-3,3),math.random(78,82)), Vector(0,0), boss)
						end
					else
						for i=0, 4 do
							Isaac.Spawn(252, 0, 0, boss.Position+Vector(math.random(-3,3),math.random(78,82)), Vector(0,0), boss)
						end
					end
				end
				if sprdlr:IsFinished("Television2Angel") or sprdlr:IsFinished("Television2Devil") then
					sprdlr:Play("Idle", true)
					boss.State = 3
				end
			end
			if boss.StateFrame ~= 0 and boss.HitPoints > 0.5 then
				boss.Velocity = boss.Velocity * 0.1
				return true
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, denpnapi.Delirium, 412)

----------------------------
--New Enemy Variant:Blue Maw
----------------------------
function denpnapi:BlueMaw(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Blue Maw") then

		local sprbm = enemy:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		local data = enemy:GetData()
		local target = enemy:GetPlayerTarget()
		data.angle = (target.Position - enemy.Position):GetAngleDegrees()

		for k, v in pairs(Entities) do
			local dist = enemy.Position:Distance(v.Position)
			if v.Type == 9 and v.SpawnerType == 26 and v.SpawnerVariant == 3
			and sprbm:IsPlaying("Shoot") and sprbm:GetFrame() == 7
			and dist <= 1 and v.FrameCount == 0 then
				v:Remove()
				local fly = Isaac.Spawn(18, 0, 0, enemy.Position, Vector.FromAngle(data.angle):Resized(5), enemy)
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.BlueMaw, 26)

----------------------------
--add Boss Pattern:Mom
----------------------------
function denpnapi:Mom(mom)
	if Game().Difficulty == 1 or Game().Difficulty == 3
	and not mom:GetData().isdelirium then
		mom:GetData().ChangedHP = true
		if mom.Variant == 0 then
			mom:Morph(396, 0, mom.SubType, -1)
		elseif mom.Variant == 10 then
			mom:Morph(396, 10, mom.SubType, -1)
			mom.HitPoints = mom.MaxHitPoints
		end
		if mom.FrameCount <= 1 then
			if mom.SubType == 1 or mom.SubType == 33 then
				mom.MaxHitPoints = math.max(750, 10*GetPlayerDps)
			else
				mom.MaxHitPoints = math.max(650, 8.7*GetPlayerDps)
			end
			mom.HitPoints = mom.MaxHitPoints
		end
	end

	if mom.Variant == 0 and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprm = mom:GetSprite()
		local target = mom:GetPlayerTarget()
		local player = Isaac.GetPlayer(0)
		local Entities = Isaac:GetRoomEntities()
		local data = mom:GetData()

		if not data.eyeHp then
			data.eyeHp = math.max(15, 1.5*GetPlayerDps)
			data.eyehurt = false
		end

		if mom.SubType == 33 and sprm:GetFilename() ~= "gfx/Mom_hard_eternal.anm2" then
			sprm:Load("gfx/Mom_hard_eternal.anm2", true)
			sprm:SetFrame("Eye", 64)
		end

		if sprm:IsPlaying("Eye") then
			if mom.SubType == 33 then
				sprm:Play("EyeAttackEternal",true)
			else
				sprm:Play("EyeAttack",true)
			end
			data.eyeHp = 15
		end

		if data.eyehurt then
			mom.State = 8
			mom.ProjectileCooldown = mom.ProjectileCooldown + 2
			mom:SetSpriteFrame("EyeHurt", mom.ProjectileCooldown)
			if mom.ProjectileCooldown == 38 then
				local params = ProjectileParams()
				params.HeightModifier = 20
				params.FallingAccelModifier = 0.5
				for i=0, math.random(6,10) do
					params.FallingSpeedModifier = -math.random(25,75) * 0.1
					if math.random(1,3) == 1 and i >= 5 then
						params.Scale = 1.65
						params.BulletFlags = 1 << 44
					else
						params.Scale = math.random(7,13) * 0.1
					end
					if mom.SubType ~= 2 then
						params.Variant = 4
						mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
						Vector.FromAngle(sprm.Rotation+90+math.random(-30,30)):Resized(math.random(45,120) * 0.1), 0, params)
					else
						mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
						Vector.FromAngle((target.Position - mom.Position):GetAngleDegrees()+math.random(-30,30)):Resized(math.random(45,120) * 0.1), 0, params)
					end
				end
				mom:PlaySound(153, 1, 0, false, 1)
			elseif mom.ProjectileCooldown == 57 then
				mom.EntityCollisionClass = 0
			elseif mom.ProjectileCooldown >= 61 then
				data.eyehurt = false
			end
		end

		if sprm:IsPlaying("EyeAttack") then
			if sprm:GetFrame() == 3 then
				mom.EntityCollisionClass = 4
			elseif sprm:GetFrame() == 62 then
				mom.EntityCollisionClass = 0
			end
			if data.eyeHp <= 0 then
				mom.ProjectileCooldown = 0
				data.eyeHp = math.max(30, 3*GetPlayerDps)
				mom:PlaySound(97, 1, 0, false, 1)
			end
		elseif sprm:IsPlaying("EyeAttackEternal") then
			if sprm:GetFrame() == 3 then
				mom.EntityCollisionClass = 4
			elseif sprm:GetFrame() == 64 then
				mom.EntityCollisionClass = 0
			end
		end

		if sprm:IsEventTriggered("Tear") then
			local params = ProjectileParams()
			params.HeightModifier = 20
			params.FallingAccelModifier = -0.1
			if mom.SubType ~= 2 then
				params.Variant = 4
				mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
				Vector.FromAngle(sprm.Rotation+90):Resized(10), 1, params)
			else
				mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
				Vector.FromAngle((target.Position - mom.Position):GetAngleDegrees()):Resized(10), 1, params)
			end
			mom:PlaySound(153, 1, 0, false, 1)
		elseif sprm:IsEventTriggered("Shoot") then
			for i=-15, 15, 30 do
				EntityLaser.ShootAngle(1, mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(16) + Vector(0,1)
				, sprm.Rotation + 90 + math.random(-10,10) + i, 27, Vector(0,-5), mom)
			end
		end

		if eye < 0 then
			eye = 0
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Mom, 45)

----------------------------
--add Boss Pattern:Mom Stomp
----------------------------
function denpnapi:Momf(mom)

	if mom.Variant == Isaac.GetEntityVariantByName("Mom Stomp") then

		local sprmf = mom:GetSprite()
		local target = mom:GetPlayerTarget()
		local player = Isaac.GetPlayer(0)
		local data = mom:GetData()
		local Entities = Isaac:GetRoomEntities()

		if data.isdelirium then
			if mom.State == 3 then
				if mom.FrameCount % 50 == 0 and mom.FrameCount >= 30 then
					mom:PlaySound(252, 1, 0, false, 1)
					if mom.SubType == 2 then
						Isaac.Spawn(70, 70, 1, Isaac.GetRandomPosition(0), Vector(0,0), mom)
					else
						Isaac.Spawn(70, 70, 0, player.Position, Vector(0,0), mom)
					end
				end
			end
		end

		if mom.SubType == 33 then
			if data.isdelirium then
				mom:SetColor(Color(1,1,1,1.5,0,0,0), 99999, 0, false, false)
			else
				if sprmf:GetFilename() ~= "gfx/Mom stomp_hard_eternal.anm2" then
					sprmf:Load("gfx/Mom stomp_hard_eternal.anm2", true)
				end
			end
		end

		if mom.State < 7 and mom.HitPoints/mom.MaxHitPoints <= 0.85 and math.random(1,3) ~= 1
		and mom.FrameCount % 200 == 0 then
			sprmf:Play("Stronger Stomp", true)
			mom:PlaySound(84, 1, 0, false, 1)
			mom.State = 7
		end

		if mom.State == 7 then
			if sprmf:IsPlaying("Stomp") and sprmf:GetFrame() == 1 and math.random(1,3) == 1
			and mom.HitPoints/mom.MaxHitPoints <= 0.5 then
				sprmf:Play("Stomp2", true)
			end
			if sprmf:IsPlaying("Stomp2") then
				if sprmf:GetFrame() == 28 then
					mom:PlaySound(52, 1, 0, false, 1)
					Game():ShakeScreen(20)
					Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
				elseif sprmf:GetFrame() == 67 then
					mom:PlaySound(93, 1.3, 0, false, 1.03)
				elseif sprmf:GetFrame() == 69 then
					Game():ShakeScreen(20)
					mom:PlaySound(138, 1, 0, false, 1)
					Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
					player:AnimatePitfallOut()
					player.ControlsEnabled = false
					player.Velocity = player.Velocity * 3
					for i=0, math.random(4,8) do
						Game():SpawnParticles(Isaac.GetRandomPosition(0), 35, 1, 0, Color(0.35,0.35,0.35,1,0,0,0), -1)
					end
				end
			elseif sprmf:IsPlaying("Stronger Stomp") then
				mom.Position = Room:GetCenterPos()
				if sprmf:GetFrame() == 58 then
					mom:PlaySound(52, 1, 0, false, 1)
					Game():ShakeScreen(20)
					Game():SpawnParticles(mom.Position, 88, 10, 20, Color(1,1,1,1,135,126,90), -4)
					Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
					local shockwave1 = Isaac.Spawn(1000, 61, 0, mom.Position, Vector(0,0), mom)
					shockwave1.Parent = mom
					shockwave1:ToEffect().Timeout = 10
					shockwave1:ToEffect().MaxRadius = 90
					if mom.SubType == 33 then
						for i=20, 335, 45 do
							local shockwave2 = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
							shockwave2.Parent = mom
							shockwave2:ToEffect().Timeout = 120
							shockwave2:ToEffect():SetRadii(6,6)
						end
					else
						for i=30, 330, 60 do
							if i == 30 or i == 150 or i == 210 or i == 330 then
								local shockwave3 = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
								shockwave3.Parent = mom
								shockwave3:ToEffect().Timeout = 120
								shockwave3:ToEffect():SetRadii(6,6)
							end
						end
					end
				end
			end
			if sprmf:IsFinished("Stronger Stomp")
			or sprmf:IsFinished("Stomp2") then
				mom.State = 3
			end
		end

		if sprmf:IsPlaying("Stronger Stomp") and sprmf:IsPlaying("Stomp2") then
			if (sprmf:IsPlaying("Stronger Stomp") and sprmf:GetFrame() >= 58 and sprmf:GetFrame() <= 101)
			or (sprmf:IsPlaying("Stomp2") and ((sprmf:GetFrame() >= 28 and sprmf:GetFrame() <= 56)
			or (sprmf:GetFrame() >= 69 and sprmf:GetFrame() <= 97))) then
				mom.EntityCollisionClass = 4
			else
				mom.EntityCollisionClass = 0
			end
		end

		for k, v in pairs(Entities) do
			if v:IsVulnerableEnemy() then
				if sprmf:IsPlaying("Stomp2") and sprmf:GetFrame() == 69
				and not v:IsFlying() then
					v:AddFreeze(EntityRef(mom),30)
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Momf, 45)

----------------------------
--New Entity:Big Knife
----------------------------
function denpnapi:BKnife(knife)

	if knife.Variant == Isaac.GetEntityVariantByName("Big Knife") then

		local sprkf = knife:GetSprite()
		local data = knife:GetData()
		local path = knife.Pathfinder
		local Entities = Isaac:GetRoomEntities()
		knife:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		knife:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		knife:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		knife:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		knife:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		path:FindGridPath(knife.Position, 0, 900, false)
	
		if knife.FrameCount <= 1 and sprkf:IsFinished("Falling") then
			sprkf:Play("Falling", true)
			knife.State = 8
			if Room:GetRoomShape() >= 6 then
				if knife.Position.X <= 560 then
					knife.FlipX = true
				end
			else
				if knife.Position.X <= 320 then
					knife.FlipX = true
				end
			end
		end
	
		if knife.SubType == 1 and knife.FrameCount <= 1 then
			local mark = Isaac.Spawn(1000, 367, 0, knife.Position, Vector(0,0), knife)
			mark:SetColor(Color(1,1,1,1,155,0,0), 99999, 0, false, false)
		end
	
		if sprkf:GetFrame() < 20 then
			knife.EntityCollisionClass = 0
		else
			knife.EntityCollisionClass = 4
			knife.CollisionDamage = 1
		end
	
		if sprkf:GetFrame() == 20 then
			SpawnGroundParticle(false, knife, 8, 6, 1, 0)
			Game():BombDamage(knife.Position, 40, 10, false, knife, 0, 1<<7, false)
		end
	
		for k, v in pairs(Entities) do
			if v:IsVulnerableEnemy() and v.Type ~= 70 and v.Variant ~= 70
			and knife.FrameCount > 20 then
				if v.Position:Distance(knife.Position) <= knife.Size + v.Size then
					v:TakeDamage(1.5, 0, EntityRef(knife), 1)
				end
			end
			if v:IsBoss() and v.Size >= 20
			and v.Position:Distance(knife.Position) <= knife.Size + v.Size
			and knife.EntityCollisionClass == 4 and v.EntityCollisionClass >= 3 then
				knife:Kill()
			end
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.BKnife, 70)

----------------------------
--add Boss Pattern:Mom's Heart
----------------------------
function denpnapi:MomHeart(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Mom's Heart")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprmh = boss:GetSprite()
		local rng = boss:GetDropRNG()
		local target = boss:GetPlayerTarget()
		local angle = (target.Position - boss.Position):GetAngleDegrees()

		if sprmh:IsPlaying("HeartHidingHeartbeat")
		and boss.FrameCount % 100 == 0
		and Room:GetAliveEnemiesCount() > 0 then
			local bswirlhm = Isaac.Spawn(1000, 350, 0, boss.Position-Vector(0,100), Vector(0,0), boss)
			bswirlhm.Parent = boss
		end

		if boss.State == 11 then
			if boss.ProjectileCooldown <= 0 then
				if boss.I2 ~= 4 then
					boss.I2 = math.random(0,4)
				else
					boss.I2 = math.random(0,3)
				end
				boss.ProjectileCooldown = 150
			end
			if boss.I2 == 4 then
				boss.I1 = 6
				if not sprmh:IsPlaying("HeartBeatAttack") then
					sprmh:Play("HeartBeatAttack",true)
				end
				boss.ProjectileCooldown = boss.ProjectileCooldown - 1
			else
				boss.I1 = 3
				if not sprmh:IsPlaying("HeartBeat3") then
					sprmh:Play("HeartBeat3",true)
				end
			end
			if boss.I2 == 0 then
				if boss.FrameCount % 3 == 0 then
					local params = ProjectileParams()
					params.FallingSpeedModifier = -math.random(30,70)*0.1
					params.FallingAccelModifier = math.random(3,13)*0.1
					params.HeightModifier = -5
					params.Scale = math.random(10,16)*0.1
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(5,12)), 0, params)
				elseif boss.FrameCount % 76 == 0 then
					local params = ProjectileParams()
					params.HeightModifier = -5
					params.FallingSpeedModifier = -math.random(5,12)
					params.FallingAccelModifier = 0.5
					params.Scale = 2
					params.BulletFlags = ProjectileFlags.ACID_RED | ProjectileFlags.EXPLODE
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(5,8)), 0, params)
				end
			elseif boss.I2 == 1 then
				if boss.FrameCount % 49 == 0 then
					for i=0, 324, 36 do
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.1
						params.HeightModifier = -5
						params.Scale = 2
						params.BulletFlags = 1 << 1 | 1 << 21 | 1 << 32 | 1 << 33
						params.ChangeTimeout = 30
						params.ChangeVelocity = 10
						params.ChangeFlags = 1 << 1
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i+((boss.FrameCount % 2)*18)):Resized(5), 0, params)
					end
				end
			elseif boss.I2 == 2 then
				if boss.FrameCount % 10 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.1
					params.HeightModifier = -5
					params.Scale = 1.8
					for i=-17.5, 17.5, 35 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(angle+i+(boss.FrameCount % 2)*4):Resized(6), 0, params)
					end
				end
			elseif boss.I2 == 3 then
				if boss.FrameCount % 50 == 26 then
					boss.ProjectileDelay = rng:RandomInt(180)
				end
				if boss.FrameCount % 50 <= 16 and boss.FrameCount % 4 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.1
					params.HeightModifier = -5
					params.BulletFlags = 1 << 36
					params.Scale = 1.8
					for i=0, 270, 90 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i+boss.ProjectileDelay):Resized(7), 0, params)
					end
				end
			elseif boss.I2 == 4 then
				if sprmh:IsPlaying("HeartBeatAttack") and sprmh:IsEventTriggered("Heartbeat") then
					boss:PlaySound(213, 1, 0, false, 1)
					local agl = rng:RandomInt(359)
					Isaac.Spawn(1000, 2, 3, boss.Position + Vector.FromAngle(agl):Resized(20), Vector(0,0), boss)
					local cloatty = Isaac.Spawn(549, 100, 0, boss.Position + Vector.FromAngle(agl):Resized(20),
					Vector.FromAngle(agl):Resized(math.random(5,10)), boss):ToNPC()
					cloatty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				end
			end
		end

		if boss:IsDead() then
			sound:Stop(85)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MomHeart, 78)

----------------------------
--add Boss Pattern:It Lives
----------------------------
function denpnapi:ItLives(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("It Lives")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprlv = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local dist = target.Position:Distance(boss.Position)
		local rng = boss:GetDropRNG()
		local angle = (target.Position - boss.Position):GetAngleDegrees()
		local data = boss:GetData()

		if boss.FrameCount <= 1 then
			KilledCloatty = 0
		end

		if sprlv:IsPlaying("HeartHidingHeartbeat") and Room:GetAliveEnemiesCount() > 0 then
			if boss.FrameCount % 120 == 0 then
				local bswirlhm = Isaac.Spawn(1000, 350, 0, boss.Position-Vector(0,100), Vector(0,0), boss)
				bswirlhm.Parent = boss
			elseif boss.FrameCount % 40 == 0 then
				local params = ProjectileParams()
				params.HeightModifier = -5
				params.FallingAccelModifier = -0.15
				params.Scale = 1.5
				params.BulletFlags = ProjectileFlags.SINE_VELOCITY | ProjectileFlags.MEGA_WIGGLE
				boss:FireProjectiles(boss.Position-Vector(0,100), Vector.FromAngle(angle):Resized(5), 0, params)
			end
		end

		if boss.State == 0 then
			data.sttposX = 0
			data.endposY = 0
			data.sttposY = 0
			data.endposY = 0
			data.intervelX = 0
			data.intervelY = 0
			data.spawnvel = Vector(0,0)
		end

		if boss:IsDead() then
			sound:Stop(85)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.ItLives, 78)

----------------------------
--add Boss Pattern:Satan
----------------------------
function denpnapi:Satan(boss)
	if (Game().Difficulty == 1 or Game().Difficulty == 3) and boss.Variant == 0
	and boss:GetSprite():IsPlaying("Walk") and not boss:GetData().isdelirium
	and not boss:GetData().ncrsHP then
		boss:GetData().ncrsHP = true
		boss.MaxHitPoints = math.max(600, 8*GetPlayerDps)
		boss.HitPoints = boss.MaxHitPoints
	end

	if boss.Variant == Isaac.GetEntityVariantByName("Satan")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprst = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		local Entities = Isaac:GetRoomEntities()
		local angle = (target.Position - boss.Position):GetAngleDegrees()

		if boss.FrameCount >= 10 and sprst:IsFinished("SmallIdle")
		and boss:GetAliveEnemyCount() <= 1 then
			boss.State = 30
		end

		if boss.State == 30 then
			if sprst:IsPlaying("SmallAttack") then
				if sprst:GetFrame() >= 24 and sprst:GetFrame() <= 27 then
					if sprst:GetFrame() == 24 then
						boss:PlaySound(245, 0.75, 0, false, 1)
					end
					local params = ProjectileParams()
					params.Scale = 1.5
					for i=0, 40, 20 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle((((sprst:GetFrame()-24)*60)+i)-20)
						:Resized(9), 0, params)
					end
				end
			else
				if sprst:IsFinished("SmallAttack") then
					sprst:Play("SmallIdle", true)
				end
				if boss.FrameCount % 220 == 0 then
					sprst:Play("SmallAttack", true)
				end
				if boss.FrameCount >= 400 and Room:GetAliveEnemiesCount() <= 1 then
					boss.State = 3
				end
			end
		end

		if sprst:IsPlaying("Attack02") and sprst:GetFrame() == 1 and math.random(1,2) == 1 then
			sprst:Play("Attack04",true)
			boss.State = 29
		end

		if sprst:IsPlaying("Attack03") and sprst:GetFrame() == 1
		and math.random(1,2) == 1 then
			if boss.I2 == 10 then
				sprst:Play("Attack02",true)
				boss.State = 9
			elseif boss.I2 == 11 and math.random(1,4) == 1
			and Room:GetAliveEnemiesCount() <= 2 then
				sprst:Play("Summon",true)
				boss.State = 12
			end
		end

		if boss.FrameCount % 30 == 0 and boss.State == 4 and sprst:IsPlaying("Walk")
		and math.abs(target.Position.Y-boss.Position.Y) <= 60
		and math.abs(target.Position.X-boss.Position.X) >= 150 then
			boss.State = 28
			sprst:Play("Attack05Ready",true)
		end

		if sprst:IsPlaying("Attack04") then
			if sprst:GetFrame() == 17 then
				boss:PlaySound(52, 1.5, 0, false, 1)
				boss:PlaySound(245, 1, 0, false, 1)
				Game():ShakeScreen(20)
				local shockwave = Isaac.Spawn(1000, 67, 0, boss.Position, Vector(0,0), boss)
				shockwave.Parent = boss
			end
			if sprst:GetFrame() >= 17 and sprst:GetFrame() <= 23 then
				local params = ProjectileParams()
				params.FallingAccelModifier = 0.7
				params.HeightModifier = -300
				params.Scale = math.random(18,23) * 0.1
				params.Variant = 9
				params.BulletFlags = 1 << 1 | 1 << 31 | 1 << 32
				params.ChangeTimeout = 5
				params.ChangeFlags = 1 << 1
				boss:FireProjectiles(Isaac.GetRandomPosition(0), Vector(0,0), 0, params)
			end
		end

		if sprst:IsFinished("Attack05Ready") then
			sprst:Play("Attack05Loop",true)
			boss:PlaySound(245, 1, 0, false, 1)
			boss.Velocity = Vector.FromAngle(angle):Resized(50)
			boss.StateFrame = 20
		end

		if sprst:IsPlaying("Attack05Loop") then
			boss.StateFrame = boss.StateFrame - 1
			if boss.StateFrame <= 0 then
				sprst:Play("Attack05End",true)
			end
		end

		if sprst:IsFinished("Attack05End") or sprst:IsFinished("Summon")
		or sprst:IsFinished("Attack04") then
			sprst:Play("Walk",true)
			boss.State = 4
		end

		if sprst:IsPlaying("Summon") then
			if sprst:GetFrame() == 13 then
				boss:PlaySound(243, 1, 0, false, 1)
				Isaac.Spawn(259, 0, 0, boss.Position+Vector(50,0), Vector(0,0), boss)
			end
		end

		for k, v in pairs(Entities) do
			if v.Type == 7 and v.Variant == 1
			and v.SpawnerType == 84 then
				if v.FrameCount == 0 then
					if sprst:IsPlaying("Attack02") then
						v:GetData().lflag = 1
						v:GetData().pvl = 7
						v:GetData().pdensity = 9
					elseif sprst:IsPlaying("Attack03") then
						v:GetData().lflag = 2
					end
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Satan, 84)

----------------------------
--add Boss Pattern:Satan Stomp
----------------------------
function denpnapi:SatanFoot(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Satan Stomp")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprstf = boss:GetSprite()
		local Entities = Isaac:GetRoomEntities()

		if not boss:GetData().isdelirium then
			if boss.State < 8 then
				if boss.FrameCount % math.random(100,200) == 0 and math.random(3,5) == 3 then
					Isaac.Spawn(252, 0, 0, Isaac.GetRandomPosition(0), Vector(0,0), boss)
				end
				if sprstf:GetFrame() == 30 and math.random(1,5) <= 3
				and boss.FrameCount >= boss.StateFrame + 350 then
					StAttackReady = math.random(1,2)
				end
				if StAttackReady > 0 then
					if sprstf:GetFrame() == 80 then
						boss.StateFrame = boss.FrameCount
						boss.State = 8
					end
				end
			else
				if boss.FrameCount == boss.StateFrame + 50 then
					if StAttackReady == 1 then
						local BigDownLaser = Isaac.Spawn(1000, 356, 2, Isaac.GetRandomPosition(0), Vector(0,0), boss)
						BigDownLaser:ToEffect().Timeout = 76
					elseif StAttackReady == 2 then
						if #Isaac.FindByType(1000, 356, -1, true, true) == 0 then
							Isaac.Spawn(1000, 356, 3, Isaac.GetRandomPosition(0), Vector(0,0), boss)
						end
					end
				end
			end

			if boss.State == 8 and boss.FrameCount >= boss.StateFrame + 200 then
				boss.State = 3
				StAttackReady = 0
			end

			if boss:IsDead() then
				StAttackReady = 0
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.SatanFoot, 84)

----------------------------
--New Enemy:Hush Spider
----------------------------
function denpnapi:Spider(enemy)
	if enemy.FrameCount == 1 then
		if enemy.SpawnerType == 608 then
			enemy:Morph(85, 402, 0, -1)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Spider, 85)

function denpnapi:HsSpider(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Hush Spider") then

		local sprspdr = enemy:GetSprite()
		local InitSpeed = enemy.Velocity

		enemy.Velocity = InitSpeed * 0.65

		if enemy.FrameCount <= 2 then
			if math.random(0,2) == 1 then
				sprspdr:ReplaceSpritesheet(0, "gfx/enemies/monster_spider_hush_2.png")
				sprspdr:LoadGraphics()
			elseif math.random(0,2) == 2 then
				sprspdr:ReplaceSpritesheet(0, "gfx/enemies/monster_spider_hush_3.png")
				sprspdr:LoadGraphics()
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.HsSpider, 85)

----------------------------
--Me
----------------------------
function denpnapi:Me(isaac)

	local sprme = isaac:GetSprite()
	local target = isaac:GetPlayerTarget()
	local data = isaac:GetData()

	if Game().Difficulty == 1 or Game().Difficulty == 3 then
		if sprme:IsPlaying("1Idle") and isaac.State == 8
		and math.random(1,3) == 1 then
			isaac.State = 20
			isaac.StateFrame = 70
		end

		if isaac.State == 20 then
			if sprme:IsPlaying("1Idle") then
				sprme:Play("1Attack2",true)
			elseif sprme:IsPlaying("1Attack2") then
				if sprme:GetFrame() == 56 then
					isaac:PlaySound(267, 1, 0, false, 1)
					if isaac.Variant == 0 then
						local params = ProjectileParams()
						params.Variant = 4
						params.FallingAccelModifier = 0.5
						for i=0, math.random(7,10) do
							if i >= 7 then
								params.Scale = 1.5
								params.BulletFlags = 1 << 44
							else
								params.Scale = math.random(7,13) * 0.1
							end
							params.FallingSpeedModifier = -math.random(130,180) * 0.1
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(isaac:GetDropRNG():RandomInt(359)):Resized(math.random(10,70)*0.1), 0, params)
						end
					elseif isaac.Variant == 1 then
						local params = ProjectileParams()
						params.Scale = 1.3
						params.BulletFlags = 1
						params.FallingAccelModifier = -0.05
						for i=0, 330, 30 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i+
							(target.Position-isaac.Position):GetAngleDegrees()):Resized(10), 0, params)
						end
					elseif isaac.Variant == 2 then
						local params = ProjectileParams()
						params.Scale = 1.3
						params.Variant = 6
						params.FallingAccelModifier = -0.165
						params.BulletFlags = 1 << 40 | ProjectileFlags.NO_WALL_COLLIDE
						params.Color = Color(0.8,0.8,1.3,1,0,0,0)
						params.CurvingStrength = (25*((math.random(-1,0)*2)+1))*0.001
						for i=0, 340, 20 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(6), 0, params)
						end
					end
				end
			end
			if sprme:IsFinished("1Attack2") then
				sprme:SetFrame("1Attack", 15)
				isaac.State = 8
			end
		end
	end

	if sprme:IsEventTriggered("Feather") then
		Game():SpawnParticles(isaac.Position, 352, math.random(6,13), 13, Color(1,1,1,1,0,0,0), -20)
	end
	if (Game().Difficulty == 1 or Game().Difficulty == 3) then
		if not data.finalform and isaac.HitPoints / isaac.MaxHitPoints <= 0.3
		and isaac.Variant <= 1 then
			data.finalform = true
			isaac.State = 155
			sprme:Play("4Evolve",true)
			isaac.FlipX = false
		end

		if data.finalform and isaac.State < 33 then
			isaac.Visible = true
			isaac.State = 155
			sprme:Play("4Evolve",true)
		end

		if isaac.State == 155 then
			if sprme:IsPlaying("4Evolve") then
				if sprme:GetFrame() == 24 then
					isaac:PlaySound(266, 1, 0, false, 1.05)
					if isaac.Variant == 1 then
						isaac.I1 = 2
					end
				end
			else
				isaac.State = 33
				isaac.TargetPosition = Isaac.GetRandomPosition(0)
			end
		end
	end

end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Me, 102)

----------------------------
--add Boss Pattern:Isaac
----------------------------
function denpnapi:Isaac(isaac)

	if isaac.Variant == Isaac.GetEntityVariantByName("Isaac")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local spri = isaac:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		local target = isaac:GetPlayerTarget()
		local data = isaac:GetData()

		if not data.door then
			if Room:GetRoomShape() >= 8 then
				data.door = 8
			elseif Room:GetRoomShape() >= 6 then
				data.door = 6
			elseif Room:GetRoomShape() >= 4 then
				data.door = 6
			else
				data.door = 4
			end
		end

		if ((spri:IsPlaying("2Idle") and isaac.State == 3)
		or (spri:IsPlaying("2Attack") and isaac.State == 8))
		and isaac.FrameCount % 90 == 0 and Room:GetAliveEnemiesCount() <= 3 then
			Isaac.Spawn(523, 0, 0, isaac.Position+Vector.FromAngle(math.random(1,359)):Resized(math.random(10,30)), Vector(0,0), isaac)
		end

		if spri:IsFinished("2Evolve") then
			data.i3 = math.random(4,7)
		end

		if isaac.State == 100 then
			if not spri:IsPlaying("4FBAttack4") then
				spri:Play("4FBAttack4",true)
			else
				if spri:GetFrame() == 17 then
					isaac:PlaySound(129, 1, 0, false, 1)
					local rlwv = Isaac.Spawn(1000, 358, 0, isaac.Position, Vector(0,0), isaac):ToEffect()
					rlwv.Timeout = 150
					rlwv.Scale = 1.15
				elseif spri:GetFrame() == 51 then
					isaac.State = 33
					isaac.StateFrame = math.random(70,170)
				end
			end
		elseif isaac.State == 99 then
			isaac.ProjectileCooldown = isaac.ProjectileCooldown - 1
			if isaac.ProjectileCooldown == 200 then
				spri:Play("4FBAttack3Ready",true)
			elseif isaac.ProjectileCooldown == 134 then
				isaac:PlaySound(129, 1, 0, false, 1)
			elseif isaac.ProjectileCooldown == 30 then
				spri:Play("4FBAttack3End",true)
			elseif isaac.ProjectileCooldown <= 0 then
				isaac.State = 33
				isaac.StateFrame = math.random(70,170)
			end
			if spri:IsFinished("4FBAttack3Ready") then
				spri:Play("4FBAttack3Start",true)
			elseif spri:IsFinished("4FBAttack3Start") then
				spri:Play("4FBAttack3Loop2",true)
			end
			if isaac.ProjectileCooldown >= 50 and isaac.ProjectileCooldown <= 134
			and isaac.ProjectileCooldown % 9 == 0 then
				isaac:PlaySound(267, 1, 0, false, 1)
				if isaac.FrameCount % 2 == 0 then
					for i=0, 345, 15 do
						Isaac.Spawn(552, 1, 12, isaac.Position,
						Vector.FromAngle(i+(target.Position-isaac.Position):GetAngleDegrees()):Resized(7), isaac)
					end
				else
					local params = ProjectileParams()
					params.Variant = 4
					params.FallingAccelModifier = -0.175
					for i=0, 340, 20 do
						isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i+((isaac.FrameCount % 4)*15)):Resized(7), 0, params)
					end
				end
			end
		elseif isaac.State == 88 then
			if spri:IsPlaying("4Appear") then
				isaac.Visible = true
				if spri:GetFrame() == 1 then
					isaac.I1 = isaac.I1 - 1
					isaac.Position = target.Position
				elseif spri:GetFrame() == 10 then
					isaac.EntityCollisionClass = 4
					isaac:PlaySound(52, 1, 0, false, 1)
					for i = 30, 330, 60 do
						local lwavel = Isaac.Spawn(1000, 351, 27,
						isaac.Position + Vector.FromAngle(i):Resized(20), Vector(0,0), isaac)
						lwavel.Parent = isaac
						lwavel:ToEffect().Rotation = i
						lwavel:ToEffect().LifeSpan = 70
					end
					for i = 0, 300, 60 do
						local lwaver = Isaac.Spawn(1000, 351, 28,
						isaac.Position + Vector.FromAngle(i):Resized(20), Vector(0,0), isaac)
						lwaver.Parent = isaac
						lwaver:ToEffect().Rotation = i
						lwaver:ToEffect().LifeSpan = 70
					end
				end
			end
			if spri:IsFinished("4Appear") then
				if isaac.I1 > 0 then
					spri:Play("4FBAttack",true)
				else
					isaac.State = 33
					isaac.StateFrame = math.random(70,170)
				end
			end
			if spri:IsPlaying("4FBAttack") then
				if spri:GetFrame() >= 24 then
					isaac.Visible = false
					isaac.EntityCollisionClass = 0
				elseif spri:GetFrame() == 20 then
					isaac:PlaySound(215, 1, 0, false, 1)
				end
			end
			if spri:IsFinished("4FBAttack") then
				spri:Play("4Appear",true)
				isaac:PlaySound(214, 1, 0, false, 1)
			end
		elseif isaac.State == 80 then
			isaac.ProjectileCooldown = isaac.ProjectileCooldown - 1
			if isaac.ProjectileCooldown <= 0 and spri:IsPlaying("4FBAttack2Loop") then
				spri:Play("4FBAttack2End",true)
			end
			if isaac.ProjectileCooldown > 0 and isaac.FrameCount % 5 == 0 then
				if isaac.I1 == 1 then
					isaac:PlaySound(267, 0.65, 0, false, 1)
					local params = ProjectileParams()
					params.Variant = 4
					params.BulletFlags = ProjectileFlags.SAWTOOTH_WIGGLE
					params.FallingAccelModifier = -0.175
					params.FallingSpeedModifier = 0
					for i=0, 315, 45 do
						isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(7), 0, params)
					end
					if isaac.FrameCount % 2 == 0 then
						local params2 = ProjectileParams()
						params2.Variant = 4
						params2.FallingSpeedModifier = 0
						params2.FallingAccelModifier = -0.175
						for i=0, 315, 45 do
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(i+((isaac.FrameCount % 4)/2)*22.5):Resized(7), 0, params2)
						end
					end
				elseif isaac.I1 == 2 then
					isaac:PlaySound(267, 0.65, 0, false, 1)
					local params = ProjectileParams()
					params.Variant = 4
					params.BulletFlags = ProjectileFlags.CURVE_LEFT | ProjectileFlags.NO_WALL_COLLIDE
					params.CurvingStrength = 0.014
					params.FallingSpeedModifier = 0
					params.FallingAccelModifier = -0.16
					for i=0, 315, 45 do
						isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(9), 0, params)
					end
				elseif isaac.I1 == 3 then
					isaac:PlaySound(267, 0.65, 0, false, 1)
					local params = ProjectileParams()
					params.Variant = 4
					params.BulletFlags = 1 << (18 + isaac.FrameCount % 2) | ProjectileFlags.NO_WALL_COLLIDE
					| ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT | ProjectileFlags.ACCELERATE
					params.CurvingStrength = 0.014
					params.Acceleration = 0.98
					params.FallingSpeedModifier = 0
					params.FallingAccelModifier = -0.165
					params.ChangeTimeout = 42
					params.ChangeFlags = 0
					for i=0, 315, 45 do
						isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i+isaac.ProjectileCooldown*3):Resized(15), 0, params)
					end
				end
			end
			if spri:IsPlaying("4FBAttack2Start") and spri:GetFrame() == 21 then
				isaac:PlaySound(129, 1, 0, false, 1)
				isaac.ProjectileCooldown = math.random(20,50)
			end
			if spri:IsFinished("4FBAttack2Start") then
				spri:Play("4FBAttack2Loop",true)
			elseif spri:IsFinished("4FBAttack2End") then
				isaac.State = 33
				isaac.StateFrame = math.random(70,170)
			end
		elseif isaac.State == 33 then
			isaac.StateFrame = isaac.StateFrame - 1
			if not spri:IsPlaying("4Idle") then
				spri:Play("4Idle",true)
			end
			if ((data.isdelirium and isaac.FrameCount % 100 == 0)
			or (not data.isdelirium and isaac.FrameCount % 50 == 0))
			and spri:IsPlaying("4Idle") then
				isaac:PlaySound(267, 0.65, 0, false, 1)
				local params = ProjectileParams()
				params.Scale = 1.3
				params.Variant = 4
				params.FallingSpeedModifier = 0
				params.FallingAccelModifier = -0.12
				for i=0, 330, 30 do
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(6), 0, params)
				end
			end
			if isaac.StateFrame <= 0 then
				if math.random(1,4) == 1 and not data.isdelirium then
					spri:Play("4FBAttack",true)
					isaac.State = 88
					isaac.I1 = math.random(1,3)
				elseif math.random(1,4) == 2 then
					isaac.State = 99
					isaac.ProjectileCooldown = 201
				elseif math.random(1,4) == 3 then
					isaac.State = 100
				else
					spri:Play("4FBAttack2Start",true)
					isaac.State = 80
					isaac.I1 = math.random(1,3)
					isaac.ProjectileCooldown = 0
				end
			end
			if isaac.TargetPosition:Distance(isaac.Position) <= 75 then
				isaac.TargetPosition = Isaac.GetRandomPosition(0)
			end
			if spri:IsPlaying("4Idle") then
				if data.isdelirium then
					data.vlength = 0.4
				else
					data.vlength = 0.9
				end
				isaac.Velocity = (isaac.Velocity * 0.9999) +
				Vector.FromAngle((isaac.TargetPosition - isaac.Position):GetAngleDegrees()):Resized(data.vlength)
			else
				isaac.Velocity = isaac.Velocity * 0.99
			end
		elseif isaac.State == 28 then
			if spri:IsPlaying("3FBAppear2") then
				if spri:GetFrame() == 1 then
					isaac:PlaySound(214, 1, 0, false, 1)
				elseif spri:GetFrame() == 26 then
					isaac:PlaySound(52, 1, 0, false, 1)
					for i = 0, 315, 45 do
						local lwave = Isaac.Spawn(1000, 351, 0,
						isaac.Position + Vector.FromAngle(i):Resized(20), Vector(0,0), isaac)
						lwave.Parent = isaac
						lwave:ToEffect().Rotation = i
					end
				end
				if spri:GetFrame() <= 25 then
					isaac.EntityCollisionClass = 0
				else
					isaac.EntityCollisionClass = 4
				end
			end

			if spri:IsFinished("3FBAttack3") then
				spri:Play("3FBAppear2",true)
				isaac.Position = target.Position
			elseif spri:IsFinished("3FBAppear2") then
				isaac.State = 3
			end
		elseif isaac.State == 15 then
			isaac.StateFrame = isaac.StateFrame + 1
			if isaac.Velocity.X < 0 then
				isaac.FlipX = true
			else
				isaac.FlipX = false
			end
			if spri:IsFinished("3FBAttack6Ready") then
				isaac.StateFrame = 0
				isaac:PlaySound(129, 1, 0, false, 1)
				isaac.Velocity = Vector.FromAngle((target.Position-isaac.Position):GetAngleDegrees()):
				Resized(32)
			end
			if not spri:IsPlaying("3FBAttack6Ready") then
				if isaac.Velocity.Y < 0 then
					isaac:SetSpriteFrame("3FBAttack6Up", isaac.StateFrame+1)
				else
					isaac:SetSpriteFrame("3FBAttack6Down", isaac.StateFrame+1)
				end
				if isaac.FrameCount % 3 == 0 and isaac.StateFrame <= 15 then
					isaac:PlaySound(267, 0.65, 0, false, 1)
					local params = ProjectileParams()
					params.Variant = 4
					params.BulletFlags = ProjectileFlags.ACCELERATE
					params.Acceleration = 0.94
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle((isaac.Velocity):GetAngleDegrees()-90):Resized(13), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle((isaac.Velocity):GetAngleDegrees()-130):Resized(13), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle((isaac.Velocity):GetAngleDegrees()+90):Resized(13), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle((isaac.Velocity):GetAngleDegrees()+130):Resized(13), 0, params)
				end
				if isaac.StateFrame >= 36 then
					isaac.FlipX = false
					if isaac.I1 <= 0 then
						spri:SetFrame("3FBAttack4End", 27)
						isaac.State = 8
					else
						isaac.I1 = isaac.I1 - 1
						spri:Play("3FBAttack6Ready",true)
					end
				end
			end
		elseif isaac.State == 12 then
			if spri:IsPlaying("3FBAttack3") then
				if spri:GetFrame() == 20 then
					isaac:PlaySound(215, 1, 0, false, 1)
					isaac.I1 = 6
					for i=1, 3 do
						Isaac.Spawn(1000, 19, 999, Isaac.GetRandomPosition(0), Vector(0,0), isaac)
					end
				elseif spri:GetFrame() == 26 then
					isaac.Visible = false
				end
				if spri:GetFrame() >= 22 then
					isaac.EntityCollisionClass = 0
				end
			end
			if not isaac.Visible then
				if Room:GetAliveEnemiesCount() <= 4 and isaac.FrameCount % 30 == 0 then
					isaac.I1 = isaac.I1 - 1
					if isaac.I1 > 1 then
						Isaac.Spawn(1000, 19, 999, Isaac.GetRandomPosition(0), Vector(0,0), isaac)
					end
				end
				if isaac.I1 <= 0 and Room:GetAliveEnemiesCount() <= 1 then
					isaac.Visible = true
					isaac.State = 28
					spri:Play("3FBAppear2",true)
					isaac.Position = target.Position
				end
			end
			if spri:IsPlaying("3Summon") and spri:GetFrame() == 11 then
				isaac.I1 = 0
				isaac:PlaySound(129, 1, 0, false, 1)
				isaac:PlaySound(265, 1, 0, false, 1)
				if math.random(1,2) == 2 then
					Isaac.Spawn(523, 0, 0, isaac.Position+Vector.FromAngle(90):Resized(40), Vector(0,0), isaac)
				else
					Isaac.Spawn(38, 1, 0, isaac.Position+Vector.FromAngle(90):Resized(40), Vector(0,0), isaac)
				end
			end
			if spri:IsFinished("3Summon") then
				spri:Play("3Idle",true)
				isaac.State = 3
			end
		elseif isaac.State == 10 then
			if spri:IsFinished("3FBAttack3") then
				if isaac.I1 > 0 then
					spri:Play("3Appear",true)
					data.i3 = math.random(0,7)
					data.dash = false
					if data.i3 == 0 then
						isaac.Position = Room:GetTopLeftPos()
					elseif data.i3 == 1 then
						isaac.Position = Vector(Room:GetBottomRightPos().X,Room:GetTopLeftPos().Y)
					elseif data.i3 == 2 then
						isaac.Position = Vector(Room:GetTopLeftPos().X,Room:GetBottomRightPos().Y)
					elseif data.i3 == 3 then
						isaac.Position = Room:GetBottomRightPos()
					else
						isaac.Position = Room:GetDoorSlotPosition(math.random(0,data.door))
						isaac.StateFrame = 55
					end
				else
					isaac.State = 28
					isaac.EntityCollisionClass = 0
				end
			end
			if spri:IsFinished("3Appear") then
				if isaac.I1 > 0 then
					if data.i3 > 3 then
						spri:Play("3Idle",true)
						isaac.StateFrame = 50
					else
						spri:Play("3FBAttack6Ready",true)
					end
				else
					isaac.State = 3
				end
			end
			if data.i3 < 4 then
				isaac.StateFrame = isaac.StateFrame + 1
				if isaac.Velocity.X < 0 then
					isaac.FlipX = true
				else
					isaac.FlipX = false
				end
				if spri:IsFinished("3FBAttack6Ready") and not data.dash then
					isaac.StateFrame = 0
					isaac:PlaySound(129, 1, 0, false, 1)
					data.dash = true
					if data.i3 == 0 then
						isaac.Velocity = Vector.FromAngle((Room:GetBottomRightPos()-isaac.Position)
						:GetAngleDegrees()):Resized(Room:GetBottomRightPos():Distance(isaac.Position)*0.11)
					elseif data.i3 == 1 then
						isaac.Velocity = Vector.FromAngle((Vector(Room:GetTopLeftPos().X,Room:GetBottomRightPos().Y)-isaac.Position)
						:GetAngleDegrees()):Resized(Vector(Room:GetTopLeftPos().X,Room:GetBottomRightPos().Y):Distance(isaac.Position)*0.11)
					elseif data.i3 == 2 then
						isaac.Velocity = Vector.FromAngle((Vector(Room:GetBottomRightPos().X,Room:GetTopLeftPos().Y)-isaac.Position)
						:GetAngleDegrees()):Resized(Vector(Room:GetBottomRightPos().X,Room:GetTopLeftPos().Y):Distance(isaac.Position)*0.11)
					elseif data.i3 == 3 then
						isaac.Velocity = Vector.FromAngle((Room:GetTopLeftPos()-isaac.Position)
						:GetAngleDegrees()):Resized(Room:GetTopLeftPos():Distance(isaac.Position)*0.11)
					end
				end
				if data.dash then
					if isaac.Velocity.Y < 0 then
						isaac:SetSpriteFrame("3FBAttack6Up", isaac.StateFrame+1)
					else
						isaac:SetSpriteFrame("3FBAttack6Down", isaac.StateFrame+1)
					end
					if isaac.FrameCount % 2 == 0 and isaac.StateFrame <= 20 then
						isaac:PlaySound(267, 0.65, 0, false, 1)
						local params = ProjectileParams()
						params.Variant = 4
						params.BulletFlags = ProjectileFlags.ACCELERATE
						params.Acceleration = 1.075
						params.FallingAccelModifier = -0.1
						for i=-90, 90, 180 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle((isaac.Velocity):GetAngleDegrees()+i):Resized(0.5), 0, params)
						end
					end
					if isaac.StateFrame >= 36 and not spri:IsPlaying("3FBAttack3") then
						isaac.FlipX = false
						isaac.I1 = isaac.I1 - 1
						data.i3 = 0
						spri:Play("3FBAttack3",true)
						data.dash = false
					end
				end
			elseif spri:IsPlaying("3Idle") then
				isaac.StateFrame = isaac.StateFrame - 1
				if isaac.StateFrame > 0 then
					if isaac:HasEntityFlags(1<<9) then
						angle = angle + 3
					else
						angle = (target.Position - isaac.Position):GetAngleDegrees()
					end
				end
				InitSpeed = isaac.Velocity
				isaac.Velocity = (InitSpeed*0.9) + Vector.FromAngle(angle):Resized(2.05)
				if isaac.FrameCount % 8 == 0 and isaac.I1 > 0 then
					isaac:PlaySound(153, 1, 0, false, 1)
					local params = ProjectileParams()
					params.Scale = 1.5
					params.Variant = 4
					params.BulletFlags = ProjectileFlags.BURST
					isaac:FireProjectiles(isaac.Position, Vector(0,0), 0, params)
				end
				if isaac.StateFrame <= 0 then
					isaac.I1 = isaac.I1 - 1
					spri:Play("3FBAttack3",true)
				end
			end
		elseif isaac.State == 9 then
			if spri:IsPlaying("2Attack2") and spri:GetFrame() == 28 then
				EntityLaser.ShootAngle(3, isaac.Position+Vector(0,1), (data.i3-(data.i3 % 10000))*13.5, 20, Vector(0,-20), isaac)
				EntityLaser.ShootAngle(3, isaac.Position+Vector(0,1), 81+(data.i3-((data.i3 / 10000)*10000)-(data.i3 % 1000))*13.5, 20, Vector(0,-20), isaac)
				EntityLaser.ShootAngle(3, isaac.Position+Vector(0,1), 153+(data.i3-((data.i3 / 1000)*1000)-(data.i3 % 100))*13.5, 20, Vector(0,-20), isaac)
				EntityLaser.ShootAngle(3, isaac.Position+Vector(0,1), 225+(data.i3-((data.i3 / 100)*100)-(data.i3 % 10))*13.5, 20, Vector(0,-20), isaac)
				EntityLaser.ShootAngle(3, isaac.Position+Vector(0,1), 297+(data.i3-(data.i3 / 10)*10)*13.5, 20, Vector(0,-20), isaac)
			end
			if spri:IsFinished("2Attack2") then
				data.i3 = 0
				isaac.I1 = -1
				spri:SetFrame("2Attack", 29)
				isaac.State = 8
			end
			if spri:IsPlaying("3Appear") and not data.isdelirium then
				isaac.State = 28
				spri:Play("3FBAppear2",true)
				isaac.Position = target.Position
				isaac.EntityCollisionClass = 0
			end
			if spri:IsPlaying("3FBAttack3") and spri:GetFrame() == 1 then
				if math.random(1,3) == 1 then
					isaac.State = 10
					isaac.I1 = math.random(2,4)
				elseif math.random(1,3) == 2 then
					isaac.State = 12
				end
			end
			if spri:IsPlaying("1Attack") then
				if data.i3 > 0 then
					if isaac.I1 == 1 then
						if (data.i3 < data.start and spri:GetFrame() == 5)
						or (data.i3 >= data.start and spri:GetFrame() == 9) then
							spri:Play("1Attack",true)
						end
					elseif isaac.I1 == 2 then
						if spri:GetFrame() == 12 then
							spri:Play("1Attack",true)
						end
					end
					if spri:GetFrame() == 1 then
						data.i3 = data.i3 - 1
					end
				end
				if data.i3 < data.start and spri:GetFrame() == 1 then
					isaac:PlaySound(267, 0.65, 0, false, 1)
					if isaac.I1 == 1 then
						local params = ProjectileParams()
						params.Variant = 4
						params.FallingSpeedModifier = -30
						params.FallingAccelModifier = 1.2
						params.BulletFlags = ProjectileFlags.CURVE_LEFT | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
						params.ChangeTimeout = 28
						params.ChangeFlags = 1 << 39
						params.CurvingStrength = 0.016
						for i=0, 315, 45 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(13), 0, params)
						end
					elseif isaac.I1 == 2 then
						local params = ProjectileParams()
						params.Variant = 4
						params.FallingSpeedModifier = -40
						params.FallingAccelModifier = 1
						params.BulletFlags = ProjectileFlags.ACCELERATE
						params.Acceleration = 0.945
						params.Scale = 1
						for i=-3.5, 3.5, 1 do
							isaac:FireProjectiles(isaac.Position, Vector(12*1.2,(i*1.2)*2), 0, params)
							isaac:FireProjectiles(isaac.Position, Vector(-12*1.2,(i*1.2)*2), 0, params)
						end
						for i=-6, 6, 1 do
							isaac:FireProjectiles(isaac.Position, Vector((i*1.2)*2,7*1.2), 0, params)
							isaac:FireProjectiles(isaac.Position, Vector((i*1.2)*2,-7*1.2), 0, params)
						end
					end
				end
			end
			if spri:IsFinished("1Attack") then
				isaac.State = 8
			end
		elseif isaac.State == 8 then
			if spri:IsPlaying("1Idle") and math.random(1,2) == 1 then
				isaac.State = 9
				spri:Play("1Attack",true)
				isaac.I1 = math.random(1,2)
				if isaac.I1 == 2 then
					data.i3 = math.random(3,4)
				else
					data.i3 = math.random(4,7)
				end
				data.start = data.i3 - 1
			end
			if spri:IsPlaying("2Attack") then
				if data.LsrReady and spri:GetFrame() == 1 then
					data.LsrReady = false
					spri:Play("2Attack2",true)
					isaac.State = 9
					data.i3 = (math.random(1,4)*10000) + (math.random(1,4)*1000) +
					(math.random(1,4)*100) + (math.random(1,4)*10) + math.random(1,4)
					local params = ProjectileParams()
					params.Variant = 4
					params.BulletFlags = ProjectileFlags.ACCELERATE
					params.HeightModifier = -12
					params.FallingAccelModifier = 0.1
					params.Acceleration = 0.9
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle((data.i3-(data.i3 % 10000))*13.5):Resized(10), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle(81+(data.i3-((data.i3 / 10000)*10000)-(data.i3 % 1000))*13.5):Resized(10), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle(153+(data.i3-((data.i3 / 1000)*1000)-(data.i3 % 100))*13.5):Resized(10), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle(225+(data.i3-((data.i3 / 100)*100)-(data.i3 % 10))*13.5):Resized(10), 0, params)
					isaac:FireProjectiles(isaac.Position, Vector.FromAngle(297+(data.i3-(data.i3 / 10)*10)*13.5):Resized(10), 0, params)
				end
				if isaac.I1 == 1 and spri:GetFrame() == 2 then
					data.LsrReady = true
				end
			end
			if spri:IsPlaying("3FBAttack4Start") and spri:GetFrame() == 1 then
				if math.random(1,3) == 2 and Room:GetAliveEnemiesCount() <= 2
				and isaac.FrameCount % 100 <= 30 then
					spri:Play("3Summon",true)
					isaac.State = 12
				elseif math.random(1,3) == 3 then
					targetangle = (target.Position - isaac.Position):GetAngleDegrees()
					isaac.State = 15
					isaac.I1 = math.random(1,3)
					spri:Play("3FBAttack6Ready",true)
				end
			end
		elseif isaac.State == 0 then
			data.LsrReady = false
		end

		if isaac.State > 9 then
			if spri:IsPlaying("3Appear") then
				if spri:GetFrame() == 1 then
					isaac:PlaySound(214, 1, 0, false, 1)
				end
				if spri:GetFrame() <= 7 then
					isaac.EntityCollisionClass = 0
				else
					isaac.EntityCollisionClass = 4
				end
			end
			if spri:IsPlaying("3FBAttack3") then
				if spri:GetFrame() == 20 then
					isaac:PlaySound(215, 1, 0, false, 1)
				end
				if spri:GetFrame() >= 22 then
					isaac.EntityCollisionClass = 0
				else
					isaac.EntityCollisionClass = 4
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Isaac, 102)

----------------------------
--add Boss Pattern:???
----------------------------
function denpnapi:BBaby(isaac)

	if isaac.Variant == 1 and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local spr = isaac:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		local target = isaac:GetPlayerTarget()
		local data = isaac:GetData()
		local rng = isaac:GetDropRNG()
		local angle = (target.Position - isaac.Position):GetAngleDegrees()

		if isaac.State == 8 and spr:IsPlaying("1Idle") and math.random(1,2) == 1 then
			spr:Play("1Attack",true)
			isaac.State = 9
			isaac.I1 = math.random(1,2)
			data.i3 = math.random(5,9)
			data.start = data.i3 - 1
		end

		if not data.init then
			data.init = true
			data.Xsttpos = Vector(0,0)
			data.Ysttpos = Vector(0,0)
			data.intervalX = 0
			data.intervalY = 0
			data.lrtt = 0
			data.Xendpos = 0
			data.Yendpos = 0
		end

		if (spr:IsFinished("2Attack") and math.random(1,2) == 1)
		or (isaac.HitPoints/isaac.MaxHitPoints < 0.5 and isaac.FrameCount % 110 == 0) then
			local sucker = Isaac.Spawn(61, 0, 0, isaac.Position + Vector.FromAngle(math.random(0,360)):Resized(70), Vector(0,0), isaac)
			sucker:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end

		if spr:IsPlaying("4FBAttackStart") and spr:GetFrame() >= 21 then
			isaac:PlaySound(215, 1, 0, false, 1)
			isaac.EntityCollisionClass = 0
		end

		if isaac.State == 157 then
			if spr:IsFinished("4FBAttackStart") then
				spr:Play("4Appear", true)
				isaac:PlaySound(214, 1, 0, false, 1)
				isaac.I1 = math.random(1,4)
				if isaac.I1 == 1 then
					isaac.Position = Vector(Room:GetCenterPos().X*(0.3+(math.random(0,1)*1.4)),
					Room:GetCenterPos().Y)
				else
					isaac.Position = Isaac.GetRandomPosition(0)
					for i=0, 3 do
						if Isaac.GetPlayer(0).Position:Distance(isaac.Position) <= 70 then
							isaac.Position = Isaac.GetRandomPosition(0)
						end
					end
				end
			elseif spr:IsFinished("4Appear") then
				if isaac.I1 == 1 then
					spr:Play("4FBAttack3", true)
					isaac.State = 99
				else
					if math.random(1,2) == 1 and isaac:GetAliveEnemyCount() <= 3 then
						spr:Play("4Summon", true)
						isaac.State = 120
					else
						spr:Play("4FBAttack2Start", true)
						isaac.I1 = math.random(1,4)
						isaac.State = 88
						data.pangle = angle
						if isaac.I1 == 4 and not data.isdelirium then
							local params = ProjectileParams()
							params.BulletFlags = ProjectileFlags.ACCELERATE
							params.FallingAccelModifier = 0.05
							params.Acceleration = 0.96
							params.HeightModifier = -20
							params.Variant = 4
							for i=0, 315, 45 do
								isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i+angle):Resized(7), 0, params)
							end
						end
					end
				end
			end
			if spr:IsPlaying("4Appear") and spr:GetFrame() == 5 then
				isaac.EntityCollisionClass = 4
			end
		elseif isaac.State == 120 then
			if spr:IsPlaying("4Summon") and spr:GetFrame() == 24 then
				isaac:PlaySound(129, 1, 0, false, 1)
				isaac:PlaySound(265, 1, 0, false, 1)
				for i=0, 270, 90 do
					Isaac.Spawn(26, 3, 0, isaac.Position + Vector.FromAngle(i):Resized(40),
					Vector(0,0), isaac)
				end
			end
			if spr:IsFinished("4Summon") then
				spr:Play("4FBAttackStart", true)
				isaac.State = 157
			end
		elseif isaac.State == 99 then
			if spr:IsPlaying("4FBAttack3") then
				if spr:GetFrame() >= 32 and spr:GetFrame() <= 55 then
					if spr:GetFrame() == 32 then
						isaac:PlaySound(129, 1, 0, false, 1)
						if isaac.Position.X >= Room:GetCenterPos().X then
							isaac.FlipX = true
							isaac.Velocity = Vector(((Room:GetCenterPos().X*0.1)-isaac.Position.X)*0.1,0)
						else
							isaac.Velocity = Vector(57,0)
							isaac.Velocity = Vector(((Room:GetCenterPos().X*1.9)-isaac.Position.X)*0.1,0)
						end
					end
					if spr:GetFrame() % 4 == 1 then
						isaac:PlaySound(267, 0.65, 0, false, 1)
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.185
						params.BulletFlags = ProjectileFlags.ACCELERATE
						params.Acceleration = 1.07
						params.Variant = 4
						for i=45, 315, 90 do
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(i):Resized(0.1), 0, params)
						end
					end
				end
			end
			if spr:IsFinished("4FBAttack3") then
				spr:Play("4FBAttackStart", true)
				isaac.State = 157
				isaac.FlipX = false
			end
		elseif isaac.State == 88 then
			if spr:IsFinished("4FBAttack2Start") then
				spr:Play("4FBAttack2Loop", true)
				isaac:PlaySound(129, 1, 0, false, 1)
				isaac.ProjectileCooldown = 0
				if isaac.I1 == 4 and not data.isdelirium then
					isaac.StateFrame = 70
					for i=0, 315, 45 do
						local tlaser = EntityLaser.ShootAngle(3, isaac.Position, i+data.pangle, 55, Vector(0,-20), isaac)
						if isaac.Position.X < target.Position.X then
							tlaser:SetActiveRotation(15, -45, -0.5, false)
						else
							tlaser:SetActiveRotation(15, 45, 0.5, false)
						end
					end
				else
					isaac.StateFrame = math.random(20,50)
				end
			elseif spr:IsFinished("4FBAttack2End") then
				isaac.State = 33
			end
			if spr:IsPlaying("4FBAttack2Loop") and isaac.StateFrame <= 0 then
				spr:Play("4FBAttack2End", true)
			end
			if isaac.StateFrame > 0 then
				isaac.StateFrame = isaac.StateFrame - 1
				isaac.ProjectileCooldown = isaac.ProjectileCooldown - 1
				if isaac.ProjectileCooldown <= 0 then
					if isaac.ProjectileCooldown == 0 then
						isaac:PlaySound(267, 0.65, 0, false, 1)
					end
					if isaac.I1 == 1 then
						isaac.ProjectileCooldown = 4
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.185
						params.BulletFlags = ProjectileFlags.ACCELERATE | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
						| ProjectileFlags.CHANGE_VELOCITY_AFTER_TIMEOUT
						params.ChangeTimeout = 75
						params.ChangeFlags = 0
						params.ChangeVelocity = 7
						params.Acceleration = 0.9
						params.Variant = 4
						for i=0, 315, 45 do
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(i+(isaac.StateFrame*5)):Resized(10), 0, params)
						end
					elseif isaac.I1 == 2 then
						isaac.ProjectileCooldown = 5
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.175
						params.BulletFlags = ProjectileFlags.ACCELERATE | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
						| ProjectileFlags.NO_WALL_COLLIDE
						params.ChangeTimeout = 75
						params.ChangeFlags = 1 << 37 | ProjectileFlags.NO_WALL_COLLIDE
						params.Acceleration = 0.9
						params.Variant = 4
						params.HomingStrength = 0.6
						params.Color = Color(1,1,1,5,0,0,0)
						isaac:FireProjectiles(isaac.Position,
						Vector.FromAngle(isaac.StateFrame*10):Resized(10), 0, params)
					elseif isaac.I1 == 3 then
						isaac.ProjectileCooldown = 4
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.175
						params.BulletFlags = ProjectileFlags.ACCELERATE | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
						| ProjectileFlags.CURVE_LEFT | ProjectileFlags.CHANGE_VELOCITY_AFTER_TIMEOUT | ProjectileFlags.NO_WALL_COLLIDE
						params.ChangeTimeout = 75
						params.ChangeFlags = ProjectileFlags.CURVE_RIGHT | ProjectileFlags.NO_WALL_COLLIDE
						params.ChangeVelocity = 6
						params.Acceleration = 0.95
						params.Variant = 4
						params.CurvingStrength = 0.005
						for i=0, 270, 90 do
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(i+(isaac.StateFrame*13)):Resized(8), 0, params)
						end
					elseif isaac.I1 == 4 then
						if isaac.StateFrame > 10 then
							if not data.isdelirium then
								isaac.ProjectileCooldown = 13
							else
								isaac.ProjectileCooldown = 7
							end
							local params = ProjectileParams()
							params.FallingAccelModifier = -0.175
							params.Variant = 4
							for i=0, 315, 45 do
								isaac:FireProjectiles(isaac.Position,
								Vector.FromAngle(i+((isaac.StateFrame % 2)*22.5)):Resized(5), 0, params)
							end
						end
					end
				end
			end
		elseif isaac.State == 66 then
			if spr:IsPlaying("Jump") then
				if isaac.FrameCount % 2 == 0 then
					local creep = Isaac.Spawn(1000, 22, 0, isaac.Position, Vector(0,0), isaac)
					creep:SetColor(Color(1,1,1,1,19,208,255), 99999, 0, false, false)
					creep:ToEffect().Timeout = 70
				end
				isaac.Velocity = isaac.Velocity * 0.33
				if spr:GetFrame() == 16 then
					if target.Position:Distance(isaac.Position) < 240 then
						isaac.TargetPosition = target.Position
					else
						isaac.TargetPosition = isaac.Position
						+ Vector.FromAngle(angle):Resized(240)
					end
				elseif spr:GetFrame() == 30 then
					isaac:PlaySound(69, 1, 0, false, 1)
					isaac:PlaySound(153, 1.3, 0, false, 1)
					local creep = Isaac.Spawn(1000, 22, 0, isaac.Position, Vector(0,0), isaac)
					creep:SetColor(Color(1,1,1,1,19,208,255), 99999, 0, false, false)
					creep.SpriteScale = Vector(3,3)
					local params = ProjectileParams()
					params.Variant = 4
					params.FallingAccelModifier = 0.2
					for i=0, math.random(6,9) do
						params.Scale = math.random(5, 13) * 0.1
						params.FallingSpeedModifier = -math.random(30, 120) * 0.1
						isaac:FireProjectiles(isaac.Position,
						Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(40,85)*0.1), 0, params)
					end
				end
			end
			if spr:IsFinished("Jump") then
				isaac.State = 3
				isaac.Velocity = Vector(0,0)
			end
		elseif isaac.State == 33 then
			isaac.StateFrame = isaac.StateFrame - 1
			if not spr:IsPlaying("4Idle") then
				spr:Play("4Idle", true)
				if isaac.HitPoints/isaac.MaxHitPoints >= 0.19 then
					isaac.StateFrame = 80
				elseif isaac.HitPoints/isaac.MaxHitPoints >= 0.13 then
					isaac.StateFrame = 55
				else
					isaac.StateFrame = 35
				end
				if data.isdelirium then
					isaac.StateFrame = isaac.StateFrame * 2
				end
			end
			if isaac.StateFrame <= 0 and spr:IsPlaying("4Idle") then
				spr:Play("4FBAttackStart", true)
				isaac.State = 157
			end
		elseif isaac.State == 11 then
			isaac.StateFrame = isaac.StateFrame - 1
			isaac.ProjectileCooldown = isaac.ProjectileCooldown - 1
			if spr:IsFinished("3FBAttack4Start") then
				spr:Play("3FBAttack4Loop", true)
			elseif spr:IsFinished("3FBAttack4End") then
				spr:Play("Idle3", true)
				isaac.State = 8
			end
			if spr:IsPlaying("3FBAttack4Start") and spr:GetFrame() == 21 then
				isaac:PlaySound(129, 1, 0, false, 1)
				data.attacking = true
			elseif spr:IsPlaying("3FBAttack4Loop") and isaac.StateFrame <= 0 then
				spr:Play("3FBAttack4End", true)
				data.attacking = false
			end
			if data.attacking then
				if isaac.I1 == 1 then
					if isaac.ProjectileCooldown <= 0 then
						isaac.ProjectileCooldown = 8
					elseif isaac.ProjectileCooldown == 1 then
						local angle = rng:RandomInt(359)
						isaac:PlaySound(267, 0.65, 0, false, 1)
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.165
						params.Variant = 4
						for i=0, 25, 5 do
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(i+angle):Resized(5.75), 0, params)
							isaac:FireProjectiles(isaac.Position,
							Vector.FromAngle(i+angle):Resized(-5.75), 0, params)
						end
					end
				elseif isaac.I1 == 2 then
					if isaac.ProjectileCooldown <= 0 then
						isaac.ProjectileCooldown = 19
						isaac:PlaySound(267, 0.65, 0, false, 1)
						local params = ProjectileParams()
						params.BulletFlags = 1
						params.Scale = 1.5
						for i=0, 300, 60 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i+(isaac.FrameCount % 2)*45):Resized(9), 0, params)
						end
					end
				end
			end
		elseif isaac.State == 9 then
			if spr:IsPlaying("1Attack") then
				if data.i3 > 0 then
					if isaac.I1 == 1 then
						if (data.i3 < data.start and spr:GetFrame() == 3)
						or (data.i3 >= data.start and spr:GetFrame() == 6) then
							spr:Play("1Attack",true)
						end
					elseif isaac.I1 == 2 then
						if spr:GetFrame() == 8 then
							spr:Play("1Attack",true)
						end
					end
					if spr:GetFrame() == 1 then
						data.i3 = data.i3 - 1
					end
				end
				if data.i3 < data.start and spr:GetFrame() == 1 then
					isaac:PlaySound(267, 0.65, 0, false, 1)
					if isaac.I1 == 1 then
						local angle = (target.Position - isaac.Position):GetAngleDegrees()
						local params = ProjectileParams()
						params.Variant = 4
						params.GridCollision = false
						params.FallingSpeedModifier = -20
						params.FallingAccelModifier = 0.5
						params.Scale = 1.3
						params.BulletFlags = 1 << 32
						params.ChangeTimeout = 20
						params.ChangeFlags = 1 << 37
						params.HomingStrength = 1.2
						isaac:FireProjectiles(isaac.Position, Vector.FromAngle(angle+math.random(-20,20)):Resized(-5), 0, params)
					elseif isaac.I1 == 2 then
						local params = ProjectileParams()
						params.Variant = 4
						params.FallingAccelModifier = -0.165
						params.BulletFlags = 1 << 36
						for i=-1, 1, 2 do
							isaac:FireProjectiles(isaac.Position, Vector(3*i,math.random(-20,20)*0.1), 0, params)
						end
					end
				end
			end
			if spr:IsFinished("1Attack") then
				isaac.State = 8
			end
		elseif isaac.State == 8 then
			if spr:IsPlaying("3FBAttack4Start") and spr:GetFrame() == 1 then
				if math.random(1,4) == 1 then
					if Room:GetAliveEnemiesCount() <= 20
					and isaac.FrameCount % 150 <= 50 then
						spr:Play("3Summon",true)
						isaac.State = 12
					end
				elseif math.random(1,4) == 2 then
					isaac.I1 = math.random(2,4)
					spr:Play("3FBAttack5RS",true)
					if math.random(1,6) == 1 then
						spr:Play("3FBAttack5Up",true)
					elseif math.random(1,6) == 2 then
						spr:Play("3FBAttack5Down",true)
					elseif math.random(1,6) == 3 then
						spr:Play("3FBAttack5RS",true)
					elseif math.random(1,6) == 4 then
						spr:Play("3FBAttack5LS",true)
					elseif math.random(1,6) == 6 then
						spr:Play("3FBAttack5Left",true)
					else
						spr:Play("3FBAttack5Right",true)
					end
					isaac.State = 10
				elseif math.random(1,4) == 3 then
					isaac.State = 11
					isaac.StateFrame = math.random(50,100)
					isaac.I1 = math.random(1,2)
					isaac.ProjectileCooldown = 0
				end
			end
			if spr:IsPlaying("2Attack") then
				if spr:GetFrame() == 2 then
					if data.i3 == 1 then
						if isaac.I1 == 0 then
							isaac.I1 = 2
						elseif isaac.I1 == 1 then
							isaac.I1 = 3
							data.i3 = 0
						end
					else
						if isaac.I1 == 1 then
							data.i3 = 1
						end
					end
				elseif spr:GetFrame() == 8 then
					if isaac.I1 == 2 then
						local params = ProjectileParams()
						params.FallingSpeedModifier = 0
						params.FallingAccelModifier = -0.135
						params.BulletFlags = ProjectileFlags.ACCELERATE | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT | ProjectileFlags.NO_WALL_COLLIDE
						params.ChangeTimeout = 40
						params.ChangeFlags = 1 << 37 | ProjectileFlags.NO_WALL_COLLIDE
						params.Variant = 4
						params.Scale = 1.5
						params.Acceleration = 0.92
						params.Color = Color(1,1,1,5,0,0,0)
						params.HomingStrength = 1
						for i=0, 300, 60 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(10), 0, params)
						end
					elseif isaac.I1 == 3 then
						local params = ProjectileParams()
						params.Variant = 4
						params.BulletFlags = ProjectileFlags.BURST3
						params.FallingAccelModifier = -0.15
						params.Scale = 1.5
						for i=0, 270, 90 do
							isaac:FireProjectiles(isaac.Position, Vector.FromAngle(i):Resized(2), 0, params)
						end
					end
				end
			end
			if spr:IsFinished("2Attack") then
				if isaac.I1 == 3 then
					isaac.I1 = 1
				elseif isaac.I1 == 2 then
					isaac.I1 = 0
				end
			end
		elseif isaac.State == 3 then
			if spr:IsFinished("2Idle") then
				if isaac.FrameCount % 6 == 0 then
					local creep = Isaac.Spawn(1000, 22, 0, isaac.Position, Vector(0,0), isaac)
					creep:SetColor(Color(1,1,1,1,19,208,255), 99999, 0, false, false)
					creep:ToEffect().Timeout = 70
				end
				if isaac.FrameCount % 85 == 0 then
					spr:Play("Jump",true)
					isaac.State = 66
				end
			end
		end

		if isaac.State == 10 then
			if spr:GetFrame() == 1 then
				if spr:IsPlaying("3FBAttack5Up") then
					data.intervalX = 120
					data.lrtt = 270
					if Room:GetRoomShape() >= 6 then
						data.Xendpos = 1080
					else
						data.Xendpos = 480
					end
					if (Room:GetRoomShape() >= 4 and Room:GetRoomShape() <= 6)
					or Room:GetRoomShape() >= 8 then
						data.Xsttpos = Vector(120,720)
					else
						data.Xsttpos = Vector(120,440)
					end
				elseif spr:IsPlaying("3FBAttack5Down") then
					data.Xsttpos = Vector(80,120)
					data.intervalX = 120
					data.lrtt = 90
					if Room:GetRoomShape() >= 6 then
						data.Xendpos = 1120
					else
						data.Xendpos = 560
					end
				elseif spr:IsPlaying("3FBAttack5LS") then
					data.Xsttpos = Vector(200,120)
					data.intervalX = 200
					data.intervalY = 200
					data.lrtt = 135
					if Room:GetRoomShape() >= 6 then
						data.Xendpos = 1000
						data.Ysttpos = Vector(1120,0)
						if Room:GetRoomShape() >= 8 then
							data.Yendpos = 600
						else
							data.Yendpos = 400
						end
					else
						data.Xendpos = 600
						data.Ysttpos = Vector(600,-80)
						if Room:GetRoomShape() >= 4 then
							data.Yendpos = 520
						else
							data.Yendpos = 320
						end
					end
				elseif spr:IsPlaying("3FBAttack5RS") then
					data.Xsttpos = Vector(40,120)
					data.Ysttpos = Vector(40,240)
					data.intervalX = 200
					data.intervalY = 100
					data.lrtt = 45
					if Room:GetRoomShape() >= 6 then
						data.Xendpos = 1040
					else
						data.Xendpos = 440
					end
					if Room:GetRoomShape() == 4 or Room:GetRoomShape() == 5
					or Room:GetRoomShape() >= 8 then
						data.Yendpos = 540
					else
						data.Yendpos = 340
					end
				elseif spr:IsPlaying("3FBAttack5Right") then
					data.Ysttpos = Vector(40,40)
					data.intervalY = 120
					data.lrtt = 0
					if (Room:GetRoomShape() == 4 or Room:GetRoomShape() == 5)
					or Room:GetRoomShape() >= 8 then
						data.Yendpos = 760
					else
						data.Yendpos = 400
					end
				elseif spr:IsPlaying("3FBAttack5Left") then
					data.intervalY = 120
					data.lrtt = 180
					if Room:GetRoomShape() <= 5 then
						data.Ysttpos = Vector(600,100)
					else
						data.YsttposX = Vector(1120,100)
					end
					if (Room:GetRoomShape() >= 4 and Room:GetRoomShape() <= 6)
					or Room:GetRoomShape() >= 8 then
						data.Yendpos = 700
					else
						data.Yendpos = 340
					end
				end
				if not (spr:IsPlaying("3FBAttack5Right") or spr:IsPlaying("3FBAttack5Left")) then
					for i=data.Xsttpos.X, data.Xendpos, data.intervalX do
						local light = Isaac.Spawn(1000, 355, 0, Vector(i,data.Xsttpos.Y), Vector(0,0), isaac)
						light:ToEffect().Rotation = data.lrtt
					end
				end
				if not (spr:IsPlaying("3FBAttack5Up") or spr:IsPlaying("3FBAttack5Down")) then
					for i=data.Ysttpos.Y, data.Yendpos, data.intervalY do
						if i >= data.Ysttpos.Y + data.intervalY then
							local light = Isaac.Spawn(1000, 355, 0, Vector(data.Ysttpos.X,i), Vector(0,0), isaac)
							light:ToEffect().Rotation = data.lrtt
						end
					end
				end
			end

			if spr:IsFinished("3FBAttack5Up") or spr:IsFinished("3FBAttack5Down")
			or spr:IsFinished("3FBAttack5RS") or spr:IsFinished("3FBAttack5LS")
			or spr:IsFinished("3FBAttack5Left") or spr:IsFinished("3FBAttack5Right") then
				isaac.I1 = isaac.I1 - 1
				if spr:IsFinished("3FBAttack5Up") then
					if math.random(1,5) == 1 then
						spr:Play("3FBAttack5Down",true)
					elseif math.random(1,5) == 2 then
						spr:Play("3FBAttack5RS",true)
					elseif math.random(1,5) == 3 then
						spr:Play("3FBAttack5RS",true)
					elseif math.random(1,5) == 4 then
						spr:Play("3FBAttack5Left",true)
					else
						spr:Play("3FBAttack5Right",true)
					end
				elseif spr:IsFinished("3FBAttack5Down") then
					if math.random(1,5) == 1 then
						spr:Play("3FBAttack5Up",true)
					elseif math.random(1,5) == 2 then
						spr:Play("3FBAttack5RS",true)
					elseif math.random(1,5) == 3 then
						spr:Play("3FBAttack5LS",true)
					elseif math.random(1,5) == 4 then
						spr:Play("3FBAttack5Left",true)
					else
						spr:Play("3FBAttack5Right",true)
					end
				elseif spr:IsFinished("3FBAttack5RS") then
					if math.random(1,4) == 1 then
						spr:Play("3FBAttack5Up",true)
					elseif math.random(1,4) == 2 then
						spr:Play("3FBAttack5Down",true)
					elseif math.random(1,4) == 3 then
						spr:Play("3FBAttack5LS",true)
					else
						spr:Play("3FBAttack5Left",true)
					end
				elseif spr:IsFinished("3FBAttack5LS") then
					if math.random(1,4) == 1 then
						spr:Play("3FBAttack5Up",true)
					elseif math.random(1,4) == 2 then
						spr:Play("3FBAttack5Down",true)
					elseif math.random(1,4) == 3 then
						spr:Play("3FBAttack5RS",true)
					else
						spr:Play("3FBAttack5Right",true)
					end
				elseif spr:IsFinished("3FBAttack5Left") then
					if math.random(1,4) == 1 then
						spr:Play("3FBAttack5Up",true)
					elseif math.random(1,4) == 2 then
						spr:Play("3FBAttack5Down",true)
					elseif math.random(1,4) == 3 then
						spr:Play("3FBAttack5RS",true)
					else
						spr:Play("3FBAttack5Right",true)
					end
				elseif spr:IsFinished("3FBAttack5Right") then
					if math.random(1,4) == 1 then
						spr:Play("3FBAttack5Up",true)
					elseif math.random(1,4) == 2 then
						spr:Play("3FBAttack5Down",true)
					elseif math.random(1,4) == 3 then
						spr:Play("3FBAttack5LS",true)
					else
						spr:Play("3FBAttack5Left",true)
					end
				end
				if isaac.I1 <= 0 then
					isaac.State = 3
				end
			end
		end

		if spr:IsPlaying("3Summon") and spr:GetFrame() == 11 then
			isaac.I1 = 0
			isaac:PlaySound(129, 1, 0, false, 1)
			isaac:PlaySound(265, 1, 0, false, 1)
			for i=0, 90, 90 do
				Isaac.Spawn(26, 3, 0, isaac.Position+Vector.FromAngle(45+i):Resized(70), Vector(0,0), isaac)
			end
		end

		if spr:IsFinished("3Summon") then
			isaac.State = 3
		end

		for k, v in pairs(Entities) do
			if v.Type == 1000 and v.Variant == 355
			and v.SpawnerType == 102 and v.SpawnerVariant == 1 then
				v.SpawnerEntity = isaac
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.BBaby, 102)

----------------------------
--add Boss Pattern:??? (Alt)
----------------------------
function denpnapi:HsBaby(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("??? (Alt)")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprbb = boss:GetSprite()
		local data = boss:GetData()
		local target = boss:GetPlayerTarget()
		local angle = (target.Position - boss.Position):GetAngleDegrees()

		if sprbb:GetFrame() == 1 and sprbb:IsPlaying("3FBAttack4Start")
		and boss.State == 8 and math.random(1,3) == 1 then
			boss.State = 10
			sprbb:Play("3FBAttack4Start", true)
			boss.StateFrame = math.random(50,150)
			boss.I1 = math.random(1,2)
			boss.ProjectileCooldown = 0
		end

		if boss.State == 10 then
			boss.StateFrame = boss.StateFrame - 1
			boss.ProjectileCooldown = boss.ProjectileCooldown - 1
			if sprbb:IsFinished("3FBAttack4Start") then
				sprbb:Play("3FBAttack4Loop", true)
			elseif sprbb:IsFinished("3FBAttack4End") then
				boss.State = 8
			end
			if sprbb:IsPlaying("3FBAttack4Start") and sprbb:GetFrame() == 21 then
				boss:PlaySound(129, 1, 0, false, 1)
				data.attacking = true
			elseif sprbb:IsPlaying("3FBAttack4Loop") and boss.StateFrame <= 0 then
				sprbb:Play("3FBAttack4End", true)
				data.attacking = false
			end
			if data.attacking then
				if boss.I1 == 1 then
					if boss.ProjectileCooldown <= 0 then
						boss.ProjectileCooldown = 15
						if data.angle45 then
							data.angle45 = false
						else
							data.angle45 = true
						end
					elseif boss.ProjectileCooldown == 5 or boss.ProjectileCooldown == 8
					or boss.ProjectileCooldown == 11 or boss.ProjectileCooldown == 14 then
						boss:PlaySound(267, 0.65, 0, false, 1)
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.165
						params.Variant = 4
						if data.angle45 then
							for i=45, 315, 90 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+45-boss.ProjectileCooldown*2):Resized(6.5), 0, params)
							end
						else
							for i=0, 270, 90 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+boss.ProjectileCooldown*2):Resized(6.5), 0, params)
							end
						end
					end
				elseif boss.I1 == 2 then
					if boss.ProjectileCooldown <= 0 then
						boss.ProjectileCooldown = 13
						boss:PlaySound(267, 0.65, 0, false, 1)
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.1
						params.Variant = 4
						for i=-6, 12, 1.5 do
							boss:FireProjectiles(boss.Position, Vector.FromAngle(angle):Resized(i), 0, params)
						end
						for i=-6, 6, 1.5 do
							boss:FireProjectiles(boss.Position, Vector.FromAngle(angle+90):Resized(i), 0, params)
						end
					end
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.HsBaby, 102)

----------------------------
--New Enemy:Greed Fatty
----------------------------
function denpnapi:GreedFatty(enemy)
	if enemy.Variant == Isaac.GetEntityVariantByName("Greed Fatty") then

		local sprgf = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local angle = (target.Position - enemy.Position):GetAngleDegrees()
		enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		enemy.SplatColor = Color(0.7,0.7,0.7,1,0,0,0)

		if enemy.State == 4 then
			enemy.StateFrame = enemy.StateFrame + 1
		end

		if sprgf:IsEventTriggered("Spit") then
			enemy:PlaySound(319, 1, 0, false, 1)
			local params = ProjectileParams()
			params.HeightModifier = -5
			params.Variant = 7
			enemy:FireProjectiles(enemy.Position, Vector.FromAngle(angle):Resized(10), 0, params)
		end

		if enemy:IsDead() then
			if math.random(1,2) == 1 then
				Isaac.Spawn(5, 20, 1, enemy.Position, Vector(0,0), enemy)
			end
			for i=45, 315, 90 do
				local params = ProjectileParams()
				params.Variant = 7
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(i):Resized(7), 0, params)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.GreedFatty, 208)

----------------------------
--add Boss pattern:The Lamb
----------------------------
function denpnapi:Lamb(boss)
	if (Game().Difficulty == 1 or Game().Difficulty == 3)
	and boss.Variant == 10 and not boss:GetData().isdelirium then
		boss:Morph(400, 0, 0, -1)
		boss.SpriteOffset = Vector(0,0)
		boss.MaxHitPoints = math.max(550, 7.3*GetPlayerDps)
	end

	if boss.Variant == Isaac.GetEntityVariantByName("The Lamb")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprl = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		local Entities = Isaac:GetRoomEntities()
		local dist = target.Position:Distance(boss.Position)
		local rng = boss:GetDropRNG()
		targetangle = (target.Position - boss.Position):GetAngleDegrees()

		data.planc = false

		if boss.State ~= 4 then
			if sprl:GetFrame() == 1 then
				if sprl:IsPlaying("Charge") then
					if math.random(1,3) == 1 then
						if math.random(1,3) == 1 and boss.HitPoints / boss.MaxHitPoints <= 0.75 then
							sprl:Play("AttackReady", true)
							boss.State = 12
							boss.StateFrame = 138
						else
							sprl:Play("Charge3", true)
							boss.State = 11
						end
					end
				elseif sprl:IsPlaying("HeadCharge") then
					if math.random(1,3) == 1 then
						sprl:Play("HeadCharge2", true)
						boss.State = 11
						boss:PlaySound(312 , 1, 0, false, 1)
						if sound:IsPlaying(106) then
							sound:Stop(106)
						elseif sound:IsPlaying(108) then
							sound:Stop(108)
						end
					elseif math.random(1,3) == 2 then
						sprl:Play("HeadSummon", true)
						boss.State = 13
						if sound:IsPlaying(106) then
							sound:Stop(106)
						elseif sound:IsPlaying(108) then
							sound:Stop(108)
						end
					end
					if math.random(1,4) == 2 then
						sprl:Play("HeadAttackReady", true)
						boss.State = 12
						boss.StateFrame = 0
						boss.I2 = math.random(4,7)
						for k, v in pairs(Entities) do
							if v.Type == 400 and v.Variant == 0 then
								v:GetSprite():Play("StompReady", true)
							end
						end
					end
				end
			end

			if sprl:IsFinished("Charge2") then
				sprl:Play("Blast", true)
				boss.I2 = 0
				boss.StateFrame = math.random(80,120)
			elseif sprl:IsFinished("Charge3") then
				sprl:Play("Swarm3", true)
			elseif sprl:IsFinished("HeadShoot2Start") then
				sprl:Play("HeadShoot2Loop", true)
			elseif sprl:IsFinished("Swarm3") or sprl:IsFinished("Blast")
			or sprl:IsFinished("HeadShoot3") then
				if boss.I1 == 1 then
					sprl:Play("Idle", true)
				else
					sprl:Play("HeadIdle", true)
				end
				boss.State = 4
			elseif sprl:IsFinished("HeadCharge2") then
				sprl:Play("HeadShoot3", true)
			end
		end

		if boss.State == 12 then
			if boss.I1 ~= 1 then
				boss.PositionOffset = Vector(0,
				boss.PositionOffset.Y-((boss.PositionOffset.Y+40)*0.15))
				boss.EntityCollisionClass = 0
			end
			if sprl:IsPlaying("AttackReady") then
				boss.Velocity = Vector(0,0)
				if boss.I1 ~= 1 then
					sprl:Play("HeadAttackReadyLoop", true)
				end
			else
				if boss.I1 == 1 then
					boss.StateFrame = boss.StateFrame - 1
					if boss.StateFrame == 113 then
						sprl:Play("StompAttack", true)
					end
				else
					boss.StateFrame = boss.StateFrame + 1
					if boss.StateFrame == 43 then
						if math.random(1,3) == 1 then
							sprl:Play("HeadStompUp", true)
						elseif math.random(1,3) == 2 then
							sprl:Play("HeadStompDown", true)
						else
							sprl:Play("HeadStompHori", true)
							if math.random(0,1) == 1 then
								boss.FlipX = true
							else
								boss.FlipX = false
							end
						end
					end
				end
				if Room:GetRoomShape() >= 8 then
					boss.Velocity = Vector.FromAngle((Vector(560,440) - boss.Position):GetAngleDegrees())
					:Resized(Vector(560,440):Distance(boss.Position)*0.14)
				elseif Room:GetRoomShape() >= 6 then
					boss.Velocity = Vector.FromAngle((Vector(560,280) - boss.Position):GetAngleDegrees())
					:Resized(Vector(560,280):Distance(boss.Position)*0.14)
				elseif Room:GetRoomShape() >= 4 then
					boss.Velocity = Vector.FromAngle((Vector(320,440) - boss.Position):GetAngleDegrees())
					:Resized(Vector(320,440):Distance(boss.Position)*0.14)
				else
					boss.Velocity = Vector.FromAngle((Vector(320,280) - boss.Position):GetAngleDegrees())
					:Resized(Vector(320,280):Distance(boss.Position)*0.14)
				end
			end
		elseif boss.State == 13 then
			boss.Velocity = Vector(0,0)
			if sprl:IsPlaying("HeadSummon") then
				if sprl:GetFrame() == 15 then
					boss:PlaySound(122 , 1, 0, false, 1)
				elseif sprl:GetFrame() == 32 then
					boss:PlaySound(265 , 1, 0, false, 1)
					Isaac.Spawn(558, 0, 0, boss.Position+Vector(0,50), Vector(0,0), boss)
				end
			else
				sprl:Play("HeadIdle", true)
				boss.State = 4
				boss.StateFrame = math.random(90,140)
			end
		end

		if sprl:IsPlaying("HeadIdle") then
			boss.PositionOffset = Vector(0,
			boss.PositionOffset.Y-(boss.PositionOffset.Y*0.15))
		end

		if sprl:IsPlaying("StompAttack") then
			if sprl:GetFrame() == 1 then
				for i=-130, 130, 260 do
					Game():Spawn(507, 0, boss.Position+Vector(0,i), Vector(0,0), boss, 0, 0)
				end
			elseif sprl:GetFrame() == 60 then
				for i=-170, 170, 340 do
					Game():Spawn(507, 0, boss.Position+Vector(i,0), Vector(0,0), boss, 0, 0)
				end
			elseif sprl:GetFrame() == 22 or sprl:GetFrame() == 81 then
				boss:PlaySound(306 , 1.3, 0, false, 1)
			end
		elseif sprl:IsFinished("StompAttack") then
			sprl:Play("Idle", true)
			boss.State = 4
			boss.StateFrame = math.random(90,140)
		end

		if sprl:IsPlaying("HeadStompUp") or sprl:IsPlaying("HeadStompDown")
		or sprl:IsPlaying("HeadStompHori") then
			if sprl:GetFrame() == 1 then
				boss.I2 = boss.I2 - 1
				if sprl:IsPlaying("HeadStompDown") then
					Game():Spawn(507, 0, boss.Position+Vector.FromAngle(90):Resized(130), Vector(0,0), boss, 1, 0)
				elseif sprl:IsPlaying("HeadStompUp") then
					Game():Spawn(507, 0, boss.Position+Vector.FromAngle(270):Resized(130), Vector(0,0), boss, 1, 0)
				elseif sprl:IsPlaying("HeadStompHori") then
					if boss.FlipX then
						Game():Spawn(507, 0, boss.Position+Vector.FromAngle(180):Resized(170), Vector(0,0), boss, 1, 0)
					else
						Game():Spawn(507, 0, boss.Position+Vector.FromAngle(0):Resized(170), Vector(0,0), boss, 1, 0)
					end
				end
			end
			if sprl:GetFrame() == 36 then
				boss:PlaySound(306 , 1.3, 0, false, 1)
			end
			if boss.I2 > 0 and sprl:GetFrame() == 75 then
				if math.random(1,3) == 1 then
					sprl:Play("HeadStompUp", true)
				elseif math.random(1,3) == 2 then
					sprl:Play("HeadStompDown", true)
				else
					sprl:Play("HeadStompHori", true)
					if math.random(0,1) == 1 then
						boss.FlipX = true
					else
						boss.FlipX = false
					end
				end
			end
		end

		if sprl:IsFinished("HeadStompUp") or sprl:IsFinished("HeadStompDown")
		or sprl:IsFinished("HeadStompHori") then
			sprl:Play("HeadIdle", true)
			boss.State = 4
			boss.StateFrame = math.random(90,140)
			boss.EntityCollisionClass = 4
		end

		if (sprl:IsPlaying("Swarm3") or sprl:IsPlaying("HeadShoot3"))
		and sprl:IsEventTriggered("Shoot2") then
			boss:PlaySound(305 , 1, 0, false, 1)
		elseif (sprl:IsPlaying("Swarm3") or sprl:IsPlaying("HeadShoot3"))
		and sprl:GetFrame() == 35 then
			boss.StateFrame = math.random(80,120)
		end

		if (sprl:IsPlaying("Swarm2Start") or sprl:IsPlaying("HeadShoot2Start"))
		and sprl:GetFrame() == 2 and math.random(1,5) <= 2 and boss.I2 ~= 0 then
			boss.I2 = 10
		elseif (sprl:IsPlaying("Swarm2End") or sprl:IsPlaying("HeadShoot2End"))
		and sprl:GetFrame() == 10 then
			boss.I2 = 0
		end

		if boss.I2 == 10 then
			if boss.FrameCount % 40 == 0 then
				boss:PlaySound(116 , 1, 0, false, 1)
			end
			if sprl:IsPlaying("Swarm2Loop") or sprl:IsPlaying("Swarm2Start") then
				if boss.FrameCount % 5 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.165
					params.HeightModifier = -5
					params.Scale = 2
					params.Color = Color(0.11,1.5,2,1,0,0,0)
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(2,3)+0.3), 0, params)
				end
			elseif sprl:IsPlaying("HeadShoot2Start") or sprl:IsPlaying("HeadShoot2Loop") then
				if boss.FrameCount % 30 == 0 then
					local params = ProjectileParams()
					params.Scale = 2
					params.Color = Color(0.11,1.5,2,1,0,0,0)
					params.BulletFlags = 2
					boss:FireProjectiles(boss.Position, Vector.FromAngle(targetangle):Resized(10), 0, params)
				end
				if boss.FrameCount % 3 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.17
					params.Scale = 0.5
					params.Color = Color(0.11,1.5,2,1,0,0,0)
					for i=0, 270, 90 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(4), 0, params)
					end
				end
			end
		end

		if sprl:IsPlaying("Swarm2End") and sprl:GetFrame() == 4 and boss.I2 == 10 and boss.I1 == 1 then
			sprl:Play("Charge2", true)
			boss:PlaySound(112 , 1, 0, false, 1)
			boss.I2 = 0
		end

		if sprl:IsPlaying("Death") then
			boss.I2 = 0
			data.skill = false
			data.angle = 0
		end

		if sprl:IsPlaying("Swarm3") and boss.FrameCount % 3 == 0 then
			local params = ProjectileParams()
			params.FallingSpeedModifier = -50
			params.FallingAccelModifier = 2
			params.HeightModifier = -15
			params.Scale = math.random(10,20) * 0.1
			params.Color = Color(0.11,1.5,2,1,0,0,0)
			params.BulletFlags = 2
			if math.random(1,3) == 1 then
				boss:FireProjectiles(boss.Position, Vector.FromAngle(targetangle+math.random(-3,3))
				:Resized(dist*(math.random(20,30)*0.001)), 0, params)
			else
				boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(30,55)*0.1), 0, params)
			end
		elseif sprl:IsPlaying("HeadShoot3") and boss.FrameCount % 2 == 0 then
			local params = ProjectileParams()
			params.GridCollision = false
			params.FallingSpeedModifier = -math.random(3,7)
			params.FallingAccelModifier = -0.1
			params.HeightModifier = -24
			params.Scale = math.random(10,20) * 0.1
			params.Color = Color(0.11,1.5,2,1,0,0,0)
			params.BulletFlags = ProjectileFlags.CONTINUUM
			boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(4,8)), 0, params)
		end

		if sprl:IsPlaying("Blast") and sprl:IsEventTriggered("Shoot2") then
			boss:PlaySound(306 , 1.3, 0, false, 1)
		end

		for k, v in pairs(Entities) do
			if sprl:IsPlaying("Blast") and sprl:GetFrame() == 4 then
				if v.Type == 9 and v.SpawnerType == 273 and v.SpawnerVariant == 0 then
					v:ToProjectile().ProjectileFlags = ProjectileFlags.EXPLODE
					v:ToProjectile().FallingAccel = 10
					v.Velocity = Vector(0,0)
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Lamb, 273)

----------------------------
--change Boss AI:Mega Satan
----------------------------
function denpnapi:MSatan(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Mega Satan") then

		local sprms = boss:GetSprite()
		local target = Game():GetPlayer(1)
		local dist = target.Position:Distance(boss.Position)
		local data = boss:GetData()
		local angle = (target.Position - boss.Position):GetAngleDegrees()

		if boss.State == 13 and (data.isdelirium
		or (Game().Difficulty == 1 or Game().Difficulty == 3)) then
			if sprms:IsPlaying("Hide") then
				boss.I2 = 0
				boss.ProjectileCooldown = math.random(150,200)
			else
				if boss.I2 == 0 then
					boss.ProjectileCooldown = boss.ProjectileCooldown - 1
					if boss.ProjectileCooldown <= 0 then
						boss.StateFrame = 0
						if data.isdelirium then
							data.i3 = math.random(1,3)
							boss.I2 = math.random(1,2)
						else
							data.i3 = math.random(1,3)
							if #Isaac.FindByType(274, 1, -1, true, true) == 0
							and #Isaac.FindByType(274, 2, -1, true, true) == 0 then
								boss.I2 = 2
							else
								boss.I2 = math.random(2,3)
							end
						end
					end
				else
					boss.StateFrame = boss.StateFrame + 1
					if boss.I2 == 1 then
						if boss.StateFrame >= 94 then
							boss.I2 = 0
							boss.ProjectileCooldown = math.random(150,200)
						elseif boss.StateFrame >= 30 then
							boss:SetSpriteFrame("HidingShoot1", boss.StateFrame-29)
							if boss.StateFrame >= 35 and boss.StateFrame % 8 == 0 then
								local params = ProjectileParams()
								params.FallingAccelModifier = -0.165
								params.HeightModifier = -7
								for i=210, 330, 14 do
									boss:FireProjectiles(Vector(boss.Position.X,690),
									Vector.FromAngle(i+((boss.FrameCount % 2)*7)):Resized(5.5), 0, params)
								end
							end
						else
							boss:SetSpriteFrame("HidingCharging", boss.StateFrame+1)
						end
						if boss.StateFrame == 35 then
							local bldlaer = EntityLaser.ShootAngle(1, boss.Position + Vector(0,1), 90, 50, Vector(0,-20), boss)
							bldlaer.Size = 80
						elseif boss.StateFrame == 1 then
							boss:PlaySound(240, 1, 0, false, 1)
						end
					elseif boss.I2 == 2 then
						if boss.StateFrame >= 256 then
							boss.I2 = 0
							boss.ProjectileCooldown = math.random(150,200)
						elseif boss.StateFrame >= 250 then
							boss:SetSpriteFrame("HidingShoot2End", boss.StateFrame-249)
						elseif boss.StateFrame >= 35 then
							boss:SetSpriteFrame("HidingShoot2Loop", (boss.StateFrame % 9)+1)
							if boss.StateFrame % 40 == 0 then
								boss:PlaySound(245, 1, 0, false, 1)
								if data.i3 ~= 1 then
									data.angle = (target.Position - boss.Position):GetAngleDegrees()
								end
							end
							if data.i3 == 1 and boss.StateFrame % 41 == 0 then
								local params = ProjectileParams()
								params.FallingAccelModifier = -0.16
								params.BulletFlags = ProjectileFlags.HIT_ENEMIES
								params.Scale = 2
								params.HeightModifier = -7
								for i=30-(boss.StateFrame % 2)*15, 150+(boss.StateFrame % 2)*15, 30 do
									boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(5), 0, params)
								end
							elseif data.i3 == 2 and boss.StateFrame % 40 <= 10 and boss.StateFrame % 2 == 0 then
								local params = ProjectileParams()
								params.FallingAccelModifier = -0.065
								params.Scale = 2
								params.HeightModifier = -7
								boss:FireProjectiles(boss.Position, Vector.FromAngle(data.angle):Resized(11), 0, params)
							elseif data.i3 == 3 and boss.StateFrame % 30 == 0 then
								local params = ProjectileParams()
								params.FallingAccelModifier = -0.15
								params.Scale = 2
								params.HeightModifier = -7
								for i=0, 340, 20 do
									boss:FireProjectiles(boss.Position, Vector.FromAngle(data.angle):Resized(5) + Vector.FromAngle(i):Resized(1), 0, params)
								end
							end
						elseif boss.StateFrame >= 30 then
							boss:SetSpriteFrame("HidingShoot2Start", boss.StateFrame-29)
						else
							boss:SetSpriteFrame("HidingCharging", boss.StateFrame+1)
						end
						if boss.StateFrame == 1 then
							boss:PlaySound(240, 1, 0, false, 1)
						end
					elseif boss.I2 == 3 then
						if boss.StateFrame <= 58 then
							boss:SetSpriteFrame("HidingSmash", boss.StateFrame)
						else
							boss.I2 = 0
							boss.ProjectileCooldown = math.random(150,200)
						end
						if boss.StateFrame == 1 then
							boss:PlaySound(239, 1, 0, false, 1)
						end
					end
				end
				if boss.I2 > 3 then
					boss.I2 = 0
					if data.isdelirium then
						boss.ProjectileCooldown = math.random(110,160)
					else
						boss.ProjectileCooldown = math.random(150,200)
					end
				end
			end
		end

		if Game().Difficulty == 1 or Game().Difficulty == 3 then

			if sprms:IsEventTriggered("ShootStart") and math.random(1,5) <= 2 then
				boss.State = 10
				boss.I2 = math.random(1,3)
				boss.ProjectileCooldown = 0
			end

			if boss.State == 10 then
				boss.StateFrame = boss.StateFrame - 1
				if boss.I2 == 1 then
					boss.ProjectileCooldown = boss.ProjectileCooldown + 1
					if boss.ProjectileCooldown >= 20 then
						boss.ProjectileCooldown = 0
					end
					if sprms:IsFinished("Shoot2Start") then
						sprms:Play("Shoot2Loop", true)
						boss.StateFrame = 205
					end
					if boss.ProjectileCooldown == 1 then
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.1
						params.Scale = 2
						params.HeightModifier = -7
						for i=15, 1, -1 do
							boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
							Vector.FromAngle(angle):Resized(i), 0, params)
						end
					end
				elseif boss.I2 == 2 then
					if sprms:IsFinished("Shoot2Start") then
						sprms:Play("Shoot2Loop", true)
						boss.StateFrame = 240
					end
					if boss.StateFrame % 30 == 0 then
						data.random = math.random(4,14) * 10
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.155
						params.Scale = 1.8
						params.BulletFlags = ProjectileFlags.HIT_ENEMIES
						params.HeightModifier = -7
						for i=0, data.random-20, 5 do
							boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
							Vector.FromAngle(i):Resized(4), 0, params)
						end
						for i=180, data.random+20, -5 do
							boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
							Vector.FromAngle(i):Resized(4), 0, params)
						end
					end
				elseif boss.I2 == 3 then
					if sprms:IsFinished("Shoot2Start") then
						sprms:Play("Shoot2Loop", true)
						boss.StateFrame = 320
					end
					if boss.StateFrame % 2 == 0 then
						local params = ProjectileParams()
						params.Scale = 2
						params.FallingAccelModifier = -0.03
						params.HeightModifier = -7
						params.BulletFlags = ProjectileFlags.HIT_ENEMIES
						boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
						Vector.FromAngle(angle):Resized(dist*0.03), 0, params)
						if boss.StateFrame % 40 == 0 then
							boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
							Vector.FromAngle(angle+20):Resized(dist*0.03), 0, params)
							boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
							Vector.FromAngle(angle-20):Resized(dist*0.03), 0, params)
						end
					end
				end
				if sprms:IsPlaying("Shoot2Loop") then
					if boss.StateFrame % 40 == 0 then
						boss:PlaySound(245, 1, 0, false, 1)
					end
					if boss.StateFrame <= 0 then
						sprms:Play("Shoot2End", true)
					end
				end
				if sprms:IsFinished("Shoot2End") then
					sprms:Play("Idle", true)
					boss.State = 3
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MSatan, 274)

function denpnapi:MSHand(boss)

	if boss.Variant ~= 0 and (Game().Difficulty == 1 or Game().Difficulty == 3)
	and not boss:GetData().isdelirium then

		local sprshnd = boss:GetSprite()
		local target = Game():GetPlayer(1)
		local dist = target.Position:Distance(boss.Position)
		local data = boss:GetData()
		local Entities = Isaac:GetRoomEntities()

		if boss.State == 13 then
			if boss.Variant == 1 then
				data.tpos = Vector(203,370)
			else
				data.tpos = Vector(473,370)
			end
			if boss.I2 == 1 then
				boss.Velocity = Vector.FromAngle((data.tpos - boss.Position):GetAngleDegrees()):
				Resized(data.tpos:Distance(boss.Position)*0.1)
				boss.ProjectileCooldown = boss.ProjectileCooldown + 1
				boss:SetSpriteFrame("HidingSmash", boss.ProjectileCooldown + 1)
				if boss.ProjectileCooldown == 31 then
					boss:PlaySound(52, 1, 0, false, 1)
					Game():ShakeScreen(20)
					if #Isaac.FindByType(271, -1, -1, true, true) > 0
					or #Isaac.FindByType(272, -1, -1, true, true) > 0 then
						for i=45, 135, 90 do
							local shockwave = Isaac.Spawn(1000, 72, 0, boss.Position, Vector(0,0), boss):ToEffect()
							shockwave.Parent = boss
							shockwave.Rotation = i
						end
					else
						local shockwave = Isaac.Spawn(1000, 67, 0, boss.Position, Vector(0,0), boss)
						shockwave.Parent = boss
					end
				end
				if boss.ProjectileCooldown >= 31 and boss.ProjectileCooldown <= 54 then
					boss.EntityCollisionClass = 4
				end
			end
		elseif boss.State == 10 then
			boss.GridCollisionClass = 0
			if sprshnd:IsFinished("Charging2") then
				sprshnd:Play("Blast", true)
			end
			if sprshnd:IsPlaying("Blast") and sprshnd:GetFrame() == 6 then
				EntityLaser.ShootAngle(6, boss.Position, 90, 40, Vector(0,-40), boss)
			end
			if sprshnd:IsFinished("Blast") then
				boss.State = 3
			end
		end

		for k, v in pairs(Entities) do
			if v.Type == 274 then
				if v.Variant == 0 then
					if boss.State == 11 then
						if sprshnd:IsPlaying("Punch") then
							if sprshnd:GetFrame() == 1 then
								if boss.Variant == 1 then
									boss.TargetPosition = v.Position + Vector(-120,-20)
								else
									boss.TargetPosition = v.Position + Vector(120,-20)
								end
							elseif sprshnd:GetFrame() == 25 then
								if boss.Variant == 1 then
									boss.Velocity = Vector(-2.4,-3)
								else
									boss.Velocity = Vector(2.4,-3)
								end
							elseif sprshnd:GetFrame() == 54 then
								if boss.Variant == 1 then
									boss.TargetPosition = v.Position + Vector(-30,20)
								else
									boss.TargetPosition = v.Position + Vector(30,20)
								end
							end
							if sprshnd:GetFrame() >= 28 and sprshnd:GetFrame() <= 35 then
								if sprshnd:GetFrame() == 28 then
									boss:PlaySound(182, 1, 0, false, 1)
								end
								boss.TargetPosition = v.Position + Vector(0,300)
								if boss.Variant == 1 then
									boss.Velocity = Vector(17,45)
								else
									boss.Velocity = Vector(-17,45)
								end
							end
						else
							boss.State = 3
						end
					elseif boss.State == 10 then
						if boss.Variant == 1 then
							boss.TargetPosition = v.Position + Vector(-215,80)
						else
							boss.TargetPosition = v.Position + Vector(215,80)
						end
					end
					if v:ToNPC().State == 13 and v:ToNPC().I2 == 3 and boss.State == 13 then
						boss.I2 = 1
					else
						boss.I2 = 0
						boss.ProjectileCooldown = 0
					end
					if boss.I2 == 0 and boss.State == 13 and
					(v:GetSprite():IsPlaying("Hiding") or v:ToNPC().I2 > 0)
					and not sprshnd:IsPlaying("Hide") then
						sprshnd:Play("Hiding", true)
					end
					if v:ToNPC().State == 8 and v:GetSprite():IsPlaying("Charging")
					and boss.State == 3 then
						sprshnd:Play("Charging2", true)
						boss.State = 10
					end
					if v:ToNPC().State == 3 and boss.State == 3
					and boss.FrameCount % 130 == 0 and data.canattack then
						if boss.Variant == 1 or
						(boss.Variant == 2 and #Isaac.FindByType(274, 1, -1, true, true) == 0) then
							boss.State = 11
							sprshnd:Play("Punch", true)
						end
					end
				elseif v.Variant == 1 then
					if v:ToNPC().State == 8 then
						if boss.Variant == 2 then
							data.canattack = false
							if boss.State == 11 then
								v:ToNPC().State = 3
							end
						end
					elseif boss.Variant == 2 then
						data.canattack = true
					end
				elseif v.Variant == 2 then
					if v:ToNPC().State == 8 then
						if boss.Variant == 1 then
							data.canattack = false
							if boss.State == 11 then
								v:ToNPC().State = 3
							end
						end
					elseif boss.Variant == 1 then
						data.canattack = true
					end
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MSHand, 274)

----------------------------
--change Boss AI:Mega Satan 2
----------------------------
function denpnapi:MSatanS(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Mega Satan 2")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprss = boss:GetSprite()
		local data = boss:GetData()
		local Entities = Isaac:GetRoomEntities()
		boss.GridCollisionClass = 0

		if not data.ChangedHPMS then
			boss.MaxHitPoints = math.max(boss.MaxHitPoints, (boss.MaxHitPoints/110)*GetPlayerDps)
			if boss.HitPoints < boss.MaxHitPoints then
				boss.HitPoints = boss.MaxHitPoints
			end
			data.ChangedHPMS = true
		end

		if sprss:IsPlaying("Appear") and sprss:GetFrame() == 0 then
			data.rhandcooldown = 0
			data.lhandcooldown = 0
			local rhand = Isaac.Spawn(399, 1, 0, boss.Position + Vector(-300,-5), Vector(0,0), boss)
			rhand.SpawnerEntity = boss
			local lhand = Isaac.Spawn(399, 2, 0, boss.Position + Vector(300,-5), Vector(0,0), boss)
			lhand.SpawnerEntity = boss
			data.handattacking = false
		end

		if boss.HitPoints / boss.MaxHitPoints <= 0.66
		and boss.HitPoints / boss.MaxHitPoints > 0.325 then
			data.i3 = 2
		elseif boss.HitPoints / boss.MaxHitPoints <= 0.325 then
			data.i3 = 3
		else
			data.i3 = 1
		end

		if boss.State == 3 then
			if #Isaac.FindByType(399, 1, -1, true, true) == 0 then
				data.rhandcooldown = boss.FrameCount
				if boss.FrameCount >= data.rhandcooldown + 100 then
					local rhand = Isaac.Spawn(399, 1, 1, boss.Position + Vector(-150,115), Vector(0,0), boss)
					rhand.SpawnerEntity = boss
				end
			elseif #Isaac.FindByType(399, 2, -1, true, true) == 0 then
				data.lhandcooldown = boss.FrameCount
				if boss.FrameCount >= data.lhandcooldown + 100 then
					local lhand = Isaac.Spawn(399, 2, 1, boss.Position + Vector(150,115), Vector(0,0), boss)
					lhand.SpawnerEntity = boss
				end
			end
		end

		if boss.HitPoints / boss.MaxHitPoints <= 0.5 and not data.summonpattern then
			boss.I2 = 0
			if boss.State == 3 then
				if sprss:GetFrame() >= 15 then
					boss.State = 12
					boss.I1 = 4
					data.summonpattern = true
					boss.StateFrame = 0
					boss:PlaySound(241, 1, 0, false, 1)
					sprss:Play("Up"..data.i3, true)
				end
			else
				boss:PlaySound(242, 1, 0, false, 1)
				boss.ProjectileCooldown = 0
				boss.State = 3
			end
		end

		if sprss:IsEventTriggered("ShootStart") and math.random(1,5) <= 2 then
			boss.State = 10
			boss.I1 = math.random(1,3)
		end

		if boss.State == 10 then
			if sprss:IsFinished("Shoot"..data.i3.."Start") then
				sprss:Play("Shoot"..data.i3.."Loop", true)
				if boss.I1 == 1 then
					boss.StateFrame = 245
				else
					boss.StateFrame = 325
				end
			end

			boss.StateFrame = boss.StateFrame - 1
			if boss.I1 == 1 then
				if boss.StateFrame % 10 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.14
					params.BulletFlags = ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
					params.ChangeFlags = ProjectileFlags.CURVE_LEFT
					params.Variant = 2
					params.ChangeTimeout = ((boss.FrameCount % 7)+1) * 10
					params.CurvingStrength = 0.007
					params.Color = Color(2,0.2,0.2,1,0,0,0)
					boss:FireProjectiles(Vector(boss.Position.X+5,boss.Position.Y+30),
					Vector.FromAngle(90):Resized(6), 0, params)
					boss:FireProjectiles(Vector(boss.Position.X+5,boss.Position.Y+30),
					Vector.FromAngle(60):Resized(4.6), 0, params)
					local params2 = ProjectileParams()
					params2.FallingAccelModifier = -0.165
					params2.BulletFlags = ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
					params2.ChangeFlags = ProjectileFlags.CURVE_RIGHT
					params2.Variant = 2
					params2.ChangeTimeout = ((boss.FrameCount % 7)+1) * 10
					params2.CurvingStrength = 0.007
					params2.Color = Color(2,0.2,0.2,1,0,0,0)
					boss:FireProjectiles(Vector(boss.Position.X-5,boss.Position.Y+30),
					Vector.FromAngle(90):Resized(6), 0, params2)
					boss:FireProjectiles(Vector(boss.Position.X-5,boss.Position.Y+30),
					Vector.FromAngle(120):Resized(4.6), 0, params2)
				end
			elseif boss.I1 == 2 then
				if boss.StateFrame % 56 <= 8 and boss.StateFrame % 4 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.175
					params.BulletFlags = 1<<43
					params.Scale = 1.7
					params.Variant = 2
					params.Color = Color(0.3,0.3,1,1,0,0,0)
					for i=5+((boss.StateFrame % 56)*2.5), 155+((boss.StateFrame % 56)*2.5), 30 do
						boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+30),
						Vector.FromAngle(i):Resized(7), 0, params)
					end
				end
			elseif boss.I1 == 3 then
				if boss.StateFrame % 39 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.155
					params.BulletFlags = ProjectileFlags.CONTINUUM
					params.Scale = 2
					params.Color = Color(2,1,5,1,0,0,0)
					params.Variant = 4
					if boss.StateFrame % 2 == 0 then
						dirc = 1
					else
						dirc = -1
					end
					for i=0, 34, 3.4 do
						boss:FireProjectiles(Vector(boss.Position.X,boss.Position.Y+10),
						Vector(-17+i,4), 0, params)
					end
				end
			end
			if sprss:IsPlaying("Shoot"..data.i3.."Loop") then
				if boss.StateFrame % 40 == 0 then
					boss:PlaySound(245, 1, 0, false, 1)
				end
				if boss.StateFrame <= 0 then
					sprss:Play("Shoot"..data.i3.."End", true)
				end
			end
			if sprss:IsFinished("Shoot"..data.i3.."End") then
				sprss:Play("Idle"..data.i3, true)
				boss.State = 3
			end
		end

		if boss.State == 12 then
			boss.EntityCollisionClass = 0
			boss.StateFrame = boss.StateFrame + 1
			if boss.StateFrame >= 38 and Isaac.CountBosses() <= 1 then
				if boss.I1 > 0 then
					boss.I1 = boss.I1 - 1
					if boss.I1 == 3 then
						Isaac.Spawn(404, 0, 0, Vector(280,440), Vector(0,0), boss)
						Isaac.Spawn(411, 0, 0, Vector(360,440), Vector(0,0), boss)
					elseif boss.I1 == 2 then
						Isaac.Spawn(69, 0, 0, Vector(280,440), Vector(0,0), boss)
						Isaac.Spawn(267, 0, 0, Vector(360,440), Vector(0,0), boss)
					elseif boss.I1 == 1 then
						Isaac.Spawn(69, 1, 0, Vector(280,440), Vector(0,0), boss)
						Isaac.Spawn(268, 0, 0, Vector(360,440), Vector(0,0), boss)
					else
						local ultipride = Isaac.Spawn(46, 2, 0, Vector(280,440), Vector(0,0), boss)
						ultipride.MaxHitPoints = ultipride.MaxHitPoints * 0.8
						local baby = Isaac.Spawn(38, 2, 0, Vector(320,480), Vector(0,0), boss)
						baby.MaxHitPoints = 133
						baby.HitPoints = 133
						Isaac.Spawn(81, 0, 0, Vector(360,440), Vector(0,0), boss)
					end
				else
					if not data.handattacking and boss.I2 == 0 then
						sprss:Play("Down"..data.i3, true)
						boss.State = 15
						boss.StateFrame = 0
					end
				end
			end
			if boss.I2 >= 1 then
				boss.ProjectileCooldown = boss.ProjectileCooldown - 1
				if #Isaac.FindByType(1000, 363, -1, true, true) == 0
				and boss.ProjectileCooldown >= 250 then
					if boss.I2 % 2 == 1 then
						local efthead = Isaac.Spawn(1000, 363, 0, Vector(0,400), Vector(0,0), boss):ToEffect()
						efthead.Timeout = boss.ProjectileCooldown - 24
						efthead.LifeSpan = data.i3
					else
						local efthead = Isaac.Spawn(1000, 363, 1, Vector(600,700), Vector(0,0), boss):ToEffect()
						efthead.Timeout = boss.ProjectileCooldown - 24
						efthead.LifeSpan = data.i3
					end
				end
				if boss.ProjectileCooldown <= 0 then
					boss.I2 = 0
					data.handattacking = false
				end
			end
		elseif boss.State == 15 then
			boss.StateFrame = boss.StateFrame + 1
			if boss.StateFrame >= 38 then
				boss.State = 3
			end
		else
			boss.EntityCollisionClass = 4
		end

		for k, v in pairs(Entities) do
			if v.Type == 9 and v.Variant == 4
			and v.SpawnerType == 275 and v.SpawnerVariant == 0 then
				if v.FrameCount == 20 then
					v.Velocity = Vector(5.5*dirc,4)
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MSatanS, 275)

----------------------------
--Ultra Greed Door
----------------------------
function denpnapi:UtGreedDoor(door)

	if door.Type == 294 then

		local sprgdr = door:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		local data = door:GetData()
		for k, v in pairs(Entities) do
			if v.Type == 406 and v.Variant == 1 then
				local greeddist = v.Position:Distance(door.Position)
				if v:GetSprite():IsEventTriggered("Call") then
					data.greedieropen = true
				end
				if door.State == 3 and data.greedieropen then
					door.State = 12
					door.StateFrame = 180
					for i=-15, 15, 30 do
						local bling = Isaac.Spawn(1000, 103, 0, door.Position + Vector.FromAngle(sprgdr.Rotation+90):Resized(1), Vector(0,0), door)
						bling.PositionOffset = Vector.FromAngle(sprgdr.Rotation-90+i):Resized(32)
						bling:SetColor(Color(2,0.5,0.5,1,0,0,0), 99999, 0, false, false)
						bling:GetSprite():Play("Bling3", true)
					end
				end
				if door.State == 12 then
					if door.StateFrame > 0 then
						door.StateFrame = door.StateFrame - 1
					end
					if sprgdr:IsPlaying("Closed") and door.StateFrame <= 150 then
						sprgdr:Play("Open", true)
					end
					if sprgdr:IsFinished("Open") then
						sprgdr:Play("Opened", true)
						door.State = 14
					end
					if sprgdr:GetFrame() == 5 then
						door:PlaySound(36, 1, 0, false, 1)
					end
				elseif door.State == 14 then
					if door.StateFrame > 0 then
						door.StateFrame = door.StateFrame - 1
					else
						data.greedieropen = false
					end
					if sprgdr:IsPlaying("Opened") then
						if not data.greedieropen then
							sprgdr:Play("Close", true)
						end
					end
				end
			end
		end

		if door.State == 14 then
			if sprgdr:IsPlaying("Opened") then
				if door.FrameCount % 55 == 0 then
					if math.random(1,6) ~= 1 then
						Isaac.Spawn(553, 15, 0, door.Position, Vector(0,0), door)
					else
						Isaac.Spawn(554, 15, 0, door.Position, Vector(0,0), door)
					end
				end
			else
				door.State = 3
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.UtGreedDoor, 294)

function denpnapi:Bboil(enemy)
	if enemy.FrameCount == 1 and math.random(0,2) == 1 then
		if Game().Difficulty == 1 or Game().Difficulty == 3 then
			enemy:Morph(547, 0, 0, -1)
			enemy.HitPoints = enemy.MaxHitPoints
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Bboil, 298)

function denpnapi:GrdGaper(enemy)
	if Game().Difficulty == 3 then
		if math.random(0,7) == 1 and enemy.FrameCount == 0 then
			enemy:Morph(208, 10, 0, -1)
			enemy.HitPoints = enemy.MaxHitPoints
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.GrdGaper, 299)

function denpnapi:Mushroom(enemy)
	if enemy.Variant == Isaac.GetEntityVariantByName("Mushroom")
	and enemy:GetSprite():GetFilename() == "gfx/mushroomman_dlrform.anm2" then
		local sprmsr = enemy:GetSprite()
		enemy.SplatColor = Color(1,1,1,1,255,255,255)
		if (sprmsr:IsPlaying("Reveal") or sprmsr:IsPlaying("Hide"))
		and sprmsr:GetFrame() == 4 then
			Game():SpawnParticles(enemy.Position+Vector(0,1), 111, 8, 5, Color(1,1,1,1,255,255,255), -23)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Mushroom, 300)

----------------------------
--Mom (Hard)
----------------------------
function denpnapi:HardMom(mom)

	if mom.Variant == 0 then

		local sprm = mom:GetSprite()
		local target = mom:GetPlayerTarget()
		local player = Isaac.GetPlayer(0)
		local Entities = Isaac:GetRoomEntities()
		local data = mom:GetData()
		mom:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		mom:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		mom.DepthOffset = -30

		mom.Velocity = Vector.FromAngle((mom.TargetPosition-mom.Position):GetAngleDegrees())
		:Resized(mom.TargetPosition:Distance(mom.Position)*0.1)

		if not data.eyeHp then
			data.eyeHp = math.max(15, 1.5*GetPlayerDps)
			data.hurt = false
			if mom.SubType == 33 then
				data.numspider = 2
			else
				data.numspider = 1
			end
			data.doorbroken = false
			data.handpos = Vector(0,0)
			data.spawnpos = mom.Position+Vector.FromAngle(sprm.Rotation+90):Resized(60)
			mom.I1 = 0
		end

		if mom.SubType == 33 then
			for i=0, 3 do
				sprm:ReplaceSpritesheet(i, "gfx/bosses/classic/boss_mom_eternal.png")
			end
			sprm:LoadGraphics()
		end

		if data.hurt then
			data.hurt = false
			if not sound:IsPlaying(97) then
				mom:PlaySound(97, 1, 0, false, 1)
			end
		end

		if data.isdelirium then
			mom:Morph(412, 0, 0, -1)
		end

		if mom.StateFrame > 0 and mom.State ~= 10 then
			mom.StateFrame = mom.StateFrame - 1
		end

		if mom.FrameCount >= 100 then
		if target:ToPlayer() and mom.StateFrame <= 40 then
			if mom.State == 3 then
				if math.abs(mom.Position.X-target.Position.X) <= 10 and math.abs(mom.Position.Y-target.Position.Y) <= 35
				and data.doorbroken and target:ToPlayer():GetDamageCooldown() <= 0 then
					data.cplayer = target:ToPlayer()
					mom.I2 = 0
					sprm:SetFrame("Damaging", 50)
					data.cplayer.Velocity = Vector(0,0)
					if data.cplayer.Variant == 0 then
						if sprm.Rotation == -90 then
							data.cplayer:GetData().playmodanim = 2
						elseif sprm.Rotation == 90 then
							data.cplayer:GetData().playmodanim = 3
						end
					else
						Isaac.Spawn(1000, 15, 0, data.cplayer.Position, Vector(0,0), data.cplayer)
						data.cplayer.Visible = false
					end
					data.cplayer.ControlsEnabled = true
					mom.StateFrame = 50
					mom.State = 32
					data.cplayer.EntityCollisionClass = 0
					MomHand = MomHand + 1
				end

				if math.abs(mom.Position.X-target.Position.X) <= 140 and math.abs(mom.Position.Y-target.Position.Y) <= 35
				and math.random(1,50) == 1 and data.doorbroken then
					sprm:Play("Grab", true)
					MomHand = MomHand + 1
					mom.State = 29
					mom:SetSize(35,Vector(1,1),0)
				end

				if math.random(1,75) == 1 and data.doorbroken
				and target.Position:Distance(mom.Position) <= 35 + target.Size and  MomHand < 2 then
					mom.State = 11
					sprm:Play("ArmOpen", true)
					MomHand = MomHand + 1
				end
			end
		end

		if (mom.SubType ~= 2 and ((not data.doorbroken and math.random(1,120) == 1) or
		(data.doorbroken and Room:GetFrameCount() % 160 == 0)))
		and mom.State ~= 15 and mom.State ~= 25 then
			if mom.State <= 10 and mom.State ~= 9 and not sprm:IsPlaying("EyeHurt")
			and math.random(1,2) == 1 and mom.SubType ~= 2 and mom:GetAliveEnemyCount() <= 7
			and mom.I1 ~= 1 then
				if mom.State == 8 then
					eye = eye - 1
				elseif mom.State == 10 then
					Wig = false
				end
				mom.State = 9
				sprm:Play("Fat0"..math.random(1,2), true)
			end
			if mom.State == 3 then
				if mom.StateFrame <= 0 then
					if math.random(1,3) == 1 then
						if mom.SubType ~= 2 and eye < 2 then
							mom.State = 8
							if mom.SubType == 33 then
								sprm:Play("EyeAttackEternal", true)
							else
								sprm:Play("EyeAttack", true)
							end
							eye = eye + 1
						end
					elseif math.random(1,3) == 2 then
						if mom.SubType ~= 2 and not Wig then
							Wig = true
							mom.State = 10
							sprm:Play("Wig", true)
						end
					else
						if data.doorbroken and MomHand < 1 then
							sprm:Play("KnifeThrow", true)
							MomHand = MomHand + 1
							mom.State = 30
						end
					end
				end
			end
		end
		end

		if mom.I1 == 2 and not data.doorbroken and (sprm.Rotation == 90 or sprm.Rotation == -90) then
			MomHand = MomHand + 1
			data.doorbroken = true
			sprm:Load("gfx/Mom_hardmode_doorbroken.anm2", true)
			if mom.SubType == 33 then
				for i=0, 1 do
					sprm:ReplaceSpritesheet(i, "gfx/bosses/classic/boss_mom_eternal.png")
				end
				sprm:LoadGraphics()
			end
			sprm:Play("DoorBreak", true)
			mom.State = 25
			mom.EntityCollisionClass = 0
			data.numspider = data.numspider + 1
			mom.CollisionDamage = 2
		end

		for k, v in pairs(Entities) do
			if v.Type == 9 then
				if v.Variant == 12 and data.doorbroken and v.Position:Distance(mom.Position) <= 100
				and math.abs((sprm.Rotation-90)-v.SpriteRotation) <= 45 and mom.State == 10 then
					v:Remove()
					mom:PlaySound(77, 1, 0, false, 1)
					if sprm.Rotation == 90 then
						sprm:Play("WigStuckKnifeRight", true)
					else
						sprm:Play("WigStuckKnifeLeft", true)
					end
					for i=0, data.numspider do
						if i > 0 then
							EntityNPC.ThrowSpider(mom.Position, mom, mom.Position + Vector.FromAngle(sprm.Rotation+90+math.random(-80,80)):Resized(math.random(50,150)), false, -15)
						end
					end
				end
			elseif v.Type == 396 then
				if v:GetData().doorbroken and v:ToNPC().State >= 8
				and v:ToNPC().State <= 9 and mom.State == 30 then
					mom.State = 9
					sprm:Play("Fat0"..math.random(1,2), true)
					MomHand = MomHand - 1
				end
				if v.Variant == 10 and mom.FrameCount >= 1 then
					if mom.SubType == 2 and math.random(1,70) == 1
					and mom.State == 3 and (v:GetSprite():IsFinished("Stomp")
					or v:GetSprite():IsFinished("Stomp2")) then
						if math.random(1,3) == 1 and eye < 1 then
							eye = eye + 1
							mom.State = 8
							sprm:Play("EyeAttack", true)
						elseif math.random(1,3) == 1 and not Wig then
							Wig = true
							mom.State = 10
							sprm:Play("Wig", true)
						end
					end
					if mom.HitPoints > v.HitPoints then
						mom.HitPoints = v.HitPoints
					end
					if mom.I1 == 3 then
						mom:Remove()
						v:Kill()
					end
				end
			end
		end

		if mom.HitPoints <= 0 or mom:IsDead() then
			mom.I1 = 3
			mom:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
			if mom:IsDead() then
				mom.HitPoints = 0
			end
		end

		if mom.HitPoints/mom.MaxHitPoints <= 0.5 and mom.I1 == 0 then
			if sprm:IsPlaying("EyeAttack") or sprm:IsPlaying("EyeAttackEternal")
			or sprm:IsPlaying("EyeHurt") then
				sprm:Play("EyeClose", true)
				eye = 0
			elseif sprm:IsPlaying("Fat01") then
				sprm:Play("Fat01Close", true)
			elseif sprm:IsPlaying("Fat02") then
				sprm:Play("Fat02Close", true)
			elseif sprm:IsPlaying("ArmOpen") then
				sprm:Play("ArmClose", true)
				MomHand = 0
			end
			if mom.State == 10 then
				sprm:Play("WigClose", true)
				Wig = false
			end
			mom.I1 = 1
			mom.CollisionDamage = 0
		end

		if mom.I1 == 1 then
			mom.State = 15
		end

		if mom.State == 15 then
			if mom.I1 == 2 then
				mom.State = 3
				mom.CollisionDamage = 2
			end
		elseif mom.State == 9 then
			if sprm:IsEventTriggered("Open") then
				mom:PlaySound(265 , 1, 0, false, 1)
				if mom.SubType == 1 then
					if math.random(1,7) == 1 then
						Isaac.Spawn(24, 2, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 2 then
						Isaac.Spawn(256, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 3 then
						Isaac.Spawn(257, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 4 then
						Isaac.Spawn(258, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 5 then
						Isaac.Spawn(279, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 6 then
						Isaac.Spawn(280, 0, 0, data.spawnpos, Vector(0,0), mom)
					else
						Isaac.Spawn(284, 0, 0, data.spawnpos, Vector(0,0), mom)
					end
				else
					if math.random(1,7) == 1 then
						Isaac.Spawn(208, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 2 then
						Isaac.Spawn(214, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 3 then
						Isaac.Spawn(215, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 4 then
						Isaac.Spawn(217, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 5 then
						Isaac.Spawn(220, 0, 0, data.spawnpos, Vector(0,0), mom)
					elseif math.random(1,7) == 6 then
						Isaac.Spawn(227, 0, 0, data.spawnpos, Vector(0,0), mom)
					else
						Isaac.Spawn(244, 0, 0, data.spawnpos, Vector(0,0), mom)
					end
				end
			end
		elseif mom.State == 8 then
			if data.eyeHp <= 0 and sprm:IsPlaying("EyeAttack") then
				sprm:Play("EyeHurt", true)
				data.eyeHp = math.max(15, 1.5*GetPlayerDps)
				mom:PlaySound(97, 1, 0, false, 1)
			end
			if sprm:IsEventTriggered("Shoot") then
				for i=-15, 15, 30 do
					EntityLaser.ShootAngle(1, mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(16) + Vector(0,1)
					, sprm.Rotation + 90 + math.random(-10,10) + i, 27, Vector(0,-5), mom)
				end
			end
			if sprm:IsPlaying("EyeHurt") and sprm:GetFrame() == 38 then
				local params = ProjectileParams()
				params.HeightModifier = 20
				params.FallingAccelModifier = 0.5
				for i=0, math.random(6,10)+(mom.SubType/8) do
					params.FallingSpeedModifier = -math.random(25,75) * 0.1
					if math.random(1,3) == 1 and i >= 5 then
						params.Scale = 1.65
						params.BulletFlags = 1 << 44
					else
						params.Scale = math.random(7,13) * 0.1
					end
					if mom.SubType ~= 2 then
						params.Variant = 4
						mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
						Vector.FromAngle(sprm.Rotation+90+math.random(-30,30)):Resized(math.random(45,120) * 0.1), 0, params)
					else
						mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
						Vector.FromAngle((target.Position - mom.Position):GetAngleDegrees()+math.random(-30,30)):Resized(math.random(45,120) * 0.1), 0, params)
					end
				end
				mom:PlaySound(153, 1, 0, false, 1)
			end
			if sprm:IsFinished("EyeAttack") or sprm:IsFinished("EyeAttackEternal")
			or sprm:IsFinished("EyeHurt") then
				eye = eye - 1
				mom.State = 3
				mom.StateFrame = 50
			end
		end

		if mom.State ~= 3 then
			if sprm:IsFinished("Fat01") or sprm:IsFinished("Fat02")
			or sprm:IsFinished("KnifeThrow") then
				mom.State = 3
				mom.StateFrame = 50
				if sprm:IsFinished("KnifeThrow") then
					MomHand = MomHand - 1
				end
			end
		elseif mom.State ~= 30 or mom.State ~= 15 then
			mom.CollisionDamage = 2
		end

		if sprm:IsEventTriggered("Open") then
			mom.EntityCollisionClass = 4
		elseif sprm:IsEventTriggered("Close") then
			mom.EntityCollisionClass = 0
		end

		if mom.State == 10 then
			mom.StateFrame = mom.StateFrame + 1
			mom.CollisionDamage = 0
			if mom.StateFrame >= 139 and not sprm:IsPlaying("WigClose")
			and not sprm:IsFinished("WigClose") then
				sprm:Play("WigClose", true)
			end
			if sprm:IsFinished("WigClose") then
				mom.State = 3
				Wig = false
				mom.StateFrame = 50
				mom.CollisionDamage = 2
			elseif sprm:IsFinished("WigStuckKnifeRight") or sprm:IsFinished("WigStuckKnifeLeft") then
				Wig = false
				mom.CollisionDamage = 2
				if MomHand < 2 then
					mom.State = 30
					sprm:Play("KnifeThrow", true)
				else
					mom.State = 3
				end
			end
		elseif mom.State == 11 then
			if sprm:IsPlaying("ArmOpen") and sprm:GetFrame() == 7 then
				mom:PlaySound(48, 1, 0, false, 1)
			end
			if sprm:IsFinished("ArmOpen") then
				mom.State = 3
				mom.StateFrame = 50
				MomHand = MomHand - 1
			end
		end

		if data.doorbroken then
			if mom.State == 10 then
				mom:SetSize(35,Vector(1.25,1.25),0)
			end
			if sprm:IsPlaying("Fat01") or sprm:IsPlaying("Fat02") then
				mom:SetSize(35,Vector(1.25,1),0)
				if sprm:GetFrame() == 11 then
					mom:PlaySound(48, 1, 0, false, 1)
					Game():ShakeScreen(8)
					Game():BombDamage(mom.Position, 0, 100, false, mom, 0, 1<<2, false)
				end
			end
			if sprm:IsPlaying("EyeAttack") or sprm:IsPlaying("EyeAttackEternal") then
				mom:SetSize(35,Vector(1,0.2),0)
			end
		end
		if mom.State == 32 then
			if data.cplayer then
				data.cplayer.ControlsEnabled = false
				data.cplayer.Position = mom.Position
				if mom.StateFrame <= 0 then
					if sprm:IsFinished("Damaging") then
						if mom.I2 >= 5 then
							data.cplayer.Position = mom.Position
							data.cplayer.Velocity = Vector.FromAngle(sprm.Rotation+90+math.random(-15,15))
							:Resized(math.random(12,15))
							data.cplayer.EntityCollisionClass = 4
							data.cplayer:TakeDamage(1, 0, EntityRef(mom), 5)
							data.cplayer:SetColor(Color(1,1,1,1,0,0,0), 99999, 0, false, false)
							data.cplayer.Visible = true
							data.cplayer.ControlsEnabled = true
							MomHand = MomHand - 1
							mom.State = 3
							mom.StateFrame = 50
							data.catch = false
						else
							sprm:Play("Damaging", true)
							mom:PlaySound(28, 0.6, 0, false, 1)
							mom.I2 = mom.I2 + 1
						end
					end
				end
				if mom:IsDead() then
					data.cplayer.Velocity = Vector.FromAngle(sprm.Rotation+90+math.random(-15,15))
					:Resized(math.random(12,15))
					data.cplayer.Visible = true
					data.cplayer:SetColor(Color(1,1,1,1,0,0,0), 99999, 0, false, false)
					data.cplayer.EntityCollisionClass = 4
					data.cplayer.ControlsEnabled = true
				end
			else
				mom.State = 3
			end
		elseif mom.State == 30 then
			if sprm:GetFrame() == 21 then
				mom:PlaySound(252, 1, 0, false, 1)
				local params = ProjectileParams()
				params.HeightModifier = 7
				params.FallingAccelModifier = -0.19
				params.Variant = 12
				params.HeightModifier = 5
				mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(70),
				Vector.FromAngle(sprm.Rotation+90):Resized(30), 0, params)
			end
		elseif mom.State == 29 then
			if sprm:GetFrame() >= 11 and sprm:GetFrame() <= 13 then
				mom.CollisionDamage = 0
				if mom.EntityCollisionClass == 4 and data.handpos:Distance(target.Position) <= 35 + target.Size then
					if target:IsVulnerableEnemy() then
						target:Remove()
					elseif target:ToPlayer() and target:ToPlayer():GetDamageCooldown() <= 0 then
						data.catch = true
					end
				end
			else
				mom.CollisionDamage = 2
			end
			if sprm:GetFrame() == 11 then
				mom:PlaySound(252, 0.5, 0, false, 0.6)
				data.handpos = mom.Position
			elseif sprm:GetFrame() == 12 then
				mom:SetSize(35,Vector(1,4),0)
				data.handpos = mom.Position+Vector.FromAngle(sprm.Rotation+90):Resized(105)
			elseif sprm:GetFrame() == 14 then
				mom:PlaySound(48, 0.6, 0, false, 1.25)
			elseif sprm:GetFrame() == 33 then
				mom:SetSize(35,Vector(1,1),0)
			end
			if sprm:IsFinished("Grab") then
				if data.catch then
					data.catch = false
					sprm:Play("Damaging", true)
					mom.State = 32
					mom:PlaySound(28, 0.6, 0, false, 1)
					mom.I2 = 0
				else
					mom.State = 3
					MomHand = MomHand - 1
					mom.StateFrame = 50
				end
			end
			if data.catch and target:ToPlayer() then
				data.cplayer = target:ToPlayer()
				data.cplayer.EntityCollisionClass = 0
				data.cplayer:SetColor(Color(1,1,1,0,0,0,0), 99999, 0, false, false)
				data.cplayer.Visible = false
				data.cplayer.ControlsEnabled = false
				if sprm:GetFrame() >= 32 then
					target.Velocity = Vector.FromAngle((mom.Position-data.cplayer.Position):GetAngleDegrees())
					:Resized(data.cplayer.Position:Distance(mom.Position)*0.1)
				end
			end
		elseif mom.State == 25 then
			if sprm:GetFrame() == 7 then
				mom:PlaySound(52, 1, 0, false, 1)
				Game():ShakeScreen(15)
				Game():BombDamage(mom.Position, 35, 20, false, mom, 0, 1<<2, false)
				for i=0, math.random(5,10) do
					local piece = Isaac.Spawn(1000, 35, 0, mom.Position,
					Vector.FromAngle(sprm.Rotation+90+math.random(-20,20)):Resized(math.random(15,20)), mom):ToEffect()
					piece.m_Height = -math.random(5,35)
					piece:SetColor(Color(0.39,0.31,0.35,1,0,0,0), 99999, 0, false, false)
				end
			elseif sprm:GetFrame() == 39 then
				mom:SetSize(35,Vector(1,4),0)
				Game():BombDamage(mom.Position+Vector.FromAngle(sprm.Rotation+90):Resized(105)
				, 35, 20, false, mom, 0, 1<<2, false)
				mom:PlaySound(52, 1.4, 0, false, 1.15)
				mom:PlaySound(137, 1, 0, false, 0.5)
				Game():ShakeScreen(25)
				for i=0, math.random(10,15) do
					local params = ProjectileParams()
					params.FallingSpeedModifier = -math.random(18,45) * 0.1
					params.FallingAccelModifier = 0.25
					params.HeightModifier = -10
					params.Scale = math.random(5,13) * 0.1
					params.Variant = 9
					mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(9),
					Vector.FromAngle(sprm.Rotation+90+math.random(-60,60)):Resized(math.random(35,140) * 0.1), 0, params)
				end
				for i=0, math.random(10,15) do
					local piece = Isaac.Spawn(1000, 35, 0, mom.Position,
					Vector.FromAngle(sprm.Rotation+90+math.random(-60,60)):Resized(math.random(20,27)), mom):ToEffect()
					piece.m_Height = -math.random(5,35)
					piece:SetColor(Color(0.39,0.31,0.35,1,0,0,0), 99999, 0, false, false)
				end
			elseif sprm:GetFrame() == 62 then
				mom:SetSize(35,Vector(1,1),0)
			end
			if sprm:IsFinished("DoorBreak") then
				mom.State = 3
				MomHand = MomHand - 1
				mom.EntityCollisionClass = 0
				mom.StateFrame = 50
			end
		elseif mom.State == 3 then
			mom.EntityCollisionClass = 0
		end

		if sprm:IsEventTriggered("Tear") then
			local params = ProjectileParams()
			params.HeightModifier = 20
			params.FallingAccelModifier = -0.1
			if mom.SubType ~= 2 then
				params.Variant = 4
				mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
				Vector.FromAngle(sprm.Rotation+90):Resized(10), 1, params)
			else
				mom:FireProjectiles(mom.Position + Vector.FromAngle(sprm.Rotation+90):Resized(6),
				Vector.FromAngle((target.Position - mom.Position):GetAngleDegrees()):Resized(10), 1, params)
			end
			mom:PlaySound(153, 1, 0, false, 1)
		end

		if eye and eye < 0 then
			eye = 0
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.HardMom, 396)

----------------------------
--Mom Stomp(Hard)
----------------------------
function denpnapi:HardMomf(mom)

	if mom.Variant == Isaac.GetEntityVariantByName("Mom Stomp (Hard)") then

		local sprmf = mom:GetSprite()
		local target = mom:GetPlayerTarget()
		local player = Isaac.GetPlayer(0)
		local data = mom:GetData()
		local Entities = Isaac:GetRoomEntities()

		mom.Velocity = mom.Velocity * 0.7

		if data.isdelirium then
			if mom.StateFrame > 0 then
				mom.StateFrame = mom.StateFrame - 1
			end
			if mom.State == 0 then
				for i=0, 1 do
					sprmf:ReplaceSpritesheet(i, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_mom.png")
				end
				sprmf:LoadGraphics()
				mom.State = 3
			elseif mom.State == 3 then
				if mom.StateFrame <= 0 and mom.FrameCount >= 30 then
					mom:PlaySound(252, 1, 0, false, 1)
					if mom.SubType == 2 then
						local knife = Isaac.Spawn(70, 70, 1, Isaac.GetRandomPosition(0), Vector(0,0), mom)
						knife.HitPoints = 30
						knife.MaxHitPoints = 30
					else
						local knife = Isaac.Spawn(70, 70, 0, player.Position, Vector(0,0), mom)
						knife.HitPoints = 30
						knife.MaxHitPoints = 30
					end
					mom.StateFrame = math.random(140,200)
				end
			end
		end

		if not data.phase2 then
			data.phase2 = false
		end

		if mom.HitPoints/mom.MaxHitPoints <= 0.5 and data.phase2 == false
		and not data.isdelirium then
			data.phase2 = true
			if mom.State == 7 and ((sprmf:IsPlaying("Stomp")
			and sprmf:GetFrame() >= 27 and sprmf:GetFrame() <= 63)
			or (sprmf:IsPlaying("Stronger Stomp") and sprmf:GetFrame() >= 57
			and sprmf:GetFrame() <= 101)) then
				mom.Visible = true
			else
				mom.Visible = false
			end
			sprmf:Play("Hurt", true)
			mom.State = 8
			mom:PlaySound(97, 1, 0, false, 1)
			mom:PlaySound(28, 1, 0, false, 1)
			Room:EmitBloodFromWalls(5,10)
			Game():ShakeScreen(20)
		end

		if mom.FrameCount <= 1 then
			mom:PlaySound(101, 1, 0, false, 1)
		end
		if mom.SubType == 2 then
			sprmf.PlaybackSpeed = 1.5
		elseif mom.SubType == 33 then
			if data.isdelirium then
				mom:SetColor(Color(1,1,1,1.5,0,0,0), 99999, 0, false, false)
			else
				for i=0,1 do
					sprmf:ReplaceSpritesheet(i, "gfx/bosses/classic/boss_mom_eternal.png")
				end
				sprmf:LoadGraphics()
			end
		end

		if mom.ProjectileCooldown > 0 then
			mom.ProjectileCooldown = mom.ProjectileCooldown - 1
		end

		if mom.State == 3 then
			if mom.FrameCount == 30 then
				mom.State = 7
				sprmf:Play("Stomp", true)
				mom:PlaySound(93, 1, 0, false, 1)
			end
			if mom.FrameCount >= 30
			and ((mom.SubType ~= 2 and mom.FrameCount % 80 == 0 and mom.ProjectileCooldown <= 0)
			or (mom.SubType == 2 and mom.FrameCount % 40 == 0 and mom.ProjectileCooldown <= 0))
			and (not eye or eye <= 0) and (not MomHand or MomHand <= 0) then
				if (mom.SubType == 2 and math.random(1,3) ~= 1)
				or (mom.SubType ~= 2 and math.random(1,5) >= 4)
				or data.isdelirium then
					mom.State = 7
					if math.random(1,4) > 1 or mom.SubType == 2 then
						mom:PlaySound(93, 1, 0, false, 1)
						if math.random(1,2) == 1 and data.phase2 then
							sprmf:Play("Stomp2",true)
						else
							sprmf:Play("Stomp",true)
						end
						if mom.FrameCount > 30 then
							mom.Position = target.Position
						end
					else
						sprmf:Play("Stronger Stomp",true)
						mom:PlaySound(84, 1, 0, false, 1)
					end
				else
					if not sound:IsPlaying(101) then
						mom:PlaySound(101, 1, 0, false, 1)
					end
				end
				if mom.SubType == 2 then
					if not data.phase2 then
						mom.ProjectileCooldown = math.random(20,45)
					else
						mom.ProjectileCooldown = math.random(10,22)
					end
				else
					if data.isdelirium then
						mom.ProjectileCooldown = 90
					else
						mom.ProjectileCooldown = math.random(75,120)
					end
				end
			end
		elseif mom.State == 7 then
			if sprmf:IsPlaying("Stomp2") then
				if sprmf:GetFrame() == 67 then
					mom:PlaySound(93, 1.3, 0, false, 1.03)
				elseif sprmf:GetFrame() == 69 then
					Game():ShakeScreen(20)
					mom:PlaySound(138, 1, 0, false, 1)
					Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
					player:AnimatePitfallOut()
					player.ControlsEnabled = false
					player.Velocity = player.Velocity * 3
					for i=0, math.random(4,8) do
						Game():SpawnParticles(Isaac.GetRandomPosition(0), 35, 1, 0, Color(0.35,0.35,0.35,1,0,0,0), -1)
					end
				end
			elseif sprmf:IsPlaying("Stronger Stomp") then
				mom.Position = Room:GetCenterPos()
				if sprmf:GetFrame() == 58 then
					mom:PlaySound(52, 1, 0, false, 1)
					Game():ShakeScreen(20)
					Game():SpawnParticles(mom.Position, 88, 10, 20, Color(1,1,1,1,135,126,90), -4)
					Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
					local shockwave1 = Isaac.Spawn(1000, 61, 0, mom.Position, Vector(0,0), mom)
					shockwave1.Parent = mom
					shockwave1:ToEffect().Timeout = 10
					shockwave1:ToEffect().MaxRadius = 90
					if mom.SubType == 33 then
						for i=20, 335, 45 do
							local shockwave2 = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
							shockwave2.Parent = mom
							shockwave2:ToEffect().Timeout = 120
							shockwave2:ToEffect():SetRadii(6,6)
						end
					else
						for i=30, 330, 60 do
							if i == 30 or i == 150 or i == 210 or i == 330 then
								local shockwave3 = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
								shockwave3.Parent = mom
								shockwave3:ToEffect().Timeout = 120
								shockwave3:ToEffect():SetRadii(6,6)
							end
						end
					end
				end
			end
		elseif mom.State == 8 then
			if sprmf:IsFinished("Hurt") then
				mom.I1 = 5
				mom.Visible = true
				sprmf:Play("Faster Stomp",true)
				mom:PlaySound(93, 1, 0, false, 1)
				mom.Position = target.Position
			end
			if sprmf:IsFinished("Faster Stomp") then
				if mom.I1 > 0 then
					mom.I1 = mom.I1 - 1
					sprmf:Play("Faster Stomp",true)
					mom:PlaySound(93, 1, 0, false, 1)
					mom.Position = target.Position + Vector(target.Velocity.X*30, target.Velocity.Y*30)
				else
					mom.State = 7
					sprmf:Play("Stronger Stomp",true)
					mom:PlaySound(84, 1, 0, false, 1)
				end
			end
		end

		if mom.FrameCount > 30 and mom.State ~= 3 and (sprmf:IsFinished("Stronger Stomp")
		or sprmf:IsFinished("Stomp") or sprmf:IsFinished("Stomp2")) then
			mom.State = 3
			mom.I2 = 2
			if sprmf:IsFinished("Stronger Stomp") then
				for k, v in pairs(Entities) do
					if v.Type == 396 and v.Variant == 0 and v:ToNPC().I1 == 1 then
						v:ToNPC().I1 = 2
					end
				end
			end
		end

		if sprmf:IsEventTriggered("Stomp") then
			mom:PlaySound(52, 1, 0, false, 1)
			Game():ShakeScreen(20)
			Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
			if mom.SubType == 33 then
				if math.random(1,2) == 1 then
					for i=45, 315, 90 do
						local shockwave = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
						shockwave.Parent = mom
						shockwave:ToEffect().Timeout = 13
						shockwave:ToEffect():SetRadii(6,6)
					end
				else
					for i=0, 270, 90 do
						local shockwave = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
						shockwave.Parent = mom
						shockwave:ToEffect().Timeout = 13
						shockwave:ToEffect():SetRadii(6,6)
					end
				end
			end
		end

		for k, v in pairs(Entities) do
			if v.Type == 396 and v.Variant == 0 and mom.FrameCount >= 1 then
				if mom.HitPoints > v.HitPoints then
					mom.HitPoints = v.HitPoints
				end
			end
		end

		if data.hurt then
			data.hurt = false
			if not sound:IsPlaying(97) then
				mom:PlaySound(97, 1, 0, false, 1)
			end
		end

		if player:IsDead() and not sound:IsPlaying(84) then
			mom:PlaySound(84, 1, 0, false, 1)
		end

		if (sprmf:IsPlaying("Stomp") and sprmf:GetFrame() >= 28 and sprmf:GetFrame() <= 61)
		or (sprmf:IsPlaying("Stronger Stomp") and sprmf:GetFrame() >= 58 and sprmf:GetFrame() <= 101)
		or (sprmf:IsPlaying("Faster Stomp") and sprmf:GetFrame() >= 12 and sprmf:GetFrame() <= 30)
		or (sprmf:IsPlaying("Hurt") and mom.Visible and sprmf:GetFrame() <= 34)
		or (sprmf:IsPlaying("Stomp2") and ((sprmf:GetFrame() >= 28 and sprmf:GetFrame() <= 56)
		or (sprmf:GetFrame() >= 69 and sprmf:GetFrame() <= 97))) then
			mom.EntityCollisionClass = 4
		else
			mom.EntityCollisionClass = 0
		end

		for k, v in pairs(Entities) do
			if (mom.HitPoints <= 0 or mom:IsDead())
			and v.Type == 396 and v.Variant == 0 then
				v:ToNPC().I1 = 3
				mom:PlaySound(141, 1, 0, false, 1)
			end
			if v:IsVulnerableEnemy() or v:IsBoss() then
				if mom:IsDead() then
					v:Kill()
				end
				if sprmf:IsPlaying("Stomp2") and sprmf:GetFrame() == 69
				and not v:IsFlying() and v:IsVulnerableEnemy() then
					if v.Type == 56 or v.Type == 58 or v.Type == 244 or v.Type == 255
					or v.Type == 276 or v.Type == 289 or v.Type == 300 then
						v:AddFreeze(EntityRef(mom),30)
					else
						v:AddVelocity(Vector.FromAngle(v.Velocity:GetAngleDegrees()):Resized(v.Velocity:Length()*2.5))
					end
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.HardMomf, 396)

----------------------------
--Mom Stomp(Last Ditch)
----------------------------
function denpnapi:MomFLD(mom)

	if mom.Variant == Isaac.GetEntityVariantByName("Mom Stomp (Last Ditch)") then

		local sprmf2 = mom:GetSprite()
		local target = mom:GetPlayerTarget()
		local player = Isaac.GetPlayer(0)
		local data = mom:GetData()
		local Entities = Isaac:GetRoomEntities()
		local rng = mom:GetDropRNG()

		if mom.FrameCount <= 1 then
			mom.TargetPosition = mom.Position
			mom:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
		elseif mom.FrameCount <= 75 then
			mom.EntityCollisionClass = 0
		end

		local angle = (mom.TargetPosition-mom.Position):GetAngleDegrees()
		local dist = mom.TargetPosition:Distance(mom.Position)

		if mom.SubType == 1 then
			mom:SetColor(Color(0.5,0.7,1,1,0,0,0), 99999, 0, false, false)
		elseif mom.SubType == 2 then
			mom:SetColor(Color(1.2,0.7,0.7,1,0,0,0), 99999, 0, false, false)
		elseif mom.SubType == 33 then
			for i=0, 1 do
				sprmf2:ReplaceSpritesheet(i, "gfx/bosses/classic/boss_mom_eternal.png")
			end
			sprmf2:LoadGraphics()
		end

		if mom.FrameCount == 75 then
			sprmf2:Play("Stomp", true)
			music:Play(denpnapi.musics.MomLastDitch, 0)
			music:UpdateVolume()
			mom:ClearEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
		end

		if sprmf2:IsPlaying("Stomp") and sprmf2:GetFrame() >= 40 and mom.FrameCount >= 75 then
			mom.State = 7
			sprmf2:SetFrame("Stomp", 40)
		end

		if data.isdelirium then
			mom:Morph(412, 0, 0, -1)
		end

		if mom.State == 7 then
			mom.StateFrame = mom.StateFrame - 1
			mom.ProjectileCooldown = mom.ProjectileCooldown - 1
			if mom.SubType == 2 then
				sprmf2.PlaybackSpeed = 1.5
			end
			if sprmf2:IsPlaying("Phase2Stomp") then
				if (mom.SubType == 2 and sprmf2:GetFrame() <= 9) or (mom.SubType ~= 2 and sprmf2:GetFrame() <= 12) then
					mom.TargetPosition = target.Position
				end
			else
				if mom.ProjectileCooldown == 0 and math.random(1,5) == 1
				and #Isaac.FindByType(70, 70, -1, true, true) <= 3 then
					mom:PlaySound(252, 1, 0, false, 1)
					local knife = Isaac.Spawn(70, 70, 0, target.Position
					+Vector.FromAngle(rng:RandomInt(359)):Resized(rng:RandomInt(80)), Vector(0,0), boss)
					knife.HitPoints = 30
					knife.MaxHitPoints = 30
				end
				if mom.StateFrame <= 0 then
					mom:PlaySound(93, 1, 0, false, 1)
					sprmf2:Play("Phase2Stomp", true)
					if mom.SubType == 2 then
						mom.ProjectileCooldown = 45
					else
						mom.ProjectileCooldown = 50
					end
					mom.StateFrame = 64
				end
			end
		end

		if mom.SubType == 2 then
			mom.Velocity = Vector.FromAngle(angle):Resized(dist*0.2)
		else
			mom.Velocity = Vector.FromAngle(angle):Resized(dist*0.1)
		end

		if sprmf2:IsEventTriggered("Stomp") then
			mom:PlaySound(52, 1, 0, false, 1)
			Game():ShakeScreen(20)
			Game():BombDamage(mom.Position, 41, 40, false, mom, 0, 1<<2, true)
			mom.TargetPosition = mom.Position
			if mom.SubType == 33 then
				for i=0, 270, 90 do
					local shockwave = Isaac.Spawn(1000, 61, 1, mom.Position, Vector.FromAngle(i):Resized(8), mom)
					shockwave.Parent = mom
					shockwave:ToEffect().Timeout = 13
					shockwave:ToEffect():SetRadii(6,6)
				end
			end
		end

		for k, v in pairs(Entities) do
			if v.Type == 396 and v.Variant == 20 then
				if mom.HitPoints > v.HitPoints then
					mom.HitPoints = v.HitPoints
				end
			end
		end

		if data.hurt then
			data.hurt = false
			if not sound:IsPlaying(97) then
				mom:PlaySound(97, 1, 0, false, 1)
			end
		end

		if player:IsDead() and not sound:IsPlaying(84) then
			mom:PlaySound(84, 1, 0, false, 1)
			mom:PlaySound(141, 1, 0, false, 1)
		end

		if (sprmf2:IsPlaying("Stomp") and sprmf2:GetFrame() == 28)
		or (sprmf2:IsPlaying("Phase2Stomp") and sprmf2:GetFrame() == 21) then
			mom.EntityCollisionClass = 4
		elseif (sprmf2:IsPlaying("Stomp") and sprmf2:GetFrame() == 61)
		or (sprmf2:IsPlaying("Phase2Stomp") and sprmf2:GetFrame() == 7) then
			mom.EntityCollisionClass = 0
		end

		if mom:IsDead() then
			mom:PlaySound(82, 1, 0, false, 1)
			Room:EmitBloodFromWalls(10,20)
		end

		for k, v in pairs(Entities) do
			if v:IsVulnerableEnemy() or v:IsBoss() then
				if mom:IsDead() then
					v:Kill()
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MomFLD, 396)

----------------------------
--Mom's Heart II
----------------------------
function denpnapi:MmHeart2(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Mom's Heart 2") then
  
		local sprmht = boss:GetSprite()
		local data = boss:GetData()
		local target = boss:GetPlayerTarget()
		local rng = boss:GetDropRNG()
		local dist = target.Position:Distance(boss.Position)
		local dist2 = boss.TargetPosition:Distance(boss.Position)
		local angle = (target.Position - boss.Position):GetAngleDegrees()
		local angle2 = (boss.TargetPosition - boss.Position):GetAngleDegrees()
		local Entities = Isaac:GetRoomEntities()
		boss:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		InitSpeed = boss.Velocity
		boss.Velocity = boss.Velocity * 0.9
	
		if data.hurt then
			data.hurt = false
			if not sound:IsPlaying(87) then
				boss:PlaySound(87, 1, 0, false, 0.1)
			end
		end
	
		if Isaac.GetPlayer(0):IsDead() and not sound:IsPlaying(86) then
			boss:PlaySound(86, 1, 0, false, 1)
		end
	
		if boss.FrameCount % 5 == 0 then
			boss:MakeSplat(math.random(5,10)*0.1)
		end
	
		if dist2 <= 90 or not boss.Pathfinder:HasPathToPos(boss.TargetPosition, false)
		or dist <= 200 then
			if math.random(1,3) == 1 then
				boss.TargetPosition = Isaac.GetRandomPosition(0)
			else
				boss.TargetPosition = boss.Position
				+ Vector.FromAngle(rng:RandomInt(359)):Resized(rng:RandomInt(100))
			end
		end
	
		if sprmht:IsFinished("Appear") then
			sprmht:Play("AppearStomp", true)
			boss.State = 38
		elseif sprmht:IsFinished("AppearStomp") then
			boss.State = 4
			boss.StateFrame = math.random(100,200)
		end
	
		if (boss.State == 8 or boss.State == 38) and boss.ProjectileCooldown > 0 then
			boss.ProjectileCooldown = boss.ProjectileCooldown - 1
			local params = ProjectileParams()
			params.FallingSpeedModifier = -math.random(50,66)
			params.FallingAccelModifier = 1.3
			params.Acceleration = 0.95
			params.HeightModifier = -40
			if math.random(1,2) > 1 then
				params.Scale = math.random(10,15) * 0.1
				params.BulletFlags = ProjectileFlags.ACCELERATE | 1 << 7
			else
				params.Scale = math.random(16,19) * 0.1
				params.BulletFlags = 1 << 1 | ProjectileFlags.ACCELERATE | 1 << 7
			end
			for i=0, math.random(1,3) do
				local dist3 = Room:GetRandomPosition(0):Distance(boss.Position)
				local rangle = (Room:GetRandomPosition(0) - boss.Position):GetAngleDegrees()
				if i ~= 0 then
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rangle)
					:Resized(dist3 * 0.075), 0, params)
				end
			end
		end
	
		if sprmht:IsEventTriggered("Heartbeat") then
			Game():ShakeScreen(10)
			boss:PlaySound(321+(boss.I1-1), 1, 0, false, 1)
			boss:PlaySound(72, 0.5, 0, false, 0.12+(boss.I1*0.03))
			if sprmht:IsPlaying("AppearStomp") or sprmht:IsPlaying("HeartStomp") then
				boss:PlaySound(52, 1, 0, false, 1)
				boss:PlaySound(213, 1, 0, false, 1)
				boss.ProjectileCooldown = 10
				local params = ProjectileParams()
				params.FallingSpeedModifier = -math.random(50,55)
				params.FallingAccelModifier = 1
				params.HeightModifier = -40
				params.Acceleration = 0.95
				params.Scale = math.random(20,25) * 0.1
				params.BulletFlags = 1 << 1 | 1 << 7 | 1 << 8 | 1 << 27
				boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(20,55) * 0.1), 0, params)
				boss.I2 = math.random(0,2)
				local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
				creep.SpriteScale = Vector(3,3)
				creep:ToEffect():SetTimeout(200)
			end
		end
	
		if boss.HitPoints / boss.MaxHitPoints >= 0.66 then
			boss.I1 = 1
		elseif boss.HitPoints / boss.MaxHitPoints >= 0.33 then
			boss.I1 = 2
		else
			if boss.I1 ~= 3 then
			boss.I1 = 3
			boss:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			boss:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				if boss.FrameCount > 30 then
					sprmht:Play("Hurt", true)
					boss.State = 15
					boss:PlaySound(87, 1, 0, false, 1)
					boss:BloodExplode()
					Game():ShakeScreen(20)
					boss.StateFrame = math.random(120,200)
				end
			end
		end
	
		if boss.State == 3 or boss.State == 4 then
			boss.StateFrame = boss.StateFrame - 1
			if boss.State == 3 and boss.Pathfinder:HasPathToPos(boss.TargetPosition, false) then
				boss.State = 4
			end
			local params = ProjectileParams()
			params.Scale = 1.8
			if boss.I1 == 1 then
				if sprmht:IsEventTriggered("Heartbeat") then
					if boss.I2 == 0 then
						for i=0, 330, 30 do
							params.FallingAccelModifier = -0.1
							params.BulletFlags = ProjectileFlags.HIT_ENEMIES
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(5), 0, params)
						end
					elseif boss.I2 == 1 then
						for i=0, 315, 45 do
							params.FallingAccelModifier = -0.15
							params.BulletFlags = 1 << 7 | 1 << 27
							params.Acceleration = 0.95
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(10), 0, params)
						end
					elseif boss.I2 == 2 then
						params.FallingAccelModifier = -0.1
						params.BulletFlags = ProjectileFlags.HIT_ENEMIES
						boss:FireProjectiles(boss.Position, Vector.FromAngle(angle):Resized(4), 5, params)
					end
				end
			elseif boss.I1 == 2 then
				if boss.I2 == 0 then
					if sprmht:IsEventTriggered("Heartbeat") then
						for i=0, 324, 36 do
							params.FallingAccelModifier = -0.165
							params.BulletFlags = 1 << 5 | 1 << 7
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(4), 0, params)
						end
					end
				elseif boss.I2 == 1 then
					if sprmht:IsEventTriggered("Heartbeat") and boss.FrameCount % 2 == 0 then
						if boss.FrameCount % 4 == 0 then
							for i=0, 270, 90 do
								params.FallingAccelModifier = -0.1
								params.BulletFlags = 1 << 7 | 1 << 29
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(3), 0, params)
							end
						elseif boss.FrameCount % 4 == 2 then
							for i=45, 315, 90 do
								params.FallingAccelModifier = -0.1
								params.BulletFlags = 1 << 7 | 1 << 29
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(3), 0, params)
							end
						end
					end
				elseif boss.I2 == 2 then
					if boss.FrameCount % 2 == 0 then
						params.FallingAccelModifier = -0.15
						params.BulletFlags = ProjectileFlags.HIT_ENEMIES
						boss:FireProjectiles(boss.Position, Vector.FromAngle((boss.FrameCount % 20)*16)
						:Resized(4), 0, params)
					end
				end
			end
			if not sprmht:IsPlaying("Heartbeat"..boss.I1) then
				sprmht:Play("Heartbeat"..boss.I1, true)
			end
			if boss.State == 4 then
				if boss.I1 ~= 3 then
					if dist > 200 or boss:HasEntityFlags(1<<9) then
						boss.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(angle2):Resized(0.5)
					else
						boss.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(angle+180):Resized(1)
						if boss.StateFrame <= 0 then
							if not sound:IsPlaying(90) then
								boss:PlaySound(90, 1, 0, false, 1)
							end
							if math.random(1,2) == 1 then
								boss.State = 8
								sprmht:Play("HeartStomp", true)
							else
								if Room:GetAliveEnemiesCount() <= 3 then
									boss.State = 9
									sprmht:Play("Attack", true)
									boss.I2 = math.random(1,5)
								end
							end
						end
					end
				else
					if boss.StateFrame <= -50 or (boss.StateFrame <= 0
					and math.abs(boss.Position.Y - target.Position.Y) <= 70) then
						boss:PlaySound(90, 1, 0, false, 1)
						if boss.Position.X < target.Position.X then
							boss.I2 = 1
						else
							boss.I2 = -1
						end
						boss.State = 8
					end
					boss.CollisionDamage = 1
					if boss.Velocity:GetAngleDegrees() >= -180 and boss.Velocity:GetAngleDegrees() < -90 then
						boss.Velocity = Vector.FromAngle(-135)
					elseif boss.Velocity:GetAngleDegrees() >= -90 and boss.Velocity:GetAngleDegrees() < 0 then
						boss.Velocity = Vector.FromAngle(-45)
					elseif boss.Velocity:GetAngleDegrees() >= 0 and boss.Velocity:GetAngleDegrees() < 90 then
						boss.Velocity = Vector.FromAngle(45)
					elseif boss.Velocity:GetAngleDegrees() >= 90 and boss.Velocity:GetAngleDegrees() < 180 then
						boss.Velocity = Vector.FromAngle(135)
					end
					if boss.StateFrame > 50 then
						boss.Velocity = boss.Velocity:Normalized() * 11.5
					else
						boss.Velocity = boss.Velocity:Normalized() * 4
					end
					if boss:CollidesWithGrid() and boss.StateFrame > 50 then
						Game():ShakeScreen(10)
						boss:PlaySound(48, 1, 0, false, 1)
						for i=0, 315, 45 do
							local params = ProjectileParams()
							params.Scale = 1.8
							params.BulletFlags = ProjectileFlags.HIT_ENEMIES
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(8), 0, params)
						end
					end
				end
			end
		end
	
		if boss.State == 8 then
			if sprmht:IsFinished("HeartStomp") then
				boss.State = 3
				boss.StateFrame = math.random(100,200) - (boss.I1 * 20)
			end
			if boss.I1 == 3 then
				if boss.I2 ~= 0 then
					boss.Velocity = Vector(13.5*boss.I2, 0)
					if not sprmht:IsPlaying("Charge") then
						sprmht:Play("Charge", true)
					end
					if boss:CollidesWithGrid() then
						boss.Velocity = Vector(0,0)
						boss:PlaySound(52, 1, 0, false, 1)
						Game():ShakeScreen(20)
						for i=0, math.random(13,22) do
							local params = ProjectileParams()
							if math.random(1,3) == 1 then
								params.Scale = 2
								params.BulletFlags = 1 << 1
							else
								params.BulletFlags = ProjectileFlags.HIT_ENEMIES
								params.Scale = math.random(10,18) * 0.1
							end
							params.FallingAccelModifier = 0.11
							params.HeightModifier = -20
							params.FallingSpeedModifier = -math.random(45,120) * 0.1
							if boss.I2 > 0 then
								boss:FireProjectiles(boss.Position, Vector.FromAngle(math.random(-55,55)):Resized(-math.random(35,110)*0.1), 0, params)
							else
								boss:FireProjectiles(boss.Position, Vector.FromAngle(math.random(-55,55)):Resized(math.random(35,110)*0.1), 0, params)
							end
						end
						if boss.I2 > 0 then
							sprmht:Play("CollideRight", true)
						else
							sprmht:Play("CollideLeft", true)
						end
						boss.I2 = 0
					end
				else
					if sprmht:IsFinished("CollideRight") or sprmht:IsFinished("CollideLeft") then
						boss.State = 4
						boss.StateFrame = math.random(180,230)
					end
				end
			end
		elseif boss.State == 9 then
			if sprmht:IsPlaying("Attack") and sprmht:IsEventTriggered("Heartbeat") then
				data.agl = rng:RandomInt(359)
				boss:PlaySound(213, 1, 0, false, 1)
				Isaac.Spawn(1000, 2, 3, boss.Position + Vector.FromAngle(data.agl):Resized(20), Vector(0,0), boss)
				local cloatty = Isaac.Spawn(549, 0, 0, boss.Position + Vector.FromAngle(data.agl):Resized(20),
				Vector.FromAngle(data.agl):Resized(math.random(5,10)), boss):ToNPC()
				cloatty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
			if sprmht:IsFinished("Attack") then
				if boss.I2 > 0 then
					sprmht:Play("Attack", true)
					boss.I2 = boss.I2 - 1
				else
					boss.State = 3
					boss.I2 = math.random(0,2)
					boss.StateFrame = math.random(100,200) - (boss.I1 * 20)
				end
			end
		elseif boss.State == 15 then
			if sprmht:IsFinished("Hurt") then
				boss.State = 3
			end
		end
	
		if boss:IsDead() then
			boss:PlaySound(85, 1, 0, false, 1)
		end
	
		for k, v in pairs(Entities) do
			if v:IsVulnerableEnemy() and not v:IsBoss() and boss.Velocity:Length() >= 5
			and v.Position:Distance(boss.Position) <= v.Size + boss.Size then
				v:Kill()
			end
		end
	
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MmHeart2, 397)

----------------------------
--It Lives II
----------------------------
function denpnapi:Lives2(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("It Lives 2") then

		local sprilv = boss:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		local data = boss:GetData()
		local target = boss:GetPlayerTarget()
		local rng = boss:GetDropRNG()
		data.idle = "Idle"..boss.I1
		boss:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

		if boss.FrameCount % 5 == 0 then
			boss:MakeSplat(math.random(5,10)*0.1)
		end

		if not data.init then
			data.init = true
			data.hurt = false
			data.umove = "WalkUp"..boss.I1
			data.dmove = "WalkDown"..boss.I1
			data.lmove = "WalkLeft"..boss.I1
			data.rmove = "WalkRight"..boss.I1
			data.creeptimeout = 55
			data.panictime = 0
		end

		if data.hurt then
			data.hurt = false
			if not sound:IsPlaying(87) then
				boss:PlaySound(87, 1, 0, false, 1)
			end
		end

		if Isaac.GetPlayer(0):IsDead() and not sound:IsPlaying(86) then
			boss:PlaySound(86, 1, 0, false, 1)
		end

		if Isaac.GetPlayer(0):GetSprite():IsPlaying("Hurt") and not sound:IsPlaying(86) then
			boss:PlaySound(86, 1, 0, false, 1)
		end

		if not sprilv:IsPlaying("Jump") then
			if boss:HasEntityFlags(1<<9) or (boss.I1 >= 3 and boss.State ~= 8
			and target.Position:Distance(boss.Position) > 200) or data.panictime > 0 then
				if boss.FrameCount % 13 == 0 or boss:CollidesWithGrid() then
					data.angle = math.random(0,360)
				end
			else
				data.angle = (target.Position - boss.Position):GetAngleDegrees()
			end
			boss.EntityCollisionClass = 4
		else
			boss.EntityCollisionClass = 0
		end

		if sprilv:IsFinished("Appear") then
			boss.State = 3
			boss.StateFrame = math.random(200,300)
			boss.Velocity = Vector(0,0)
		end

		if sprilv:IsPlaying("Appear") then
			boss.Velocity = boss.Velocity * 0.7
			if sprilv:GetFrame() == 15 then
				boss:PlaySound(52, 1, 0, false, 1)
				Game():ShakeScreen(20)
				for i=0, 15 do
					local params = ProjectileParams()
					params.Scale = math.random(10,20) * 0.1
					params.FallingAccelModifier = 0.15
					params.FallingSpeedModifier = -math.random(35,60) * 0.1
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359))
					:Resized(math.random(35,90) * 0.1), 0, params)
				end
			local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
				creep.SpriteScale = Vector(1,1)
				creep:ToEffect():SetTimeout(170)
			elseif sprilv:GetFrame() == 17 then
				local creep2 = Isaac.Spawn(1000, 22, 0, boss.Position + Vector(0,40), Vector(0,0), boss)
				creep2.SpriteScale = Vector(1.5,1.5)
				creep2:ToEffect():SetTimeout(170)
			elseif sprilv:GetFrame() == 19 then
				local creep3 = Isaac.Spawn(1000, 22, 0, boss.Position + Vector(0,90), Vector(0,0), boss)
				creep3.SpriteScale = Vector(2.5,2.5)
				creep3:ToEffect():SetTimeout(170)
			end
		end

		if boss.State == 4 then
			data.umove = "WalkUp"..boss.I1
			data.dmove = "WalkDown"..boss.I1
			data.lmove = "WalkLeft"..boss.I1
			data.rmove = "WalkRight"..boss.I1
		elseif boss.State == 8 then
			data.umove = "RunUp"..boss.I1
			data.dmove = "RunDown"..boss.I1
			data.lmove = "RunLeft"..boss.I1
			data.rmove = "RunRight"..boss.I1
		end

		if sprilv:IsEventTriggered("HeartBeat") then
			Game():ShakeScreen(10)
			boss:PlaySound(321+(boss.I1-1), 1, 0, false, 1)
			boss:PlaySound(72, 0.5, 0, false, 0.12+(boss.I1*0.03))
		end

		if boss.State >= 3 and boss.State <= 4 then
			if boss.I1 == 3 and boss.FrameCount % 5 == 0 then
				if data.isdelirium then
					data.creeptimeout = 100
				else
					data.creeptimeout = 55
				end
				local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
				creep.SpriteScale = Vector(2,2)
				creep:ToEffect():SetTimeout(data.creeptimeout)
			end
			local params = ProjectileParams()
			params.Scale = 1.8
			if boss.I2 == 0 then
				if boss.I1 == 1 and boss.FrameCount % 20 == 0 then
					for i=0, 315, 45 do
						params.FallingAccelModifier = -0.08
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(5.5), 0, params)
					end
				elseif boss.I1 == 2 and boss.FrameCount % 17 == 0 then
					for i=0, 240, 120 do
						params.GridCollision = false
						params.FallingAccelModifier = -0.075
						if boss.FrameCount % 2 == 0 then
							params.BulletFlags = 1 << 18
						else
							params.BulletFlags = 1 << 19
						end
						params.CurvingStrength = 0.008
						boss:FireProjectiles(boss.Position, Vector.FromAngle(boss.Velocity:GetAngleDegrees()+i):Resized(6), 0, params)
					end
				elseif boss.I1 == 3 and boss.FrameCount % 9 == 0 then
					for i=0, 270, 90 do
						params.FallingAccelModifier = -0.03
						boss:FireProjectiles(boss.Position,
						Vector.FromAngle(((boss.FrameCount % 2)*45)+i):Resized(7), 0, params)
					end
				end
			elseif boss.I2 == 1 then
				if boss.I1 == 1 then
					if boss.FrameCount % 20 == 0 then
						for i=0, 270, 90 do
							params.FallingAccelModifier = -0.05
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(5.5), 0, params)
						end
					elseif boss.FrameCount % 8 == 0 then
						local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
						creep.SpriteScale = Vector(2,2)
						creep:ToEffect():SetTimeout(165)
					end
				elseif boss.I1 == 2 and boss.FrameCount % 8 == 0 then
					params.FallingAccelModifier = -0.05
					params.HeightModifier = 15
					for i=0, 180, 180 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle((boss.FrameCount*3)+i):Resized(6), 0, params)
					end
				elseif boss.I1 == 3 and boss.FrameCount % 13 == 0 then
					params.BulletFlags = 1 << 27
					params.FallingAccelModifier = -0.15
					params.Acceleration = 0.96
					for i=0, 240, 120 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(((boss.FrameCount % 2)*60)+i):Resized(7), 0, params)
					end
				end
			elseif boss.I2 == 2 then
				if boss.I1 == 1 and boss.FrameCount % 30 == 0 then
					for i=45, 285, 120 do
						params.BulletFlags = 1 << 29
						params.FallingAccelModifier = -0.08
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(3), 0, params)
					end
				elseif boss.I1 == 2 and boss.FrameCount % 22 == 0 then
					for i=45, 345, 60 do
						params.BulletFlags = 1 << 22
						params.FallingAccelModifier = -0.1
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(5), 0, params)
					end
				elseif boss.I1 == 3 and boss.FrameCount % 15 == 0 then
					params.BulletFlags = 1 << 21 | 1 << 32 | 1 << 33
					params.FallingAccelModifier = -0.15
					params.ChangeTimeout = 35
					params.ChangeVelocity = 6.5
					for i=0+((boss.FrameCount % 2)*30), 300+((boss.FrameCount % 2)*30), 60 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(3), 0, params)
					end
				end
			end
		end

		if boss.State == 3 then
			boss.State = 4
		elseif boss.State == 4 then
			boss.StateFrame = boss.StateFrame - 1
			if data.panictime > 0 then
				data.panictime = data.panictime - 1
			end
			boss.Velocity = boss.Velocity * 0.93
			if (boss:HasEntityFlags(1<<11) or boss:HasEntityFlags(1<<24))
			and target.Position:Distance(boss.Position) <= 300 then
				boss:AddVelocity(Vector.FromAngle(-data.angle):Resized(0.08+(boss.I1*0.2)))
			else
				boss:AddVelocity(Vector.FromAngle(data.angle):Resized(0.08+(boss.I1*0.2)))
			end
			if boss.StateFrame <= 0 then
				if not sound:IsPlaying(90) then
					boss:PlaySound(90, 1, 0, false, 1)
				end
				if math.random(1,3) == 1 then
					boss.State = 8
					if boss.I1 < 3 then
						boss:PlaySound(313, 1, 0, false, 1)
					end
					boss.I2 = math.random(0,2)
				elseif math.random(1,3) == 2 then
					if not data.isdelirium then
						boss.State = 9
						sprilv:Play("JumpReady", true)
						boss.I2 = math.random(1,4)
						data.i3 = 1
					end
				else
					if boss.I1 == 3 and boss.Position.Y >= 210 then
						boss.State = 10
						boss.StateFrame = math.random(150,200)
						if target.Position.X >= boss.Position.X then
							sprilv:Play("ShootRightStart", true)
						else
							sprilv:Play("ShootLeftStart", true)
						end
						boss.I2 = math.random(0,2)
					end
				end
			end
		elseif boss.State == 8 then
			boss.Velocity = (boss.Velocity * 0.99) + Vector.FromAngle(data.angle):Resized(0.45+(boss.I1*0.2))
			if boss:CollidesWithGrid() then
				Game():ShakeScreen(20)
				boss:PlaySound(52, 1, 0, false, 1)
				boss.State = 4
				boss.StateFrame = math.random(200,300)
				for i=0, 345, 15 do
					local params = ProjectileParams()
					params.Scale = 1.8
					params.FallingAccelModifier = -0.1
					boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(8), 0, params)
				end
			end
		elseif boss.State == 9 then
			boss.Velocity = boss.Velocity * 0.7
			if sprilv:IsFinished("JumpReady") then
				sprilv:Play("Jump", true)
				if boss.I1 < 3 then
					boss:PlaySound(25, 1, 0, false, 1)
				else
					boss:PlaySound(72, 1, 0, false, 1)
				end
			elseif sprilv:IsFinished("Jump") then
				if data.i3 == 1 then data.i3 = 0 else data.i3 = 1 end
				sprilv:Play("Stomp", true)
				boss.I2 = boss.I2 - 1
				boss:PlaySound(48, 1, 0, false, 1)
				Game():ShakeScreen(20)
				boss:PlaySound(321+(boss.I1-1), 1, 0, false, 1)
				boss:PlaySound(72, 0.2, 0, false, 0.12+(boss.I1*0.03))
				boss:PlaySound(52, 1, 0, false, 1)
				boss:PlaySound(213, 1, 0, false, 1)
				boss.ProjectileCooldown = 20
				for i=0+(data.i3*45), 270+(data.i3*45), 90 do
					EntityLaser.ShootAngle(1, boss.Position, i, 13, Vector(0,0), boss)
				end
				local params = ProjectileParams()
				params.FallingSpeedModifier = -35
				params.FallingAccelModifier = 1
				params.HeightModifier = -70
				params.Scale = 2
				params.BulletFlags = 2
				boss:FireProjectiles(boss.Position,
				Vector.FromAngle((target.Position - boss.Position):GetAngleDegrees()):
				Resized(target.Position:Distance(boss.Position) * 0.02), 0, params)
				local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
				creep.SpriteScale = Vector(3,3)
				creep:ToEffect():SetTimeout(150)
			elseif sprilv:IsFinished("Stomp") then
				if boss.I2 < 1 then
					boss.State = 4
					boss.StateFrame = math.random(200,300)
					boss.I2 = math.random(0,2)
				else
					sprilv:Play("JumpReady", true)
				end
			end
			if sprilv:IsPlaying("Jump") then
				boss.Velocity = (boss.Velocity * 0.99) + Vector.FromAngle(data.angle):Resized(2)
			end
		elseif boss.State == 10 then
			boss.Velocity = boss.Velocity * 0.7
			if sprilv:GetFrame() == 37 then
				boss:PlaySound(48, 1, 0, false, 0.75)
				if sprilv:IsPlaying("ShootRightStart") then
					local blaser = EntityLaser.ShootAngle(1, boss.Position+Vector(46,5), 0, boss.StateFrame, Vector(0,-56), boss)
					blaser:GetData().lflag = 1
					blaser:GetData().pvl = 5
					blaser:GetData().pdensity = 9
				elseif sprilv:IsPlaying("ShootLeftStart") then
					local blaser = EntityLaser.ShootAngle(1, boss.Position+Vector(-46,5), 180, boss.StateFrame, Vector(0,-56), boss)
					blaser:GetData().lflag = 1
					blaser:GetData().pvl = 5
					blaser:GetData().pdensity = 9
				end
			end
			if sprilv:IsPlaying("ShootRightLoop") or sprilv:IsPlaying("ShootLeftLoop") then
				boss.StateFrame = boss.StateFrame - 1
				if sprilv:IsPlaying("ShootRightLoop") then
					boss.Velocity = Vector(-1,0)
					if boss.StateFrame <= 0 then
						sprilv:Play("ShootRightEnd", true)
					end
				elseif sprilv:IsPlaying("ShootLeftLoop") then
					boss.Velocity = Vector(1,0)
					if boss.StateFrame <= 0 then
						sprilv:Play("ShootLeftEnd", true)
					end
				end
			end
			if sprilv:IsFinished("ShootRightStart") then
				sprilv:Play("ShootRightLoop", true)
			elseif sprilv:IsFinished("ShootLeftStart") then
				sprilv:Play("ShootLeftLoop", true)
			elseif sprilv:IsFinished("ShootRightEnd") or sprilv:IsFinished("ShootLeftEnd") then
				boss.State = 4
				boss.StateFrame = math.random(180,250)
			end
		elseif boss.State == 15 then
			boss.Velocity = boss.Velocity * 0.7
			if not sprilv:IsPlaying("Shock") and not sprilv:IsFinished("Shock") then
				sprilv:Play("Shock", true)
			end
			if sprilv:IsFinished("Shock") then
				boss.State = 4
				boss.StateFrame = math.random(200,300)
			end
			if sprilv:IsPlaying("Shock") and sprilv:GetFrame() >= 3
			and sprilv:GetFrame() <= 43 and boss.FrameCount % 2 == 0 then
				local params = ProjectileParams()
				params.Scale = math.random(7,15) * 0.1
				params.FallingAccelModifier = 0.5
				params.FallingSpeedModifier = -math.random(110,190) * 0.1
				params.HeightModifier = -30
				boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(10,40) * 0.1), 0, params)
			end
		end

		if boss.ProjectileCooldown >= 1 then
			boss.ProjectileCooldown = boss.ProjectileCooldown - 1
			if boss.State == 9 then
				local params = ProjectileParams()
				params.FallingSpeedModifier = -math.random(250,350) * 0.1
				params.FallingAccelModifier = 1
				params.HeightModifier = -70
				params.Scale = math.random(8,18) * 0.1
				boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(10,65) * 0.1), 0, params)
			end
		end

		if boss:IsDead() then
			boss:PlaySound(85, 1, 0, false, 1)
		end

		if boss.HitPoints / boss.MaxHitPoints >= 0.66 then
			boss.I1 = 1
		elseif boss.HitPoints / boss.MaxHitPoints >= 0.33 then
			boss.I1 = 2
		else
			if boss.I1 ~= 3 then
				boss.I1 = 3
				data.panictime = 150
				if boss.FrameCount > 30 then
					boss.State = 15
					boss:BloodExplode()
					Game():ShakeScreen(10)
					local head = Isaac.Spawn(398, 10, 0, boss.Position, Vector(0,0), boss)
					head.EntityCollisionClass = 0
				end
				if data.isdelirium then
					sprilv:ReplaceSpritesheet(0,"gfx/bosses/deliriumforms/boss_070_itlives2_12.png")
					for i=1, 5 do
						sprilv:ReplaceSpritesheet(i,"gfx/bosses/deliriumforms/boss_070_itlives2_22.png")
					end
				else
					sprilv:ReplaceSpritesheet(0,"gfx/bosses/afterbirthplus/boss_070_itlives2_12.png")
					for i=1, 5 do
						sprilv:ReplaceSpritesheet(i,"gfx/bosses/afterbirthplus/boss_070_itlives2_22.png")
					end
				end
				sprilv:LoadGraphics()
			end
		end

		if boss.State == 4 or boss.State == 8 then
			if boss.Velocity:Length() >= 0.1 then
				if math.abs(boss.Velocity.X) < math.abs(boss.Velocity.Y) then
					if boss.Velocity.Y >= 0 and not sprilv:IsPlaying(data.dmove) then
						sprilv:Play(data.dmove, true)
					elseif boss.Velocity.Y < 0 and not sprilv:IsPlaying(data.umove) then
						sprilv:Play(data.umove, true)
					end
				else
					if boss.Velocity.X < 0 and not sprilv:IsPlaying(data.rmove) then
						sprilv:Play(data.rmove, true)
					elseif boss.Velocity.X >= 0 and not sprilv:IsPlaying(data.lmove) then
						sprilv:Play(data.lmove, true)
					end
				end
			else
				if not sprilv:IsPlaying(data.idle) then
					sprilv:Play(data.idle, true)
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Lives2, 398)

----------------------------
--Head of Lives
----------------------------
function denpnapi:LivesHead(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Head of Lives") then

		local sprlhd = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		local dist = target.Position:Distance(boss.Position)
		local angle = (target.Position - boss.Position):GetAngleDegrees()
		local rng = boss:GetDropRNG()
		local gi = Room:GetGridIndex(boss.TargetPosition)
		boss:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

		if boss.State <= 1 and not data.isdelirium then
			boss.State = 2
			sprlhd:Play("RotateVert", true)
			boss.EntityCollisionClass = 0
			boss.PositionOffset = Vector(0, -35)
			boss.I1 = 20
			boss.StateFrame = math.random(10,35)
		end

		if boss.State ~= 3 then
			sprlhd.PlaybackSpeed = 1
		end

		if boss.State == 2 then
			if sprlhd:IsPlaying("RotateVert") then
				if boss.FrameCount <= 5 then
					boss.Velocity = Vector(0,2.5)
				end
				boss.I1 = boss.I1 - 1
				boss.PositionOffset = Vector(0, boss.PositionOffset.Y - boss.I1)
				if boss.PositionOffset.Y >= 0 then
					boss:PlaySound(52, 1, 0, false, 1)
					sprlhd:Play("Land", true)
					Game():ShakeScreen(20)
					boss.I1 = 0
					boss.PositionOffset = Vector(0, 0)
					local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
					creep.SpriteScale = Vector(3,3)
					creep:ToEffect():SetTimeout(200)
					boss.EntityCollisionClass = 4
				end
			elseif sprlhd:IsPlaying("Land") then
				boss.Velocity = boss.Velocity * 0.8
			end

			if sprlhd:IsFinished("Land") then
				sprlhd:Play("Idle", true)
				boss.State = 3
			end
		elseif boss.State == 3 then
			boss.StateFrame = boss.StateFrame - 1
			if boss.I1 >= 1 then
				boss.Velocity = boss.Velocity * 0.95
				if not sprlhd:IsPlaying("RotateHoriLoop") then
					sprlhd:Play("RotateHoriLoop", true)
				end
				if boss.FrameCount % 10 == 0 then
					local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
					creep.SpriteScale = Vector(1.6,1.6)
					creep:ToEffect():SetTimeout(60)
				end
				if boss:CollidesWithGrid() then
					boss:PlaySound(28, 1, 0, false, 1)
					boss.Velocity = boss.Velocity * 1.2
				end
				if boss.Velocity:Length() < 0.5 then
					boss.I1 = 0
				end
				sprlhd.PlaybackSpeed = 0.1 + (boss.Velocity:Length()/5)
			else
				sprlhd.PlaybackSpeed = 1
				boss.Velocity = boss.Velocity * 0.83
				if sprlhd:IsFinished("Stop") then
					sprlhd:Play("Idle", true)
				end
				if sprlhd:IsPlaying("RotateHoriLoop") then
					sprlhd:Play("Stop", true)
				end
				if boss.Velocity:Length() >= 5 then
					boss.I1 = 1
				end
				if boss.StateFrame <= 0 then
					if math.random(1,6) == 1 then
						boss.State = 8
					elseif math.random(1,6) <= 5 then
						boss.State = 9
						boss.TargetPosition = target.Position
					else
						boss.State = 6
					end
				end
			end
		elseif boss.State == 6 then
			if not sprlhd:IsPlaying("Jump") and not sprlhd:IsFinished("Jump") then
				sprlhd:Play("Jump", true)
			end
			if sprlhd:IsPlaying("Jump") then
				if sprlhd:IsEventTriggered("Jump") then
					boss:PlaySound(38, 1.3, 0, false, 1)
					if math.random(1,2) == 1 then
						boss.Velocity = Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(50,100)*0.1)
					else
						boss.Velocity = Vector.FromAngle(angle):Resized(10)
					end
				elseif sprlhd:IsEventTriggered("Land") then
					boss.Velocity = Vector(0,0)
					boss:PlaySound(72, 1, 0, false, 1)
					local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
					creep.SpriteScale = Vector(3,3)
					creep:ToEffect().Timeout = 60
				end
				if sprlhd:GetFrame() <= 7 then
					boss.Velocity = boss.Velocity * 0.8
					if Room:GetGridEntity(gi) then
						boss.TargetPosition = Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(100,250))
					end
				elseif sprlhd:GetFrame() >= 21 then
					boss.Velocity = boss.Velocity * 0.6
				end
			end
			if sprlhd:IsFinished("Jump") then
				boss.State = 3
				sprlhd:Play("Idle", true)
				boss.StateFrame = math.random(10,90)
			end
		elseif boss.State == 8 then
			if not sprlhd:IsPlaying("Shoot") and not sprlhd:IsFinished("Shoot") then
				sprlhd:Play("Shoot", true)
			end
			if sprlhd:IsPlaying("Shoot") then
				if sprlhd:GetFrame() == 5 then
					boss:PlaySound(72, 1, 0, false, 1)
				elseif sprlhd:GetFrame() == 25 then
					boss:PlaySound(313, 1, 0, false, 1)
					local params = ProjectileParams()
					params.FallingAccelModifier = 0.15
					for i=0, math.random(8,15) do
						params.Scale = math.random(8,15) * 0.1
						params.FallingSpeedModifier = -math.random(25,75) * 0.1
						boss:FireProjectiles(boss.Position,
						Vector.FromAngle(angle+math.random(-30,30)):Resized(math.random(55,130)*0.1), 0, params)
					end
				end
			end
			if sprlhd:IsFinished("Shoot") then
				boss.State = 3
				sprlhd:Play("Idle", true)
				boss.StateFrame = math.random(10,120)
			end
		elseif boss.State == 9 then
			if data.isdelirium then
				if not sprlhd:IsPlaying("JumpAttackDlr") and not sprlhd:IsFinished("JumpAttackDlr") then
					sprlhd:Play("JumpAttackDlr", true)
				end
			else
				if not sprlhd:IsPlaying("JumpAttack") and not sprlhd:IsFinished("JumpAttack") then
					sprlhd:Play("JumpAttack", true)
				end
			end
			if sprlhd:IsPlaying("JumpAttack") or sprlhd:IsPlaying("JumpAttackDlr") then
				if sprlhd:IsEventTriggered("Jump") then
					boss:PlaySound(25, 1, 0, false, 1)
					if boss.TargetPosition:Distance(boss.Position) <= 250 then
						boss.Velocity = Vector.FromAngle
						((boss.TargetPosition-boss.Position):GetAngleDegrees()):Resized(25)
					else
						boss.Velocity = Vector.FromAngle
						((boss.TargetPosition-boss.Position):GetAngleDegrees())
						:Resized(boss.TargetPosition:Distance(boss.Position)*0.2)
					end
				elseif sprlhd:IsEventTriggered("Land") then
					boss:PlaySound(72, 1, 0, false, 1)
					local creep = Isaac.Spawn(1000, 22, 0, boss.Position, Vector(0,0), boss)
					creep.SpriteScale = Vector(3,3)
					creep:ToEffect().Timeout = 60
				end
				if sprlhd:IsPlaying("JumpAttackDlr") then
					if sprlhd:GetFrame() <= 23 then
						boss.Velocity = boss.Velocity * 0.8
					elseif sprlhd:GetFrame() >= 33 then
						boss.Velocity = boss.Velocity * 0.6
					end
				else
					if sprlhd:GetFrame() <= 17 then
						boss.Velocity = boss.Velocity * 0.8
					elseif sprlhd:GetFrame() >= 27 then
						boss.Velocity = boss.Velocity * 0.6
					end
				end
			end
			if sprlhd:IsFinished("JumpAttack") or sprlhd:IsFinished("JumpAttackDlr") then
				boss.State = 3
				sprlhd:Play("Idle", true)
				boss.StateFrame = math.random(10,120)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.LivesHead, 398)

----------------------------
--New Entity:Mega Satan 2's Hands
----------------------------
function denpnapi:MSHandS(enemy)

	if enemy.Variant == 1 or enemy.Variant == 2 then

		if enemy:GetData().isdelirium then
			enemy:Morph(412, 0, 0, -1)
		end

		if enemy.SpawnerEntity then

			local sprshn = enemy:GetSprite()
			local sents = enemy.SpawnerEntity
			local target = Game():GetPlayer(1)
			local Entities = Isaac:GetRoomEntities()
			local data = enemy:GetData()
			local sdt = sents:GetData()
			sspr = enemy.SpawnerEntity:GetSprite()
			local tangle = (target.Position - enemy.Position):GetAngleDegrees()
			enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			enemy:RemoveStatusEffects()
			enemy.GridCollisionClass = 0

			if sprshn:IsFinished("Appear") then
				sprshn:Play("TrueAppear", true)
				enemy.State = 22
			end

			if enemy.Variant % 2 == 1 then
				enemy.FlipX = false
			else
				enemy.FlipX = true
			end

			if sprshn:IsFinished("TrueAppear") and ((sspr:IsPlaying("Appear")
			and sspr:GetFrame() >= 114) or not sspr:IsPlaying("Appear")) then
				sprshn:Play("Idle1", true)
				enemy.State = 3
				enemy.EntityCollisionClass = 4
			end

			if enemy.State == 8 then
				if enemy.Variant % 2 == 0 then
					data.dist = (sents.Position + Vector(150,115)):Distance(enemy.Position)
					data.angle = ((sents.Position + Vector(150,115))-enemy.Position):GetAngleDegrees()
				else
					data.dist = (sents.Position + Vector(-150,115)):Distance(enemy.Position)
					data.angle = ((sents.Position + Vector(-150,115))-enemy.Position):GetAngleDegrees()
				end
			else
				if enemy.Variant % 2 == 0 then
					data.dist = (sents.Position + Vector(40,115)):Distance(enemy.Position)
					data.angle = ((sents.Position + Vector(40,115))-enemy.Position):GetAngleDegrees()
				else
					data.dist = (sents.Position + Vector(-40,115)):Distance(enemy.Position)
					data.angle = ((sents.Position + Vector(-40,115))-enemy.Position):GetAngleDegrees()
				end
			end

			if enemy.State == 3 or enemy.State == 8 then
				enemy.EntityCollisionClass = 4
				enemy.Velocity = (enemy.Velocity * 0.7) + Vector.FromAngle(data.angle)
				:Resized(data.dist*0.03)
			end

			if sspr:IsPlaying("Idle1") or sspr:IsPlaying("Idle2")
			or sspr:IsPlaying("Idle3") then
				enemy.State = 3
			elseif sspr:IsPlaying("Shoot1Start") or sspr:IsPlaying("Shoot2Start")
			or sspr:IsPlaying("Shoot3Start") then
				enemy.State = 8
			elseif sspr:IsPlaying("Up1") or sspr:IsPlaying("Up2")
			or sspr:IsPlaying("Up3") then
				enemy.State = 15
				if enemy.State == 15 and sprshn:IsPlaying("Idle1") then
					sprshn:Play("Up", true)
					enemy.Velocity = Vector(0,0)
				end
			elseif sspr:IsPlaying("Down1") or sspr:IsPlaying("Down2")
			or sspr:IsPlaying("Down3") then
				if sspr:GetFrame() == 1 then
					sprshn:Play("Down", true)
				end
			end

			if sprshn:IsPlaying("Up") or sprshn:IsPlaying("Down")
			or sprshn:IsPlaying("Vanish") or enemy.FrameCount <= 114 then
				enemy.EntityCollisionClass = 0
			end

			if sprshn:IsFinished("Up") then
				if enemy.Variant == 1 then
					enemy.Position = Vector(0,target.Position.Y)
					sprshn:Play("Appear2", true)
					sdt.handattacking = true
					sdt.side = "Right"
				end
			end

			if sprshn:IsFinished("Appear2") then
				sprshn:Play("PunchReady", true)
			end

			if sprshn:IsPlaying("PunchReady") then
				enemy.EntityCollisionClass = 4
				enemy.StateFrame = enemy.StateFrame - 1
				if enemy.Variant == 1 then
					enemy.Position = Vector(0,enemy.Position.Y)
				else
					enemy.Position = Vector(660,enemy.Position.Y)
				end
				if enemy.Position.Y + target.Position.Y < 0
				or enemy.Position.Y - target.Position.Y < 0  then
					enemy.Velocity = (enemy.Velocity * 0.96) + Vector.FromAngle(90):Resized(1)
				else
					enemy.Velocity = (enemy.Velocity * 0.96) + Vector.FromAngle(270):Resized(1)
				end
				if enemy.StateFrame <= 0
				and (target.Position.Y - enemy.Position.Y >= -15
				or target.Position.Y + enemy.Position.Y <= 15) then
					sprshn:Play("Punchstart", true)
				end
			end

			if sprshn:IsPlaying("Punchstart") then
				if sprshn:GetFrame() == 1 or sprshn:GetFrame() == 32 then
					enemy.Velocity = Vector(0,0)
				elseif sprshn:GetFrame() >= 26 and sprshn:GetFrame() <= 31 then
					if enemy.Variant == 1 then
						enemy.Velocity = Vector(60,0)
					else
						enemy.Velocity = Vector(-60,0)
					end
				end

				if sprshn:GetFrame() == 26 then
					enemy:PlaySound(182, 1, 0, false, 1)
				end
				enemy.Velocity = enemy.Velocity * 0.8
			end

			if sprshn:IsFinished("Punchstart") then
				if enemy.Variant == 1 then
					if enemy.Position.X >= 0 then
						enemy.Velocity = (enemy.Velocity * 0.96) + Vector.FromAngle(180):Resized(1)
					else
						enemy.Velocity = enemy.Velocity * 0.7
						sprshn:Play("Vanish", true)
					end
				else
					if enemy.Position.X <= Room:GetBottomRightPos().X then
						enemy.Velocity = (enemy.Velocity * 0.96) + Vector.FromAngle(0):Resized(1)
					else
						enemy.Velocity = enemy.Velocity * 0.7
						sprshn:Play("Vanish", true)
						enemy.EntityCollisionClass = 0
					end
				end
			end

			if sprshn:IsPlaying("Appear2") or sprshn:IsPlaying("Vanish") then
				enemy.StateFrame = math.random(75,110)
				enemy.Velocity = enemy.Velocity * 0.6
			end

			if sprshn:IsPlaying("Down") and sprshn:GetFrame() == 1 then
				if enemy.Variant % 2 == 1 then
					enemy.Position = sents.Position + Vector(-50,115)
				else
					enemy.Position = sents.Position + Vector(50,115)
				end
			end

			if sprshn:IsFinished("Down") then
				enemy.EntityCollisionClass = 4
			end

			if sprshn:IsPlaying("Vanish") then
				if sprshn:GetFrame() == 15 then
					sdt.handattacking = false
				elseif sprshn:GetFrame() == 30 then
					if sdt.side == "Left" then
						sdt.side = "Right"
					elseif sdt.side == "Right" then
						sdt.side = "Left"
					end
					if math.random(1,2) == 1 then
						sents:ToNPC().ProjectileCooldown = math.random(259,309)
						if sdt.side == "Left" then
							sents:ToNPC().I2 = 1
							sdt.side = "Right"
						elseif sdt.side == "Right" then
							sents:ToNPC().I2 = 2
							sdt.side = "Left"
						end
					end
				end
			end

			if (sprshn:IsFinished("Vanish") or sprshn:IsFinished("Up"))
			and sents:ToNPC().ProjectileCooldown <= 0 then
				if enemy.Variant % 2 == 0 and sdt.side == "Left" then
					enemy.Position = Vector(660,target.Position.Y)
					sprshn:Play("Appear2", true)
					sdt.handattacking = true
				elseif enemy.Variant % 2 == 1 and sdt.side == "Right" then
					enemy.Position = Vector(0,target.Position.Y)
					sprshn:Play("Appear2", true)
					sdt.handattacking = true
				end
			end

			if enemy:IsDead() then
				sdt.handattacking = false
				enemy:PlaySound(242, 1, 0, false, 1)
			end

			for k, v in pairs(Entities) do
				if v:IsVulnerableEnemy() and v.Type ~= 399 and v.Type ~= 275 then
					if v.Position:Distance(enemy.Position) <= 45 + v.Size
					and enemy.Velocity:Length() >= 5 and sprshn:IsPlaying("Punchstart") then
						v:TakeDamage(25, 0, EntityRef(enemy), 5)
					end
				end
			end

		end
	end

end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MSHandS, 399)

----------------------------
--New Boss:Lamb Body(Hard)
----------------------------
function denpnapi:LambBody(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Lamb Body(Hard)") then

		local sprlb = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		local Entities = Isaac:GetRoomEntities()
		local dist = target.Position:Distance(boss.Position)
		local rng = boss:GetDropRNG()
		boss:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		boss:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		boss.StateFrame = boss.StateFrame - 1
		angle = (target.Position - boss.Position):GetAngleDegrees()
		boss.SplatColor = Color(0.13,1.73,2.28,1.5,0,0,0)

		if sprlb:IsFinished("LBBDefault") or sprlb:IsFinished("Appear") then
			sprlb:Play("TrueAppear", true)
			boss.State = 3
		end

		if sprlb:IsFinished("TrueAppear") or sprlb:IsFinished("Attack")
		or sprlb:IsFinished("Shoot2End") or sprlb:IsFinished("ShootEnd") then
			sprlb:Play("Idle", true)
			boss.State = 4
			boss.StateFrame = math.random(60,70)
		end

		if boss.State == 4 then
			InitSpeed = boss.Velocity
			if not boss:HasEntityFlags(1<<11) and not boss:HasEntityFlags(1<<9) then
				boss.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(1*angle):Resized(0.1)
			elseif boss:HasEntityFlags(1<<11) then
				boss.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(1*angle+180):Resized(0.2)
			elseif boss:HasEntityFlags(1<<9) then
				if boss.FrameCount % 100 then
					data.cfvel =  Vector.FromAngle(math.random(0,359)):Resized(0.2)
				end
				boss.Velocity = (InitSpeed * 0.9) + data.cfvel
			end
			if data.hurtattack then
				sprlb:Play("Shoot3", true)
				boss.State = 10
			end
		else
			boss.Velocity = boss.Velocity * 0.9
		end

		if boss.State == 4 and boss.StateFrame <= 0 then
			if dist <= 500 then
				if math.random(0,5) == 0 then
					if #Isaac.FindByType(557, 0, -1, true, true) > 0 then
						boss.State = 13
						sprlb:Play("Charge", true)
						boss.I1 = 0
					end
				elseif math.random(0,5) == 1 then
					if math.abs(target.Position.X-boss.Position.X) <= 80
					and boss.Position.Y <= target.Position.Y then
						sprlb:Play("Shoot2Start", true)
						boss.State = 9
						boss:PlaySound(310 , 1, 0, false, 1)
					end
				elseif math.random(0,5) == 2 then
					if #Isaac.FindByType(555, 0, -1, true, true) > 0 then
						sprlb:Play("Throw", true)
						boss.State = 11
						boss.I2 = math.random(1,4)
					end
				elseif math.random(0,5) == 3 then
					if boss.I1 == 1 then
						sprlb:Play("StompReady", true)
						boss.State = 12
					end
				elseif math.random(0,5) == 4 then
					sprlb:Play("Shoot3", true)
					boss.State = 10
				else
					sprlb:Play("Charge", true)
					boss.I1 = math.random(0,2)
					boss.State = 8
					boss:PlaySound(14 , 1, 0, false, 1)
				end
			end
		end

		if sprlb:IsFinished("Charge") then
			if boss.State == 13 then
				sprlb:Play("Rebirth", true)
				boss:PlaySound(265 , 1, 0, false, 1)
			end
		end

		if boss.State == 13 and sprlb:IsFinished("Rebirth") then
			sprlb:Play("Idle", true)
			boss.State = 4
			boss.StateFrame = math.random(60,70)
		end

		if boss.State == 11 then
			if sprlb:IsPlaying("Throw") and sprlb:GetFrame() == 24 then
				boss:PlaySound(252, 1, 0, false, 1)
				local params = ProjectileParams()
				params.FallingAccelModifier = 0.5
				params.BulletFlags = 1 << 42 | ProjectileFlags.ACCELERATE
				params.Variant = 6
				params.Acceleration = 0.9
				boss:FireProjectiles(boss.Position, Vector.FromAngle(angle):Resized(dist*0.1), 0, params)
			end
			if sprlb:IsPlaying("Throw") and sprlb:GetFrame() == 37 then
				if boss.I2 > 0 then
					sprlb:Play("Throw", true)
					boss.I2 = boss.I2 - 1
					if boss.FlipX then
						boss.FlipX = false
					else
						boss.FlipX = true
					end
				end
			end
			if sprlb:IsFinished("Throw") then
				sprlb:Play("Idle", true)
				boss.State = 4
				boss.StateFrame = math.random(60,70)
				boss.FlipX = false
			end
		elseif boss.State == 10 then
			if sprlb:IsPlaying("Shoot3") and sprlb:GetFrame() == 11 then
				boss:PlaySound(226, 1, 0, false, 1)
				local params = ProjectileParams()
				params.HeightModifier = -13
				params.FallingAccelModifier = 0.45
				params.Color = Color(0.11,1.5,2,1,0,0,0)
				for i=0, math.random(8,17) do
					params.Scale = math.random(7,16)*0.1
					params.FallingSpeedModifier = -math.random(15,100)*0.1
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(50,100)*0.08), 0, params)
				end
				for i=0, math.random(1,3) do
					if i >= 1 then
						local fly = Isaac.Spawn(18, 0, 0, boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(50,80)*0.1), boss)
						fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
				end
			end
			if sprlb:IsFinished("Shoot3") then
				sprlb:Play("Idle", true)
				boss.State = 4
				if not data.hurtattack then
					boss.StateFrame = math.random(60,70)
				else
					data.hurtattack = false
				end
			end
		elseif boss.State == 8 then
			if sprlb:IsFinished("Charge") then
				boss:PlaySound(304 , 1, 0, false, 1)
				if boss.I1 <= 1 then
					sprlb:Play("Attack", true)
				else
					sprlb:Play("ShootStart", true)
					boss.StateFrame = 35
				end
			end

			if sprlb:IsFinished("ShootStart") then
				sprlb:Play("Shoot", true)
			end

			if boss.StateFrame <= 0 and sprlb:IsPlaying("Shoot") then
				sprlb:Play("ShootEnd", true)
			end

			if sprlb:IsPlaying("Attack")
			and sprlb:IsEventTriggered("shoot") then
				if boss.I1 == 0 then
					local params = ProjectileParams()
					params.HeightModifier = -13
					params.Variant = 11
					for i=0, 315, 45 do
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(9), 0, params)
					end
				elseif boss.I1 == 1 then
					for i=36, 324, 72 do
						local flame = Isaac.Spawn(1000, 10, 10, boss.Position ,Vector.FromAngle(i):Resized(10), boss):ToEffect()
						flame.EntityCollisionClass = 4
						flame.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
						flame.Timeout = 100
					end
				end
			end

			if sprlb:IsPlaying("ShootStart") or sprlb:IsPlaying("Shoot") then
				if boss.FrameCount % 3 == 0 and boss.StateFrame > 20 then
					local params = ProjectileParams()
					params.HeightModifier = -13
					params.Variant = 11
					boss:FireProjectiles(boss.Position, Vector.FromAngle(angle):Resized(10), 0, params)
				end
			end
		end

		if sprlb:IsPlaying("Shoot2Start") and sprlb:GetFrame() == 19 then
			data.boost = true
			EntityLaser.ShootAngle(3, boss.Position+Vector(0,10), 90, 999, Vector(-2,-50), boss)
		end

		if data.isdelirium then
			data.deliriumspeed = 0.5
		else
			data.deliriumspeed = 1
		end

		if data.boost then
			if boss.State == 9 then
				InitSpeed = boss.Velocity
				if boss.Position.X <= target.Position.X then
					boss.Velocity = (InitSpeed * 0.999) + Vector(0.3,-0.85*data.deliriumspeed)
				elseif boss.Position.X >= target.Position.X then
					boss.Velocity = (InitSpeed * 0.999) + Vector(-0.3,-0.85*data.deliriumspeed)
				end
			end
			if boss:CollidesWithGrid() or not boss:Exists() or boss:IsDead() then
				data.boost = false
				sprlb:Play("Shoot2End", true)
				boss:PlaySound(48, 1, 0, false, 1)
			end
		end

		for k, v in pairs(Entities) do
			if v.Type == 7 and v.SpawnerType == 400 then
				if not data.boost then
					v:ToLaser().Timeout = 1
				end
			end
			if v.Type == 1000 and v.Variant == 10
			and v.SpawnerType == 273 then
				v:Remove()
			end
			if (v.Type == 273 and v.Variant == 0)
			or (v.Type == 555 and v.Variant == 0) then
				local lspr = v:GetSprite()
				if lspr:GetFrame() == 1 then
					if lspr:IsPlaying("HeadStompUp") or lspr:IsPlaying("HeadStompDown") then
						sprlb:Play("StompHori", true)
						boss.State = 12
					elseif lspr:IsPlaying("HeadStompHori") then
						sprlb:Play("StompVert", true)
						boss.State = 12
					end
				end
				if v:IsDead() or not v:Exists() then
					boss.I1 = 1
				end
				if v:Exists() then
					boss.I1 = 0
				end
			end
		end

		if sprlb:IsPlaying("StompReady") then
			boss.State = 12
			if boss.I1 == 1 then
				boss.I2 = math.random(2,5)
			else
				boss.I2 = 0
			end
		end
		if sprlb:IsFinished("StompReady") then
			sprlb:Play("StpReadyLoop", true)
		end
		if boss.State == 12 and not sprlb:IsPlaying("StompReady") then
			if Room:GetRoomShape() >= 8 then
				boss.Velocity = Vector.FromAngle((Vector(560,440) - boss.Position):GetAngleDegrees())
				:Resized(Vector(560,440):Distance(boss.Position)*0.14)
			elseif Room:GetRoomShape() >= 6 then
				boss.Velocity = Vector.FromAngle((Vector(560,280) - boss.Position):GetAngleDegrees())
				:Resized(Vector(560,280):Distance(boss.Position)*0.14)
			elseif Room:GetRoomShape() >= 4 then
				boss.Velocity = Vector.FromAngle((Vector(320,440) - boss.Position):GetAngleDegrees())
				:Resized(Vector(320,440):Distance(boss.Position)*0.14)
			else
				boss.Velocity = Vector.FromAngle((Vector(320,280) - boss.Position):GetAngleDegrees())
				:Resized(Vector(320,280):Distance(boss.Position)*0.14)
			end
			if boss.I2 > 0 then
				if sprlb:IsPlaying("StpReadyLoop") and boss.Velocity:Length() <= 0.2 then
					if math.random(1,2) == 1 then
						sprlb:Play("StompHori", true)
						boss.I2 = boss.I2 - 1
					else
						sprlb:Play("StompVert", true)
						boss.I2 = boss.I2 - 1
					end
				end
				if sprlb:GetFrame() == 76 then
					if sprlb:IsPlaying("StompVert") then
						sprlb:Play("StompHori", true)
						boss.I2 = boss.I2 - 1
					elseif sprlb:IsPlaying("StompHori") then
						sprlb:Play("StompVert", true)
						boss.I2 = boss.I2 - 1
					end
				end
			end
			if sprlb:GetFrame() == 2 then
				if sprlb:IsPlaying("StompVert") then
					for i=-75, 75, 150 do
						Game():Spawn(507, 0, Room:GetCenterPos()+Vector(0,i), Vector(0,0), boss, -boss.I1+1, 0)
					end
				elseif sprlb:IsPlaying("StompHori") then
					for i=-170, 170, 340 do
						Game():Spawn(507, 0, Room:GetCenterPos()+Vector(i,0), Vector(0,0), boss, -boss.I1+1, 0)
					end
				end
			end

			if sprlb:IsFinished("StompVert") or sprlb:IsFinished("StompHori") then
				sprlb:Play("Idle", true)
				boss.State = 4
				boss.StateFrame = math.random(60,70)
			end
		end

		if boss:IsDead() then
			local poof = Isaac.Spawn(1000, 15, 0, boss.Position, Vector(0,0), boss)
			poof.SpriteOffset = Vector(0, -40)
			boss:PlaySound(261, 1, 0, false, 1)
			Game():Darken(1,230)
			if #Isaac.FindByType(273, 0, -1, true, true) > 0
			or #Isaac.FindByType(555, 0, -1, true, true) > 0 then
				Isaac.Spawn(400, 1, 0, boss.Position, Vector(0,0), boss)
				boss:Remove()
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.LambBody, 400)

----------------------------
--New Object:Lamb Body(Hard and Dead)
----------------------------
function denpnapi:DLambBody(object)

	if object.Variant == Isaac.GetEntityVariantByName("Lamb Body(Hard and Dead)") then

		local sprdlb = object:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		object:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		object:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		object:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		object.EntityCollisionClass = 1
		object:RemoveStatusEffects()
		object.SplatColor = Color(0.13,1.73,2.28,1.5,0,0,0)
		object.CanShutDoors = false

		object.Velocity = object.Velocity * 0.7

		if object.FrameCount == 1 then
			sprdlb:Play("death", true)
		end

		if object.FrameCount >= 230 and (#Isaac.FindByType(273, 0, -1, true, true) > 0
		or #Isaac.FindByType(555, 0, -1, true, true) > 0) then
			object:Morph(400, 0, 0, -1)
			local poof = Isaac.Spawn(1000, 15, 0, object.Position, Vector(0,0), object)
			poof.SpriteOffset = Vector(20, 0)
			poof:SetColor(Color(0,0,6,1,0,0,0), 99999, 0, false, false)
			object.EntityCollisionClass = 4
			if (bpattern or hdlamb) and Room:GetType() == 5 and Level:GetStage() == 11 then
				object.HitPoints = math.max(250, (250/60)*GetPlayerDps)
			else
				object.HitPoints = 250
			end
			object:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DLambBody, 400)

----------------------------
--Add Boss Pattern:Ultra Greed
----------------------------
function denpnapi:Ultigreed(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Ultra Greed")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprug = boss:GetSprite()
		local data = boss:GetData()
		local target = Game():GetPlayer(1)
		local dist = target.Position:Distance(boss.Position)
		local Entities = Isaac:GetRoomEntities()
		local rng = boss:GetDropRNG()
		local angle = (target.Position - boss.Position):GetAngleDegrees()

		if boss.State == 3 or boss.State == 4 then
			if boss.HitPoints <= boss.MaxHitPoints/2 and not data.Phase2 then
				sprug:Load("gfx/406.000_ultragreed_angry.anm2", true)
				sprug:Play("Shocked", true)
				boss.State = 15
			end
		end

		if data.Phase2 and boss.I2 < 3 then
			boss.I2 = boss.I2 + 1
		end

		if boss.State == 9 then
			if sprug:IsPlaying("SpinOnce2") then
				if sprug:GetFrame() == 15 then
					boss:PlaySound(252, 1, 0, false, 0.4)
					data.attackcount = data.attackcount - 1
					boss.Velocity = Vector.FromAngle(angle):Resized(12+(boss.I2*0.5))
					if not boss.FlipX then
						boss.FlipX = true
					else
						boss.FlipX = false
					end
				elseif sprug:GetFrame() >= 15 and sprug:GetFrame() <= 21 then
					local params = ProjectileParams()
					params.Scale = 1.5
					params.Variant = 7
					params.FallingAccelModifier = -0.15
					if boss.FlipX then
						for i=0, 30, 30 do
							boss:FireProjectiles(boss.Position,
							Vector.FromAngle((60*(sprug:GetFrame()-15))-i):Resized(10), 0, params)
						end
					else
						for i=0, 30, 30 do
							boss:FireProjectiles(boss.Position,
							Vector.FromAngle((-60*(sprug:GetFrame()-15))+i):Resized(10), 0, params)
						end
					end
				end
			end
			if sprug:IsFinished("SpinOnce2") then
				if data.attackcount > 0 then
					sprug:Play("SpinOnce2", true)
				else
					boss.State = 3
					boss.FlipX = false
				end
			end
		elseif boss.State == 10 then
			if sprug:IsFinished("JumpReady") then
				sprug:Play("Jump", true)
			end
			if sprug:IsPlaying("Jump") then
				if sprug:GetFrame() == 1 then
					Game():ShakeScreen(3)
					boss:PlaySound(14, 1, 0, false, 1)
					data.attackcount = data.attackcount - 1
					boss.Velocity = Vector.FromAngle(angle):Resized(dist*0.2)
				end
				if sprug:IsEventTriggered("Stomp") then
					boss:PlaySound(48, 1.5, 0, false, 1)
					Game():BombDamage(boss.Position, 40, 40, false, boss, 0, 1<<2, true)
					Game():ShakeScreen(20)
					Game():SpawnParticles(boss.Position, 88, 10, 20, Color(1,1,1,1,135,126,90), -4)
					local params = ProjectileParams()
					params.Variant = 7
					for i=1, 11+(boss.I2*0.5) do
						params.Scale = math.random(13,20)*0.1
						params.FallingSpeedModifier = -math.random(15,65)*0.1
						params.FallingAccelModifier = 0.3
						boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(5,15)), 0, params)
					end
					if boss.Position.X > target.Position.X then
						boss.FlipX = true
					else
						boss.FlipX = false
					end
				end
				if data.attackcount > 0 and sprug:GetFrame() == 34 then
					sprug:Play("Jump", true)
				end
			end
			if sprug:IsFinished("Jump") then
				boss.State = 3
			end
		elseif boss.State == 11 then
			if sprug:IsPlaying("BlastStart") and sprug:GetFrame() == 5 then
				boss:PlaySound(424, 1, 0, false, 1)
			end

			if sprug:IsEventTriggered("Blast") then
				boss:PlaySound(denpnapi.sounds.AngerScream, 1.2, 0, false, 0.8)
				local coinshot = EntityLaser.ShootAngle(1, boss.Position+Vector(0,5), 90, boss.StateFrame, Vector(0,-50), boss)
				coinshot.Angle = 90
				coinshot.Size = 80
			end

			if sprug:IsFinished("BlastStart") then
				sprug:Play("BlastLoop", true)
			elseif sprug:IsFinished("BlastEnd") then
				boss.State = 3
			end

			if sprug:IsPlaying("BlastLoop") then
				boss.StateFrame = boss.StateFrame - 1
				boss:AddVelocity(Vector(0,-3))
				if boss.StateFrame <= 0 then
					sprug:Play("BlastEnd", true)
				end
			end
		elseif boss.State == 15 then
			if sprug:IsPlaying("Shocked") and sprug:GetFrame() == 43 then
				boss:PlaySound(denpnapi.sounds.AngerScream, 1, 0, false, 1)
				data.Phase2 = true
				boss.I1 = 0
				Game():ShakeScreen(35)
			end
			if sprug:IsFinished("Shocked") then
				sprug:Play("Wrath", true)
			end
			if sprug:IsPlaying("Wrath") then
				if sprug:IsEventTriggered("Stomp2") then
					boss.I1 = boss.I1 + 1
					boss:PlaySound(48, 1.2, 0, false, 1)
					Game():ShakeScreen(15)
					local params = ProjectileParams()
					params.Variant = 7
					for i=0, math.random(1,3) do
						if i ~= 0 then
							if math.random(1,3) == 1 then
								params.Scale = 1.5
								params.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER
								| ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
								params.ChangeTimeout = 10
								params.ChangeFlags = 2
							else
								params.Scale = 1
								params.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER
								| ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
								params.ChangeTimeout = 10
								params.ChangeFlags = 0
							end
							params.FallingSpeedModifier = 0
							params.HeightModifier = -300
							params.FallingAccelModifier = 0.6
							boss:FireProjectiles(Isaac.GetRandomPosition(0), Vector(math.random(-10,10)*0.1,math.random(-10,10)*0.1), 0, params)
						end
					end
				end
				if sprug:GetFrame() == 9 then
					if boss.I1 < 17 then
						sprug:Play("Wrath", true)
					end
				end
			end
			if sprug:IsFinished("Wrath") then
				sprug:Play("Idle", true)
				boss.StateFrame = 150
			end
			if sprug:IsPlaying("Idle") then
				boss.StateFrame = boss.StateFrame - 1
				if sprug:GetFrame() == 18 then
					boss:PlaySound(14, 1, 0, false, 0.7)
				end
				if boss.StateFrame <= 0 then
					boss.State = 3
				end
			end
			if sprug:IsFinished("JumpReady") then
				sprug:Play("LowJump", true)
			end
		elseif boss.State == 19 then
			if sprug:IsPlaying("SmashLeft") or sprug:IsPlaying("SmashRight") then
				if sprug:GetFrame() == 20 then
					boss:PlaySound(48, 1.4, 0, false, 0.75)
					Game():ShakeScreen(20)
					for i=0, math.random(2,4) do
						Isaac.Spawn(1000, 353, 0, Isaac.GetRandomPosition(0), Vector(0,0), boss)
					end
				end
			end
			if sprug:IsFinished("SmashLeft") or sprug:IsFinished("SmashRight") then
				data.attackcount = data.attackcount - 1
				if data.attackcount > 0 then
					if sprug:IsFinished("SmashLeft") then
						sprug:Play("SmashRight", true)
					elseif sprug:IsFinished("SmashRight") then
						sprug:Play("SmashLeft", true)
					end
				else
					sprug:Play("Idle", true)
					boss.State = 3
				end
			end
		elseif boss.State == 26 then
			if sprug:IsFinished("JumpReady") then
				sprug:Play("LowJump", true)
			end
			if sprug:IsEventTriggered("jump") then
				boss:PlaySound(14, 1, 0, false, 1)
				Game():ShakeScreen(10)
				boss.EntityCollisionClass = 0
				if sprug:IsPlaying("JumpUp") then
					boss.Velocity = Vector.FromAngle((target.Position-boss.Position):GetAngleDegrees())
					:Resized(target.Position:Distance(boss.Position)*0.06)
				elseif sprug:IsPlaying("LowJump") then
					boss.Velocity = Vector(0,-20)
				end
			end
			if sprug:IsFinished("JumpUp") then
				sprug:Play("JumpDown", true)
			end
			if (sprug:IsPlaying("JumpDown") or sprug:IsPlaying("LowJump"))
			and sprug:IsEventTriggered("Stomp") then
				boss.EntityCollisionClass = 4
				if sprug:IsPlaying("JumpDown") then
					boss:PlaySound(138, 1, 0, false, 1)
					Game():BombDamage(boss.Position, 40, 40, false, boss, 0, 1<<2, true)
					local shockwave2 = Isaac.Spawn(1000, 61, 0, boss.Position, Vector(0,0), boss):ToEffect()
					shockwave2.Parent = boss
					shockwave2.MaxRadius = 250
					shockwave2.Timeout = 40
					Game():ShakeScreen(20)
				elseif sprug:IsPlaying("LowJump") then
					boss:PlaySound(48, 1, 0, false, 1)
					Game():BombDamage(boss.Position, 10, 40, false, boss, 0, 1<<2, true)
					Game():ShakeScreen(10)
				end
			end
			if sprug:IsFinished("JumpDown") then
				boss.State = 3
			end
			if sprug:IsFinished("LowJump") then
				if boss.I1 == 1 then
					if math.random(1,2) == 1 then
						sprug:Play("SmashLeft", true)
					else
						sprug:Play("SmashRight", true)
					end
					boss.State = 19
					data.attackcount = math.random(4,6)+(boss.I2/3)
					boss:PlaySound(433, 1, 0, false, 1)
				elseif boss.I1 == 2 then
					boss.State = 11
					sprug:Play("BlastStart", true)
					boss.StateFrame = math.random(120,135)
				end
			end
		end

		if boss.State >= 9 and boss.EntityCollisionClass ~= 0 then
			if boss.State == 11 or boss.State == 19 then
				boss.Velocity = boss.Velocity * 0.1
			else
				boss.Velocity = boss.Velocity * 0.7
			end
		end

		if (sprug:IsFinished("BlastEnd") or sprug:IsFinished("SpinOnce2")
		or sprug:IsFinished("Jump")) and boss.State < 3 then
			sprug:Play("Idle", true)
			boss.State = 3
		end

		if sprug:IsEventTriggered("Jump") then
			boss.EntityCollisionClass = 0
		end
		if sprug:IsEventTriggered("Stomp") then
			boss.EntityCollisionClass = 4
		end

		if data.Phase2 then
			if boss.State == 8 and sprug:IsPlaying("Tantrum")
			and (sprug:IsEventTriggered("Stomp1") or sprug:IsEventTriggered("Stomp2")) then
				local params = ProjectileParams()
				params.Variant = 7
				for i=0, math.random(1,3) do
					if i ~= 0 then
						params.Scale = 1.5
						params.FallingSpeedModifier = 0
						params.HeightModifier = -300
						params.FallingAccelModifier = 0.6
						params.BulletFlags = ProjectileFlags.CANT_HIT_PLAYER
						| ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT
						params.ChangeTimeout = 10
						params.ChangeFlags = 0
						boss:FireProjectiles(Isaac.GetRandomPosition(0), Vector(math.random(-10,10)*0.1,math.random(-10,10)*0.1), 0, params)
					end
				end
			end
			if sprug:IsPlaying("SpinStart") and sprug:GetFrame() == 1
			and math.random(1,3) == 1 then
				boss.State = 9
				sprug:Play("SpinOnce2", true)
				data.attackcount = math.random(3,6)+(boss.I2/3)
			end
			if ((sprug:IsPlaying("ShootUp") or sprug:IsPlaying("ShootDown")
			or sprug:IsPlaying("ShootLeft") or sprug:IsPlaying("ShootRight"))
			and sprug:GetFrame() == 1) or (boss.State >= 3 and boss.State <= 4
			and boss.FrameCount % 35 == 0) then
				if math.random(1,8) == 1 then
					boss.State = 10
					sprug:Play("JumpReady", true)
					data.attackcount = math.random(2,4)+(boss.I2/3)
				elseif math.random(1,8) == 2 then
					boss.State = 26
					sprug:Play("JumpUp", true)
				elseif math.random(1,8) == 3 then
					if boss.Position.Y >= 650 then
						boss.I1 = 1
						sprug:Play("JumpReady", true)
						boss.State = 26
					else
						if math.random(1,8) == 1 then
							sprug:Play("SmashLeft", true)
						else
							sprug:Play("SmashRight", true)
						end
						boss.State = 19
						data.attackcount = math.random(4,6)+(boss.I2/3)
						boss:PlaySound(433, 1, 0, false, 1)
					end
				elseif math.random(1,8) == 4 then
					if boss.Position.Y >= 600 then
						boss.I1 = 2
						sprug:Play("JumpReady", true)
						boss.State = 26
					else
						boss.State = 11
						sprug:Play("BlastStart", true)
						boss.StateFrame = math.random(120,135)
					end
				end
			end
		end

		for k, v in pairs(Entities) do
			local dist3 = v.Position:Distance(boss.Position)

			if v.EntityCollisionClass > 0 and (sprug:IsPlaying("SpinOnce2")
			and (sprug:GetFrame() >= 28 and sprug:GetFrame() <= 34))
			and boss.State == 9 then
				if dist <= 55 + target.Size then
					target.Velocity = Vector.FromAngle(angle):Resized(dist*0.2)
					target:TakeDamage(2, 0, EntityRef(boss), 5)
				end

				if v:IsVulnerableEnemy() and v.Type ~= 406 then
					if dist3 <= 55 + v.Size then
						v.Velocity = Vector.FromAngle(angle):Resized(dist*0.2)
						v:TakeDamage(40, 0, EntityRef(boss), 5)
					end
				end
			end

		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Ultigreed, 406)

----------------------------
--Add Boss Pattern:Ultra Greedier
----------------------------
function denpnapi:Ultigreedier(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Ultra Greedier") then

		local sprug2 = boss:GetSprite()
		local data = boss:GetData()
		local target = Game():GetPlayer(1)
		local dist = target.Position:Distance(boss.Position)
		local Entities = Isaac:GetRoomEntities()
		local rng = boss:GetDropRNG()
		local angle = (target.Position - boss.Position):GetAngleDegrees()
		boss:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		InitSpeed = boss.Velocity

		if not data.ChangedHPG then
			boss.MaxHitPoints = math.max(boss.MaxHitPoints, (boss.MaxHitPoints/145)*GetPlayerDps)
			if boss.HitPoints < boss.MaxHitPoints then
				boss.HitPoints = boss.MaxHitPoints
			end
			data.ChangedHPG = true
		end

		if boss.State == 1 then
			data.moveX = 0
			data.Sstomp = false
			data.tripgauge = 0
			data.firstcollide = false
		end

		if boss.HitPoints / boss.MaxHitPoints <= 0.5 and not data.TwoPhase then
			sprug2:Play("Hurt", true)
			boss.State = 15
			data.TwoPhase = true
			boss:PlaySound(427, 1, 0, false, 2)
			boss.StateFrame = 35
			Game():SpawnParticles(boss.Position, 98, 20, 10, Color(1.1,1,1,1,0,0,0), -50)
		end

		if data.TwoPhase and (boss.State == 3 or boss.State == 4) then
			if boss.FrameCount % 70 <= 7 and math.random(1,3) == 1 then
				data.smash = false
				if math.random(1,6) > 3 then
					if math.abs(boss.Position.Y-target.Position.Y) <= 120 then
						if boss.Position.X > target.Position.X then
							boss.FlipX = true
						else
							boss.FlipX = false
						end
						sprug2:Play("Punch", true)
						data.smash = false
						boss.State = 21
						boss:PlaySound(312, 0.65, 0, false, 0.6)
						data.firstcollide = false
					end
				elseif math.random(1,6) > 1 then
					sprug2:Play("SpinStart", true)
					boss.State = 11
					boss.StateFrame = math.random(100,160)
					boss:PlaySound(433, 1, 0, false, 1)
				else
					if boss:GetAliveEnemyCount() <= 3 then
						sprug2:Play("Summon", true)
						boss.State = 10
						boss:PlaySound(433, 1, 0, false, 1)
						boss.StateFrame = 35
					end
				end
			end
			if math.random(1,3) == 1 and dist <= 200 and boss.FrameCount % 20 == 0 then
				sprug2:Play("SpinOnce", true)
				boss.State = 11
				boss:PlaySound(433, 1, 0, false, 1)
			elseif math.random(1,3) == 2 and boss.Position.Y <= 420
			and math.abs(boss.Position.X-target.Position.X) <= 60 then
				sprug2:Play("DashStart", true)
				boss.State = 22
				boss:PlaySound(432, 1, 0, false, 1)
				data.tripgauge = 0
			end
		end

		if sprug2:IsPlaying("Smash") and data.TwoPhase then
			data.smash = true
		end

		if boss.State <= 4 and data.smash then
			data.smash = false
			boss.State = 720
			sprug2:Play("Smash2", true)
		end

		if boss.State == 6 then
			if data.TwoPhase and sprug2:IsPlaying("JumpUp") then
				boss.State = 66
				boss.I1 = rng:RandomInt(3)
			end
		elseif boss.State == 10 then
			if sprug2:IsFinished("Hurt") or sprug2:IsFinished("Summon") then
				boss.Velocity = Vector.FromAngle(angle):Resized(2.5)
				if boss:GetAliveEnemyCount() <= 1 then
					boss.StateFrame = boss.StateFrame - 1
					if boss.StateFrame <= 0 then
						sprug2:Play("JumpDown", true)
						boss.State = 66
						boss.EntityCollisionClass = 0
					end
				end
			end
			if sprug2:IsPlaying("Summon") then
				if sprug2:GetFrame() == 78 then
					boss:PlaySound(48, 0.65, 0, false, 2)
				elseif sprug2:GetFrame() == 85 then
					boss:PlaySound(190, 0.5, 0, false, 1.5)
					boss.EntityCollisionClass = 0
				end
			elseif sprug2:IsPlaying("Hurt") then
				if sprug2:GetFrame() == 117 then
					boss:PlaySound(48, 0.65, 0, false, 2)
				elseif sprug2:GetFrame() == 124 then
					boss:PlaySound(190, 0.5, 0, false, 1.5)
					boss.EntityCollisionClass = 0
				end
			end
			boss.Velocity = boss.Velocity * 0.7
			sprug2.PlaybackSpeed = 1
		elseif boss.State == 11 then
			boss.StateFrame = boss.StateFrame - 1
			boss.ProjectileCooldown = boss.ProjectileCooldown - 1
			if boss.FrameCount % 65 == 0 or boss:CollidesWithGrid()
			or boss.TargetPosition:Distance(boss.Position) <= 80 then
				if math.random(1,3) == 1 then
					boss.TargetPosition = Vector(math.random(0,1200), math.random(0,700))
				end
			end
			if sprug2:IsFinished("SpinOnce") or sprug2:IsFinished("SpinEnd") then
				boss.State = 3
				sound:Stop(440)
			end
			if sprug2:IsFinished("SpinStart") then
				sprug2:Play("SpinConstant", true)
			end
			if sprug2:IsPlaying("SpinConstant") and boss.StateFrame <= 0 then
				sprug2:Play("SpinEnd", true)
				sound:Stop(440)
			end
			if sprug2:IsPlaying("SpinOnce") then
				if sprug2:GetFrame() == 5 then
					boss:PlaySound(440, 3, 0, true, 1)
				end
				if sprug2:GetFrame() >= 4 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.1
					params.Scale = 1.5
					params.Variant = 7
					params.BulletFlags = 2
					boss:FireProjectiles(boss.Position, Vector.FromAngle((sprug2:GetFrame()-5)*51.4):Resized(15), 0, params)
				end
			elseif sprug2:IsPlaying("SpinConstant") then
				boss:PlaySound(440, 1, 0, false, 1)
				if boss.FrameCount % 17 == 0 then
					local params = ProjectileParams()
					params.Scale = 1.5
					params.Variant = 7
					params.BulletFlags = 2
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(45,80)*0.1), 0, params)
				end
				if boss:CollidesWithGrid() and boss.Velocity:Length() >= 3 then
					Game():SpawnParticles(boss.Position, 95, 30, 10, Color(1.1,1,1,1,0,0,0), -50)
					boss.ProjectileCooldown = 15
					boss:PlaySound(48, 1, 0, false, 1)
					for i=0, 320, 40 do
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.1
						params.Scale = 1.5
						params.Variant = 7
						params.BulletFlags = 2
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i+boss.Velocity:GetAngleDegrees()):Resized(13), 0, params)
					end
					Game():ShakeScreen(20)
					boss.Velocity = boss.Velocity * 2
				end
				if boss.ProjectileCooldown <= 0 then
					boss.Velocity = (boss.Velocity * 0.9999)
					+ Vector.FromAngle((boss.TargetPosition-boss.Position):GetAngleDegrees()):Resized(1.5)
				end
			end
			boss.Velocity = boss.Velocity * 0.9
			sprug2.PlaybackSpeed = 1
		elseif boss.State == 21 then
			if sprug2:IsPlaying("Punch") then
				if sprug2:GetFrame() == 22 then
					Game():ShakeScreen(10)
					boss:PlaySound(182, 1, 0, false, 1)
					if boss.FlipX then
						data.moveX = -1
						boss.Velocity = Vector(-100, boss.Velocity.Y)
					else
						data.moveX = 1
						boss.Velocity = Vector(100, boss.Velocity.Y)
					end
				elseif sprug2:GetFrame() == 70 then
					boss:PlaySound(252, 1, 0, false, 0.4)
					boss:PlaySound(433, 1, 0, false, 1)
					Game():ShakeScreen(10)
					Game():SpawnParticles(boss.Position, 95, 20, 10, Color(1.1,1,1,1,0,0,0), -50)
				end
				if sprug2:GetFrame() >= 70 and sprug2:GetFrame() <= 75 then
					if boss.FlipX then
						for i=180-((sprug2:GetFrame()-70)*40), 160-((sprug2:GetFrame()-70)*40), -20 do
							local params = ProjectileParams()
							params.FallingAccelModifier = -0.1
							params.Scale = 1.5
							params.Variant = 7
							params.BulletFlags = 2
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(10), 0, params)
						end
					else
						for i=(sprug2:GetFrame()-70)*40, 20+((sprug2:GetFrame()-70)*40), 20 do
							local params = ProjectileParams()
							params.FallingAccelModifier = -0.1
							params.Scale = 1.5
							params.Variant = 7
							params.BulletFlags = 2
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(10), 0, params)
						end
					end
				end
				if sprug2:GetFrame() >= 22 and sprug2:GetFrame() <= 69 then
					if boss.Velocity:Length() > 10 then
						local aftimage = Isaac.Spawn(1000, 366, 0, boss.Position, Vector(0,0), boss)
						aftimage.FlipX = boss.FlipX
						aftimage:GetSprite():Load(sprug2:GetFilename(), true)
						aftimage:GetSprite():SetFrame("Punch", sprug2:GetFrame())
						Game():BombDamage(boss.Position+Vector((data.moveX*130),0), 30, 20, true, boss, 0, 1<<2, false)
						Game():SpawnParticles(boss.Position, 95, 3, 10, Color(1.1,1,1,1,0,0,0), -3)
						local params = ProjectileParams()
						params.FallingSpeedModifier = -math.random(45,60) * 0.1
						params.FallingAccelModifier = 0.3
						params.Scale = math.random(10,13) * 0.1
						params.Variant = 7
						boss:FireProjectiles(boss.Position, Vector(-data.moveX*math.random(3,5),math.random(-5,5)), 0, params)
					end
					if (not boss.FlipX and boss.Position.X >= Room:GetBottomRightPos().X-135)
					or (boss.FlipX and boss.Position.X <= 210) then
						if boss.FlipX then
							boss.Position = Vector(210, boss.Position.Y)
						else
							boss.Position = Vector(Room:GetBottomRightPos().X-135, boss.Position.Y)
						end
						if boss.Velocity:Length() > 7 and not data.firstcollide then
							boss:PlaySound(52, 1, 0, false, 1)
							data.firstcollide = true
							Game():ShakeScreen(20)
							for i=0, math.random(9,17) do
								local params = ProjectileParams()
								params.FallingSpeedModifier = -math.random(75,125) * 0.1
								params.FallingAccelModifier = 0.45
								params.HeightModifier = -20
								params.Scale = math.random(10,15) * 0.1
								params.Variant = 7
								boss:FireProjectiles(boss.Position+Vector(data.moveX*115,0), Vector(-data.moveX*math.random(6,12),math.random(-5,5)), 0, params)
							end
						elseif boss.Velocity:Length() > 2 then
							boss:PlaySound(48, 1, 0, false, boss.Velocity:Length()/5)
						end
						boss.Velocity = Vector(0, boss.Velocity.Y)
					end
				end
			else
				boss.State = 3
			end
		elseif boss.State == 22 then
			if sprug2:IsPlaying("DashStart") and sprug2:GetFrame() == 23 then
				sprug2:Play("DashDown", true)
				boss.I1 = 1
			end
			if sprug2:IsFinished("DashStop") or sprug2:IsFinished("Trip") then
				boss.State = 3
				boss.I1 = 0
			end
			if boss.I1 == 1 then
				boss.Velocity = Vector(0,20)
			end
			if sprug2:IsEventTriggered("Stomp1") or sprug2:IsEventTriggered("Stomp2") then
				boss:PlaySound(48, 1, 0, false, 1)
			end
			if sprug2:IsPlaying("DashDown") then
				Game():SpawnParticles(boss.Position, 88, 1, 8, Color(1,1,1,1,135,126,90), 0)
				local params = ProjectileParams()
				params.HeightModifier = math.random(-70,5)
				params.FallingAccelModifier = -0.05
				params.Scale = math.random(8,12) * 0.1
				params.Variant = 7
				boss:FireProjectiles(boss.Position+Vector(math.random(-85,85),0), Vector.FromAngle(math.random(260,280)):Resized(math.random(0,20)*0.1), 0, params)
				if boss:CollidesWithGrid() then
					boss:PlaySound(52, 1, 0, false, 0.85)
					Game():ShakeScreen(20)
					for i=180, 360, 15 do
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.165
						params.Scale = 2
						params.Variant = 7
						params.BulletFlags = 2
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(12), 0, params)
					end
					sprug2:Play("DashStop", true)
				end
				if data.tripgauge >= math.max(25, 2.5*GetPlayerDps) then
					boss.I1 = 0
					sprug2:Play("Trip", true)
				end
			elseif sprug2:IsPlaying("Trip") then
				if sprug2:GetFrame() == 10 then
					Game():SpawnParticles(boss.Position, 88, 1, 13, Color(1,1,1,1,135,126,90), 0)
					boss:PlaySound(52, 1, 0, false, 1)
					Game():ShakeScreen(20)
					local params = ProjectileParams()
					params.Variant = 7
					for i=0, math.random(6,10) do
						params.FallingSpeedModifier = -math.random(35,65) * 0.1
						params.FallingAccelModifier = 0.3
						params.Scale = math.random(13,20) * 0.1
						boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(5,13)), 0, params)
					end
					for i=0, 324, 36 do
						params.FallingSpeedModifier = -3
						params.FallingAccelModifier = 0.1
						params.Scale = 2
						params.BulletFlags = 2
						boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(12), 0, params)
					end
				end
			end
		elseif boss.State == 66 then
			if sprug2:IsPlaying("JumpUp") then
				boss.Velocity = boss.Velocity * 0.7
			elseif sprug2:IsPlaying("JumpDown2") then
				boss.Velocity = boss.Velocity * 0.7
				if sprug2:GetFrame() == 30 and boss.I1 > 0 then
					sprug2:Play("JumpUp2", true)
					boss.I1 = boss.I1 - 1
				end
			end
			if sprug2:IsEventTriggered("Jump") then
				boss:PlaySound(14, 1, 0, false, 1)
				Game():ShakeScreen(10)
				boss.EntityCollisionClass = 0
				boss.TargetPosition = target.Position
				Game():SpawnParticles(boss.Position, 95, 20, 10, Color(1.1,1,1,1,0,0,0), -30)
			end
			if sprug2:IsFinished("JumpUp") or sprug2:IsFinished("JumpUp2") then
				boss.Velocity = Vector.FromAngle((boss.TargetPosition-boss.Position):GetAngleDegrees())
				:Resized(5)
				Game():SpawnParticles(boss.Position, 95, 1, 1, Color(1.1,1,1,1,0,0,0), -500)
				if math.random(1,4) == 1 then
					local params = ProjectileParams()
					params.HeightModifier = -500
					params.FallingAccelModifier = 1.2
					params.Scale = math.random(10,15) * 0.1
					params.Variant = 7
					params.BulletFlags = 2
					boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(5,20)*0.1), 0, params)
				end
				if boss.TargetPosition:Distance(boss.Position) <= 75 then
					sprug2:Play("JumpDown2", true)
				end
			end
			if sprug2:IsEventTriggered("Stomp") then
				boss:PlaySound(138, 1, 0, false, 1)
				Game():SpawnParticles(boss.Position, 95, 30, 15, Color(1.1,1,1,1,0,0,0), -5)
				if sprug2:IsPlaying("JumpDown2") then
					boss:PlaySound(52, 1, 0, false, 1)
					if math.random(1,2) == 1 then
						local cshock = Isaac.Spawn(1000, 368, 0, boss.Position, Vector(0,0), boss)
						cshock.Parent = boss
					else
						for i=0,288,72 do
							local GCrkWave = Isaac.Spawn(1000, 371, 0, boss.Position, Vector(0,0), boss):ToEffect()
							GCrkWave.Parent = boss
							GCrkWave.Rotation = i
						end
					end
				else
					for i=0, 270, 90 do
						local cwave = Isaac.Spawn(1000, 72, 0, boss.Position, Vector(0,0), boss)
						cwave.Parent = boss
						cwave:ToEffect().Rotation = i
					end
				end
				Game():ShakeScreen(20)
				boss.EntityCollisionClass = 4
			end
			if sprug2:IsFinished("JumpDown") or sprug2:IsFinished("JumpDown2") then
				boss.State = 3
			end
		elseif boss.State == 720 then
			if sprug2:IsPlaying("Smash2") then
				if sprug2:GetFrame() == 5 then
					boss:PlaySound(432, 1, 0, false, 1)
				elseif sprug2:GetFrame() == 32 then
					boss:PlaySound(138, 1, 0, false, 1)
					Game():ShakeScreen(20)
					Game():BombDamage(boss.Position+Vector(0,50), 40, 80, true, boss, 0, 1<<2, true)
					local explode = Isaac.Spawn(1000, 1, 0, boss.Position+Vector(0,50), Vector(0,0), boss)
					explode:SetColor(Color(2,2,1,1,0,0,0), 99999, 0, false, false)
					explode:GetSprite().Scale = Vector(2,2)
					local GWaveRadi = Isaac.Spawn(1000, 370, 0, boss.Position+Vector(0,50), Vector(0,0), boss)
					GWaveRadi.Parent = boss
					GWaveRadi:ToEffect().MaxRadius = 700
					GWaveRadi:ToEffect().Timeout = 60
				end
			else
				boss.State = 3
			end
		end

		if boss.State == 21 or boss.State == 22 or (boss.State == 66
		and sprug2:WasEventTriggered("Stomp")) or boss.State == 720 then
			boss.Velocity = boss.Velocity * 0.7
		end

		if (boss.State == 21 or boss.State == 22 or boss.State == 66) and sprug2.PlaybackSpeed < 1 then
			sprug2.PlaybackSpeed = 1
		end

		if not boss:Exists() then
			sound:Stop(440)
		end

		if sprug2:IsEventTriggered("Call") then
			boss:PlaySound(432, 1.5, 0, false, 1)
			boss.State = 10
		end

		if boss.State == 15 then
			boss.Velocity = boss.Velocity * 0.7
			sprug2.PlaybackSpeed = 1
		end

		if sprug2:IsEventTriggered("Cracking") then
			boss:PlaySound(427, 1, 0, false, 2)
			Game():SpawnParticles(boss.Position, 95, 30, 10, Color(1.1,1,1,1,0,0,0), -50)
		end

		for k, v in pairs(Entities) do
			local dist3 = v.Position:Distance(boss.Position)
			if v.EntityCollisionClass > 0 then
				if (sprug2:IsPlaying("SpinOnce2") and sprug2:GetFrame() >= 5)
				or sprug2:IsPlaying("SpinConstant") then
					if dist <= 55 + target.Size then
						target.Velocity = Vector.FromAngle(angle):Resized(dist*0.2)
						target:TakeDamage(2, 0, EntityRef(boss), 5)
					end
					if v:IsVulnerableEnemy() and v.Type ~= 406 then
						if dist3 <= 55 + v.Size then
							v.Velocity = Vector.FromAngle(angle):Resized(dist*0.2)
							v:TakeDamage(40, 0, EntityRef(boss), 5)
						end
					end
				end
			end
		end

		if boss:IsDead() then
			data.smash = false
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Ultigreedier, 406)

----------------------------
--Add Boss Pattern:Hush
----------------------------
function denpnapi:Hush(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Hush")
	and (Game().Difficulty == 1 or Game().Difficulty == 3) then

		local sprhs = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		local angle = (target.Position - boss.Position):GetAngleDegrees()
	
		if boss.State == 600 then
			if sprhs:IsPlaying("FaceAppearDown") or not data.FAW then
				data.FAW = "Down"
			elseif sprhs:IsPlaying("FaceAppearLeft") then
				data.FAW = "Left"
			elseif sprhs:IsPlaying("FaceAppearRight") then
				data.FAW = "Right"
			elseif sprhs:IsPlaying("FaceAppearUp") then
				data.FAW = "Up"
			end
		end
	
		if boss.State == 600 and boss.HitPoints / boss.MaxHitPoints <= 0.8 then
			if sprhs:IsPlaying("FaceAppear"..data.FAW) and sprhs:GetFrame() == 12
			and math.random(1,2) == 1 then
				boss.State = 601
				boss.I2 = math.random(0,299)
				boss.StateFrame = math.random(200,350)
				sprhs:Play("AttackLoop"..data.FAW, true)
			end
		end
	
		if boss.State == 601 then
			boss.StateFrame = boss.StateFrame - 1
			if data.FAW == "Down" then
				bltpos = boss.Position + Vector(46,-60)
				bltpos2 = boss.Position + Vector(-56,-59)
				bltpos3 = boss.Position + Vector(0,-35)
				direction = 90
			elseif data.FAW == "Left" then
				bltpos = boss.Position + Vector(-24,9)
				bltpos2 = boss.Position + Vector(-55,-72)
				bltpos3 = boss.Position + Vector(-78,-20)
				direction = 180
			elseif data.FAW == "Right" then
				bltpos = boss.Position + Vector(52,-76)
				bltpos2 = boss.Position + Vector(28,7)
				bltpos3 = boss.Position + Vector(80,-31)
				direction = 0
			elseif data.FAW == "Up" then
				bltpos = boss.Position + Vector(-55,-45)
				bltpos2 = boss.Position + Vector(51,-46)
				bltpos3 = boss.Position + Vector(0,-70)
				direction = 270
			end
			if boss.StateFrame > 20 then
				if boss.I2 % 4 <= 2 then
					local eye1 = ProjectileParams()
					eye1.HeightModifier = -10
					eye1.Variant = 6
					eye1.FallingSpeedModifier = 0
					eye1.FallingAccelModifier = -0.17
					if boss.I2 % 4 == 0 and boss.StateFrame % 3 == 0 then
						eye1.BulletFlags = 1 << 21
						eye1.Color = Color(1,1,1,1,70,70,0)
						boss:FireProjectiles(bltpos,
						Vector.FromAngle(direction-(boss.FrameCount*6)):Resized(3), 0, eye1)
					elseif boss.I2 % 4 == 1 and boss.StateFrame % 30 == 0 then
						eye1.Color = Color(1,1,1,1,70,70,0)
						for i=0, 340, 20 do
							boss:FireProjectiles(bltpos, Vector.FromAngle((target.Position - bltpos):GetAngleDegrees()+i):Resized(5), 0, eye1)
						end
					elseif boss.I2 % 4 == 2 and boss.StateFrame % 70 <= 10
					and boss.StateFrame % 2 == 0 then
						eye1.BulletFlags = 1 << 27 | 1 << 32
						eye1.Acceleration = 0.96
						eye1.ChangeTimeout = 75
						eye1.ChangeFlags = 1 << 37
						eye1.HomingStrength = 0.55
						eye1.Color = Color(1,1,1,1,20,50,20)
						boss:FireProjectiles(bltpos, Vector.FromAngle(angle):Resized(6.5), 0, eye1)
					end
				end
				if boss.I2 % 40 >= 10 then
					local eye2 = ProjectileParams()
					eye2.HeightModifier = -10
					eye2.Variant = 6
					eye2.FallingSpeedModifier = 0
					eye2.FallingAccelModifier = -0.17
					if boss.I2 % 40 >= 30 then
						if boss.StateFrame % 3 == 0 then
							eye2.BulletFlags = 1 << 21
							eye2.Color = Color(1,1,1,1,70,70,0)
							boss:FireProjectiles(bltpos2,
							Vector.FromAngle(direction+(boss.FrameCount*6)):Resized(3), 0, eye2)
						end
					elseif boss.I2 % 40 >= 20 then
						if boss.StateFrame % 13 == 0 then
							eye2.Color = Color(1,1,1,1,0,0,70)
							boss:FireProjectiles(bltpos2,
							Vector.FromAngle((target.Position - bltpos2):GetAngleDegrees()):Resized(7.5), 0, eye2)
						end
					elseif boss.I2 % 40 >= 10 then
						if boss.FrameCount % 70 <= 30 and boss.StateFrame % 2 == 0 then
							eye2.Color = Color(1,1,1,1,20,50,20)
							boss:FireProjectiles(bltpos2,
							Vector.FromAngle(direction + (boss.FrameCount % 70)*6):Resized(7), 0, eye2)
						end
					end
				end
				local mouth = ProjectileParams()
				mouth.Variant = 6
				mouth.HeightModifier = -3.5
				mouth.FallingSpeedModifier = 0
				mouth.FallingAccelModifier = -0.17
				if boss.I2 >= 200 then
					if boss.StateFrame % 30 == 0 then
						mouth.Color = Color(1,1,1,1,0,0,70)
						boss:FireProjectiles(bltpos3,
						Vector.FromAngle((target.Position - bltpos3):GetAngleDegrees()):Resized(7), 5, mouth)
					end
				elseif boss.I2 >= 100 then
					if boss.StateFrame % 5 == 0 then
						mouth.Color = Color(1,1,1,1,70,35,0)
						for i=-15, 15, 30 do
							boss:FireProjectiles(bltpos3,
							Vector.FromAngle((target.Position - bltpos3):GetAngleDegrees()+i):Resized(13), 0, mouth)
						end
					end
				else
					if boss.StateFrame % 45 == 0 then
						mouth.BulletFlags = 1 << 41
						mouth.CurvingStrength = 0.005 * (1-(math.random(0,1)*2))
						mouth.Color = Color(1,1,1,1,70,35,0)
						for i=0, 355, 5 do
							if not ((i >= 0 and i <= 25) or (i >= 180 and i <= 205)) and math.random(1,2) ~= 1 then
								boss:FireProjectiles(bltpos3, Vector.FromAngle(angle+i):Resized(5.3), 0, mouth)
							end
						end
					end
				end
			end
			if boss.StateFrame <= 0 then
				if sprhs:IsPlaying("AttackLoop"..data.FAW) then
					sprhs:Play("FaceVanishFrom"..data.FAW, true)
				end
				if sprhs:IsFinished("FaceAppearDown") then
					sprhs:Play("Wiggle", true)
					boss.State = 3
				end
			end
			if sprhs:IsFinished("FaceVanishFrom"..data.FAW) then
				sprhs:Play("FaceAppearDown", true)
			end
		end
	
		if boss.HitPoints/boss.MaxHitPoints <= 0.4
		and #Isaac.FindByType(608, -1, -1, true, true) == 0
		and not data.isdelirium and boss.State == 3
		and sprhs:IsPlaying("Wiggle") then
			if Room:GetCenterPos():Distance(boss.Position) > 50 then
				sprhs:Play("DissapearLong", true)
				boss.State = 150
				boss.StateFrame = 0
			else
				boss.State = 229
				sprhs:Play("Puffed2", true)
				boss.StateFrame = 0
			end
		end
	
		if boss.State == 150 then
			boss.StateFrame = boss.StateFrame + 1
			if boss.StateFrame >= 8 and boss.StateFrame <= 270 then
				boss.EntityCollisionClass = 0
				boss:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
				boss.DepthOffset = -100
			end
			if boss.StateFrame >= 78 and boss.StateFrame < 200 then
				boss.TargetPosition = Room:GetCenterPos()
			end
			if sprhs:IsPlaying("DissapearLong") then
				if sprhs:GetFrame() >= 8 then
					if sprhs:GetFrame() == 8 then
						boss:PlaySound(314, 1, 0, false, 1)
						Game():ShakeScreen(10)
					end
				end
			elseif sprhs:IsPlaying("Appear") then
				if sprhs:GetFrame() == 70 then
					boss.EntityCollisionClass = 4
					boss:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
					boss.DepthOffset = 0
				end
			end
			if sprhs:IsFinished("Appear") then
				boss.State = 229
				sprhs:Play("Puffed2", true)
				boss.StateFrame = 0
			end
			if boss.StateFrame >= 200 and not sprhs:IsPlaying("Appear") then
				sprhs:Play("Appear", true)
				boss.EntityCollisionClass = 1
			end
		elseif boss.State == 229 then
			boss.StateFrame = boss.StateFrame + 1
			if sprhs:IsPlaying("Puffed2") and sprhs:GetFrame() == 12 then
				boss:PlaySound(425, 1, 0, false, 0.7)
				data.breathhold = true
			end
			if sprhs:IsFinished("Puffed2") then
				sprhs:Play("Puffed2Loop", true)
			end
			if sprhs:IsPlaying("Puffed2Loop") then
				if boss.StateFrame == 46 then
					local bvessel = Game():Spawn(608, 0, Vector(Room:GetCenterPos().X*0.5,Room:GetCenterPos().Y), Vector(0,0), boss, 0, 1)
					bvessel.SpawnerEntity = boss
				elseif boss.StateFrame == 53 then
					local bvessel2 = Game():Spawn(608, 0, Vector(Room:GetCenterPos().X*1.5,Room:GetCenterPos().Y), Vector(0,0), boss, 1, 2)
					bvessel2.SpawnerEntity = boss
				elseif boss.StateFrame == 60 then
					local bvessel3 = Game():Spawn(608, 0, Vector(Room:GetCenterPos().X,Room:GetCenterPos().Y*0.73), Vector(0,0), boss, 2, 3)
					bvessel3.SpawnerEntity = boss
				elseif boss.StateFrame == 67 then
					local bvessel4 = Game():Spawn(608, 0, Vector(Room:GetCenterPos().X,Room:GetCenterPos().Y*1.27), Vector(0,0), boss, 3, 4)
					bvessel4.SpawnerEntity = boss
				end
				if boss.StateFrame >= 100 then
					sprhs:Play("Puffed2Loop2", true)
				end
			end
			if sprhs:IsPlaying("Puffed2Loop2") and boss.StateFrame >= 160 then
				sprhs:Play("Puffed2Loop3", true)
			end
			if sprhs:IsPlaying("Puffed2Loop3") and boss.StateFrame >= 400 then
				sprhs:Play("Pant", true)
				boss:PlaySound(422, 1, 0, false, 1.5)
				data.breathhold = false
			end
			if boss.StateFrame % 50 == 0
			and boss.StateFrame >= 160 and boss.StateFrame < 400 then
				local hushling = Isaac.Spawn(547, 0, 0, Isaac.GetRandomPosition(1), Vector(0,0), boss)
				hushling:ToNPC():PlaySound(423, 0.45, 0, false, math.random(15,20) * 0.1)
			end
			if sprhs:IsPlaying("PantLoop") then
				if sprhs:GetFrame() == 36 then
					boss:PlaySound(14, 1, 0, false, 0.7)
				end
				if boss.StateFrame >= 700 then
					sprhs:Play("PantEnd", true)
				end
			end
			if sprhs:IsFinished("PantEnd") then
				boss.State = 3
				sprhs:Play("Wiggle", true)
				boss.StateFrame = 30
			end
		end
	
		if boss.State ~= 229 then
			data.breathhold = false
		end
	
		if sprhs:IsFinished("Pant") then
			sprhs:Play("PantLoop", true)
		end
	
		if boss.HitPoints / boss.MaxHitPoints <= 0.2 then
			if (sprhs:IsPlaying("BecomeConvex") and sprhs:GetFrame() == 4)
			and #Isaac.FindByType(506, -1, -1, true, true) == 0 and not data.isdelirium then
				for i=0, 1 do
					local hand = Isaac.Spawn(506, 0, i, boss.Position+Vector(-300+(i*600),0), Vector(0,0), boss)
					hand.SpawnerEntity = boss
				end
			end
		end
		if boss.HitPoints / boss.MaxHitPoints <= 0.3 then
			if (sprhs:IsPlaying("OpenMouth") and sprhs:GetFrame() == 1
			and math.random(1,3) == 1) or (sprhs:IsPlaying("LaserStart")
			and sprhs:GetFrame() == 1 and math.random(1,2) == 1) then
				sprhs:Play("Puffed", true)
				boss.State = 350
			end
		end
		if boss.HitPoints / boss.MaxHitPoints <= 0.5 then
			if boss.State == 300 and sprhs:IsPlaying("FaceVanishFromDown") then
				boss.State = 301
				boss.I2 = math.random(2,5)
				boss.ProjectileCooldown = 0
				if math.random(1,2) == 1 then data.FAW = "LD" else data.FAW = "RD" end
			end
		end
	
		if boss.State == 301 then
			boss.ProjectileCooldown = boss.ProjectileCooldown + 1
			if sprhs:IsFinished("FaceVanishFromDown") then
				sprhs:Play("FaceAppear"..data.FAW, true)
			end
			if data.FAW == "LD" then
				direction = 135
				bltpos = boss.Position + Vector(-50,0)
				bltpos2 = boss.Position + Vector(0,-13)
				bltpos3 = boss.Position + Vector(-74,-57)
			elseif data.FAW == "RD" then
				direction = 45
				bltpos = boss.Position + Vector(50,0)
				bltpos2 = boss.Position + Vector(74,-57)
				bltpos3 = boss.Position + Vector(0,-13)
			end
			if sprhs:IsFinished("FaceAppear"..data.FAW) then
				sprhs:Play("AttackLoop"..data.FAW, true)
				boss.ProjectileCooldown = 0
				boss.I2 = boss.I2 - 1
			end
			if boss.ProjectileCooldown == 32 then
				if sprhs:IsPlaying("AttackLoop"..data.FAW) then
					sprhs:Play("AttackReady"..data.FAW, true)
				end
			elseif boss.ProjectileCooldown == 149 then
				sprhs:Play("FaceVanish"..data.FAW, true)
			end
			if sprhs:IsFinished("AttackReady"..data.FAW) then
				sprhs:Play("AttackLoop"..data.FAW.."2", true)
				boss:PlaySound(422, 1, 0, false, 1)
			end
			if sprhs:IsPlaying("AttackLoop"..data.FAW)
			or sprhs:IsPlaying("AttackReady"..data.FAW)
			or sprhs:IsPlaying("AttackLoop"..data.FAW.."2") then
				if boss.FrameCount % 6 == 0 and not sprhs:IsPlaying("AttackLoop"..data.FAW.."2") then
					local Eye = ProjectileParams()
					Eye.FallingAccelModifier = -0.165
					Eye.FallingSpeedModifier = 0
					Eye.HeightModifier = -6
					Eye.BulletFlags = 1 << 30
					Eye.Scale = 1.5
					Eye.Color = Color(0.3,0,0.5,1,0,0,0)
					boss:FireProjectiles(bltpos2, Vector.FromAngle(direction-math.random(1,90)):Resized(7), 0, Eye)
					boss:FireProjectiles(bltpos3, Vector.FromAngle(direction+math.random(1,90)):Resized(7), 0, Eye)
				end
				if sprhs:IsPlaying("AttackLoop"..data.FAW.."2")
				and boss.ProjectileCooldown <= 139 then
					local Mouth = ProjectileParams()
					Mouth.FallingAccelModifier = -0.17
					Mouth.FallingSpeedModifier = 0
					if math.random(1,6) == 1 then
						Mouth.BulletFlags = 1 << 5 | 1 << 30
					elseif math.random(1,6) == 2 then
						Mouth.BulletFlags = 1 << 22 | 1 << 30
					else
						Mouth.BulletFlags = 1 << 30
					end
					Mouth.HeightModifier = -math.random(65,140) * 0.1
					Mouth.Scale = 1.5
					Mouth.Color = Color(0.3,0,0.5,1,0,0,0)
					boss:FireProjectiles(bltpos + Vector.FromAngle(direction-90):Resized(math.random(-35,35)),
					Vector.FromAngle(direction):Resized(20), 0, Mouth)
				end
			end
			if sprhs:IsFinished("FaceVanish"..data.FAW) then
				if boss.I2 <= 0 then
					sprhs:Play("FaceAppearDown", true)
				else
					if data.FAW == "LD" then
						data.FAW = "RD"
					elseif data.FAW == "RD" then
						data.FAW = "LD"
					end
					sprhs:Play("FaceAppear"..data.FAW, true)
				end
			end
			if sprhs:IsFinished("FaceAppearDown")then
				boss.StateFrame = 150
			end
		end
	
		if sprhs:IsFinished("Puffed") then
			sprhs:Play("OpenMouth2", true)
		end
	
		if sprhs:IsPlaying("OpenMouth2") and sprhs:GetFrame() == 4 then
			boss.StateFrame = math.random(450,500)
			boss:PlaySound(421, 1, 0, false, 1)
			boss:PlaySound(423, 1, 0, false, 1)
			local bloodshot = EntityLaser.ShootAngle(1, boss.Position+Vector(0,5), 90, boss.StateFrame, Vector(0,-40), boss)
			bloodshot.Size = 80
			bloodshot:GetData().lflag = 1
			bloodshot:GetData().pvl = 9
			bloodshot:GetData().pdensity = 12
			for i=0, 180, 180 do
				local bloodshot2 = EntityLaser.ShootAngle(1, Vector(boss.Position.X,705), i, boss.StateFrame, Vector(0,0), boss)
				bloodshot2.DisableFollowParent = true
				if i == 0 then
					bloodshot2:SetActiveRotation(50, -50, -0.13, false)
				else
					bloodshot2:SetActiveRotation(50, 50, 0.13, false)
				end
			end
		end
	
		if boss.State == 350 then
			if sprhs:IsFinished("OpenMouth2") then
				sprhs:Play("OpenMouth2Loop", true)
			end
			if sprhs:IsPlaying("OpenMouth2Loop") then
				boss.Velocity = Vector(0,-0.95)
				boss.StateFrame = boss.StateFrame - 1
				if boss.FrameCount % 35 == 0 then
					data.random = math.random(0,90)
					local eye = ProjectileParams()
					eye.FallingAccelModifier = -0.17
					eye.HeightModifier = -7
					eye.Variant = 6
					eye.Color = Color(0.85,0.85,1.5,1,0,0,0)
					if boss.FrameCount % 2 == 0 then
						for i=0, 324, 36 do
							boss:FireProjectiles(boss.Position + Vector(-48,-75),
							Vector.FromAngle(i+data.random):Resized(5), 0, eye)
						end
					else
						for i=0, 324, 36 do
							boss:FireProjectiles(boss.Position + Vector(48,-75),
							Vector.FromAngle(i+data.random):Resized(5), 0, eye)
						end
					end
				end
				if boss.StateFrame <= 0 then
					sprhs:Play("CloseMouth2", true)
				end
				if sprhs:IsFinished("CloseMouth2") then
					boss.StateFrame = 50
				end
			end
		end
	
		if (boss.State == 301 and sprhs:IsFinished("FaceAppearDown"))
		or sprhs:IsFinished("CloseMouth2") then
			sprhs:Play("Wiggle", true)
			boss.State = 3
			boss.TargetPosition = boss.Position
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Hush, 407)

----------------------------
--Add Boss Pattern:Delirium
----------------------------
function denpnapi:Delirium(boss)
	if boss.FrameCount <= 1 and (Game().Difficulty == 1 or Game().Difficulty == 3) then
		if boss.MaxHitPoints < 66.66*GetPlayerDps then
			boss.MaxHitPoints = math.max(10000, 66.66*GetPlayerDps)
			if Room:GetFrameCount() <= 1 then
				boss.HitPoints = boss.MaxHitPoints
			end
		end
	end

	if boss.Variant == Isaac.GetEntityVariantByName("Delirium") then

		sprdlr = boss:GetSprite()
		boss.SplatColor = Color(1,1,1,1,300,300,300)
		Initspeed = boss.Velocity

		if sprdlr:GetDefaultAnimation() == "MHeartDefault" then
				if boss.State == 0 then
				sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/boss_069_momsheart2.png")
				sprdlr:LoadGraphics()
				boss.State = 4
				boss.StateFrame = math.random(140,240)
			end
			boss.Velocity = boss.Velocity * ((5 - boss.I1)/5)
		elseif sprdlr:GetDefaultAnimation() == "LivesDefault" then
			if boss.State == 0 then
				if boss.HitPoints / boss.MaxHitPoints >= 0.33 then
					sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/boss_070_itlives2_11.png")
					for i=1, 6 do
						sprdlr:ReplaceSpritesheet(i, "gfx/bosses/deliriumforms/boss_070_itlives2_21.png")
					end
				else
					sprdlr:ReplaceSpritesheet(0,"gfx/bosses/deliriumforms/boss_070_itlives2_12.png")
					for i=1, 6 do
						sprdlr:ReplaceSpritesheet(i,"gfx/bosses/deliriumforms/boss_070_itlives2_22.png")
					end
				end
				sprdlr:LoadGraphics()
				boss.State = 3
				boss.StateFrame = math.random(140,240)
			end
			boss.Mass = 90 - (boss.I1 * 5)
			boss.Velocity = boss.Velocity * 0.85
		elseif sprdlr:GetDefaultAnimation() == "LivesHeadDefault" then
			if boss.State == 0 then
				sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/boss_liveshead.png")
				sprdlr:LoadGraphics()
				boss.State = 3
				boss.StateFrame = math.random(20,40)
			end
		end

		boss:GetData().isdelirium = true

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Delirium, 412)

function denpnapi:DlrBForm(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Delirium")
	and boss:GetSprite():GetDefaultAnimation() ~= "Delirium" then

		local sprdlr = boss:GetSprite()
		local player = Game():GetPlayer(1)
		local data = boss:GetData()
		local rng = boss:GetDropRNG()
	
		if (Game().Difficulty == 1 or Game().Difficulty == 3) then
			if Room:GetFrameCount() % 100 == 0 and rng:RandomInt(18) == 1 then
				Isaac.Spawn(1000, 360, 0,
				Vector(120+(rng:RandomInt(11)*80),200+(rng:RandomInt(5)*80)), Vector(0,0), boss)
			end
			if Room:GetFrameCount() % 600 == 0 and DPhase == 1 then
				Isaac.Spawn(544, 0, 1, boss.Position, Vector(0,0), boss)
				for i=0, 3 do
					Isaac.Spawn(1000, 361, 0,
					Vector(120+(rng:RandomInt(11)*80),200+(rng:RandomInt(5)*80)), Vector(0,0), boss)
				end
			end
			if boss.EntityCollisionClass ~= 0 then
				if Room:GetFrameCount() % 110 == 0 and DPhase <= 4
				and math.random(1,2) == 1 then
					local params = ProjectileParams()
					params.Variant = 10
					params.FallingAccelModifier = -0.19
					params.Scale = 2.5
					if player:HasPlayerForm(5) then
						if math.random(1,4) == 1 then
							params.FallingSpeedModifier = 3.25
							params.GridCollision = false
							if math.random(1,2) == 1 then
								params.BulletFlags = 1 << 18 | 1 << 13
							else
								params.BulletFlags = 1 << 19 |1 << 13
							end
							for i = 0, 270, 90 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+((boss.FrameCount % 2)*45)):Resized(8), 0, params)
							end
						elseif math.random(1,4) == 2 then
							params.BulletFlags = 1 << 36
							for i = 0, 270, 90 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+45):Resized(5), 0, params)
							end
						elseif math.random(1,4) == 3 then
							if math.random(1,2) == 1 then
								params.BulletFlags = 1 << 18 | 1 << 22
							else
								params.BulletFlags = 1 << 19 | 1 << 22
							end
							for i = 0, 300, 60 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+((boss.FrameCount % 2)*30)):Resized(3), 0, params)
							end
						else
							params.BulletFlags = ProjectileFlags.SINE_VELOCITY | ProjectileFlags.TRIANGLE
							| ProjectileFlags.SAWTOOTH_WIGGLE
							params.WiggleFrameOffset = 100
							for i = 0, 270, 90 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+((boss.FrameCount % 2)*45)):Resized(4), 0, params)
							end
						end
					else
						params.BulletFlags = ProjectileFlags.SINE_VELOCITY | ProjectileFlags.TRIANGLE
						| ProjectileFlags.SAWTOOTH_WIGGLE
						params.WiggleFrameOffset = 100
						for i = 0, 270, 90 do
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i+((boss.FrameCount % 2)*45)):Resized(4), 0, params)
						end
					end
				end
				if Room:GetFrameCount() % 20 == 0 and player:HasPlayerForm(8)
				and math.random(1,12) == 1 then
					local warn = Isaac.Spawn(1000, 354, 0, player.Position, Vector(0,0), boss)
					warn:ToEffect().Scale = math.random(4,12) * 0.1
				end
				if Room:GetFrameCount() % 85 == 0 and DPhase <= 3 then
					local params = ProjectileParams()
					params.Variant = 10
					params.FallingAccelModifier = -0.19
					params.Scale = 2.3
					if math.random(1,2) == 1 then
						params.BulletFlags = 1 << 34
						params.CurvingStrength = 3
					else
						params.BulletFlags = 1 << 35
					end
					if player:HasPlayerForm(10) and math.random(1,2) == 1 then
						boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(3)*90):Resized(4), 1, params)
					else
						boss:FireProjectiles(boss.Position, Vector.FromAngle(rng:RandomInt(3)*90):Resized(4), 0, params)
					end
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DlrBForm, 412)

function denpnapi:DlrBForm2(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Delirium") then

		local sprdlr = boss:GetSprite()
		local player = Game():GetPlayer(1)

		if (Game().Difficulty == 1 or Game().Difficulty == 3) then
			if sprdlr:GetDefaultAnimation() == "MegaSatan" then
				if boss.State < 3 then
					boss.State = 3
					sprdlr:Play("Idle")
					sprdlr.Offset = Vector(0,50)
				end
			elseif sprdlr:GetDefaultAnimation() == "MegaSatanHand" then
				if boss.State < 3 then
					boss.State = 3
					sprdlr:Play("Idle")
				end
				sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/megasatan.png")
				sprdlr:LoadGraphics()
				boss.GridCollisionClass = 3
				InitSpeed = boss.Velocity
				boss.Velocity = (InitSpeed * 0.8) + Vector((boss.Position.X - player.Position.X)*-0.0045,(boss.Position.Y-200)*-0.009)
				if boss.FrameCount % 100 == 0 and boss.FrameCount >= 60 then
					boss.State = 8
					boss:PlaySound(245, 1, 0, false, 1)
				end
				if sprdlr:IsPlaying("SmashHand1") and sprdlr:GetFrame() == 32 then
					for i=0, 180, 90 do
						local shockwave = Isaac.Spawn(1000, 72, 0, boss.Position, Vector(0,0), boss)
						shockwave.Parent = boss
						shockwave:ToEffect().Rotation = 90
					end
				end
			elseif sprdlr:GetDefaultAnimation() == "MHeartDefault" then
				if boss.State == 0 then
					sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/boss_069_momsheart2.png")
					sprdlr:LoadGraphics()
					boss.State = 4
					boss.StateFrame = math.random(140,240)
				end
				boss.Velocity = boss.Velocity * ((5 - boss.I1)/5)
			elseif sprdlr:GetDefaultAnimation() == "LivesDefault" then
				if boss.State == 0 then
					if boss.HitPoints / boss.MaxHitPoints >= 0.33 then
						sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/boss_070_itlives2_11.png")
						for i=1, 6 do
							sprdlr:ReplaceSpritesheet(i, "gfx/bosses/deliriumforms/boss_070_itlives2_21.png")
						end
					else
						sprdlr:ReplaceSpritesheet(0,"gfx/bosses/deliriumforms/boss_070_itlives2_12.png")
						for i=1, 6 do
							sprdlr:ReplaceSpritesheet(i,"gfx/bosses/deliriumforms/boss_070_itlives2_22.png")
						end
					end
					sprdlr:LoadGraphics()
					boss.State = 3
					boss.StateFrame = math.random(140,240)
				end
				boss.Mass = 90 - (boss.I1 * 5)
				boss.Velocity = boss.Velocity * 0.85
			elseif sprdlr:GetDefaultAnimation() == "LivesHeadDefault" then
				if boss.State == 0 then
					sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/boss_liveshead.png")
					sprdlr:LoadGraphics()
					boss.State = 3
					boss.StateFrame = math.random(20,40)
				end
			elseif sprdlr:GetDefaultAnimation() == "LambDefault" then
				if boss.State == 0 then
					sprdlr:ReplaceSpritesheet(0, "gfx/bosses/deliriumforms/lamb_bareface.png")
					sprdlr:ReplaceSpritesheet(2, "gfx/bosses/afterbirthplus/deliriumforms/rebirth/thelamb_hmbp.png")
					sprdlr:LoadGraphics()
					boss.State = 4
				end
			end
			if boss.State == 0 then
				if sprdlr:GetDefaultAnimation() == "LBBDefault" then
					sprdlr:ReplaceSpritesheet(1, "gfx/bosses/afterbirthplus/deliriumforms/rebirth/thelamb_hmbp.png")
					sprdlr:LoadGraphics()
					boss.State = 4
				elseif sprdlr:GetDefaultAnimation() == "MomDefault" then
					boss:Morph(412, 0, 0, -1)
				elseif sprdlr:GetDefaultAnimation() == "Convex Punch" then
					boss:Morph(412, 0, 0, -1)
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DlrBForm2, 412)

----------------------------
--New Enemy:Hush's Hand
----------------------------
function denpnapi:HsHand(enemy)

	if enemy.Variant <= 1 then
  
		local sprhhn = enemy:GetSprite()
		local player = Game():GetPlayer(1)
		local Entities = Isaac:GetRoomEntities()
		local data = enemy:GetData()
		local ppos = player.Position
		local spnrpos = enemy.SpawnerEntity.Position
		local dist = ppos:Distance(enemy.Position)
		enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		enemy:RemoveStatusEffects()
		enemy.StateFrame = enemy.StateFrame - 1
		enemy.Velocity = enemy.Velocity * 0.8
		InitSpeed = enemy.Velocity
	
		if enemy.Variant == 1 then
			enemy.FlipX = true
		end
	
		if enemy.State == 0 then
			enemy.State = 4
			enemy.StateFrame = math.random(150,200)
			enemy.EntityCollisionClass = 0
			Game():ShakeScreen(10)
		end
	
		if enemy.FrameCount == 2 then
			enemy.CollisionDamage = 1
		end
	
		if sprhhn:IsEventTriggered("Jump") or sprhhn:IsPlaying("Grabbing") then
			enemy.EntityCollisionClass = 0
		end
	
		if enemy.State == 4 then
			enemy.EntityCollisionClass = 0
			if enemy.StateFrame >= 130 then
				sprhhn:Play("Falling", true)
			elseif enemy.StateFrame == 0 then
				sprhhn:Play("JumpDown", true)
			elseif enemy.StateFrame >= 30 then
				enemy.Position = ppos
			end
			if enemy.SpawnerEntity:GetSprite():IsPlaying("OpenMouth2Loop") then
				enemy.StateFrame = 0
				enemy.State = 15
				if not sprhhn:IsPlaying("JumpDown") then
					sprhhn:Play("JumpDown", true)
				end
				if enemy.Variant == 1 then
					enemy.Position = spnrpos + Vector(170,100)
				else
					enemy.Position = spnrpos + Vector(-170,100)
				end
			end
		end
	
		if enemy.SpawnerEntity:GetSprite():IsPlaying("OpenMouth2Loop") then
			if enemy.Variant == 1 then
				enemy.TargetPosition = spnrpos + Vector(170,100)
			else
				enemy.TargetPosition = spnrpos + Vector(-170,100)
			end
			if enemy.TargetPosition:Distance(enemy.Position) > 70 then
				enemy.Velocity = (InitSpeed * 0.9) +
				Vector.FromAngle((enemy.TargetPosition - enemy.Position):GetAngleDegrees()):Resized(3)
			end
			enemy.StateFrame = 1
		end
	
		if sprhhn:IsFinished("JumpDown") then
			sprhhn:Play("Stunned", true)
			enemy.StateFrame = 110
		end
	
		if sprhhn:IsPlaying("Stunned") then
			if enemy.StateFrame <= 0 or (enemy.TargetPosition:Distance(enemy.Position) > 300
			and enemy.SpawnerEntity:GetSprite():IsPlaying("OpenMouth2Loop")) then
				sprhhn:Play("JumpUp", true)
			end
		end
	
		if sprhhn:IsFinished("Release") or sprhhn:IsFinished("JumpUp") then
			enemy.StateFrame = math.random(150,200)
			enemy.State = 4
		end
	
		if sprhhn:IsEventTriggered("Land") then
			enemy:PlaySound(48, 1, 0, false, 1)
		end
	
		if sprhhn:IsFinished("Grabbing") then
			enemy.Velocity = (InitSpeed * 0.8) + Vector.FromAngle((ppos - enemy.Position):GetAngleDegrees())
			:Resized(7)
			if dist <= 100 or enemy:CollidesWithGrid() then
				sprhhn:Play("Release", true)
			end
		end
	
		if sprhhn:IsPlaying("Release") and sprhhn:GetFrame() == 10 then
			entity = Isaac.Spawn(data.etype, data.evari, data.est, enemy.Position, Vector(0,0), enemy)
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			entity.HitPoints = data.vhp
		end
	
		for k, v in pairs(Entities) do
			local dist = v.Position:Distance(enemy.Position)
			if sprhhn:IsEventTriggered("Land") then
				if dist <= 40 + v.Size then
					if v.Type ~= 420 and v:IsVulnerableEnemy()and not v:IsBoss()
					and not enemy.SpawnerEntity:GetSprite():IsPlaying("OpenMouth2Loop") then
						sprhhn:Play("Grabbing", true)
						enemy.State = 15
						v:Remove()
						data.evari = v.Variant
						data.etype = v.Type
						data.est = v.SubType
						data.vhp = v.HitPoints
					else
						enemy.EntityCollisionClass = 4
						enemy.State = 3
					end
				else
					enemy.EntityCollisionClass = 4
					enemy.State = 3
				end
			end
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.HsHand, 506)

----------------------------
--New Enemy:Lamb Stomp
----------------------------
function denpnapi:LStomp(object)

	if object.Variant == Isaac.GetEntityVariantByName("Lamb Stomp") then
  
		local sprlf = object:GetSprite()
		local path = object.Pathfinder
		object:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		object:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		object:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		object:RemoveStatusEffects()
		object.Velocity = object.Velocity * 0.8
		path:FindGridPath(object.Position, 0, 900, false)
	
		object.GridCollisionClass = 3
	
		if sprlf:IsFinished("Stomp") then
			if object.State < 8 then
				object.State = 8
				if object.SubType == 1 then
					local mark = Isaac.Spawn(1000, 367, 0, object.Position, Vector(0,0), object)
					mark:SetColor(Color(1,1,1,1,200,50,240), 99999, 0, false, false)
				else
					sprlf:Play("Stomp", true)
				end
			else
				if object.SubType == 1 then
					if object.FrameCount == 15 then
						sprlf:Play("Stomp", true)
					elseif object.FrameCount > 15 then
						object:Remove()
					end
				else
					object:Remove()
				end
			end
		end
	
		if sprlf:GetFrame() == 30 then
			object:PlaySound(52, 1.5, 0, false, 1)
			Game():BombDamage(object.Position, 40, 75, true, object, 0, 1<<2, true)
			Game():SpawnParticles(object.Position, 88, 10, 20, Color(1,1,1,1,135,126,90), -4)
			local wave = Isaac.Spawn(1000, 61, 0, object.Position, Vector(0,0), object)
			wave.Parent = object
			wave:ToEffect().Timeout = 16
			wave:ToEffect().MaxRadius = 125
			Game():ShakeScreen(20)
		end
	
		if sprlf:GetFrame() >= 30 and sprlf:GetFrame() <= 55 then
			object.EntityCollisionClass = 1
		else
			object.EntityCollisionClass = 0
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.LStomp, 507)

----------------------------
--New Enemy:Memories I
----------------------------
function denpnapi:Memories1(enemy)

	if enemy.Type == 514 then

		local sprmm = enemy:GetSprite()
		local path = enemy.Pathfinder
		local target = enemy:GetPlayerTarget()
		local Entities = Isaac:GetRoomEntities()
		local dist = target.Position:Distance(enemy.Position)

		if enemy.FrameCount == 1 and enemy.SpawnerType == 1000
		and enemy.SpawnerVariant == 360 then
			enemy:PlaySound(265, 1, 0, false, 1)
		end

		if sprmm:IsFinished("Appear") then
			sprmm:PlayOverlay("Head", true)
			enemy.State = 4
		end

		if dist <= 400 and enemy.FrameCount % 70 == 0
		and not sound:IsPlaying(143) then
			enemy:PlaySound(143, 1, 0, false, 1.1)
		end

		if sprmm:IsOverlayPlaying("Head") and sprmm:GetOverlayFrame() == 53 then
			enemy:PlaySound(178, 1, 0, false, 1)
			local params = ProjectileParams()
				params.Scale = 1.5
				if hmbppttn then
					params.Variant = 10
				end
			if enemy.FrameCount % 2 == 0 then
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(0):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(90):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(180):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(270):Resized(6), 0, params)
			else
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(45):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(135):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(225):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(315):Resized(6), 0, params)
			end
		end

		if enemy.State == 4 then
			ChaseTarget(0.6, enemy, 0.85, 100)
			if enemy.Velocity:Length() >= 0.5 then
				if math.abs(enemy.Velocity.X) < math.abs(enemy.Velocity.Y) and not sprmm:IsPlaying("WalkVert") then
					sprmm:Play("WalkVert", true)
				elseif math.abs(enemy.Velocity.X) > math.abs(enemy.Velocity.Y) then
					if enemy.Velocity.X >= 0 and not sprmm:IsPlaying("WalkRight") then
						sprmm:Play("WalkRight", true)
					elseif enemy.Velocity.X < 0 and not sprmm:IsPlaying("WalkLeft") then
						sprmm:Play("WalkLeft", true)
					end
				end
			else
				sprmm:Play("WalkVert", true)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Memories1, 514)

----------------------------
--New Enemy:Crying Gaper
----------------------------
function denpnapi:CGaper(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Crying Gaper") then

		local sprcg = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local dist = target.Position:Distance(enemy.Position)
		enemy:AnimWalkFrame("WalkHori","WalkVert",1)
		ChaseTarget(0.4, enemy, 0.88, 75)

		if sprcg:IsFinished("Appear") then
			enemy.State = 4
		end

		if not sprcg:IsOverlayPlaying("Head") and not sprcg:IsOverlayFinished("Head") then
			sprcg:PlayOverlay("Head", true)
		end

		if enemy.FrameCount % 10 == 0 then
			local creep = Isaac.Spawn(1000, 22, 0, enemy.Position, Vector(0,0), enemy) --enemy creep (red)
			creep:SetColor(Color(1,1,1,1,19,208,255), 99999, 0, false, false)
		end

		if dist < 200 and enemy.FrameCount % 80 == 0 and not sound:IsPlaying(143) then
			enemy:PlaySound(143, 1, 0, false, 1.1)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.CGaper, 523)

----------------------------
--New Enemy:Memories Unknown
----------------------------
function denpnapi:MemoriesU(enemy)

	if enemy.Type == 542 then

		local sprmmu = enemy:GetSprite()
		local data = enemy:GetData()
		InitSpeed = enemy.Velocity
		enemy.SplatColor = Color(1,1,1,1,300,300,300)

		if sprmmu:IsFinished("Appear") then
			sprmmu:Play("Rotate")
			enemy.State = 4
			enemy.StateFrame = math.random(250,350)
			if enemy.SubType == 1 then
				enemy.Velocity = Vector.FromAngle((math.random(1,4) * 90) + 45):Resized(0.5)
			end
		end

		if enemy.State == 4 then
			enemy.StateFrame = enemy.StateFrame - 1
			if enemy.SubType == 0 then
				enemy.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(enemy.FrameCount*6):Resized(0.8)
			elseif enemy.SubType == 1 then
				enemy.Velocity = enemy.Velocity:Normalized() * 5
			else
				if (enemy.FrameCount % 10 == 0 and math.random(1,2) == 1)
				or enemy:CollidesWithGrid() then
					enemy.TargetPosition = Isaac.GetRandomPosition(0)
				end
				local angle = (enemy.TargetPosition - enemy.Position):GetAngleDegrees()
				enemy.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(angle):Resized(0.6)
			end
		else
			enemy.Velocity = enemy.Velocity * 0.9
		end

		if enemy.FrameCount % 120 == 0 and enemy.State ~= 5 then
			enemy:PlaySound(178, 1, 0, false, 1)
			local params = ProjectileParams()
				params.Scale = 1.5
				if hmbppttn then
					params.Variant = 10
				end
			if enemy.FrameCount % 2 == 0 then
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(0):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(120):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(240):Resized(6), 0, params)
			else
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(60):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(180):Resized(6), 0, params)
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(320):Resized(6), 0, params)
			end
		end

		if enemy.StateFrame <= 0 and sprmmu:IsPlaying("Rotate")
		and sprmmu:GetFrame() == 15 then
			enemy.State = 5
			if math.random(1,4) <= 3 then
				sprmmu:Play("Morph", true)
			else
				sprmmu:Play("Morph2", true)
			end
		end

		if sprmmu:IsPlaying("Morph2") and sprmmu:GetFrame() == 41 then
			enemy.EntityCollisionClass = 0
		end

		if sprmmu:IsEventTriggered("Explode") then
			enemy:PlaySound(265, 1, 0, false, 1)
			if sprmmu:IsPlaying("Morph") then
				enemy:Die()
				Isaac.Spawn(514+(math.random(0,1)*29), 0, 0, enemy.Position, Vector(0,0), enemy)
			elseif sprmmu:IsPlaying("Morph2") then
				enemy:PlaySound(28, 1, 0, false, 1)
				enemy:Remove()
				Isaac.Spawn(544, 0, 0, enemy.Position, Vector(0,0), enemy)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.MemoriesU, 542)

----------------------------
--New Enemy:Memories II
----------------------------
function denpnapi:Memories2(enemy)

	if enemy.Type == 543 then

		local sprmm2 = enemy:GetSprite()
		local path = enemy.Pathfinder
		local data = enemy:GetData()
		local rng = enemy:GetDropRNG()

		if enemy.State == 0 then
			data.randpos = Room:GetRandomPosition(0)
			enemy.I1 = enemy.MaxHitPoints
			if enemy.SpawnerType == 1000 and enemy.SpawnerVariant == 360 then
				enemy:PlaySound(265, 1, 0, false, 1)
			end
		end

		enemy.State = 4

		if enemy.I1 > enemy.HitPoints then
			enemy:PlaySound(181, 1, 0, false, 1)
			enemy.I1 = enemy.I1 - 12
			data.lnth = math.random(30,100)
			if math.random(1,2) == 1 then
				local fly = Isaac.Spawn(18, 0, 0,
				enemy.Position, Vector.FromAngle(math.random(0,360)):Resized(math.random(5,10)), enemy)
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			else
				EntityNPC.ThrowSpider(enemy.Position, enemy,
				enemy.Position + Vector.FromAngle(rng:RandomInt(359)):Resized(data.lnth), false, -data.lnth*0.6)
			end
		end

		if data.randpos:Distance(enemy.Position) <= 70 or enemy.Velocity:Length() == 0 then
			data.randpos = Room:GetRandomPosition(0)
		end

		if enemy.FrameCount % 70 == 0 and math.random(1,3) == 1
		and not sound:IsPlaying(116) then
			enemy:PlaySound(116, 1, 0, false, 1)
		end

		for i=1,1 do
			if enemy.State == 4 then
				path:FindGridPath(data.randpos, 0.6, 900, false)
				if enemy.Velocity:Length() >= 0.5 then
					if math.abs(enemy.Velocity.X) < math.abs(enemy.Velocity.Y) then
						if enemy.Velocity.Y >= 0 and not sprmm2:IsPlaying("WalkDown") then
							sprmm2:Play("WalkDown", true)
						elseif enemy.Velocity.Y < 0 and not sprmm2:IsPlaying("WalkUp") then
							sprmm2:Play("WalkUp", true)
						end
					elseif math.abs(enemy.Velocity.X) > math.abs(enemy.Velocity.Y) then
						if enemy.Velocity.X >= 0 and not sprmm2:IsPlaying("WalkRight") then
							sprmm2:Play("WalkRight", true)
						elseif enemy.Velocity.X < 0 and not sprmm2:IsPlaying("WalkLeft") then
							sprmm2:Play("WalkLeft", true)
						end
					end
				end
			else
				sprmm2:Play("WalkDown", true)
				enemy.Velocity = enemy.Velocity * 0.7
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Memories2, 543)

----------------------------
--New Enemy:Memories III
----------------------------
function denpnapi:Memories3(enemy)

	if enemy.Type == 544 then

		local sprmm3 = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local dist = target.Position:Distance(enemy.Position)
		enemy.StateFrame = enemy.StateFrame - 1
		enemy.Velocity = enemy.Velocity * 0.8
		InitSpeed = enemy.Velocity
		angle = (target.Position - enemy.Position):GetAngleDegrees()

		if enemy.State == 0 then
			if enemy.SubType == 1 then
				enemy.StateFrame = 100
				enemy.PositionOffset = Vector(0,-80)
			else
				enemy.StateFrame = math.random(150,200)
				Game():ShakeScreen(10)
				enemy.I1 = 2
			end
			if math.random(1,2) == 2 then
				enemy.FlipX = true
			end
		end

		if (enemy.SpawnerType == 1000 and enemy.SpawnerVariant == 360)
		or enemy.SubType == 1 then
			if enemy.State == 0 then
				if enemy.Variant ~= 1 then
					enemy.I1 = 2
				else
					enemy.EntityCollisionClass = 0
				end
				enemy.State = 2
				enemy:PlaySound(265, 1, 0, false, 1)
			end
			if sprmm3:IsFinished("Appear") then
				sprmm3:Play("Appear2", true)
			end
			if sprmm3:IsFinished("Appear2") then
				enemy.State = 4
				if enemy.Variant == 1 then
					enemy.PositionOffset = Vector(0,0)
				end
			end
		else
			if enemy.State == 0 then
				enemy.State = 4
				enemy.EntityCollisionClass = 0
				enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			end
			enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end

		if sprmm3:IsEventTriggered("Up") then
			enemy.EntityCollisionClass = 0
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
			enemy:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			enemy:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end

		if enemy.State == 4 then
			enemy.EntityCollisionClass = 0
			if enemy.StateFrame >= 130 then
				sprmm3:Play("Falling", true)
			elseif enemy.StateFrame == 0 then
				sprmm3:Play("Down", true)
			end
			if sprmm3:IsPlaying("Falling") then
				enemy.Position = target.Position
			end
		end

		if enemy.SubType == 1 and enemy.State == 4 then
			enemy.Position = target.Position
		end

		if sprmm3:IsFinished("Down") then
			sprmm3:Play("Stuck", true)
			enemy.State = 8
		end

		if sprmm3:IsFinished("Stuck") then
			if enemy.SubType == 1 then
				sprmm3:Play("Idle", true)
				enemy.StateFrame = 20
			else
				sprmm3:Play("PullOut", true)
			end
		end

		if sprmm3:IsFinished("PullOut") then
			sprmm3:Play("PullOutLoop", true)
			enemy.StateFrame = 30
		end

		if sprmm3:IsPlaying("PullOutLoop") then
			if enemy.StateFrame >= 12 then
				enemy.Velocity = (InitSpeed * 0.9) + Vector.FromAngle(angle):Resized(5)
			end
			if enemy.StateFrame <= 0 then
				sprmm3:Play("Attack", true)
			end
		end

		if sprmm3:IsFinished("Attack") then
			if enemy.I1 > 0 then
				sprmm3:Play("PullOut", true)
				enemy.I1 = enemy.I1 - 1
			else
				sprmm3:Play("Idle", true)
				enemy.StateFrame = 75
			end
		end

		if sprmm3:IsPlaying("Idle") and enemy.StateFrame <= 0 then
			sprmm3:Play("PullOut2", true)
		end

		if sprmm3:IsFinished("PullOut2") then
			if enemy.SubType == 1 then
				enemy:Remove()
			end
			enemy.StateFrame = math.random(150,200)
			enemy.State = 4
			enemy.I1 = 2
		end

		if sprmm3:IsEventTriggered("Land") then
			enemy:PlaySound(138, 1, 0, false, 1)
			SpawnGroundParticle(false, enemy, 8, 6, 1, 7)
			Game():BombDamage(enemy.Position, 40, 20, false, enemy, 0, 1<<7, false)
			enemy.EntityCollisionClass = 4
			enemy.Velocity = Vector(0,0)
			enemy.PositionOffset = Vector(0,0)
			enemy:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Memories3, 544)

----------------------------
--New Enemy:Delirium's Hand
----------------------------
function denpnapi:DHand(hand)

	if hand.Type == 545 and hand.Variant <= 1 then
  
	  hand:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	  hand:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	  hand:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	  hand:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	  hand:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	  hand:RemoveStatusEffects()
	  hand.SplatColor = Color(1,1,1,1,300,300,300)
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DHand, 545)

function denpnapi:DHand1(hand)

	if hand.Variant == Isaac.GetEntityVariantByName("Delirium's Hand") then
  
		local sprdh = hand:GetSprite()
		local data = hand:GetData()
		sprdh.Offset = Vector(0,-13)
		hand.EntityCollisionClass = 2
		hand.Velocity = Vector.FromAngle(sprdh.Rotation):Resized(13)
	
		if hand.FrameCount % 3 == 0 then
			local cords = Isaac.Spawn(545, 1, 0, hand.Position, Vector(0,0), hand)
			cords.SpawnerEntity = hand
		end
		if hand.FrameCount == 1 then
			sprdh:Play("Move", true)
		end
	
		if hand:CollidesWithGrid() then
			hand:Die()
			hand:BloodExplode()
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DHand1, 545)

function denpnapi:DHandC(cord)

	if cord.Variant == Isaac.GetEntityVariantByName("Delirium's Hand Cord") then
  
		local sprdc = cord:GetSprite()
		local player = Game():GetPlayer(1)
		local dist = player.Position:Distance(cord.Position)
		cord.EntityCollisionClass = 0
		cord.Velocity = Vector(0,0)
	
		if cord.SpawnerEntity then
			cord.StateFrame = cord.FrameCount
		end
	
		if cord.FrameCount == 2 then
			sprdc:Play("Wiggle", true)
		elseif cord.FrameCount >= cord.StateFrame + 50 then
			cord:Die()
			cord:BloodExplode()
		end
	
		if player.EntityCollisionClass >= 3 and dist <= 13 + player.Size then
			player:TakeDamage(1, 0, EntityRef(cord), 5)
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DHandC, 545)

----------------------------
--New Enemy:Delirium's Triplets
----------------------------
function denpnapi:DTriplet(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Delirium's Triplets") then
  
		local sprdt = enemy:GetSprite()
		local data = enemy:GetData()
		local sent = enemy.SpawnerEntity
		enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		enemy:RemoveStatusEffects()
		enemy.SplatColor = Color(1,1,1,1,300,300,300)
		enemy.EntityCollisionClass = 0
		InitSpeed = enemy.Velocity
		enemy.StateFrame = enemy.StateFrame + 1
	
		if sprdt:IsFinished("Appear") then
			enemy.State = 3
			data.endframe = 0
		end
	
		if enemy.SubType == 1 then
			enemy.I1 = -45
		else
			enemy.I1 = 45
		end
	
		if enemy.SpawnerEntity then
			if sent.Size * 2 >= 100 then
				data.radi = 100
			else
				data.radi = sent.Size * 2
			end
			local pos = sent.Position + Vector.FromAngle((sent.Velocity):GetAngleDegrees()+enemy.I1+enemy.I2):Resized(data.radi)
			local angle = (sent.Position - enemy.Position):GetAngleDegrees()
			if sent.Velocity:Length() == 0 then
				enemy.I2 = 90
			else
				enemy.I2 = 0
			end
			if sent.HitPoints > 1 then
				data.endframe = 98
				if sent.HitPoints/sent.MaxHitPoints <= 0.5
				and enemy.StateFrame == 0 then
					enemy.StateFrame = 49
				end
			else
				data.endframe = 14
			end
	
			if enemy.StateFrame > data.endframe then
				enemy.StateFrame = 0
			end
	
			data.dist2 = pos:Distance(enemy.Position)
			enemy.Velocity = (InitSpeed * 0.5) + Vector.FromAngle((pos - enemy.Position):GetAngleDegrees()):Resized(data.dist2*0.2)
			if angle >= -157.5 and angle < -112.5 then
				enemy:SetSpriteFrame("HoriDown", enemy.StateFrame)
				enemy.FlipX = true
			elseif angle >= -112.5 and angle < -67.5 then
				enemy:SetSpriteFrame("Down", enemy.StateFrame)
			elseif angle >= -67.5 and angle < -22.5 then
				enemy:SetSpriteFrame("HoriDown", enemy.StateFrame)
				enemy.FlipX = false
			elseif angle >= -22.5 and angle < 22.5 then
				enemy:SetSpriteFrame("Hori", enemy.StateFrame)
				enemy.FlipX = false
			elseif angle >= 22.5 and angle < 67.5 then
				enemy:SetSpriteFrame("HoriUp", enemy.StateFrame)
				enemy.FlipX = false
			elseif angle >= 67.5 and angle < 112.5 then
				enemy:SetSpriteFrame("Up", enemy.StateFrame)
			elseif angle >= 112.5 and angle < 157.5 then
				enemy:SetSpriteFrame("HoriUp", enemy.StateFrame)
				enemy.FlipX = true
			else
				enemy:SetSpriteFrame("Hori", enemy.StateFrame)
				enemy.FlipX = true
			end
			if sprdt:GetFrame() == 84 then
				enemy:PlaySound(25, 1, 0, false, 1)
				local params = ProjectileParams()
				params.Variant = 10
				params.FallingAccelModifier = -0.165
				params.Scale = 1.5
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(angle+180):Resized(6), 4, params)
			end
			if enemy.SpawnerEntity:IsDead() then
				enemy:Kill()
			end
		else
			enemy:Remove()
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DTriplet, 546)

----------------------------
--New Enemy:Hushling
----------------------------
function denpnapi:Hushling(enemy)

	if enemy.Type == 547 then

		local sprhsl = enemy:GetSprite()
		local data = enemy:GetData()
		local target = enemy:GetPlayerTarget()
		local dist = target.Position:Distance(enemy.Position)
		angle = (target.Position - enemy.Position):GetAngleDegrees()
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		enemy.StateFrame = enemy.StateFrame - 1
		enemy.I1 = enemy.I1 - 1

		if enemy.State == 3 then
			data.destination = Isaac.GetRandomPosition(0)
		end

		if sprhsl:IsFinished("Appear") then
			sprhsl:Play("Appear2", true)
		elseif sprhsl:IsFinished("Appear2") or sprhsl:IsFinished("Convex") then
			sprhsl:Play("Shake", true)
			enemy.State = 3
			enemy.I1 = math.random(50,300)
		elseif sprhsl:IsFinished("Concave") then
			sprhsl:Play("ConcaveMove", true)
			enemy.State = 4
		end

		if (sprhsl:IsPlaying("Appear2") and sprhsl:GetFrame() == 2)
		or ((sprhsl:IsPlaying("Convex") or sprhsl:IsPlaying("Concave"))
		and sprhsl:GetFrame() == 5) then
			enemy:PlaySound(314, 0.65, 0, false, 1.5)
		end

		if sprhsl:IsPlaying("ConcaveMove")
		or (sprhsl:IsPlaying("Concave") and sprhsl:GetFrame() >= 6)
		or (sprhsl:IsPlaying("Convex") and sprhsl:GetFrame() <= 4)
		or (sprhsl:IsPlaying("Appear2") and sprhsl:GetFrame() == 1)
		or enemy.FrameCount <= 10 then
			enemy.DepthOffset = -40
		else
			enemy.DepthOffset = 0
		end

		if enemy.State == 3 then
			if enemy.I1 <= 0 and not sprhsl:IsPlaying("Concave") then
				sprhsl:Play("Concave", true)
			end
			if sprhsl:IsPlaying("Shake") and dist <= 200 then
				enemy.StateFrame = 15
				enemy.State = 8
			end
		end

		if enemy.State == 8 then
			if enemy.StateFrame <= 0 and sprhsl:IsPlaying("Shake") then
				sprhsl:Play("Spit", true)
			end
			if sprhsl:IsPlaying("Spit") and sprhsl:GetFrame() == 6 then
				enemy:PlaySound(226, 1, 0, false, 1)
				local params = ProjectileParams()
				params.Scale = 1.5
				params.BulletFlags = 1 << 16 | 1 << 27
				params.Acceleration = 0.9
				params.HeightModifier = 10
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(angle):Resized(15), 0, params)
			end
			if sprhsl:IsFinished("Spit") then
				enemy.I1 = 0
				enemy.State = 3
			end
		end

		if enemy.FrameCount <= 10 or (sprhsl:IsPlaying("Concave")
		and sprhsl:GetFrame() == 5) then
			enemy.EntityCollisionClass = 3
		elseif sprhsl:IsPlaying("Appear2") or (sprhsl:IsPlaying("Convex")
		and sprhsl:GetFrame() == 5) then
			enemy.EntityCollisionClass = 4
		end

		if enemy.State == 4 then
			enemy.Velocity = Vector.FromAngle((data.destination - enemy.Position):GetAngleDegrees()):Resized(5)
			if enemy:CollidesWithGrid() or data.destination:Distance(enemy.Position) <= 20 then
				sprhsl:Play("Convex", true)
				enemy.State = 3
				enemy.Velocity = Vector(0,0)
				enemy.I1 = math.random(50,300)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Hushling, 547)

----------------------------
--Mom (Delirium)
----------------------------
function denpnapi:Mmdelir(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Mom (Delirium)") then
  
		local sprdm = enemy:GetSprite()
		local data = enemy:GetData()
		local player = Game():GetPlayer(1)
		local Entities = Isaac:GetRoomEntities()
		local dist = player.Position:Distance(enemy.Position)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		enemy:RemoveStatusEffects()
		enemy.Velocity = Vector(0,0)
		enemy.SplatColor = Color(1,1,1,1,300,300,300)
		enemy.GridCollisionClass = 0
	
		if enemy.State == 0 then
			enemy.TargetPosition = enemy.Position
		end
	
		enemy.Velocity = Vector.FromAngle((enemy.TargetPosition-enemy.Position):GetAngleDegrees())
		:Resized(enemy.TargetPosition:Distance(enemy.Position) * 0.3)
	
		if enemy.TargetPosition.X == Room:GetTopLeftPos().X then
			sprdm.Rotation = 270
		elseif enemy.TargetPosition.X >= Room:GetBottomRightPos().X then
			sprdm.Rotation = 90
		elseif enemy.TargetPosition.Y >= 300 then
			sprdm.Rotation = 180
		else
			sprdm.Rotation = 0
		end
	
		enemy.Position = enemy.TargetPosition
	
		if sprdm:IsFinished("Appear") and enemy.State <= 2 then
			enemy.State = 3
			enemy.StateFrame = math.random(350,1000)
			enemy.CollisionDamage = 2
		end
	
		if enemy.State == 3 then
			enemy.EntityCollisionClass = 0
			enemy.StateFrame = enemy.StateFrame - 1
			if enemy.StateFrame <= 0 and dist <= 450 then
				if math.random(1,3) == 1 then
					enemy.State = 9
				else
					enemy.State = 8
				end
			end
		end
	
		if enemy.State >= 8 and enemy.State <= 11 then
			if enemy.State == 8 and not sprdm:IsPlaying("Eye") then
				sprdm:Play("Eye", true)
			elseif enemy.State == 9 and not sprdm:IsPlaying("ArmOpen") then
				sprdm:Play("ArmOpen", true)
			end
			if enemy.State == 8 then
				if sprdm:GetFrame() == 17 then
					enemy.EntityCollisionClass = 2
				elseif sprdm:GetFrame() == 55 then
					for i=5, 60 do
						if i == 5 or i == 60 then
							local creep = Isaac.Spawn(1000, 25, 0,
							enemy.Position + Vector.FromAngle(sprdm.Rotation+90):Resized(i+20), Vector(0,0), enemy)
							creep.SpriteScale = Vector(1+(i*0.015),1+(i*0.015))
						end
					end
					local params = ProjectileParams()
					params.HeightModifier = 20
					params.FallingAccelModifier = 0.5
					params.Variant = 10
					for i=0, math.random(5,10) do
						params.Scale = math.random(10,18) * 0.1
						params.FallingSpeedModifier = math.random(40,100) * -0.1
						enemy:FireProjectiles(enemy.Position + Vector.FromAngle(sprdm.Rotation+90):Resized(10),
						Vector.FromAngle(sprdm.Rotation+90+math.random(-22,22)):Resized(math.random(7,14)), 0, params)
					end
					enemy:PlaySound(153, 1, 0, false, 1)
				elseif sprdm:GetFrame() == 76 then
					enemy.EntityCollisionClass = 0
				end
			elseif enemy.State == 9 then
				if sprdm:GetFrame() == 20 then
					enemy:PlaySound(36, 1, 0, false, 1)
				elseif sprdm:GetFrame() == 49 then
					enemy.EntityCollisionClass = 2
					enemy:PlaySound(48, 1, 0, false, 1)
					local shockwave = Isaac.Spawn(1000, 72, 0,
					enemy.Position + Vector.FromAngle(sprdm.Rotation+90):Resized(15), Vector(0,0), enemy)
					shockwave:ToEffect().Rotation = sprdm.Rotation+90
					shockwave:ToEffect().Timeout = 200
					local creep = Isaac.Spawn(1000, 25, 0,
					enemy.Position + Vector.FromAngle(sprdm.Rotation+90):Resized(15), Vector(0,0), enemy)
					creep.SpriteScale = Vector(3,3)
				elseif sprdm:GetFrame() == 86 then
					enemy.EntityCollisionClass = 0
				end
			end
			if (sprdm:IsPlaying("Eye") and sprdm:GetFrame() == 77)
			or (sprdm:IsPlaying("ArmOpen") and sprdm:GetFrame() == 95) then
				enemy.State = 3
				enemy.StateFrame = math.random(350,600)
			end
		end
	
		if DPhase == 1 and #Isaac.FindByType(412, -1, -1, true, true) > 0 then
			enemy:Remove()
			Isaac.Spawn(1000, 15, 0, enemy.Position, Vector(0,0), enemy)
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Mmdelir, 548)

----------------------------
--New Enemy:Cloatty
----------------------------
function denpnapi:Cloatty(enemy)

	if enemy.Type == 549 then
		local sprclt = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local dist = target.Position:Distance(enemy.Position)
		local Entities = Isaac:GetRoomEntities()
		local data = enemy:GetData()
	
		if not data.lnth then
			if enemy.SpawnerType == 78 and enemy.SpawnerVariant == 1 then
				data.lnth = 0.45
			else
				data.lnth = 0.3
			end
		end
	
		if enemy.I2 == 0 then
			if enemy.Velocity:GetAngleDegrees() >= -180 and enemy.Velocity:GetAngleDegrees() < -90 then
				data.mangle = -135
			elseif enemy.Velocity:GetAngleDegrees() >= -90 and enemy.Velocity:GetAngleDegrees() < 0 then
				data.mangle = -45
			elseif enemy.Velocity:GetAngleDegrees() >= 0 and enemy.Velocity:GetAngleDegrees() < 90 then
				data.mangle = 45
			elseif enemy.Velocity:GetAngleDegrees() >= 90 and enemy.Velocity:GetAngleDegrees() < 180 then
				data.mangle = 135
			end
			enemy.Velocity = (enemy.Velocity * 0.9)
			+ Vector.FromAngle(data.mangle):Resized(data.lnth)
		else
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			enemy:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			enemy.Velocity = (enemy.Velocity * 0.9)
			+ Vector.FromAngle(enemy.Velocity:GetAngleDegrees()):Resized(data.lnth)
		end
	
		if enemy.State <= 2 then
			if sprclt:IsFinished("Appear") then
				enemy.State = 4
				enemy.StateFrame = math.random(60,95)
			end
		elseif enemy.State == 4 then
			if not sprclt:IsPlaying("Idle") and enemy.I1 == 0 then
				sprclt:Play("Idle", true)
				enemy.FlipX = false
			end
			if sprclt:IsPlaying("Idle") then
				enemy.StateFrame = enemy.StateFrame - 1
				if enemy.StateFrame <= 0 and dist <= 300 then
					sprclt:Play("Shoot", true)
					enemy.I1 = 1
				end
			elseif sprclt:IsPlaying("Shoot") then
				if sprclt:GetFrame() == 12 then
					enemy:PlaySound(226, 1, 0, false, 1)
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.05
					if target.Position.X < enemy.Position.X then
						enemy.FlipX = true
						enemy:FireProjectiles(enemy.Position, Vector(-7.5,0), 1, params)
					else
						enemy.FlipX = false
						enemy:FireProjectiles(enemy.Position, Vector(7.5,0), 1, params)
					end
				end
			end
			if sprclt:IsFinished("Shoot") then
				enemy.I1 = 0
				enemy.StateFrame = math.random(60,95)
			end
		end
	
		if enemy.SpawnerType == 78 and enemy.SpawnerVariant == 1
		and enemy:CollidesWithGrid() then
			Isaac.Spawn(1000, 2, 3, enemy.Position, Vector(0,0), enemy)
			enemy:PlaySound(72, 1, 0, false, 1)
			enemy:Remove()
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Cloatty, 549)

----------------------------
--New Enemy:Delirium Fly
----------------------------
function denpnapi:DeFly(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Delirium Fly") then

		local sprdfl = enemy:GetSprite()
		local data = enemy:GetData()
		enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		enemy:RemoveStatusEffects()
		enemy.GridCollisionClass = 0
		enemy.EntityCollisionClass = 2
		InitSpeed = enemy.Velocity

		if enemy.State == 0 then
			enemy.State = 4
			sprdfl:Play("Idle", true)
		end

		if enemy.SubType == 1 then
			enemy.I1 = 180
		end

		if enemy.SpawnerEntity then
			local sent = enemy.SpawnerEntity
			if sent.Size * 2 >= 100 then
				enemy.I2 = 100
			else
				enemy.I2 = sent.Size * 2
			end
			local pos = sent.Position + Vector.FromAngle(enemy.StateFrame+enemy.I1):Resized(enemy.I2)
			local dist = pos:Distance(enemy.Position)
			enemy.StateFrame = enemy.StateFrame + 2
			if enemy.StateFrame >= 360 then
				enemy.StateFrame = 0
			end
			enemy.Velocity = (InitSpeed * 0.5) + Vector.FromAngle((pos - enemy.Position):GetAngleDegrees()):Resized(dist*0.14)
			if enemy.SpawnerEntity:IsDead() then
				enemy:Kill()
			end
		else
			enemy:Remove()
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DeFly, 550)

----------------------------
--New Enemy:Delirium GodHead
----------------------------
function denpnapi:DeGhd(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("GodHead (Delirium)") then

		local sprdghd = enemy:GetSprite()
		local data = enemy:GetData()
		local player = Isaac.GetPlayer(0)

		enemy.PositionOffset = Vector(0,-50)
		enemy.EntityCollisionClass = 0

		if sprdghd:IsFinished("Appear") then
			sprdghd:Play("Idle",true)
		end
		if enemy.FrameCount % 30 == math.random(0,10)
		or enemy:CollidesWithGrid()
		or enemy.TargetPosition:Distance(enemy.Position) <= 75 then
			enemy.TargetPosition = Isaac.GetRandomPosition(0)
		end

		enemy.Velocity = (enemy.Velocity * 0.9)
		+ Vector.FromAngle((enemy.TargetPosition-enemy.Position):GetAngleDegrees())
		:Resized(math.random(5,15) * 0.02)

		if not sprdghd:IsPlaying("Appear") then
			if enemy.FrameCount % 200 == 0 and sprdghd:IsPlaying("Idle") then
				sprdghd:Play("Attack",true)
			end
			if sprdghd:IsPlaying("Attack") and sprdghd:GetFrame() == 27 then
				if math.random(1,2) == 1 then
					for i=0, 270, 90 do
						local lwave = Isaac.Spawn(1000, 351, 0, enemy.Position, Vector(0,0), enemy)
						lwave:ToEffect().Rotation = i
						lwave.Parent = enemy
					end
				else
					for i=45, 315, 90 do
						local lwave = Isaac.Spawn(1000, 351, 0, enemy.Position, Vector(0,0), enemy)
						lwave:ToEffect().Rotation = i
						lwave.Parent = enemy
					end
				end
			end
			if sprdghd:IsFinished("Attack") then
				sprdghd:Play("Idle",true)
			end
			if #Isaac.FindByType(548, -1, -1, true, true) > 0
			and not sprdghd:IsPlaying("Removing") then
				sprdghd:Play("Removing",true)
			end
		end
		if sprdghd:IsPlaying("Removing") and sprdghd:GetFrame() == 15 then
			enemy:Remove()
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.DeGhd, 551)

----------------------------
--Projectile:Pupula
----------------------------
function denpnapi:PplaProj(p)

	if p.Type == 552 then
  
		local sprppl = p:GetSprite()
		local data = p:GetData()
		p:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		p:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		p:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		p:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
		p:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		p:RemoveStatusEffects()
		p.EntityCollisionClass = 2
		p.GridCollisionClass = 6
	
		p.Size = p.SubType+1
	
		p.PositionOffset = Vector(0,p.PositionOffset.Y+0.1)
	
		if p.FrameCount == 1 then
			if p.Velocity.X >= 0 then
				data.initX = 1
			else
				data.initX = -1
			end
			if p.Velocity.Y >= 0 then
				data.initY = 1
			else
				data.initY = -1
			end
		end
	
		if p.Size >= 8 then
			p.CollisionDamage = 2
		else
			p.CollisionDamage = 1
		end
	
		if p.SubType >= 12 then
			p.Scale = p.Size/10.4
			data.anino2 = "RegularTear13"
		else
			data.anino2 = "RegularTear"..p.SubType+1
		end
	
		if not sprppl:IsPlaying(data.anino2) then
			sprppl:Play(data.anino2, true)
		end
		p.SpriteRotation = p.Velocity:GetAngleDegrees() + 90
	
		if p.PositionOffset.Y >= 0 or p:CollidesWithGrid()
		or p:IsDead() then
			p:Remove()
			if p.PositionOffset.Y >= 0 then
				p:PlaySound(258, 1, 0, false, 1)
			else
				p:PlaySound(150, 1, 0, false, 1)
			end
		end
	
		if (math.abs(p.Velocity.X) >= math.abs(p.Velocity.Y)
		and ((data.initX == -1 and p.Velocity.X >= 0) or (data.initX == 1 and p.Velocity.X < 0)))
		or (math.abs(p.Velocity.X) < math.abs(p.Velocity.Y)
		and ((data.initY == -1 and p.Velocity.Y >= 0) or (data.initY == 1 and p.Velocity.Y < 0))) then
			p:Remove()
			if p.PositionOffset.Y >= 0 then
				p:PlaySound(258, 1, 0, false, 1)
			else
				p:PlaySound(150, 1, 0, false, 1)
			end
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.PplaProj, 552)

----------------------------
--New Enemy:Greedier Gaper
----------------------------
function denpnapi:GreedierGaper(enemy)

	if enemy.Type == 553 then

		local sprgrg = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local dist = target.Position:Distance(enemy.Position)
		local data = enemy:GetData()
		local angle = (target.Position - enemy.Position):GetAngleDegrees()
		enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		enemy:AnimWalkFrame("WalkHori","WalkVert",1)
		ChaseTarget(0.62, enemy, 0.85, 75)
		enemy.StateFrame = enemy.StateFrame - 1

		if enemy.FrameCount % 4 == 0 then
			local bling = Isaac.Spawn(1000, 103, 0, enemy.Position + Vector(0,1), Vector(0,0), enemy)
			bling.PositionOffset = Vector(math.random(-20,20),math.random(-47,-5))
		end

		if enemy.State == 1 then
			enemy.State = 4
		end

		if not sprgrg:IsOverlayPlaying("Head") then
			enemy.StateFrame = math.random(70,120)
		end

		if not data.attack then
			sprgrg:PlayOverlay("Head", true)
			if dist <= 200 and enemy.StateFrame <= 0 then
				data.attack = true
			end
		end

		if sprgrg:IsOverlayPlaying("Head") and sprgrg:GetOverlayFrame() == 6 then
			enemy:PlaySound(319, 1, 0, false, 1)
			local params = ProjectileParams()
			params.Variant = 7
			enemy:FireProjectiles(enemy.Position, Vector.FromAngle(angle):Resized(10), 0, params)
		end

		if enemy:IsDead() then
			enemy:PlaySound(427, 1, 0, false, 2)
			Isaac.Spawn(1000, 357, 0, enemy.Position, Vector(0,0), enemy)
			for i=0, 6, 2 do
				Game():SpawnParticles(enemy.Position, 95, 10, i, Color(1.1,1,1,1,0,0,0), -50)
			end
			if math.random(1,2) == 1 then
				Isaac.Spawn(5, 20, 1, enemy.Position, Vector(0,0), enemy)
			end
		end

		if dist < 200 and enemy.FrameCount % 80 == 0 and not sound:IsPlaying(165)
		and data.attack then
			enemy:PlaySound(165, 1, 0, false, 1)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.GreedierGaper, 553)

----------------------------
--New Enemy:Greedier Fatty
----------------------------
function denpnapi:GreedierFatty(enemy)

	if enemy.Type == 554 then

		local sprgrf = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local dist = target.Position:Distance(enemy.Position)
		local data = enemy:GetData()
		local rng = enemy:GetDropRNG()
		enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		enemy:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		enemy.StateFrame = enemy.StateFrame - 1

		if enemy.FrameCount % 4 == 0 then
			local bling = Isaac.Spawn(1000, 103, 0, enemy.Position + Vector(0,1), Vector(0,0), enemy)
			bling.PositionOffset = Vector(math.random(-27,27),math.random(-65,-5))
		end

		if enemy.State < 3 then
			enemy.State = 4
			enemy.StateFrame = math.random(120,200)
		elseif enemy.State == 4 then
			ChaseTarget(0.25, enemy, 0.86, 75)
			enemy:AnimWalkFrame("WalkHori","WalkVert",1)
			if dist <= 200 and enemy.StateFrame <= 0 then
				enemy.State = 8
				sprgrf:Play("AttackVert", true)
				enemy:PlaySound(167, 1, 0, false, 1)
			end
		end

		if enemy.State ~= 4 then
			enemy.Velocity = enemy.Velocity * 0.7
		end

		if sprgrf:IsPlaying("AttackVert") and sprgrf:GetFrame() >= 17
		and sprgrf:GetFrame() <= 42 then
			data.vel = math.random(0,75)
			if sprgrf:GetFrame() == 17 then
				enemy:PlaySound(16, 1, 0, false, 1)
			end
			local params = ProjectileParams()
			params.Variant = 7
			params.FallingAccelModifier = 0.5
			params.FallingSpeedModifier = (-125 + data.vel) * 0.2
			params.Scale = math.random(5,12) * 0.1
			params.HeightModifier = -20
			enemy:FireProjectiles(enemy.Position + Vector(0,5), Vector.FromAngle(rng:RandomInt(359)):
			Resized(data.vel*0.1), 0, params)
		end

		if sprgrf:IsFinished("AttackVert") then
			enemy.State = 4
			enemy.StateFrame = math.random(120,200)
		end

		if enemy:IsDead() then
			enemy:PlaySound(427, 1, 0, false, 2)
			Isaac.Spawn(1000, 357, 0, enemy.Position, Vector(0,0), enemy)
			for i=0, 6, 2 do
				Game():SpawnParticles(enemy.Position, 95, 20, i, Color(1.1,1,1,1,0,0,0), -50)
			end
			if math.random(1,2) == 1 then
				Isaac.Spawn(5, 20, 1, enemy.Position, Vector(0,0), enemy)
			end
			for i=45, 315, 90 do
				local params = ProjectileParams()
				params.Variant = 7
				enemy:FireProjectiles(enemy.Position, Vector.FromAngle(i):Resized(7), 0, params)
			end
		end

		if dist < 200 and enemy.FrameCount % 120 == 0 and not sound:IsPlaying(116)
		and enemy.State == 4 then
			enemy:PlaySound(116, 1, 0, false, 1)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.GreedierFatty, 554)

----------------------------
--The Lamb II
----------------------------
function denpnapi:Lamb2(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("The Lamb II") then
  
		local sprl2 = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		local Entities = Isaac:GetRoomEntities()
		local dist = target.Position:Distance(boss.Position)
		local rng = boss:GetDropRNG()
		local angle = (target.Position - boss.Position):GetAngleDegrees()
		boss.SplatColor = Color(0.13,1.73,2.28,1.5,0,0,0)
	
		if not data.dashanim then
			data.dashanim = "none"
		end
	
		if sprl2:IsFinished("Appear") then
			boss.State = 4
			boss.StateFrame = math.random(80,100)
			boss.TargetPosition = boss.Position
		end
	
		if boss.Visible then
			if sprl2:IsPlaying("HeadDashHori") or sprl2:IsPlaying("HeadDashUp")
			or sprl2:IsPlaying("HeadDashDown") then
				if sprl2:IsPlaying("HeadDashHori") then
					data.dashanim = "Hori"
				elseif sprl2:IsPlaying("HeadDashUp") then
					data.dashanim = "Up"
				elseif sprl2:IsPlaying("HeadDashDown") then
					data.dashanim = "Down"
				end
				local aftimage = Isaac.Spawn(1000, 366, 0, boss.Position, Vector(0,0), boss)
				aftimage.FlipX = boss.FlipX
				aftimage:GetSprite():SetFrame("HeadDash"..data.dashanim, sprl2:GetFrame())
			end
		end
	
		if boss.State == 4 then
			boss.EntityCollisionClass = 4
			boss.PositionOffset = Vector(0,
			boss.PositionOffset.Y-(boss.PositionOffset.Y*0.15))
			boss.FlipX = false
			boss.StateFrame = boss.StateFrame - 1
			boss.GridCollisionClass = 3
			boss.ProjectileCooldown = boss.ProjectileCooldown - 1
			if not sprl2:IsPlaying("HeadIdle") then
				sprl2:Play("HeadIdle", true)
				data.spawnpos = Vector(0,0)
				data.WallholeRotate = 0
				data.ExtWallHolePos = Vector(0,0)
				data.WhRtt2 = 0
				data.EntWhPos = Vector(0,0)
				data.projangle = 0
			end
			if boss:HasEntityFlags(1<<11) then
				boss.Velocity = (boss.Velocity * 0.95) + Vector.FromAngle(angle+180):Resized(0.35)
			elseif boss:HasEntityFlags(1<<9) then
				if boss.FrameCount % 100 then
					data.cfvel =  Vector.FromAngle(math.random(0,359)):Resized(0.3)
				end
				boss.Velocity = (boss.Velocity * 0.95) + data.cfvel
			else
				if #Isaac.FindInRadius(boss.Position, 160, 1<<2) > 0 then
					boss.Velocity = (boss.Velocity * 0.95)+Vector.FromAngle(angle):Resized(0.1)
				else
					boss.Velocity = (boss.Velocity * 0.95)+Vector.FromAngle(angle):Resized(0.3)
				end
			end
			if boss.StateFrame <= 0 and dist <= 500 then
				if math.random(1,7) == 1 then
					if math.random(1,2) == 1 then
						sprl2:Play("HeadDashCharge", true)
						boss.State = 10
						boss.I2 = math.random(2,4)
						boss:PlaySound(14, 1, 0, false, 1)
						data.chargestart = false
					else
						sprl2:Play("HeadCharge", true)
						boss.State = 8
						boss:PlaySound(104, 1, 0, false, 1)
						boss.I1 = math.random(0,4)
					end
				elseif math.random(1,7) == 2 then
					if boss.I1 == 1 then
						boss.State = 12
						boss.I2 = math.random(4,7)
						for k, v in pairs(Entities) do
							if v.Type == 400 and v.Variant == 0 then
								v:GetSprite():Play("StompReady", true)
							end
						end
					end
				elseif math.random(1,7) == 3 then
					if #Isaac.FindByType(557, 0, -1, true, true) <= 2
					and #Isaac.FindByType(558, -1, -1, true, true) <= 2 then
						boss.State = 13
						sprl2:Play("HeadSummon", true)
					end
				elseif math.random(1,7) == 4 then
					sprl2:Play("HeadSummon", true)
					boss.State = 11
					boss.StateFrame = 315
				elseif math.random(1,7) == 5 then
					if not (Room:IsLShapedRoom() and Room:GetRoomShape() == 2
					and Room:GetRoomShape() == 3 and Room:GetRoomShape() == 5
					and Room:GetRoomShape() == 7) and not data.isdelirium then
						sprl2:Play("HeadCharge2Start", true)
						boss.State = 21
						boss:PlaySound(312, 1, 0, false, 1)
						if boss.Position.X > target.Position.X then
							boss.FlipX = true
							boss.Velocity = Vector(5,0)
							local wallholext = Isaac.Spawn(1000, 365, 1, Vector(Room:GetTopLeftPos().X, boss.Position.Y), Vector(0,0), boss)
							wallholext:GetSprite().Rotation = 270
							wallholext.PositionOffset = Vector(0,-20)
							wallholext.Parent = boss
						else
							boss.FlipX = false
							boss.Velocity = Vector(-5,0)
							local wallholext = Isaac.Spawn(1000, 365, 1, Vector(Room:GetBottomRightPos().X, boss.Position.Y), Vector(0,0), boss)
							wallholext:GetSprite().Rotation = 90
							wallholext.PositionOffset = Vector(0,-20)
							wallholext.Parent = boss
						end
					end
				else
					if math.abs(target.Position.X-boss.Position.X) < math.abs(target.Position.Y-boss.Position.Y) then
						if target.Position.Y >= boss.Position.Y then
							sprl2:Play("HeadShootDown", true)
						else
							sprl2:Play("HeadShootUp", true)
						end
					else
						sprl2:Play("HeadShootHori", true)
						if target.Position.X <= boss.Position.X then
							boss.FlipX = true
						end
					end
					boss.State = 9
				end
			else
				if #Isaac.FindInRadius(boss.Position, 100, 1<<2) > 0
				and boss.ProjectileCooldown <= 0 then
					if #Isaac.FindInRadius(boss.Position, 15, 1<<2) > 0 then
						boss.State = 6
						boss.ProjectileCooldown = 13
					else
						boss.Velocity = Vector.FromAngle
						((target.Position-boss.Position):GetAngleDegrees()):Resized(-14)
						if math.abs(boss.Position.X-target.Position.X) < math.abs(boss.Position.Y-target.Position.Y) then
							if boss.Position.X < target.Position.X then
								boss:AddVelocity(Vector(-math.abs(boss.Position.X-target.Position.X)*0.075,0))
							else
								boss:AddVelocity(Vector(math.abs(boss.Position.X-target.Position.X)*0.075,0))
							end
						else
							if boss.Position.Y < target.Position.Y then
								boss:AddVelocity(Vector(0,-math.abs(boss.Position.X-target.Position.X)*0.075))
							else
								boss:AddVelocity(Vector(0,math.abs(boss.Position.X-target.Position.X)*0.075))
							end
						end
						boss.State = 25
						boss.I1 = math.random(1,5)
						boss.ProjectileCooldown = 13
						boss:PlaySound(14, 1, 0, false, 1.3)
					end
				end
			end
		else
			boss.Velocity = boss.Velocity * 0.9
			if boss.State == 6 then
				if not sprl2:IsFinished("HeadJump2") and not sprl2:IsPlaying("HeadJump2")
				and not sprl2:IsFinished("HeadAppear") and not sprl2:IsPlaying("HeadAppear") then
					sprl2:Play("HeadJump2", true)
				end
				if sprl2:IsFinished("HeadJump2") then
					sprl2:Play("HeadAppear", true)
					boss.Position = Isaac.GetRandomPosition(0)
					boss:PlaySound(214, 1, 0, false, 1)
				elseif sprl2:IsFinished("HeadAppear") then
					boss.State = 4
				end
				if sprl2:IsPlaying("HeadJump2") then
					if sprl2:GetFrame() == 5 then
						boss:PlaySound(215, 1, 0, false, 1)
						boss.EntityCollisionClass = 0
					end
				elseif sprl2:IsPlaying("HeadAppear") then
					if sprl2:GetFrame() == 6 then
						boss.EntityCollisionClass = 4
					end
				end
			elseif boss.State == 8 then
				if sprl2:IsFinished("HeadCharge") then
					if boss.I1 <= 1 then
						sprl2:Play("HeadShoot", true)
					else
						sprl2:Play("HeadShoot2Start", true)
					end
				elseif sprl2:IsFinished("HeadShoot2Start") then
					sprl2:Play("HeadShoot2Loop", true)
				elseif sprl2:IsFinished("HeadShoot") or sprl2:IsFinished("HeadShoot2End") then
					boss.State = 4
					boss.StateFrame = math.random(80,100)
				end
				if sprl2:IsPlaying("HeadShoot") and sprl2:GetFrame() == 3 then
					if boss.I1 == 0 then
						for i=0, 270, 90 do
							EntityLaser.ShootAngle(1, boss.Position, (math.random(0,1)*45)+i, 20, Vector(0,-50), boss)
						end
					elseif boss.I1 == 1 then
						boss:PlaySound(226, 1, 0, false, 1)
						local params = ProjectileParams()
						params.BulletFlags = 1 << 40 | ProjectileFlags.NO_WALL_COLLIDE
						| ProjectileFlags.ANY_HEIGHT_ENTITY_HIT
						params.CurvingStrength = (20*((math.random(-1,0)*2)+1))*0.001
						params.Scale = 1.5
						params.HeightModifier = -5
						params.FallingAccelModifier = -0.15
						params.Color = Color(0.11,1.5,2,1,0,0,0)
						for i=0, 324, 36 do
							boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(4), 0, params)
						end
					end
				end
				if sprl2:IsEventTriggered("Shoot") then
					boss.ProjectileCooldown = 0
					boss.StateFrame = math.random(160,250)
				end
				if boss.I1 > 1 then
					if boss.StateFrame > 0 then
						boss.StateFrame = boss.StateFrame - 1
						boss.ProjectileCooldown = boss.ProjectileCooldown - 1
						if boss.ProjectileCooldown <= 0 then
							boss:PlaySound(116 , 1, 0, false, 1)
							boss.ProjectileCooldown = 50
						end
						if boss.I1 == 2 and boss.FrameCount % 30 == 0 then
							local params = ProjectileParams()
							params.BulletFlags = 1 << 41 | ProjectileFlags.ANY_HEIGHT_ENTITY_HIT
							params.CurvingStrength = (6*((math.random(-1,0)*2)+1))*0.001
							params.Scale = 1.5
							params.HeightModifier = -10
							params.Color = Color(0.11,1.5,2,1,0,0,0)
							params.FallingAccelModifier = -0.16
							for i=0, 330, 30 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(3), 0, params)
							end
						elseif boss.I1 == 3 then
							if boss.FrameCount % 6 == 0
							or boss.TargetPosition:Distance(boss.Position) <= 50 then
								if math.random(0,3) == 0 then
									boss.TargetPosition = Isaac.GetRandomPosition(0)
								end
								local params = ProjectileParams()
								params.Scale = 1.5
								params.HeightModifier = -10
								params.Color = Color(0.11,1.5,2,1,0,0,0)
								params.FallingAccelModifier = -0.145
								for i=0, 240, 120 do
									boss:FireProjectiles(boss.Position, Vector.FromAngle((boss.FrameCount*3) + i):Resized(5), 0, params)
								end
							end
							boss.Velocity = (boss.Velocity*0.95)
							+ Vector.FromAngle((boss.TargetPosition-boss.Position):GetAngleDegrees())
							:Resized(0.4)
						elseif boss.I1 == 4 and boss.FrameCount % 30 == 0 then
							local params = ProjectileParams()
							params.Scale = 1.5
							params.BulletFlags = 1 << 35 | ProjectileFlags.ANY_HEIGHT_ENTITY_HIT
							params.HeightModifier = -10
							params.Color = Color(0.11,1.5,2,1,0,0,0)
							params.FallingAccelModifier = -0.17
							for i=0, 270, 90 do
								boss:FireProjectiles(boss.Position, Vector.FromAngle(i+(math.random(0,1)*45)):Resized(4), 0, params)
							end
						end
					else
						if sprl2:IsPlaying("HeadShoot2Loop") then
							sprl2:Play("HeadShoot2End", true)
						end
					end
				end
			elseif boss.State == 9 then
				if sprl2:IsEventTriggered("Shoot2") then
					boss:PlaySound(226, 1, 0, false, 1)
					boss:PlaySound(28, 1, 0, false, 1)
					local params = ProjectileParams()
					params.Scale = 2
					params.Color = Color(0.11,1.5,2,1,0,0,0)
					params.BulletFlags = ProjectileFlags.CONTINUUM | ProjectileFlags.ANY_HEIGHT_ENTITY_HIT
					params.FallingAccelModifier = -0.18
					params.HeightModifier = -7
					if sprl2:IsPlaying("HeadShootDown") or sprl2:IsPlaying("HeadShootUp") then
						if sprl2:IsPlaying("HeadShootUp") then
							data.spawnpos = Vector(0,-27)
						else
							data.spawnpos = Vector(0,27)
						end
						boss:FireProjectiles(boss.Position+data.spawnpos,
						Vector(((target.Position.X-boss.Position.X)*0.01)*0.8,data.spawnpos.Y*0.3), 0, params)
						local xplsn = Isaac.Spawn(1000, 2, 2, boss.Position+data.spawnpos, Vector(0,0), boss)
						xplsn:SetColor(Color(0.13,1.73,2.28,1.5,0,0,0), 99999, 0, false, false)
						xplsn.PositionOffset = Vector(0,-50)
						boss.Velocity = Vector(-((target.Position.X-boss.Position.X)*0.01)*0.8,-data.spawnpos.Y*0.3)
					elseif sprl2:IsPlaying("HeadShootHori") then
						if boss.FlipX then
							data.spawnpos = Vector(-27,0)
						else
							data.spawnpos = Vector(27,0)
						end
						boss:FireProjectiles(boss.Position+data.spawnpos,
						Vector(data.spawnpos.X*0.3,((target.Position.X-boss.Position.X)*0.01)*0.8), 0, params)
						local xplsn = Isaac.Spawn(1000, 2, 2, boss.Position+data.spawnpos, Vector(0,0), boss)
						xplsn:SetColor(Color(0.13,1.73,2.28,1.5,0,0,0), 99999, 0, false, false)
						xplsn.PositionOffset = Vector(0,-50)
						boss.Velocity = Vector(-data.spawnpos.X*0.3, -((target.Position.X-boss.Position.X)*0.01)*0.8)
					end
				end
				if sprl2:IsFinished("HeadShootUp") or sprl2:IsFinished("HeadShootDown")
				or sprl2:IsFinished("HeadShootHori") then
					boss.State = 4
					boss.StateFrame = math.random(80,100)
				end
			elseif boss.State == 10 then
				if sprl2:IsFinished("HeadDashCharge") or sprl2:IsFinished("HeadChargeShort") then
					boss.TargetPosition = target.Position
					boss.I2 = boss.I2 - 1
					data.chargestart = true
					boss.StateFrame = 0
					boss:PlaySound(119, 1, 0, false, 1)
				end
				if sprl2:IsFinished("HeadWallCollide") then
					if boss.I2 <= 0 then
						boss.State = 4
						boss.StateFrame = math.random(80,100)
					else
						sprl2:Play("HeadChargeShort", true)
					end
				end
				if math.abs(boss.Position.X-Room:GetCenterPos().X) > math.abs(boss.Position.Y-Room:GetCenterPos().Y) then
					if boss.Position.X > Room:GetCenterPos().X then
						data.projangle = 0
					else
						data.projangle = 180
					end
				else
					if boss.Position.Y > Room:GetCenterPos().Y then
						data.projangle = 90
					else
						data.projangle = 270
					end
				end
				if data.chargestart then
					boss.StateFrame = boss.StateFrame + 1
					if math.abs(boss.Velocity.X) < math.abs(boss.Velocity.Y) then
						if boss.Velocity.Y >= 0 then
							data.hv = "Down"
						else
							data.hv = "Up"
						end
					else
						data.hv = "Hori"
						if boss.Velocity.X <= 0 then
							boss.FlipX = true
						else
							boss.FlipX = false
						end
					end
					if not sprl2:IsPlaying("HeadDash"..data.hv) then
						sprl2:Play("HeadDash"..data.hv, true)
					end
					boss.Velocity = Vector.FromAngle
					((boss.TargetPosition-boss.Position):GetAngleDegrees()):Resized(22)
					boss.TargetPosition = boss.TargetPosition + boss.Velocity
					if boss.StateFrame <= 25 then
						if boss.StateFrame >= 5 then
							if boss:CollidesWithGrid() then
								data.chargestart = false
								boss:PlaySound(52, 1, 0, false, 1)
								Game():ShakeScreen(10)
								local params = ProjectileParams()
								params.Variant = 9
								params.Color = Color(0.5,0.5,0.5,1,0,0,0)
								params.HeightModifier = -10
								params.FallingAccelModifier = 0.2
								for i=7, 15 do
									params.Scale = math.random(70,160)*0.01
									params.FallingSpeedModifier = math.random(-100,-10)*0.1
									boss:FireProjectiles(boss.Position-boss.Velocity,
									Vector.FromAngle(data.projangle - math.random(-55,55)):Resized(-math.random(40,130)*0.1), 0, params)
								end
								if data.hv == "Hori" then
									if boss.Velocity.X <= 0 then
										boss.FlipX = true
									else
										boss.FlipX = false
									end
								end
								sprl2:Play("HeadWallCollide", true)
							end
						end
					else
						boss.Velocity = boss.Velocity * 0.75
						data.chargestart = false
						sprl2:Play("HeadChargeShort", true)
						if boss.I2 <= 0 then
							boss.State = 4
							boss.StateFrame = math.random(80,100)
						end
					end
				end
			elseif boss.State == 11 then
				boss.Velocity = boss.Velocity * 0.9
				boss.StateFrame = boss.StateFrame - 1
				if sprl2:IsPlaying("HeadSummon") then
					if sprl2:GetFrame() == 15 then
						boss:PlaySound(122 , 1, 0, false, 1)
					elseif sprl2:GetFrame() == 32 then
						boss:PlaySound(265, 1, 0, false, 1)
						Isaac.Spawn(1000, 15, 0, boss.Position, Vector(0,0), boss)
						for i=1, 16 do
							local fclone = Isaac.Spawn(1000, 364, 0, boss.Position, Vector(0,0), boss)
							fclone:ToEffect().Timeout = 16 + (i*15) - math.random(0,12)
							fclone.TargetPosition = Isaac.GetRandomPosition(0)
						end
					end
				end
				if sprl2:IsFinished("HeadSummon") then
					sprl2:Play("HeadJump", true)
				end
				if sprl2:IsFinished("HeadJump") then
					if boss.StateFrame <= 0 then
						sprl2:Play("HeadFalling", true)
					end
					boss.EntityCollisionClass = 0
				elseif sprl2:IsFinished("HeadFalling") then
					sprl2:Play("HeadLandStomp", true)
				elseif sprl2:IsFinished("HeadLandStomp") then
					boss.State = 4
					boss.StateFrame = math.random(80,100)
				end
				if sprl2:IsPlaying("HeadJump") and sprl2:GetFrame() == 19 then
					boss:PlaySound(14, 1, 0, false, 1)
				elseif sprl2:IsPlaying("HeadLandStomp") then
					if sprl2:IsEventTriggered("Stomp") then
						Game():BombDamage(boss.Position, 40, 20, true, boss, 0, 1<<2, true)
						SpawnGroundParticle(true, boss, 10, 10, 3, 20)
						local wave = Isaac.Spawn(1000, 61, 0, boss.Position, Vector(0,0), boss):ToEffect()
						wave.Parent = boss
						wave.Timeout = 16
						wave.MaxRadius = 110
					end
				elseif sprl2:IsPlaying("HeadFalling") then
					if sprl2:GetFrame() <= 90 then
						boss:AddVelocity(Vector.FromAngle(angle):Resized(1.6))
					end
				end
			elseif boss.State == 12 then
				boss.PositionOffset = Vector(0,
				boss.PositionOffset.Y-((boss.PositionOffset.Y+40)*0.15))
				boss.EntityCollisionClass = 0
				boss.StateFrame = boss.StateFrame + 1
				if boss.StateFrame == 43 then
					if math.random(1,3) == 1 then
						sprl2:Play("HeadStompUp", true)
					elseif math.random(1,3) == 2 then
						sprl2:Play("HeadStompDown", true)
					else
						sprl2:Play("HeadStompHori", true)
						if math.random(0,1) == 1 then
							boss.FlipX = true
						else
							boss.FlipX = false
						end
					end
				end
	
				if Room:GetRoomShape() >= 8 then
					boss.Velocity = Vector.FromAngle((Vector(560,440) - boss.Position):GetAngleDegrees())
					:Resized(Vector(560,440):Distance(boss.Position)*0.14)
				elseif Room:GetRoomShape() >= 6 then
					boss.Velocity = Vector.FromAngle((Vector(560,280) - boss.Position):GetAngleDegrees())
					:Resized(Vector(560,280):Distance(boss.Position)*0.14)
				elseif Room:GetRoomShape() >= 4 then
					boss.Velocity = Vector.FromAngle((Vector(320,440) - boss.Position):GetAngleDegrees())
					:Resized(Vector(320,440):Distance(boss.Position)*0.14)
				else
					boss.Velocity = Vector.FromAngle((Vector(320,280) - boss.Position):GetAngleDegrees())
					:Resized(Vector(320,280):Distance(boss.Position)*0.14)
				end
	
				if sprl2:IsPlaying("HeadStompUp") or sprl2:IsPlaying("HeadStompDown")
				or sprl2:IsPlaying("HeadStompHori") then
					if sprl2:GetFrame() == 1 then
						boss.I2 = boss.I2 - 1
						if sprl2:IsPlaying("HeadStompDown") then
							Game():Spawn(507, 0, boss.Position+Vector.FromAngle(90):Resized(130), Vector(0,0), boss, 1, 0)
						elseif sprl2:IsPlaying("HeadStompUp") then
							Game():Spawn(507, 0, boss.Position+Vector.FromAngle(270):Resized(130), Vector(0,0), boss, 1, 0)
						elseif sprl2:IsPlaying("HeadStompHori") then
							if boss.FlipX then
								Game():Spawn(507, 0, boss.Position+Vector.FromAngle(180):Resized(170), Vector(0,0), boss, 1, 0)
							else
								Game():Spawn(507, 0, boss.Position+Vector.FromAngle(0):Resized(170), Vector(0,0), boss, 1, 0)
							end
						end
					end
					if sprl2:GetFrame() == 36 then
						boss:PlaySound(306 , 1.3, 0, false, 1)
					end
					if boss.I2 > 0 and sprl2:GetFrame() == 75 then
						if math.random(1,3) == 1 then
							sprl2:Play("HeadStompUp", true)
						elseif math.random(1,3) == 2 then
							sprl2:Play("HeadStompDown", true)
						else
							sprl2:Play("HeadStompHori", true)
							if math.random(0,1) == 1 then
								boss.FlipX = true
							else
								boss.FlipX = false
							end
						end
					end
				end
	
				if sprl2:IsFinished("HeadStompUp") or sprl2:IsFinished("HeadStompDown")
				or sprl2:IsFinished("HeadStompHori") then
					boss.State = 4
					boss.StateFrame = math.random(80,100)
					boss.EntityCollisionClass = 4
				end
			elseif boss.State == 13 then
				if sprl2:IsPlaying("HeadSummon") then
					if sprl2:GetFrame() == 15 then
						boss:PlaySound(122 , 1, 0, false, 1)
					elseif sprl2:GetFrame() == 32 then
						boss:PlaySound(265 , 1, 0, false, 1)
						for i=-90, 90, 180 do
							local lfallen = Isaac.Spawn(558, 0, 0, boss.Position+Vector(i,0), Vector(0,0), boss)
							lfallen.HitPoints = 25
							lfallen.MaxHitPoints = 25
						end
					end
				end
				if sprl2:IsFinished("HeadSummon") then
					boss.State = 4
					boss.StateFrame = math.random(80,100)
				end
			elseif boss.State == 21 then
				if sprl2:IsFinished("HeadCharge2Start") then
					sprl2:Play("HeadCharge2Loop", true)
					boss.StateFrame = 50
				elseif sprl2:IsFinished("HeadBrake") then
					boss.State = 4
					boss.StateFrame = math.random(80,100)
				end
				if sprl2:IsPlaying("HeadBrake") then
					boss.Velocity = boss.Velocity * 0.9
				elseif sprl2:IsPlaying("HeadCharge2Loop") then
					boss.Velocity = boss.Velocity * 0.98
				end
				if sprl2:IsPlaying("HeadCharge2Loop") then
					boss.StateFrame = boss.StateFrame - 1
					if boss.StateFrame <= 0 then
						sprl2:Play("HeadDashHori", true)
						Game():ShakeScreen(5)
						boss:PlaySound(115 , 1, 0, false, 1)
						boss.I2 = 13
						boss.GridCollisionClass = 0
					end
				elseif sprl2:IsPlaying("HeadDashHori") or sprl2:IsPlaying("HeadDashUp")
				or sprl2:IsPlaying("HeadDashDown") then
					if boss.Visible then
						if sprl2:IsPlaying("HeadDashHori") then
							boss.GridCollisionClass = 1
							if boss.FlipX then
								boss.Velocity = Vector(-30, 0)
							else
								boss.Velocity = Vector(30, 0)
							end
							if boss.I2 <= 0 then
								boss.StateFrame = boss.StateFrame + 1
								if boss.StateFrame >= 35 then
									sprl2:Play("HeadBrake", true)
								end
							end
						elseif sprl2:IsPlaying("HeadDashUp") then
							boss.Velocity = Vector(0, -30)
						elseif sprl2:IsPlaying("HeadDashDown") then
							boss.Velocity = Vector(0, 30)
						end
						if (sprl2:IsPlaying("HeadDashHori") and ((boss.FlipX
						and boss.Position.X <= Room:GetTopLeftPos().X)))
						or (not boss.FlipX and boss.Position.X >= Room:GetBottomRightPos().X)
						or (sprl2:IsPlaying("HeadDashUp") and boss.Position.Y <= Room:GetTopLeftPos().Y)
						or (sprl2:IsPlaying("HeadDashDown") and boss.Position.Y >= Room:GetBottomRightPos().Y)	then
							boss:PlaySound(28, 1, 0, false, 1)
							Game():ShakeScreen(10)
							boss.Visible = false
							boss.EntityCollisionClass = 0
							boss.StateFrame = 0
							boss.I2 = boss.I2 - 1
							local xplsn = Isaac.Spawn(1000, 2, 2, boss.Position, Vector(0,0), boss)
							xplsn:SetColor(Color(0.13,1.73,2.28,1.5,0,0,0), 99999, 0, false, false)
							xplsn.PositionOffset = Vector(0,-20)
							boss.Velocity = Vector(0, 0)
						end
					else
						boss.StateFrame = boss.StateFrame + 1
						if boss.StateFrame == 6 then
							if boss.I2 <= 1 then
								boss.I1 = 1
							else
								boss.I1 = math.random(1,4)
							end
							if boss.I1 == 1 then
								if Room:GetBottomRightPos().X <= 650 then
									boss.TargetPosition = Room:GetTopLeftPos() + Vector(0, math.random(20,290))
								else
									boss.TargetPosition = Room:GetTopLeftPos() + Vector(0, math.random(20,550))
								end
								data.WallholeRotate = 270
								data.ExtWallHolePos = Vector(Room:GetBottomRightPos().X, boss.TargetPosition.Y)
							elseif boss.I1 == 2 then
								if Room:GetBottomRightPos().X <= 650 then
									boss.TargetPosition = Room:GetBottomRightPos() - Vector(0, math.random(20,290))
								else
									boss.TargetPosition = Room:GetBottomRightPos() - Vector(0, math.random(20,550))
								end
								data.WallholeRotate = 90
								data.ExtWallHolePos = Vector(Room:GetTopLeftPos().X, boss.TargetPosition.Y)
							elseif boss.I1 == 3 then
								if Room:GetBottomRightPos().Y <= 500 then
									boss.TargetPosition = Room:GetBottomRightPos() - Vector(math.random(20,500), 0)
								else
									boss.TargetPosition = Room:GetBottomRightPos() - Vector(math.random(20,1000), 0)
								end
								data.WallholeRotate = 180
								data.ExtWallHolePos = Vector(boss.TargetPosition.X, Room:GetTopLeftPos().Y)
							else
								if Room:GetBottomRightPos().Y <= 500 then
									boss.TargetPosition = Room:GetTopLeftPos() + Vector(math.random(20,500), 0)
								else
									boss.TargetPosition = Room:GetTopLeftPos() + Vector(math.random(20,1000), 0)
								end
								data.WallholeRotate = 0
								data.ExtWallHolePos = Vector(boss.TargetPosition.X, Room:GetBottomRightPos().Y)
							end
							boss.Position = boss.TargetPosition
							local wallholent = Isaac.Spawn(1000, 365, 0, boss.Position, Vector(0,0), boss)
							wallholent:GetSprite().Rotation = data.WallholeRotate
							wallholent.PositionOffset = Vector(0,-20)
							if boss.I2 > 0 then
								local wallholext = Isaac.Spawn(1000, 365, 1, data.ExtWallHolePos, Vector(0,0), boss)
								wallholext:GetSprite().Rotation = data.WallholeRotate + 180
								wallholext.PositionOffset = Vector(0,-20)
								wallholext.Parent = boss
							end
						elseif boss.StateFrame == 19 + boss.I2 then
							if boss.I2 > 0 and boss.I2 <= 8 then
								if math.random(1,4) == 1 then
									data.WhRtt2 = 270
									if Room:GetBottomRightPos().X <= 650 then
										data.EntWhPos = Room:GetTopLeftPos() + Vector(0, math.random(20,290))
									else
										data.EntWhPos = Room:GetTopLeftPos() + Vector(0, math.random(20,550))
									end
								elseif math.random(1,4) == 2 then
									data.WhRtt2 = 90
									if Room:GetBottomRightPos().X <= 650 then
										data.EntWhPos = Room:GetBottomRightPos() - Vector(0, math.random(20,290))
									else
										data.EntWhPos = Room:GetBottomRightPos() - Vector(0, math.random(20,550))
									end
								elseif math.random(1,4) == 3 then
									data.WhRtt2 = 180
									if Room:GetBottomRightPos().Y <= 500 then
										data.EntWhPos = Room:GetBottomRightPos() - Vector(math.random(20,500), 0)
									else
										data.EntWhPos = Room:GetBottomRightPos() - Vector(math.random(20,1000), 0)
									end
								else
									data.WhRtt2 = 0
									if Room:GetBottomRightPos().Y <= 500 then
										data.EntWhPos = Room:GetTopLeftPos() + Vector(math.random(20,500), 0)
									else
										data.EntWhPos = Room:GetTopLeftPos() + Vector(math.random(20,1000), 0)
									end
								end
								local wallholent = Isaac.Spawn(1000, 365, 2, data.EntWhPos, Vector(0,0), boss)
								wallholent:GetSprite().Rotation = data.WhRtt2
								wallholent.PositionOffset = Vector(0,-20)
							end
						end
						if boss.StateFrame >= 28 + boss.I2 then
							boss.Visible = true
							boss.EntityCollisionClass = 4
							boss:PlaySound(28, 1, 0, false, 1)
							boss:PlaySound(119, 1, 0, false, 1)
							Game():ShakeScreen(10)
							if boss.I1 == 1 then
								sprl2:Play("HeadDashHori", true)
								boss.FlipX = false
							elseif boss.I1 == 2 then
								sprl2:Play("HeadDashHori", true)
								boss.FlipX = true
							elseif boss.I1 == 3 then
								sprl2:Play("HeadDashUp", true)
							else
								sprl2:Play("HeadDashDown", true)
							end
							local xplsn = Isaac.Spawn(1000, 2, 2, boss.Position, Vector(0,0), boss)
							xplsn:SetColor(Color(0.13,1.73,2.28,1.5,0,0,0), 99999, 0, false, false)
							xplsn.PositionOffset = Vector(0,-20)
						end
					end
				end
			elseif boss.State == 25 then
				boss.Velocity = boss.Velocity * 0.95
				if boss.I1 ~= 5 then
					if boss.I1 < 5 then
						if not sprl2:IsPlaying("HeadBackDash") and not sprl2:IsFinished("HeadBackDash") then
							sprl2:Play("HeadBackDash", true)
							if boss.Velocity.X < 0 then
								boss.FlipX = true
							end
						end
						if sprl2:IsFinished("HeadBackDash") then
							boss.State = 4
							boss.FlipX = false
						end
					elseif boss.I1 == 6 then
						if sprl2:IsFinished("HeadBackDash2") then
							sprl2:Play("HeadDashHori", true)
							if boss.FlipX then
								boss.FlipX = false
							else
								boss.FlipX = true
							end
						elseif sprl2:IsFinished("HeadWallCollideHori") then
							boss.State = 4
							boss.FlipX = false
						end
						if sprl2:IsPlaying("HeadDashHori")
						or sprl2:IsPlaying("HeadBackDash2") then
							if boss.FlipX then
								if sprl2:IsPlaying("HeadDashHori") then
									boss.Velocity = Vector(-22, boss.Velocity.Y * 0.8)
								else
									boss.Velocity = Vector(22, boss.Velocity.Y * 0.8)
								end
							else
								if sprl2:IsPlaying("HeadDashHori") then
									boss.Velocity = Vector(22, boss.Velocity.Y * 0.8)
								else
									boss.Velocity = Vector(-22, boss.Velocity.Y * 0.8)
								end
							end
						end
						if sprl2:IsPlaying("HeadDashHori") then
							if boss.Position.Y > target.Position.Y then
								boss:AddVelocity(Vector(0,-1))
							else
								boss:AddVelocity(Vector(0,1))
							end
							if (not boss.FlipX and boss.Position.X >= Room:GetBottomRightPos().X - 30)
							or (boss.FlipX and boss.Position.X <= Room:GetTopLeftPos().X + 30) then
								boss:PlaySound(52, 1, 0, false, 1)
								Game():ShakeScreen(10)
								local params = ProjectileParams()
								params.Variant = 9
								params.HeightModifier = -10
								params.FallingAccelModifier = 0.2
								for i=7, 15 do
									params.Scale = math.random(70,160)*0.01
									params.FallingSpeedModifier = math.random(-100,-10)*0.1
									boss:FireProjectiles(boss.Position-boss.Velocity, Vector.FromAngle(boss.Velocity:GetAngleDegrees()
									+ math.random(-70,70)):Resized(-math.random(40,130)*0.1), 0, params)
								end
								sprl2:Play("HeadWallCollideHori", true)
								boss.Velocity = Vector(0,0)
							end
						end
					end
				else
					if not sprl2:IsPlaying("HeadBackDash2") and not sprl2:IsFinished("HeadBackDash2") then
						sprl2:Play("HeadBackDash2", true)
						if boss.Velocity.X < 0 then
							boss.FlipX = true
						end
					end
					if sprl2:IsPlaying("HeadBackDash2") and sprl2:GetFrame() == 20 then
						boss.I1 = 6
						boss:PlaySound(119, 1, 0, false, 1)
					end
				end
			end
		end
  
	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.Lamb2, 555)

----------------------------
--New Object:Lamb II Clone
----------------------------
function denpnapi:L2Clone(boss)

	if boss.Variant == Isaac.GetEntityVariantByName("Lamb II Clone") then

		local sprl2 = boss:GetSprite()
		local target = boss:GetPlayerTarget()
		local data = boss:GetData()
		boss:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		boss:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		boss.GridCollisionClass = 0
		boss.EntityCollisionClass = 1

		if boss.State == 0 then
			boss.State = 8
			boss:PlaySound(119, 1, 0, false, 1)
			boss.Visible = true
			if math.abs(boss.Velocity.X) >= math.abs(boss.Velocity.Y) then
				sprl2:Play("HeadDashHoriC", true)
				if boss.Velocity.X < 0 then
					local wallholext = Isaac.Spawn(1000, 365, 1, Vector(Room:GetTopLeftPos().X, boss.Position.Y), Vector(0,0), boss)
					wallholext:GetSprite().Rotation = 270
					wallholext.Parent = boss
					wallholext.PositionOffset = Vector(0,-20)
					boss.FlipX = true
				else
					local wallholext = Isaac.Spawn(1000, 365, 1, Vector(Room:GetBottomRightPos().X, boss.Position.Y), Vector(0,0), boss)
					wallholext:GetSprite().Rotation = 90
					wallholext.Parent = boss
					wallholext.PositionOffset = Vector(0,-20)
				end
			else
				if boss.Velocity.Y < 0 then
					sprl2:Play("HeadDashUpC", true)
					local wallholext = Isaac.Spawn(1000, 365, 1, Vector(boss.Position.X, Room:GetTopLeftPos().Y), Vector(0,0), boss)
					wallholext.Parent = boss
				else
					sprl2:Play("HeadDashDownC", true)
					local wallholext = Isaac.Spawn(1000, 365, 1, Vector(boss.Position.X, Room:GetBottomRightPos().Y), Vector(0,0), boss)
					wallholext.Parent = boss
					wallholext:GetSprite().Rotation = 180
				end
			end
		end

		if sprl2:IsPlaying("HeadDashHoriC") then
			data.dashanim = "HoriC"
			if not boss.FlipX then
				boss.Velocity = Vector(33, boss.Velocity.Y * 0.9)
				if boss.Position.X >= Room:GetBottomRightPos().X + 10 then
					boss.I1 = 1
				end
			else
				boss.Velocity = Vector(-33, boss.Velocity.Y * 0.9)
				if boss.Position.X <= Room:GetTopLeftPos().X - 10 then
					boss.I1 = 1
				end
			end
		elseif sprl2:IsPlaying("HeadDashUpC") then
			data.dashanim = "UpC"
			boss.Velocity = Vector(boss.Velocity.X * 0.9, -33)
			if boss.Position.Y <= Room:GetTopLeftPos().Y - 10 then
				boss.I1 = 1
			end
		elseif sprl2:IsPlaying("HeadDashDownC") then
			data.dashanim = "DownC"
			boss.Velocity = Vector(boss.Velocity.X * 0.9, 33)
			if boss.Position.Y >= Room:GetBottomRightPos().Y + 10 then
				boss.I1 = 1
			end
		end

		local aftimage = Isaac.Spawn(1000, 366, 0, boss.Position, Vector(0,0), boss)
		aftimage.FlipX = boss.FlipX
		aftimage:GetSprite():SetFrame("HeadDash"..data.dashanim, sprl2:GetFrame())

		if boss.I1 == 1 then
			boss:Remove()
			boss:PlaySound(28, 1, 0, false, 1)
			Game():ShakeScreen(10)
			local xplsn = Isaac.Spawn(1000, 2, 2, boss.Position, Vector(0,0), boss)
			xplsn:SetColor(Color(0.13,1.73,2.28,1.5,0,0,0), 99999, 0, false, false)
			xplsn.PositionOffset = Vector(0,-20)
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.L2Clone, 555)

----------------------------
--Lil Fallen's Skull
----------------------------
function denpnapi:LFSkull(obj)

	if obj.Variant == Isaac.GetEntityVariantByName("Lil Fallen's Skull") then

		local sprfls = obj:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		obj:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		obj:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		obj:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		obj:RemoveStatusEffects()
		obj.Velocity = obj.Velocity * 0.75
		obj.EntityCollisionClass = 1

		if obj.State <= 2 and sprfls:IsFinished("Drop") then
			sprfls:Play("Drop", true)
			obj.State = 3
		end

		if sprfls:IsPlaying("Drop") and sprfls:GetFrame() == 11 then
			obj:PlaySound(467, 1, 0, false, 0.35)
		end

		for k, v in pairs(Entities) do
			local vspr = v:GetSprite()
			if v.Type == 400 and v:ToNPC().State == 13 and vspr:IsPlaying("Rebirth")
			and vspr:GetFrame() > 5 and vspr:GetFrame() <= 10 then
				obj.I1 = 1
			end
		end

		if obj.I1 ~= 0 then
			obj:Remove()
			Isaac.Spawn(558, 2, 0, obj.Position, Vector(0,0), obj)
		end

		if #Isaac.FindByType(273, 0, -1, true, true) <= 0
		and #Isaac.FindByType(400, 0, -1, true, true) <= 0
		and #Isaac.FindByType(555, -1, -1, true, true) <= 0 then
			Isaac.Spawn(1000, 15, 1, obj.Position, Vector(0,0), obj)
			obj:Kill()
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.LFSkull, 557)

----------------------------
--New Enemy Variant:Little Fallen
----------------------------
function denpnapi:LilFallen(enemy)

	if enemy.Variant == Isaac.GetEntityVariantByName("Little Fallen") then

		local sprlfl = enemy:GetSprite()
		local Entities = Isaac:GetRoomEntities()
		local target = enemy:GetPlayerTarget()
		local angle = (target.Position - enemy.Position):GetAngleDegrees()
		local dist = target.Position:Distance(enemy.Position)

		if sprlfl:IsFinished("Appear") and enemy.State <= 1 then
			enemy.State = 4
		end

		if enemy.State == 3 then
			enemy.State = 4
		end

		if enemy.State == 4 then
			enemy.StateFrame = enemy.StateFrame - 1
			enemy.Velocity = (enemy.Velocity * 0.8) + Vector.FromAngle(angle):Resized(0.2)
			if not sprlfl:IsPlaying("Move") then
				sprlfl:Play("Move",true)
			end
			if dist <= 300 and enemy.StateFrame <= 0 then
				enemy.State = 8
			end
		else
			enemy.Velocity = enemy.Velocity * 0.8
			if enemy.State == 8 then
				if not sprlfl:IsPlaying("Attack") and not sprlfl:IsFinished("Attack") then
					sprlfl:Play("Attack",true)
				end
				if sprlfl:IsFinished("Attack") then
					enemy.State = 4
					enemy.StateFrame = 15
				end
				if sprlfl:IsPlaying("Attack") then
					if sprlfl:GetFrame() == 13 then
						enemy:PlaySound(44, 1, 0, false, 1)
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.05
						enemy:FireProjectiles(enemy.Position, Vector.FromAngle(angle):Resized(8), 1, params)
					elseif sprlfl:GetFrame() == 37 then
						sound:Stop(44)
						enemy:PlaySound(44, 1, 0, false, 1)
						local params = ProjectileParams()
						enemy:FireProjectiles(enemy.Position, Vector.FromAngle(angle):Resized(10), 0, params)
					end
				end
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.LilFallen, 558)

----------------------------
--New Enemy Variant:Baby Bone
----------------------------
function denpnapi:BabyBone(enemy)

	if enemy.Variant == 1 or enemy.Variant == 2 then

		local sprbbn = enemy:GetSprite()
		local target = enemy:GetPlayerTarget()
		local angle = (target.Position - enemy.Position):GetAngleDegrees()

		if sprbbn:IsFinished("Appear") then
			enemy.State = 4
			sprbbn:Play("Move",true)
		end
		if enemy.State == 4 then
			enemy.Velocity = (enemy.Velocity * 0.9) + Vector.FromAngle(angle):Resized(0.3)
			if enemy.ProjectileCooldown <= 0 then
				sprbbn:Play("Vanish",true)
				enemy.State = 6
			end
			enemy.EntityCollisionClass = 4
		else
			enemy.Velocity = enemy.Velocity * 0.9
		end

		if enemy.State == 0 then
			enemy.ProjectileCooldown = math.random(150,250)
		end

		enemy.ProjectileCooldown = enemy.ProjectileCooldown - 1

		if enemy.State == 6 then
			enemy.EntityCollisionClass = 0
			if sprbbn:IsFinished("Vanish") then
				sprbbn:Play("Vanish2",true)
				enemy.Position = Isaac.GetRandomPosition(0)
			end
			if sprbbn:IsFinished("Vanish2") then
				sprbbn:Play("Move",true)
				enemy.State = 4
				enemy.ProjectileCooldown = math.random(150,250)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.BabyBone, 558)

----------------------------
--New Enemy:Hush's BloodVessel
----------------------------
function denpnapi:BVesselH(vessel)

	if vessel.Variant == Isaac.GetEntityVariantByName("Hush's BloodVessel") then

		local sprvsl = vessel:GetSprite()
		local rng = vessel:GetDropRNG()
		local data = vessel:GetData()
		local path = vessel.Pathfinder
		vessel:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		vessel:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		vessel:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		vessel:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		vessel:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		vessel:RemoveStatusEffects()
		vessel.Velocity = Vector(0,0)
		path:FindGridPath(vessel.Position, 0, 900, false)

		if ((sprvsl:IsPlaying("Swelling") or sprvsl:IsPlaying("Subsides1")
		or sprvsl:IsPlaying("Subsides2")) and sprvsl:GetFrame() < 16)
		or sprvsl:IsPlaying("Swell") or sprvsl:IsPlaying("SwellLoop")
		or sprvsl:IsPlaying("Burst") or sprvsl:IsPlaying("BurstLoop") then
			vessel.DepthOffset = 0
		else
			vessel.DepthOffset = -40
		end

		data.height = math.random(15,50)

		if sprvsl:IsFinished("Appear") then
			if vessel.SubType >= 3 then
				sprvsl:ReplaceSpritesheet(0, "gfx/effects/bloodvessel_hush3.png")
				sprvsl:LoadGraphics()
				vessel.StateFrame = 67
			elseif vessel.SubType == 2 then
				sprvsl:ReplaceSpritesheet(0, "gfx/effects/bloodvessel_hush2.png")
				sprvsl:LoadGraphics()
				vessel.StateFrame = 60
			elseif vessel.SubType == 1 then
				vessel.FlipX = true
				vessel.StateFrame = 53
			else
				vessel.StateFrame = 46
			end
			sprvsl:Play("Swelling", true)
		elseif sprvsl:IsFinished("Swell") then
			sprvsl:Play("SwellLoop", true)
		elseif sprvsl:IsFinished("Burst") then
			sprvsl:Play("BurstLoop", true)
		end

		if vessel.FrameCount == 65 then
			sprvsl:Play("Swell", true)
		end

		if sprvsl:IsFinished("Subsides1") or sprvsl:IsFinished("Subsides2") then
			vessel.EntityCollisionClass = 0
		end

		if vessel.StateFrame >= 400 then
			vessel.State = 12
		end

		if vessel.SpawnerEntity then
			if vessel.State ~= 12 then
				vessel.StateFrame = vessel.StateFrame + 1
				if vessel.StateFrame >= 190
				and sprvsl:IsPlaying("SwellLoop") then
					sprvsl:Play("Burst", true)
					vessel:PlaySound(211, 1, 0, false, 1)
					vessel:PlaySound(52, 1.5, 0, false, 1)
					Game():ShakeScreen(30)
					local expl = Isaac.Spawn(1000, 2, 0, vessel.Position, Vector(0,0), vessel)
					expl.SpriteOffset = Vector(0,-24)
				end
				if sprvsl:IsPlaying("BurstLoop") then
					if vessel.StateFrame >= 400 then
						sprvsl:Play("Subsides1", true)
						vessel.StateFrame = math.random(800,1000)
					end
				end
				if (sprvsl:IsPlaying("Burst") or sprvsl:IsPlaying("BurstLoop")) then
					if vessel.FrameCount % 2 == 0 and vessel.StateFrame <= 380 then
						local params = ProjectileParams()
						params.HeightModifier = -4
						params.FallingSpeedModifier = -data.height * 1.2
						params.FallingAccelModifier = 1
						params.Scale = math.random(10,15) * 0.1
						vessel:FireProjectiles(vessel.Position,
						Vector.FromAngle(rng:RandomInt(359)):Resized(10 - (data.height * 0.2)), 0, params)
					end
					if vessel.FrameCount % 40 == 0 and vessel.StateFrame <= 320 then
						EntityNPC.ThrowSpider(vessel.Position, vessel,
						vessel.Position + Vector.FromAngle(rng:RandomInt(359)):Resized(100 - (data.height * 0.2)), false, -data.height)
					end
				end
			else
				vessel.StateFrame = vessel.StateFrame - 1
				if vessel.StateFrame <= 0
				and (sprvsl:IsFinished("Subsides1") or sprvsl:IsFinished("Summon"))
				and vessel.SpawnerEntity.Position:Distance(vessel.Position) > 110
				and #Isaac.FindByType(85, 402, -1, true, true) < 10 then
					sprvsl:Play("Summon", true)
				end
				if sprvsl:IsPlaying("Summon") and sprvsl:GetFrame() == 70 then
					if not vessel.SpawnerEntity:GetSprite():IsPlaying("Death")
					and vessel.SpawnerEntity.Position:Distance(vessel.Position) > 110
					and #Isaac.FindByType(85, 402, -1, true, true) < 10 then
						Isaac.Spawn(85, 402, 0, vessel.Position, Vector(0,0), vessel)
						vessel:PlaySound(181, 1, 0, false, 1)
					end
					vessel.StateFrame = math.random(800,1000)
				end
			end
		else
			if sprvsl:IsPlaying("Swell") or sprvsl:IsPlaying("SwellLoop") then
				sprvsl:Play("Subsides2", true)
			elseif sprvsl:IsPlaying("BurstLoop") then
				sprvsl:Play("Subsides1", true)
			end
		end

	end
end

denpnapi:AddCallback(ModCallbacks.MC_NPC_UPDATE, denpnapi.BVesselH, 608)

function denpnapi:hit(entity,amount,damageflag,source,num)

	local Entities = Isaac:GetRoomEntities()
	local player = Game():GetPlayer(1)
	local rng = entity:GetDropRNG()
	local enspr = entity:GetSprite()
	local edata = entity:GetData()

	if (entity:IsBoss() and source.Type == 1000 and source.Variant == 356)
	or (entity.Type == 70 and source.Type == 70)
	or (entity:IsBoss() and source.Type == 70 and damageflag ~= 1<<2)
	or (entity.Type == 78 and enspr:IsPlaying("HeartHidingHeartbeat2"))
	or (entity.Type == 273 and source.Type == 507)
	or (entity.Type == 396 and source.Type == 396)
	or (damageflag == 1<<2 and ((entity.Type == 397 or entity.Type == 398) and source.Type == 9))
	or (entity.Type == 400 and (source.Type == 273 or source.Type == 555))
	or (entity.Type == 400 and damageflag == 1<<2 and source.Type == 507)
	or (entity.Type == 544 and entity.SubType == 1)
	or (entity.Type == 549 and entity.SpawnerType == 78 and source.Type == 78)
	or (damageflag == 1<<2 and (entity.Type == 555 or source.Type == 555))
	or (entity.Type == 555 and entity.EntityCollisionClass == 0)
	or (entity.Type == 406 and source.Type == 1000 and source.Variant == 353)
	or (entity.Type == 506 and entity.Variant <= 1) then
		return false
	end
	if entity.Type == 552 then
		if damageflag == 1<<2 or damageflag == 1<<3 then -- explosion
			entity:Die()
		else
			if source.Type == 8 then
				entity.HitPoints = entity.HitPoints + amount
				entity.Velocity = entity.Velocity + Vector.FromAngle((entity.Position-source.Position):GetAngleDegrees()):
				Resized(amount*0.08)
			else
				return false
			end
		end
	elseif entity.Type == 85 and entity.Variant == 402 then
		if entity.FrameCount <= 250 and amount > 1.5
		and entity:IsVulnerableEnemy() then
			entity.HitPoints = entity.HitPoints + amount - 1.5
		end
	end
	if Game().Difficulty == 1 or Game().Difficulty == 3 then
		if (damageflag == 1<<2 and (entity.Type == 273 and source.Type == 9))
		or (damageflag == 1<<2 and (entity.Type == 406 and source.Type == 9))
		or (entity.Type == 406 and (source.Type == 406 or (source.Type == 100
		and source.Variant == 368))) or (entity.Type == 412
		and (source.Type == 1000 and source.Variant == 19 and source.SubType == 1)) then
			return false
		end
		if entity.Type == 45 and entity.Variant == 0 then
			if enspr:IsPlaying("EyeAttack") and enspr:GetFrame() <= 61 then
				edata.eyeHp = edata.eyeHp - amount
			end
		elseif entity.Type == 273 and entity.Variant == 0 then
			if amount >= 50000 and entity.HitPoints/entity.MaxHitPoints < 0.5 then
				edata.planc = true
			end
		elseif entity.Type == 275 and entity.Variant == 0 then
			if not edata.summonpattern
			and (amount >= entity.MaxHitPoints * 0.5
			or entity.HitPoints/entity.MaxHitPoints <= 0.5) then
				entity.HitPoints = entity.MaxHitPoints * 0.5
				return false
			end
		elseif entity.Type == 396 and entity.Variant == 0 then
			if enspr:IsPlaying("EyeAttack") and enspr:GetFrame() <= 61 then
				edata.eyeHp = edata.eyeHp - amount
			end
			if entity:ToNPC().State == 10 then
				if not enspr:IsPlaying("WigHit")
				and (damageflag == 1<<2 or damageflag == 1<<3
				or source.Type == 2 or source.Type == 9) then
					if source.Type == 2 then
						entity:ToNPC():PlaySound(181, 1, 0, false, 1)
						enspr:Play("WigHit", true)
					end
					for i=0, edata.numspider do
						if i > 0 then
							EntityNPC.ThrowSpider(entity.Position, e, entity.Position + Vector.FromAngle(enspr.Rotation+90+math.random(-80,80)):Resized(math.random(50,150)), false, -15)
						end
					end
				end
				return false
			elseif entity:ToNPC().State == 15 then
				return false
			end
		end
	end
	if amount >= 50000 then
		if entity.Type == 555 and entity.Variant == 0 then
			entity:GetData().planc = true
		end
	end
	if (entity.Type == 102 and entity.Variant <= 1 and entity:ToNPC().State == 155)
	or (entity.Type == 78 and ((entity:ToNPC().I1 == 7 and not enspr:IsPlaying("HeartStomp")) or source.Type == 78))
	or (entity.Type == 102 and (not entity.Visible or (enspr:IsPlaying("4FBAttackStart") and entity.EntityCollisionClass == 0) or enspr:IsPlaying("4Evolve")))
	or entity.Type == 184
	or (entity.Type == 275 and enspr:IsPlaying("Up"))
	or (entity.Type == 396 and (entity.EntityCollisionClass == 0 or entity.FrameCount < 30 or entity:GetSprite():IsPlaying("Hurt")))
	or (entity.Type == 397 and entity:GetSprite():IsPlaying("Hurt"))
	or (entity.Type == 398 and ((entity:GetSprite():IsPlaying("Jump") or entity:GetSprite():IsPlaying("Appear")) or entity:ToNPC().State == 15))
	or entity.Type == 399
	or (entity.Type == 407 and enspr:IsFinished("DissapearLong"))
	or (entity.Type == 407 and edata.breathhold)
	or (entity.Type == 544 and entity.SubType == 1)
	or entity.Type == 545
	or (entity.Type == 555 and not entity.Visible and entity:ToNPC().State == 21) then
		return false
	end
	if ((entity.Type == 396 or entity.Type == 397)
	or (entity.Type == 398 and entity.Variant == 0)) and amount >= 20
	and math.random(1,9) == 1 then
		entity:GetData().hurt = true
	end
	if entity.Type == 400 and math.random(1,8) == 1 then
		entity:GetData().hurtattack = true
	end
	if entity.Type == 406 and entity.Variant == 1 then
		if Game().Difficulty == 1 or Game().Difficulty == 3 then
			if entity:ToNPC().State == 22 then
				edata.tripgauge = edata.tripgauge + amount
			end
		end
		if entity.EntityCollisionClass == 0 then
			return false
		end
	end
	if entity.Type == 412 and (Game().Difficulty == 1 or Game().Difficulty == 3) then
		if player:HasPlayerForm(2) and math.random(1,3) == 1 then
			local spore = Isaac.Spawn(9, 10, 999, entity.Position,
			Vector.FromAngle(rng:RandomInt(359)):Resized(math.random(10,40)*0.1), entity):ToProjectile()
			spore.FallingSpeed = -math.random(17,80) * 0.1
			spore.Scale = math.random(10,20) * 0.1
			spore.Acceleration = 0.94
		end
		if player:HasPlayerForm(9) and math.random(1,5) == 1 then
			local corn = Isaac.Spawn(217, 1, 412, entity.Position, Vector(0,0), entity)
			corn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			corn:GetSprite():Load("gfx/dip_corn_dlrform.anm2", true)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, denpnapi.hit)

function denpnapi:ModAnim(player)
	local pdata = player:GetData()
	if pdata.playmodanim and pdata.playmodanim > 0 then
		if pdata.playmodanim <= 4 and (pdata.playmodanim ~= pdata.playingmodanim) then
			local playeranim = Isaac.Spawn(1000, 369, pdata.playmodanim, player.Position, Vector(0,0), player)
			playeranim.Parent = player
			pdata.playingmodanim = pdata.playmodanim
		end
	end
	if Room:GetFrameCount() <= 1 then
		if not pdata.DefaultDamage then
			pdata.DefaultDamage = 0
			pdata.DefaultTears = 0
		end
		if player:GetName() == "Cain" or player:GetName() == "Lazarus II"
		or player:GetName() == "Keeper" then
			pdata.DefaultDamage = 4.2
		elseif player:GetName() == "Judas" then
			pdata.DefaultDamage = 4.72
		elseif player:GetName() == "???" then
			pdata.DefaultDamage = 3.67
		elseif player:GetName() == "Eve" then
			pdata.DefaultDamage = 2.63
		elseif player:GetName() == "Azazel" then
			pdata.DefaultDamage = 5.25
		elseif player:GetName() == "Eden" then
			if Game():GetFrameCount() <= 1 then
				pdata.DefaultDamage = player.Damage
				pdata.DefaultTears = player.MaxFireDelay
			end
		elseif player:GetName() == "Black Judas" then
			pdata.DefaultDamage = 7
		elseif player:GetName() == "The Forgotten" then
			pdata.DefaultDamage = 5.25
		else
			pdata.DefaultDamage = 3.5
		end
		if player:GetName() ~= "Eden" then
			if player:GetName() == "Samson" then
				pdata.DefaultTears = 11
			elseif player:GetName() == "Azazel" then
				pdata.DefaultTears = 31
			elseif player:GetName() == "Keeper" then
				pdata.DefaultTears = 28
			elseif player:GetName() == "The Forgotten" then
				pdata.DefaultTears = 20
			else
				pdata.DefaultTears = 10
			end
		end
		local Fps = 30 / ((player.MaxFireDelay/pdata.DefaultTears)+1)
		GetPlayerDps = (player.Damage-pdata.DefaultDamage) * Fps
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, denpnapi.ModAnim)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, knife)
	if not knife.Variant == Isaac.GetEntityVariantByName("Big Knife") then
		return
	end
	knife.EntityCollisionClass = 0
end, 70)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, boss)
	if (Game().Difficulty == 1 or Game().Difficulty == 3) and boss.Variant == 10
	and FBossFight and Level:GetStage() == 10 then
		boss.MaxHitPoints = math.max(600, 8*GetPlayerDps)
		boss.HitPoints = boss.MaxHitPoints
	end
end, 84)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, mom)
	if mom.Variant == Isaac.GetEntityVariantByName("Mom (Hard)") then
		local sprm = mom:GetSprite()
		mom.State = 3
		mom.TargetPosition = mom.Position
	elseif mom.Variant == Isaac.GetEntityVariantByName("Mom Stomp (Hard)") then
		local sprmf = mom:GetSprite()
		sprmf:SetFrame("Stomp", 75)
		mom.State = 3
	elseif mom.Variant == Isaac.GetEntityVariantByName("Mom Stomp (Last Ditch)") then
		local sprmf2 = mom:GetSprite()
		mom:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		sprmf2:SetFrame("Stomp", 75)
	end
end, 396)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, boss)
	if not boss.Variant == Isaac.GetEntityVariantByName("Mom's Heart 2") then
		return
	end
  	boss:GetSprite():Play("Appear", true)
end, 397)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, boss)
	if not boss.Variant == Isaac.GetEntityVariantByName("It Lives 2") then
		return
	end
	boss:GetSprite():Play("Appear", true)
	boss.I2 = math.random(0,2)
end, 398)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, object)
	if object.Variant == Isaac.GetEntityVariantByName("Lamb Body(Hard and Dead)") then
		local sprdlb = object:GetSprite()
		sprdlb:Play("death", true)
	end
end, 400)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, object)
	if object.Type ~= 507 then
		return
	end
	object.EntityCollisionClass = 0
end, 507)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, enemy)
	if not enemy.Type == 549 then
		return
	end
	enemy.PositionOffset = Vector(0,-30)
end, 549)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, p)
	if not p.Type == 552 then
		return
	end
	if p.SpawnerType == 102 then
		p.PositionOffset = Vector(0,-40)
	else
		p.PositionOffset = Vector(0,-20)
	end
	p:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	p:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	p:RemoveStatusEffects()
	p.EntityCollisionClass = 2
end, 552)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, boss)
	if boss.Variant == Isaac.GetEntityVariantByName("Lamb II Clone") then
		local sprl2 = boss:GetSprite()
		boss:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
		sprl2:Play("HeadDashDownC", true)
	end
end, 555)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, knife)
	if knife.Variant ~= Isaac.GetEntityVariantByName("Big Knife") then
		return
	end
	knife:PlaySound(138, 1, 0, false, 1)
	Isaac.Spawn(1000, 97, 0, knife.Position, Vector(0,0), knife)
	Game():SpawnParticles(knife.Position, 27, 10, 3, Color(1,1,1,1,0,0,0), -80)
	Game():SpawnParticles(knife.Position, 35, 20, 6, Color(0.7,0.7,0.7,1,0,0,0), -8)
end, 70)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, mom)
	if mom.Variant == Isaac.GetEntityVariantByName("Mom Stomp (Hard)") then
		Room:EmitBloodFromWalls(10,20)
		if Room:GetType() == 5 then
			mom:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
			music:Fadeout()
			for i=0, 1 do
				local ldmom = Isaac.Spawn(396, 20, mom.SubType, Room:GetCenterPos()+Vector(-25+i*50,-80+i*160), Vector(0,0), mom)
				ldmom:ToNPC().StateFrame = i*32
			end
		end
	end
end, 396)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, boss)
	if not boss.Variant == Isaac.GetEntityVariantByName("Mom's Heart 2") then
		return
	end
	for i=0, 330, 30 do
		local params = ProjectileParams()
		params.Scale = 1.8
		boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(7), 0, params)
	end
end, 397)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, boss)
	if boss.Variant == Isaac.GetEntityVariantByName("It Lives 2") then
		for i=0, 330, 30 do
			local params = ProjectileParams()
			params.Scale = 1.8
			boss:FireProjectiles(boss.Position, Vector.FromAngle(i):Resized(7), 0, params)
		end
	end
end, 398)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, boss)
	if not boss.Variant == Isaac.GetEntityVariantByName("Lamb Body(Hard)") then
		return
	end
	local sprlb = boss:GetSprite()
	if sprlb:IsFinished("Death") then
		Game():SpawnParticles(boss.Position, 88, 10, 15, Color(1,1,1,1,135,126,90), -4)
	end
end, 400)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, enemy)
	if not enemy.Type == 549 then
		return
	end
	if enemy.SpawnerType == 78 and enemy.SpawnerVariant == 1 then
		KilledCloatty = KilledCloatty + 1
	end
end, 549)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, obj)
	if not obj.Variant == Isaac.GetEntityVariantByName("Lil Fallen's Skull") then
		return
	end
	obj:Remove()
	obj:PlaySound(137, 1, 0, false, 1.5)
	Game():SpawnParticles(obj.Position, 35, math.random(5,10), 5, Color(1,1,1,1,0,0,0), -10)
end, 557)

denpnapi:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, enemy)
	if enemy.Variant == Isaac.GetEntityVariantByName("Little Fallen") then
		enemy:PlaySound(207, 1, 0, false, 1)
		if (enemy.SpawnerType == 273 or enemy.SpawnerType == 555)
		and #Isaac.FindByType(400, 0, -1, true, true) > 0
		and hmbppttn then
			Isaac.Spawn(557, 0, 0, enemy.Position, Vector(0,0), enemy)
		end
	elseif enemy.Variant == Isaac.GetEntityVariantByName("Baby Bone") then
		for i=45, 315, 90 do
			local params = ProjectileParams()
			params.Variant = 1
			enemy:FireProjectiles(enemy.Position, Vector.FromAngle(i):Resized(10), 0, params)
		end
	end
end, 558)

----------------------------
--Projectiles
----------------------------
function denpnapi:BLACKCIRCLE(p)
	if p.ProjectileFlags >= 1 << 42 and p.ProjectileFlags < 1 << 43 then
		p:SetColor(Color(0,0,0,1,0,0,0), 99999, 0, false, false)
		if p:IsDead() then
			p:Remove()
			local bcircle = Isaac.Spawn(1000, 354, 0, p.Position, Vector(0,0), p):ToEffect()
			bcircle.Scale = p.Scale * 0.5
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.BLACKCIRCLE)

function denpnapi:CURVE2(p)
	if p.ProjectileFlags >= 1 << 40 and p.ProjectileFlags < 1 << 42 then
	local pd = p:GetData()
		if not pd.inspd then
			pd.inspd = p.Velocity
		end
		if not pd.inicstlth then
			pd.inicstlth = p.CurvingStrength
		end
		if p.ProjectileFlags <= 1 << 40 and p.CurvingStrength >= pd.inicstlth * 0.2 then
			p.CurvingStrength = p.CurvingStrength * 0.95
		end
		p.Velocity = Vector.FromAngle(p.Velocity:GetAngleDegrees()
		+ ((p.CurvingStrength*1000)*5/p.FrameCount))
		:Resized(pd.inspd:Length()
		+((math.abs(p.CurvingStrength)*1000)*(pd.inspd:Length()*0.04)))
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.CURVE2)

function denpnapi:CURVE3(p)
	if p.ProjectileFlags >= 1 << 34 and p.ProjectileFlags < 1 << 35 then
		if p.FrameCount % 30 == 0 then
			p.CurvingStrength = p.CurvingStrength * (1 - (math.random(0,1)*2))
		end
		p.Velocity = Vector.FromAngle(p.Velocity:GetAngleDegrees()+p.CurvingStrength):Resized(p.Velocity:Length())
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.CURVE3)

function denpnapi:GRAVITY_VERT(p)
	if p.ProjectileFlags >= 1 << 36 and p.ProjectileFlags < 1 << 37 then
		local pd = p:GetData()
		pd.ge = Room:GetGridEntity(Room:GetGridIndex(p.Position + Vector(0,p.Velocity.Y)))
		if not pd.gravity then
			if p.Velocity.Y > 0 then
				pd.gravity = 1
			else
				pd.gravity = -1
			end
		end
		p.Velocity = Vector(p.Velocity.X,p.Velocity.Y+(pd.gravity * 0.15))
		if pd.ge and ((pd.ge:GetType() > 1 and pd.ge:GetType() < 7)
		or (pd.ge:GetType() > 10 and pd.ge:GetType() < 16) or pd.ge:GetType() >= 21) then
			if p.Velocity.Y > 9 then
				p.Velocity = Vector(p.Velocity.X,-9)
			elseif p.Velocity.Y < -9 then
				p.Velocity = Vector(p.Velocity.X,9)
			else
				p.Velocity = Vector(p.Velocity.X,-p.Velocity.Y)
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.GRAVITY_VERT)

function denpnapi:NOFALL(p)
	if p.ProjectileFlags >= 1 << 39 and p.ProjectileFlags < 1 << 40 then
		p.FallingSpeed = 0
		p.FallingAccel = 0
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.NOFALL)

function denpnapi:SMART2(p)
	if p.ProjectileFlags >= 1 << 37 and p.ProjectileFlags < 1 << 38 then
		local pd = p:GetData()
		local pl = Game():GetPlayer(1)
		p:SetColor(Color(1,1,1,5,0,0,0), 99999, 0, false, false)
		if not pd.smart2 then
			pd.smart2 = true
			pd.homingtime = 20
		end
		pd.homingtime = pd.homingtime - 1
		if pd.homingtime > 0 then
			initspeed = p.Velocity
			p.Velocity = (initspeed * 0.9) + Vector.FromAngle
			((pl.Position - p.Position):GetAngleDegrees()):Resized(p.HomingStrength*3)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.SMART2)

function denpnapi:TURN_RIGHTANGLE(p)
	if p.ProjectileFlags >= 1 << 35 and p.ProjectileFlags < 1 << 36 then
		if p.FrameCount % 35 == 0 and p.FrameCount > 0 then
			p.Velocity = Vector.FromAngle((p.Velocity):GetAngleDegrees()+(math.random(-1,1)*90)):Resized(p.Velocity:Length())
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.TURN_RIGHTANGLE)

function denpnapi:WAVE(p)
	local pd = p:GetData()
	if p.ProjectileFlags >= 1 << 43 and p.ProjectileFlags < 1 << 44 then
		if not pd.sine then
			pd.sine = 0
			end
		if not pd.back then
			pd.sine = pd.sine + 0.08
		else
			pd.sine = pd.sine - 0.2
		end
		if pd.sine >= 0.8 then
			pd.back = true
		elseif pd.sine <= -2 then
			pd.back = false
		end
		p.Position = p.Position + Vector.FromAngle(p.Velocity:GetAngleDegrees())
		:Resized(p.Velocity:Length()*pd.sine)
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.WAVE)

function denpnapi:projs(p)
	if p:IsDead() then
		if p.Variant == 4 and p.Velocity:Length() == 0
		and p.SpawnerType == 102 and p.SpawnerVariant == 0 then
			p.Velocity = Vector(8, 0)
			p.FallingAccel = -0.055
		end
		if p.SpawnerType == 412 then
			if p.SubType == 999 and Isaac.GetPlayer(0):HasPlayerForm(2) then
				sound:Play(265, 1, 0, false, 1)
				local mush = Isaac.Spawn(300, 0, 0, p.Position, Vector(0,0), p)
				mush:GetSprite():Load("gfx/mushroomman_dlrform.anm2", true)
				mush:GetSprite():Play("Hide", true)
			end
			if Isaac.GetPlayer(0):HasPlayerForm(0) and math.random(1,2) == 1 then
				local fly = Isaac.Spawn(18, 0, 0, p.Position, Vector(0,0), p)
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.projs)

function denpnapi:projstone(p)
	local pspr = p:GetSprite()
	if p.Variant == 9 then
		if Room:GetBackdropType() == 3 then
			p:SetColor(Color(0.6,0.35,0.35,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 6 then
			p:SetColor(Color(0.3,0.45,0.5,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 7 or Room:GetBackdropType() == 9
		or Room:GetBackdropType() == 14 or Room:GetBackdropType() == 16 then
			p:SetColor(Color(0.3,0.3,0.3,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() >= 10 and Room:GetBackdropType() <= 12 then
			p:SetColor(Color(0.75,0.25,0.25,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 13 then
			p:SetColor(Color(0.5,0.6,1,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 15 then
			p:SetColor(Color(0.35,0.45,0.55,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 24 then
			p:SetColor(Color(0.9,0,0,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 27 then
			p:SetColor(Color(0.5,0.6,1,1,0,0,0), 99999, 0, false, false)
		else
			p:SetColor(Color(0.75,0.6,0.6,1,0,0,0), 99999, 0, false, false)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.projstone)

function denpnapi:projdlr(p)
	local pspr = p:GetSprite()
	local pd = p:GetData()
	if p.Variant == 10 then
		if p.Scale >= 2.5 then
			pd.anino = 13
		elseif p.Scale >= 2.27 then
			pd.anino = 12
		elseif p.Scale >= 2.04 then
			pd.anino = 11
		elseif p.Scale >= 1.81 then
			pd.anino = 10
		elseif p.Scale >= 1.58 then
			pd.anino = 9
		elseif p.Scale >= 1.35 then
			pd.anino = 8
		elseif p.Scale >= 1.13 then
			pd.anino = 7
		elseif p.Scale >= 0.9 then
			pd.anino = 6
		elseif p.Scale >= 0.75 then
			pd.anino = 5
		elseif p.Scale >= 0.6 then
			pd.anino = 4
		elseif p.Scale >= 0.45 then
			pd.anino = 3
		elseif p.Scale >= 0.3 then
			pd.anino = 2
		elseif p.Scale >= 0.15 then
			pd.anino = 1
		end
		if not pspr:IsPlaying("RegularTear"..pd.anino) then
			pspr:Play("RegularTear"..pd.anino, true)
		end
		if p:IsDead() and p.ProjectileFlags ~= 1 << 1 then
			if p.Height >= -5 then
				sound:Play(258, 1, 0, false, 1)
			else
				sound:Play(150, 1, 0, false, 1)
			end
			local bpoof = Isaac.Spawn(1000, 412, 0, p.Position, Vector(0,0), p)
			bpoof:GetSprite().Offset = Vector(0, p.Height+8)
			bpoof.SpriteScale = Vector(prj.Scale, p.Scale)
			bpoof:SetColor(p:GetColor(), 99999, 0, false, false)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.projdlr)

function denpnapi:projblflame(p)
	local pspr = p:GetSprite()
	if p.Variant == 11 then
		if not pspr:IsPlaying("Move") then
			pspr:Play("Move", true)
		end
		if p:IsDead() then
			local poof = Isaac.Spawn(1000, 15, 0, p.Position, Vector(0,0), p)
			poof:SetColor(Color(0.5,0.5,2,1,0,0,0), 99999, 0, false, false)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.projblflame)

function denpnapi:projknife(p)
	local pspr = p:GetSprite()
	local pd = p:GetData()
	if p.Variant == 12 then
		if not pspr:IsPlaying("Move") then
			pspr:Play("Move", true)
		end
		p:SetSize(40,Vector(1,0.5),0)
		p.SpriteRotation = p.Velocity:GetAngleDegrees()
		p.SpriteOffset = Vector(0,-10)
		for k, v in pairs(Isaac:GetRoomEntities()) do
			if p.SpawnerType == 396 and v:IsVulnerableEnemy() and not v:IsBoss()
			and v.Position:Distance(p.Position) <= p.Size+v.Size then
				v:Kill()
			end
		end
		if p:IsDead() then
			sound:Play(138, 1, 0, false, 1)
			Isaac.Spawn(1000, 97, 0, p.Position, Vector(0,0), p)
			Game():SpawnParticles(p.Position, 27, 10, 3, Color(1,1,1,1,0,0,0), -80)
			Game():SpawnParticles(p.Position, 35, 20, 6, Color(0.7,0.7,0.7,1,0,0,0), -8)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.projknife)

function denpnapi:projvari(p)
	if p.Variant == 9 then
		local pspr = p:GetSprite()
		if Room:GetBackdropType() == 3 then
			p:SetColor(Color(0.6,0.35,0.35,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 6 then
			p:SetColor(Color(0.3,0.45,0.5,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 7 or Room:GetBackdropType() == 9
		or Room:GetBackdropType() == 14 or Room:GetBackdropType() == 16 then
			p:SetColor(Color(0.3,0.3,0.3,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() >= 10 and Room:GetBackdropType() <= 12 then
			p:SetColor(Color(0.75,0.25,0.25,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 13 then
			p:SetColor(Color(0.5,0.6,1,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 15 then
			p:SetColor(Color(0.35,0.45,0.55,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 24 then
			p:SetColor(Color(0.9,0,0,1,0,0,0), 99999, 0, false, false)
		elseif Room:GetBackdropType() == 27 then
			p:SetColor(Color(0.5,0.6,1,1,0,0,0), 99999, 0, false, false)
		else
			p:SetColor(Color(0.75,0.6,0.6,1,0,0,0), 99999, 0, false, false)
		end
		p.SpriteScale = Vector(p.Scale,p.Scale)
		if p.FrameCount >= 1 and not pspr:IsPlaying("Move") then
			pspr:Play("Move", true)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.projvari)

function denpnapi:others(p)
	if p.SpawnerType == 547 and p:IsDead() then
		p.Velocity = Vector(7,0)
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, denpnapi.others)

----------------------------
--Effects
----------------------------
function denpnapi:InitAftImage(eft)
	if eft.Variant == 366 then
		eft.Timeout = 10
		eft:SetColor(Color(0.1,0.1,0.1,eft.Timeout*0.1,0,0,0), 99999, 0, false, false)
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitAftImage)

function denpnapi:InitBCoin(eft)
	if eft.Variant == 353 then
		local espr = eft:GetSprite()
		if math.random(1,2) == 1 then
			eft.FlipX = true
			Game():SpawnParticles(eft.Position, 4, math.random(6,13), 13, Color(1,1,1,1,0,0,0), 0)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitBCoin)

function denpnapi:InitGoldBreak(eft)
	if eft.Variant == 367 and eft.SubType == 1 then
		local espr = eft:GetSprite()
		espr:Play("Break")
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitGoldBreak)

function denpnapi:InitLmLaser(eft)
	if eft.Variant == 362 then
		eft.Timeout = 250
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitLmLaser)

function denpnapi:InitCnWave(eft)
	if eft.Variant == 368 then
		eft.Visible = false
		if eft.Timeout <= 0 then
			eft.Timeout = 20
		end
		eft:GetData().interval = 60
		eft:GetData().radi = 0
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitCnWave)

function denpnapi:InitGWave(eft)
	if eft.Variant == 370 or eft.Variant == 371 then
		eft.Visible = false
	end
	if eft.Variant == 370 then
		if eft.Timeout < 8 then
			eft.Timeout = 24
		end
		if eft.MaxRadius <= 3 then
			eft.MaxRadius = 100
		end
		eft:GetData().radi = 0
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitGWave)

function denpnapi:InitPMAnim(eft)
	if eft.Variant == 369 then
		local espr = eft:GetSprite()
		if eft.SubType == 1 then
			espr:Play("Falling", true)
		elseif eft.SubType == 2 then
			espr:Play("FallInLeft", true)
		elseif eft.SubType == 3 then
			espr:Play("FallInRight", true)
		elseif eft.SubType == 4 then
			espr:Play("Golden", true)
			eft.Timeout = 120
			sound:Play(427, 1, 0, false, 2)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, denpnapi.InitPMAnim)

function denpnapi:Afterimage(eft)
	if eft.Variant == 366 then
		if eft.Timeout <= 0 then
			eft:Remove()
		end
		if eft.SubType == 1 then
			eft:SetColor(Color(0.1,0.1,0.1,eft.Timeout*0.1,0,0,0), 99999, 0, false, false)
		else
			eft:SetColor(Color(1,1,1,eft.Timeout*0.1,0,0,0), 99999, 0, false, false)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.Afterimage)

function denpnapi:BeamWarn(eft)
	if eft.Variant == 355 then
		local espr = eft:GetSprite()
		espr.Rotation = eft.Rotation
		if eft.FrameCount == 37 then
			if eft.SpawnerEntity then
				EntityLaser.ShootAngle(5, eft.Position, espr.Rotation, 3, Vector(0,0), eft.SpawnerEntity)
			else
				EntityLaser.ShootAngle(5, eft.Position, espr.Rotation, 3, Vector(0,0), eft)
			end
		end
		if espr:IsFinished("Warn") then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BeamWarn)

function denpnapi:BeamWaveL(eft)
	if eft.Variant == 351 then
		local edt = eft:GetData()
		local gi = Room:GetGridIndex(eft.Position)
		local ge = Room:GetGridEntity(gi)
		eft.Visible = false
		if eft.FrameCount == 1 and eft.Timeout <= 0 then
			eft.Timeout = 200
		end
		if eft.LifeSpan > 0 then
			eft.LifeSpan = eft.LifeSpan - 1
		end
		if eft.SubType > 0 and eft.LifeSpan > 0 then
			if eft.SubType % 2 == 1 then
				eft.Rotation = eft.Rotation + (eft.SubType/20)
			else
				eft.Rotation = eft.Rotation - ((eft.SubType-1)/20)
			end
		end
		eft.Velocity = Vector.FromAngle(eft.Rotation):Resized(7)
		if eft.FrameCount % 7 == 0 then
			sound:Play(133, 0.5, 0, false, 1)
			local light = Isaac.Spawn(1000, 19, 1, eft.Position, Vector(0,0), eft.Parent)
			light.Parent = eft.Parent
		end
		if ge then
			if ge:GetType() == 15 or ge:GetType() == 16 then
				eft:Remove()
			end
		end
		if eft.Position.X <= Room:GetTopLeftPos().X
		or eft.Position.X >= Room:GetBottomRightPos().X
		or eft.Position.Y <= Room:GetTopLeftPos().Y
		or eft.Position.Y >= Room:GetBottomRightPos().Y
		or (eft.FrameCount > 1 and eft.Timeout <= 0) then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BeamWaveL)

function denpnapi:BeamWaveR(eft)
	if eft.Variant == 358 then
		local edt = eft:GetData()
		if Room:GetRoomShape() >= 6 then
			edt.maxr = 560
		elseif Room:GetRoomShape() >= 4 then
			edt.maxr = 440
		else
			if Room:GetRoomShape() == 3 then
				edt.maxr = 240
			else
				edt.maxr = 320
			end
		end
		eft.Visible = false
		if eft.FrameCount == 1 then
			if eft.Timeout <= 0 then
				eft.Timeout = 155
			end
			if eft.LifeSpan <= 1 then
				eft.LifeSpan = 30
			end
		end
		if eft.FrameCount % eft.LifeSpan == 1 then
			sound:Play(133, 0.5, 0, false, 1)
			for i=0, 359.9, 15/(eft.Scale*(eft.FrameCount/eft.LifeSpan)) do
				local gi = Room:GetGridIndex(eft.Position+Vector.FromAngle(i):Resized((eft.FrameCount/eft.LifeSpan)*(eft.Scale*125)))
				if not Room:GetGridEntity(gi) or Room:GetGridEntity(gi):GetType() ~= 15 then
					local light = Isaac.Spawn(1000, 19, 0, eft.Position+Vector.FromAngle(i):Resized((eft.FrameCount/eft.LifeSpan)*(eft.Scale*125)),
					Vector(0,0), eft)
					light.Parent = eft.Parent
				end
			end
		end
		if (eft.FrameCount >= 1 and eft.Timeout <= 0) or (eft.FrameCount/eft.LifeSpan)*(eft.Scale*125) > edt.maxr then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BeamWaveR)

function denpnapi:BlackCircle(eft)
	if eft.Variant == 354 then
		local espr = eft:GetSprite()
		eft.DepthOffset = -1
		eft.SpriteScale = Vector(eft.Scale,eft.Scale)
		if eft.FrameCount == 1 then
			sound:Play(316, 1, 0, false, 1)
		elseif eft.FrameCount == 45 then
			for i=0, 340, 20 do
				local Dproj = Isaac.Spawn(9, 6, 0, eft.Position + Vector.FromAngle(i):Resized(15*eft.Scale),
				Vector.FromAngle(i):Resized(11 * eft.Scale), eft):ToProjectile()
				Dproj:AddProjectileFlags(1 << 27)
				Dproj.Acceleration = 0.9
				Dproj:SetColor(Color(0,0,0,1,0,0,0), 99999, 0, false, false)
				Dproj.Scale = 1.4
			end
		end
		if eft.FrameCount >= 85 then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BlackCircle)

function denpnapi:BlankPolaroid(eft)
	if eft.Variant == 360 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		eft.DepthOffset = -10
		if eft.FrameCount == 1 then
			espr:PlayOverlay("Shadow",true)
			if math.random(1,2) == 1 then
				eft.FlipX = true
			else
				eft.FlipX = false
			end
		elseif eft.FrameCount == 300 then
			if eft.SpawnerType == 0 or (eft.SpawnerType > 1 and
			#Isaac.FindByType(eft.SpawnerType, eft.SpawnerVariant, -1, true, true) > 0) then
				if math.random(1,4) <= 3 then
					Isaac.Spawn(514, 0, 0, eft.Position, Vector(0,0), eft)
				else
					Isaac.Spawn(544, 0, 0, eft.Position, Vector(0,0), eft)
				end
			end
		elseif eft.FrameCount == 350 then
			local poof = Isaac.Spawn(1000, 15, 0, eft.Position, Vector(0,0), eft)
			poof.SpriteScale = Vector(1.5,1.5)
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BlankPolaroid)

function denpnapi:BloodParticle(eft)
	if eft.Variant == 5 then
		if eft.SpawnerType == 545 or eft.SpawnerType == 546 then
			eft:SetColor(Color(1,1,1,1,150,150,150), 99999, 0, false, false)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BloodParticle)

function denpnapi:BlueFlame(eft)
	if eft.Variant == 10 then
		local player = Isaac.GetPlayer(1)
		if eft.SubType == 10 then
			if player.Position:Distance(eft.Position) <= 13 + player.Size then
				player:TakeDamage(1, 0, EntityRef(eft), 1)
			end
			if eft.Timeout == 1 then
				local poof = Isaac.Spawn(1000, 15, 0, eft.Position, Vector(0,0), eft)
				poof:SetColor(Color(0.3,0.3,1.5,2,0,0,0), 99999, 0, false, false)
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BlueFlame)

function denpnapi:BrimImpact(eft)
	if eft.Variant == 50 then
		local espr = eft:GetSprite()
		if eft.SubType == 1 and eft.Parent then
			local prdata = eft.Parent:GetData()
			if eft.Parent.Type == 7 and eft.Parent.Variant == 1 then
				if eft.Parent.Size >= 80 and eft.Parent.SpawnerType == 406 then
					if espr:GetFilename() ~= "gfx/brimstoneimpact coin.anm2" then
						espr:Load("gfx/brimstoneimpact coin.anm2", true)
						espr:Play("Start", true)
					end
					if espr:IsFinished("Start") then
						espr:Play("Loop", true)
					end
				end
			end
			if eft.FrameCount % 13 == 1 and eft.Parent:ToLaser().Timeout > 0 then
				if prdata.lflag == 1 then
					if eft.FrameCount % 2 == 0 then
						for i=0, 180, 180/prdata.pdensity do
							local proj = Isaac.Spawn(9, 0, 0, eft.Position+eft.PositionOffset+Vector.FromAngle(espr.Rotation+90):Resized(30),
							Vector.FromAngle(espr.Rotation+i):Resized(prdata.pvl), eft):ToProjectile()
							proj.FallingAccel = -0.09
						end
					else
						for i=(180/prdata.pdensity)/2, 180-(180/prdata.pdensity)/2, 180/prdata.pdensity do
							local proj = Isaac.Spawn(9, 0, 0, eft.Position+eft.PositionOffset+Vector.FromAngle(espr.Rotation+90):Resized(30),
							Vector.FromAngle(espr.Rotation+i):Resized(prdata.pvl), eft):ToProjectile()
							proj.FallingAccel = -0.09
						end
					end
				elseif prdata.lflag == 2 then
					if eft.Parent:ToLaser().RotationSpd > 0 then
						for i=45, 165, 30 do
							local proj = Isaac.Spawn(9, 0, 0, eft.Position+eft.PositionOffset+Vector.FromAngle(espr.Rotation+90):Resized(30),
							Vector.FromAngle(espr.Rotation+i):Resized(6), eft):ToProjectile()
							proj.FallingAccel = -0.09
						end
					else
						for i=-45, 75, 30 do
							local proj = Isaac.Spawn(9, 0, 0, eft.Position+eft.PositionOffset+Vector.FromAngle(espr.Rotation+90):Resized(30),
							Vector.FromAngle(espr.Rotation+i):Resized(6), eft):ToProjectile()
							proj.FallingAccel = -0.09
						end
					end
				end
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BrimImpact)

function denpnapi:BrimSwirl2(eft)
	if eft.Variant == 350 then
		local espr = eft:GetSprite()
		local target = Game():GetPlayer(1)
		if eft.MinRadius < 80 then
			eft.MinRadius = 80
		end
		if eft.MaxRadius <= eft.MinRadius then
			eft.MaxRadius = eft.MinRadius + 1
		end
		if eft.FrameCount <= 1 then
			if eft.SubType ~= 2 then
				espr:PlayOverlay("ShortLaserStart",true)
			else
				espr:PlayOverlay("LongLaserStart",true)
			end
		end
		if eft.Parent and eft.SubType == 1 then
			eft.Position = eft.Parent.Position
		end
		if espr:IsOverlayFinished("ShortLaserStart") then
			espr:PlayOverlay("ShortLaserLoop",true)
		elseif espr:IsOverlayFinished("LongLaserStart") then
			espr:PlayOverlay("LongLaserLoop",true)
		elseif espr:IsFinished("Idle") then
			eft:Remove()
		end
		if eft.SubType == 0 and eft.FrameCount <= 20 then
			espr.Rotation = (target.Position - eft.Position):GetAngleDegrees()
		end
		if espr:IsEventTriggered("Fire") then
			espr:RemoveOverlay()
			if eft.Parent then
				local bshot = EntityLaser.ShootAngle(1, eft.Position, espr.Rotation, 18, Vector(0,-5), eft.Parent):ToLaser()
				if eft.SubType == 1 then
					bshot.MaxDistance = math.random(eft.MinRadius,eft.MaxRadius)
				end
			else
				local bshot = EntityLaser.ShootAngle(1, eft.Position, espr.Rotation, 18, Vector(0,-5), eft):ToLaser()
				if eft.SubType == 1 then
					bshot.MaxDistance = math.random(eft.MinRadius,eft.MaxRadius)
				end
			end
			espr.Rotation = 0
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.BrimSwirl2)

function denpnapi:CircularImpact(eft)
	if eft.Variant == 357 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		if espr:IsFinished("Impact") then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.CircularImpact)

function denpnapi:CoinWave(eft)
	if eft.Variant == 368 then
		local edt = eft:GetData()
		if eft.FrameCount % 8 == 1 then
			sound:Play(138, 1, 0, false, 1)
			edt.radi = edt.radi + 53
			edt.interval = edt.interval * 0.8
			for i=0, 359, edt.interval do
				Game():BombDamage(eft.Position+Vector.FromAngle(i):Resized(edt.radi), 10, 10, true, eft.Parent, 0, 1<<2, false)
				local bstcoin = Isaac.Spawn(1000, 353, 1, eft.Position+Vector.FromAngle(i):Resized(edt.radi), Vector(0,0), eft)
				bstcoin.Parent = eft.Parent
				bstcoin:ToEffect().Scale = 0.5
			end
		end
		if eft.Timeout <= 0 then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.CoinWave)

function denpnapi:CrackTheSky(eft)
	if eft.Variant == 19 then
		local espr = eft:GetSprite()
		if eft.Position.X <= Room:GetTopLeftPos().X
		or eft.Position.X >= Room:GetBottomRightPos().X
		or eft.Position.Y <= Room:GetTopLeftPos().Y
		or eft.Position.Y >= Room:GetBottomRightPos().Y then
			eft:Remove()
		end
		if eft.SubType == 999 and eft.FrameCount == 18 and eft.SpawnerType == 102 then
			sound:Play(265, 0.85, 0, false, 1)
			if math.random(1,2) == 1 then
				Isaac.Spawn(523, 0, 0, eft.Position, Vector(0,0), eft)
			else
				Isaac.Spawn(38, 1, 0, eft.Position, Vector(0,0), eft)
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.CrackTheSky)

function denpnapi:EscTrapdoor(eft)
	if eft.Variant == 361 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		local Ents = Isaac:GetRoomEntities()
		eft.DepthOffset = -40

		if espr:IsFinished("Appear") and eft.State == 0 then
			eft.State = 3
			if eft.SubType == 1 then
				eft.Timeout = 35
			else
				eft.Timeout = 150
				espr:PlayOverlay("In", true)
			end
		end

		if eft.State == 3 then
			if eft.SubType == 1 then
				if eft.Timeout == 10 then
					if edt.player.Variant == 0 then
						edt.player:AnimatePitfallOut()
					else
						Isaac.Spawn(1000, 15, 0, eft.Position, Vector(0,0), eft)
					end
					edt.player.EntityCollisionClass = 4
					edt.player.ControlsEnabled = true
					edt.player.Visible = true
				end
				if eft.Timeout > 10 and eft:Exists() then
					edt.player.Position = eft.Position
					edt.player.Velocity = Vector(0,0)
				end
			else
				if espr:IsOverlayPlaying("In") and espr:GetOverlayFrame() == 52
				and Isaac.GetPlayer(0).Position:Distance(eft.Position) > 500 then
					espr:PlayOverlay("In", true)
				end
			end
			if eft.Timeout <= 0 and eft.FrameCount > 12 then
				eft:Remove()
				Isaac.Spawn(1000, 15, 0, eft.Position, Vector(0,0), eft)
			end
		end
		if eft.State == 15 then
			if eft.Timeout <= edt.frame - 16  then
				edt.player.Visible = false
			end
			if eft.Timeout <= 0 then
				eft:Remove()
				edt.player:SetMinDamageCooldown(210)
			end
			if eft:IsDead() then
				edt.randpos = Isaac.GetRandomPosition(0)
				edt.player.Position = edt.randpos
				local etrapdoor = Isaac.Spawn(1000, 361, 1, edt.randpos, Vector(0,0), eft)
				etrapdoor:GetData().player = edt.player
				Isaac.Spawn(1000, 15, 0, eft.Position, Vector(0,0), eft)
			end
		end

		for k, v in pairs(Ents) do
			if v:ToPlayer() then
			local dist = v.Position:Distance(eft.Position)

			if eft.State == 3 and eft.SubType ~= 1 then
				if dist <= 32 then
					edt.player = v:ToPlayer()
					if edt.player.Variant == 0 then
						edt.player:AnimateTrapdoor()
					else
						Isaac.Spawn(1000, 15, 0, eft.Position, Vector(0,0), eft)
						edt.player.Visible = false
					end
					edt.player.EntityCollisionClass = 0
					edt.player.ControlsEnabled = false
					edt.player:SetMinDamageCooldown(400)
					edt.player.Position = eft.Position
					edt.player.Velocity = Vector(0,0)
					eft.State = 15
					if eft.Timeout < 20 then
						eft.Timeout = 20
						edt.frame = 20
					else
						edt.frame = eft.Timeout
					end
				end
			end

			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.EscTrapdoor)

function denpnapi:Feather(eft)
	if eft.Variant == 352 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		if eft.FrameCount == 0 then
			edt.rt = math.random(0,1)
			eft.SpriteRotation = math.random(0,359)
		end
		if eft.FallingAcceleration <= 0.7 then
			eft.FallingAcceleration = eft.FallingAcceleration + 0.05
		end
		eft.m_Height = eft.m_Height + eft.FallingAcceleration
		if eft.m_Height < 0 then
			eft.PositionOffset = Vector(0,eft.m_Height)
			if edt.rt == 0 then
				eft.SpriteRotation = eft.SpriteRotation + (eft.Velocity:Length()+1)
			else
				eft.SpriteRotation = eft.SpriteRotation - (eft.Velocity:Length()+1)
			end
		end
		if eft.Position.X >= Room:GetBottomRightPos().X-10 or eft.Position.X <= Room:GetTopLeftPos().X+10 then
			eft.Velocity = Vector(0,eft.Velocity.Y)
		end
		if eft.Position.Y >= Room:GetBottomRightPos().Y-10 or eft.Position.Y <= Room:GetTopLeftPos().Y+10 then
			eft.Velocity = Vector(eft.Velocity.X,0)
		end
		eft.Velocity = eft.Velocity * 0.9
		if eft.m_Height >= 0 then
			if eft.Timeout <= -1 then
				eft.Timeout = 30
			end
			eft:SetColor(Color(1,1,1,eft.Timeout/30,0,0,0), 99999, 0, false, false)
			if eft.Timeout == 0 then
				eft:Remove()
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.Feather)

function denpnapi:GiantDownLaser(eft)
	if eft.Variant == 356 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		local plrpos = Isaac.GetPlayer(0).Position
		if eft.FrameCount == 1 then
			if eft.Timeout <= 31 then
				eft.Timeout = 95
			end
			espr:Play("Warn")
			sound:Play(240, 1, 0, false, 1)
		elseif eft.FrameCount == 26 then
			sound:Play(211, 2, 0, false, 1)
			espr:PlayOverlay("LaserDownLoop",true)
		end
		if eft.Timeout <= 0 and espr:IsOverlayPlaying("LaserDownLoop") then
			espr:PlayOverlay("LaserDownEnd",true)
		end
		if espr:IsOverlayFinished("LaserDownEnd") then
			eft:Remove()
		end

		if espr:IsOverlayPlaying("LaserDownLoop") then
			Game():BombDamage(eft.Position, 10, 60, false, eft, 0, 1<<3, true)
			if eft.SubType == 1 then
				if eft.FrameCount % 2 == 0 then
					local proj = Isaac.Spawn(9, 0, 0, eft.Position, Vector.FromAngle(eft.FrameCount * 15):Resized(6), eft):ToProjectile()
					proj.FallingAccel = -0.085
				end
			elseif	eft.SubType == 2 then
				local proj = Isaac.Spawn(9, 0, 0, eft.Position, Vector.FromAngle(eft.FrameCount * 20):Resized(6), eft):ToProjectile()
				proj.FallingAccel = -0.085
			elseif eft.SubType == 3 then
				if eft.FrameCount % 5 == 0 then
					local creep = Isaac.Spawn(1000, 22, 0, eft.Position, Vector(0,0), eft):ToEffect()
					creep.SpriteScale = Vector(3,3)
				end
				eft.Velocity = (eft.Velocity * 0.9) + Vector.FromAngle((plrpos-eft.Position):GetAngleDegrees())
				:Resized(0.85)
			end
			if math.abs(eft.Position.X-plrpos.X) <= 150 and eft.Position.Y > plrpos.Y then
				eft:SetColor(Color(1,1,1,0.5,0,0,0), 99999, 0, false, false)
			else
				eft:SetColor(Color(1,1,1,1,0,0,0), 99999, 0, false, false)
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.GiantDownLaser)

function denpnapi:GoldBreak(eft)
	if eft.Variant == 367 and eft.SubType == 1 then
		local Ents = Isaac:GetRoomEntities()
		if eft.Position.X >= Room:GetBottomRightPos().X or eft.Position.X <= Room:GetTopLeftPos().X
		or eft.Position.Y >= Room:GetBottomRightPos().Y or eft.Position.Y <= Room:GetTopLeftPos().Y then
			eft:Remove()
		end
		eft.SpriteScale = Vector(eft.Scale,eft.Scale)
		if eft.FrameCount >= 2 and eft.FrameCount <= 10 then
			for k, v in pairs(Ents) do
				if v.Position:Distance(eft.Position) <= 20 * eft.Scale and v.Type ~= 406
				and not v:HasEntityFlags(1<<10) then
					if v:ToPlayer() and v:ToPlayer():GetDamageCooldown() <= 5 then
						if v.Variant == 0 then
							if not v:GetData().playingmodanim or v:GetData().playingmodanim <= 0 then
								v:GetData().playmodanim = 4
							end
						else
							v:AddMidasFreeze(EntityRef(eft), 70)
							v:ToPlayer():PlayExtraAnimation("Hit")
							sound:Play(427, 1, 0, false, 2)
						end
					elseif v:IsVulnerableEnemy() then
						v:AddMidasFreeze(EntityRef(eft), 70)
						sound:Play(427, 1, 0, false, 2)
					end
				end
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.GoldBreak)

function denpnapi:GoldenWave(eft)
	if eft.Variant == 370 then
		local edt = eft:GetData()
		if not edt.initimeout then
			edt.initimeout = eft.Timeout
		end
		if eft.FrameCount % 4 == 1 and eft.Timeout > 0 then
			sound:Play(138, 0.7, 0, false, 1.5)
			edt.radi = edt.radi + ((4/edt.initimeout)*eft.MaxRadius)
			edt.num = edt.radi/6
			for i=0, 359, 360/edt.num do
				local gbreak = Isaac.Spawn(1000, 367, 1, eft.Position+Vector.FromAngle(i):Resized(edt.radi), Vector(0,0), eft)
				gbreak:ToEffect().Scale = math.max(20,((4/edt.initimeout)*eft.MaxRadius)*0.5)/20
			end
		end
		if eft.Timeout <= -6 then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.GoldenWave)

function denpnapi:GoldenCrkWave(eft)
	if eft.Variant == 371 then
		local edt = eft:GetData()
		if eft.FrameCount == 1 then
			eft.Velocity = Vector.FromAngle(eft.Rotation):Resized(10)
		end
		if eft.FrameCount % 3 == 1 and not edt.removing then
			eft.Velocity = Vector.FromAngle((eft.Rotation-5)+(math.random(-6,6)*6)+((eft.FrameCount % 2)*10))
			:Resized(eft.Velocity:Length())
			sound:Play(138, 0.7, 0, false, 1.5)
			Isaac.Spawn(1000, 367, 1, eft.Position, Vector(0,0), eft)
		end
		if (eft.Position.X <= Room:GetTopLeftPos().X
		or eft.Position.X >= Room:GetBottomRightPos().X
		or eft.Position.Y <= Room:GetTopLeftPos().Y
		or eft.Position.Y >= Room:GetBottomRightPos().Y) and not edt.removing then
			edt.removing = true
			eft.Timeout = 6
		end
		if edt.removing and eft.Timeout <= 0 then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.GoldenCrkWave)

function denpnapi:Lamb2Laser(eft)
	if eft.Variant == 362 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		local player = Isaac.GetPlayer(1)
		if eft.SubType == 1 then
			edt.cpos = eft.Position + Vector(80,80)
		elseif eft.SubType == 2 then
			edt.cpos = eft.Position + Vector(-80,80)
		else
			edt.cpos = eft.Position + Vector(0,-100)
		end
		if espr:IsFinished("Start") then
			espr:Play("Loop", true)
		elseif espr:IsFinished("End") then
			eft:Remove()
		end
		local angle = (player.Position - edt.cpos):GetAngleDegrees()
		eft.Velocity = (eft.Velocity * 0.97) + Vector.FromAngle(angle):Resized(0.6)
		if player.Position:Distance(eft.Position) <= 13 + player.Size
		and espr:IsPlaying("Loop") then
			player:TakeDamage(1, 0, EntityRef(eft), 1)
		end
		if eft.Parent then
			local lamb = eft.Parent
			if eft.SubType == 0 and lamb:GetSprite():IsPlaying("HeadDyingAttackLoop") then
				lamb:GetSprite().Rotation = -espr.Rotation
			end
			if math.abs(edt.cpos.X-lamb.Position.X) <= 1100 then
				espr.Rotation = (edt.cpos.X-lamb.Position.X) * -0.064
			else
				if edt.cpos.X > lamb.Position.X then
					espr.Rotation = -70
				else
					espr.Rotation = 70
				end
			end
		end
		if espr:IsPlaying("Loop") and eft.Timeout <= 0 then
			espr:Play("End", true)
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.Lamb2Laser)

function denpnapi:LambClone2(eft)
	if eft.Variant == 364 then
		local espr = eft:GetSprite()
		if not eft.TargetPosition then
			eft.TargetPosition = eft.Position
		end
		eft.Velocity = Vector.FromAngle((eft.TargetPosition-eft.Position):GetAngleDegrees())
		:Resized(eft.TargetPosition:Distance(eft.Position)*0.075)
		if eft.FrameCount == 15 then
			espr:Play("HeadJumpNoGlow", true)
		end
		if espr:IsFinished("HeadJumpNoGlow") and eft.Timeout <= 0 then
			espr:Play("HeadFallVanish", true)
			local mark = Isaac.Spawn(1000, 367, 0, eft.Position, Vector(0,0), eft)
			mark:SetColor(Color(1,1,1,1,200,50,240), 99999, 0, false, false)
		elseif espr:IsFinished("HeadFallVanish") then
			eft:Remove()
		end
		if eft.Position.X >= Room:GetBottomRightPos().X or eft.Position.X <= Room:GetTopLeftPos().X then
			eft.Velocity = Vector(0,eft.Velocity.Y)
		end
		if eft.Position.Y >= Room:GetBottomRightPos().Y or eft.Position.Y <= Room:GetTopLeftPos().Y then
			eft.Velocity = Vector(eft.Velocity.X,0)
		end
		if espr:IsPlaying("HeadFallVanish") then
			if espr:IsEventTriggered("Stomp") then
				Game():BombDamage(eft.Position, 40, 20, true, eft, 0, 1<<2, true)
				SpawnGroundParticle(true, eft, 10, 10, 3, 15)
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.LambClone2)

function denpnapi:LambPiece(eft)
	if eft.Variant == 359 then
		local espr = eft:GetSprite()
		if eft.FrameCount <= 1 then
			if eft.SubType == 4 then
				eft.m_Height = -40
				espr:Play("Piece5",true)
				eft.Velocity = Vector(-1,-1)
				eft.FallingAcceleration = -4
			elseif eft.SubType == 5 then
				eft.m_Height = -20
				espr:Play("Piece6",true)
				eft.Velocity = Vector(0,-4)
				eft.FallingAcceleration = -1
			else
				eft.FallingAcceleration = -2
				eft.m_Height = -30
				if eft.SubType == 1 then
					espr:Play("Piece2",true)
					eft.Velocity = Vector(-3,3)
				elseif eft.SubType == 2 then
					espr:Play("Piece3",true)
					eft.Velocity = Vector(3,-3)
				elseif eft.SubType == 3 then
					espr:Play("Piece4",true)
					eft.Velocity = Vector(-3,-3)
				else
					eft.Velocity = Vector(3,3)
				end
			end
		end
		if eft.m_Height >= 0 then
			eft:Remove()
			Game():SpawnParticles(eft.Position, 35, 13, 5, Color(1,0.95,0.9,1,0,10,0), -24)
		end
		eft.FallingAcceleration = eft.FallingAcceleration + 0.3
		eft.m_Height = eft.m_Height + eft.FallingAcceleration
		eft.PositionOffset = Vector(0,eft.m_Height)
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.LambPiece)

function denpnapi:LaserImpact(eft)
	if eft.Variant == 50 then
		local espr = eft:GetSprite()
		if eft.SubType == 1 and eft.Parent then
			if eft.Parent.Type == 7 and eft.Parent.Variant == 1
			and eft.Parent.Size >= 80 and eft.Parent.SpawnerType ~= 406 then
				if espr:GetFilename() ~= "gfx/brimstoneimpact_red.anm2" then
					espr:Load("gfx/brimstoneimpact_red.anm2", true)
					espr:Play("Start", true)
				end
				if espr:IsFinished("Start") then
					espr:Play("Loop", true)
				end
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.LaserImpact)

function denpnapi:MGST2Head(eft)
	if eft.Variant == 363 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		if eft.SubType == 0 then
			edt.vel = 1.1
			edt.side = "Right"
		else
			edt.vel = -1.1
			edt.side = "Left"
		end
		if eft.FrameCount == 1 then
			espr:Play("AppearB"..eft.LifeSpan..edt.side, true)
		end
		if espr:IsFinished("AppearB"..eft.LifeSpan..edt.side) then
			espr:Play("ShootB"..eft.LifeSpan.."Loop"..edt.side, true)
		elseif espr:IsFinished("ShootB"..eft.LifeSpan.."End"..edt.side) then
			eft:Remove()
		end
		if espr:IsEventTriggered("ShootStart2") then
			edt.attacking = true
			eft.State = math.random(1,3)
		elseif espr:IsEventTriggered("ShootStop2") then
			edt.attacking = false
		end
		if edt.attacking then
			if eft.State == 1 then
				if (eft.Position.X > 300 and eft.Position.Y <= 450)
				or (eft.Position.X < 300 and eft.Position.Y >= 645) then
					eft.Velocity = Vector(0,0)
				else
					eft.Velocity = Vector(0,edt.vel)
				end
			else
				eft.Velocity = Vector(0,edt.vel)
			end
			if eft.Timeout > 0 then
				if eft.FrameCount % 40 == 0 then
					sound:Play(245, 1, 0, false, 1)
				end
				if eft.State == 1 then
					if eft.FrameCount % 2 == 0 then
						local proj = Isaac.Spawn(9, 2, 0, eft.Position+Vector(10*edt.vel,math.random(-20,20)),
						Vector(math.random(11,17)*edt.vel,0), eft):ToProjectile()
						proj.Height = -30
						proj.Color = Color(1,0.5,0.5,1,0,0,0)
					end
				elseif eft.State == 2 then
					if eft.FrameCount % 4 == 0 then
						for i=-0.1, 0.1, 0.2 do
							local proj = Isaac.Spawn(9, 2, 0, eft.Position+Vector(10*edt.vel,math.random(-20,20)),
							Vector(8*edt.vel,math.random(25,60)*i), eft):ToProjectile()
							proj.Height = -30
							proj.FallingAccel = -0.05
							proj.Color = Color(0.8,1,0.5,1,0,0,0)
						end
					end
				else
					if eft.FrameCount % 20 == 0 then
						for i=-45, 45, 22.5 do
							if eft.SubType == 1 then
								local proj = Isaac.Spawn(9, 2, 0, eft.Position+Vector(10*edt.vel,0),
								Vector.FromAngle(i*edt.vel):Resized(-7.5), eft):ToProjectile()
								proj.Height = -30
								proj.FallingAccel = -0.07
								proj.Color = Color(0.8,1.3,0.7,1,0,0,0)
							else
								local proj = Isaac.Spawn(9, 2, 0, eft.Position+Vector(10*edt.vel,0),
								Vector.FromAngle(i*edt.vel):Resized(7.5), eft):ToProjectile()
								proj.Height = -30
								proj.FallingAccel = -0.07
								proj.Color = Color(0.8,1.3,0.7,1,0,0,0)
							end
						end
					end
				end
			else
				if not espr:IsPlaying("ShootB"..eft.LifeSpan.."End"..edt.side) then
					espr:Play("ShootB"..eft.LifeSpan.."End"..edt.side, true)
				end
			end
		else
			eft.Velocity = eft.Velocity * 0.8
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.MGST2Head)

function denpnapi:PlrModAnim(eft)
	if eft.Variant == 369 and eft.Parent.Type == 1 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		local player = eft.Parent:ToPlayer()
		local pldata = player:GetData()
		player.FireDelay = 10
		player:SetColor(Color(1,1,1,0,0,0,0), 99999, 0, false, false)
		player.Child = eft
		eft.Position = player.Position
		eft.Velocity = player.Velocity
		if player:GetData().playingmodanim ~= eft.SubType then
			eft:Remove()
		end
		player.ControlsEnabled = false
		if espr:IsPlaying("Falling") and espr:GetFrame() == 65 then
			sound:Play(69, 1, 0, false, 1)
		end
		if player:GetName() == "???" then edt.plname = "Bluebaby"
		elseif player:GetName() == "Lazarus II" and eft.SubType == 4 then edt.plname = "Lazarus"
		else edt.plname = player:GetName() end
		for i=0, 1 do
			espr:ReplaceSpritesheet(i, "gfx/effects/characters/character_"..edt.plname..".png")
		end
		espr:ReplaceSpritesheet(2, "gfx/effects/characters/"..edt.plname.."_golden.png")
		espr:LoadGraphics()
		if eft.SubType == 4 then
			player.ControlsEnabled = false
			if not espr:IsPlaying("Golden") and (Input.IsActionTriggered(0, player.ControllerIndex)
			or Input.IsActionTriggered(1, player.ControllerIndex) or Input.IsActionTriggered(2, player.ControllerIndex)
			or Input.IsActionTriggered(3, player.ControllerIndex) or Input.IsActionTriggered(4, player.ControllerIndex)
			or Input.IsActionTriggered(5, player.ControllerIndex) or Input.IsActionTriggered(6, player.ControllerIndex)
			or Input.IsActionTriggered(7, player.ControllerIndex)) then
				espr:Play("GoldStruggle", true)
				eft.Timeout = eft.Timeout - 7
				sound:Play(138, 0.75, 0, false, 1.75)
				if player:GetName() == "_NULL" then
					if math.random(1,5) == 1 then
						eft.FlipX = true
					elseif math.random(1,5) == 2 then
						eft.FlipX = false
					elseif math.random(1,5) == 3 then
						espr.FlipY = true
					elseif math.random(1,5) == 4 then
						espr.FlipY = false
					end
				end
			end
		end
		if (espr:IsFinished("Falling") or espr:IsFinished("FallInLeft")
		or espr:IsFinished("FallInRight") or (eft.SubType == 4
		and (player:GetSprite():IsPlaying("Hit") or eft.Timeout <= 0))) and eft.FrameCount > 1 then
			if eft.SubType == 4 then
				Isaac.Spawn(1000, 357, 0, eft.Position, Vector(0,0), eft)
				Game():SpawnParticles(eft.Position, 95, 20, 7, Color(1.1,1,1,1,0,0,0), 0)
				sound:Play(427, 1, 0, false, 1)
				player:SetColor(Color(1,1,1,1,0,0,0), 99999, 0, false, false)
				if not player:GetSprite():IsPlaying("Hit") then
					player:PlayExtraAnimation("Jump")
					player:SetMinDamageCooldown(110)
					player.ControlsCooldown = 30
				end
			end
			if eft.SubType == 1 or eft.SubType == 4 then
				player.ControlsEnabled = true
			end
			player.FireDelay = 0
			player:GetData().playingmodanim = 0
			player:GetData().playmodanim = 0
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.PlrModAnim)

function denpnapi:ShockWaveR(eft)
	if eft.Variant == 61 then
		if eft.SubType >= 1 and eft.SubType <= 4 then
			local gi = Room:GetGridIndex(eft.Position)
			local ge = Room:GetGridEntity(gi)
			if eft.FrameCount <= 50 then
				if eft.SubType == 2 then
					eft.Velocity = Vector.FromAngle((eft.Velocity):GetAngleDegrees()+(eft.Velocity:Length()*0.25))
					:Resized(eft.Velocity:Length())
				elseif eft.SubType == 3 then
					eft.Velocity = Vector.FromAngle((eft.Velocity):GetAngleDegrees()-(eft.Velocity:Length()*0.25))
					:Resized(eft.Velocity:Length())
				end
			end
			if ge then
				if ge:GetType() == 3 or ge:GetType() == 7
				or ge:GetType() == 11 or ge:GetType() == 15 or ge:GetType() == 16 then
					eft:Remove()
				end
			end
			if eft.Position.X <= Room:GetTopLeftPos().X + 24
			or eft.Position.X >= Room:GetBottomRightPos().X
			or eft.Position.Y <= Room:GetTopLeftPos().Y
			or eft.Position.Y >= Room:GetBottomRightPos().Y then
				eft:Remove()
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.ShockWaveR)

function denpnapi:SimpleEffect(eft)
	if eft.Variant == 367 or eft.Variant == 412 then
		local espr = eft:GetSprite()
		if espr:IsFinished(espr:GetDefaultAnimationName()) then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.SimpleEffect)

function denpnapi:UtGreedCoinB(eft)
	if eft.Variant == 353 then
		local espr = eft:GetSprite()
		if eft.SpawnerType == 1000 and eft.SpawnerVariant == 368 and eft.FrameCount <= 1 then
			if eft.Position.X >= Room:GetBottomRightPos().X-5 or eft.Position.X <= Room:GetTopLeftPos().X+5
			or eft.Position.Y >= Room:GetBottomRightPos().Y-5 or eft.Position.Y <= Room:GetTopLeftPos().Y+5 then
				eft:Remove()
			else
				Game():SpawnParticles(eft.Position, 95, 3, 8, Color(1.1,1,1,1,0,0,0), 0)
			end
		end
		if espr:IsPlaying("Move") and espr:GetFrame() == 38 then
			if eft.SubType == 1 then
				Isaac.Explode(eft.Position, eft.Parent, 40)
				eft:Remove()
			else
				sound:Play(427, 1, 0, false, 1)
				for i=0, 270, 90 do
					local cproj = Isaac.Spawn(9, 7, 0, eft.Position, Vector.FromAngle(i):Resized(9), eft):ToProjectile()
					cproj.FallingSpeed = -5
					cproj.FallingAccel = 0.1
				end
			end
			eft.Velocity = Vector(0,0)
		end
		if espr:IsFinished("Move") then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.UtGreedCoinB)

function denpnapi:WallHole(eft)
	if eft.Variant == 365 then
		local espr = eft:GetSprite()
		local edt = eft:GetData()
		eft.DepthOffset = -1
		if Room:GetBackdropType() == 3 then
			espr.Color = Color(1,0.471,0.471,1,0,0,0)
		elseif Room:GetBackdropType() == 6 or Room:GetBackdropType() == 27 then
			espr.Color = Color(0.55,0.55,0.784,1,0,0,0)
		elseif Room:GetBackdropType() == 7 or Room:GetBackdropType() == 8
		or Room:GetBackdropType() == 14 then
			espr.Color = Color(0.61,0.61,0.61,1,0,0,0)
		elseif Room:GetBackdropType() == 9 then
			espr.Color = Color(0.4,0.4,0.4,1,0,0,0)
		elseif (Room:GetBackdropType() >= 10 and Room:GetBackdropType() <= 12)
		or Room:GetBackdropType() == 24 then
			espr.Color = Color(1,0.352,0.352,1,0,0,0)
		elseif Room:GetBackdropType() == 13 then
			espr.Color = Color(0.51,0.59,1,1.3,0,0,0)
		elseif Room:GetBackdropType() == 15 then
			espr.Color = Color(0.431,0.75,1,1,0,0,0)
		elseif Room:GetBackdropType() == 15 then
			espr.Color = Color(0.431,0.75,1,1,0,0,0)
		elseif Room:GetBackdropType() == 16 then
			espr.Color = Color(0.63,0.4,0.863,1,0,0,0)
		elseif Room:GetBackdropType() == 18 or Room:GetBackdropType() == 26 then
			espr.Color = Color(1,1,1,1,0,0,0)
		else
			espr.Color = Color(0.784,0.51,0.51,1,0,0,0)
		end
		if eft.SubType ~= 1 and eft.FrameCount == 45 then
			espr:Play("Remove"..edt.backdrop, true)
		end
		if Room:GetBackdropType() >= 10 and Room:GetBackdropType() <= 13 then
			edt.backdrop = "W"
		else
			edt.backdrop = "N"
		end
		if eft.Parent then
			if eft.SubType == 1 then
				if espr.Rotation == 90 or espr.Rotation == 270 then
					eft.Position = Vector(eft.Position.X, eft.Parent.Position.Y)
				elseif espr.Rotation == 0 or espr.Rotation == 180 then
					eft.Position = Vector(eft.Parent.Position.X, eft.Position.Y)
				end
			end
			if espr:IsFinished("Appear"..edt.backdrop)
			and eft.Parent.Position:Distance(eft.Position) <= 65 then
				espr:Play("Remove"..edt.backdrop, true)
			end
		else
			if eft.SubType == 1 and espr:IsFinished("Appear"..edt.backdrop) then
				espr:Play("Remove"..edt.backdrop, true)
			end
		end
		if eft.SubType == 2 and eft.FrameCount == 25 then
			Game():ShakeScreen(10)
			sound:Play(28, 1, 0, false, 1)
			Isaac.Spawn(555, 10, 0, eft.Position, Vector.FromAngle(espr.Rotation+90):Resized(33), eft)
			local xplsn = Isaac.Spawn(1000, 2, 2, eft.Position, Vector(0,0), eft)
			xplsn:SetColor(Color(0.13,1.73,2.28,1.5,0,0,0), 99999, 0, false, false)
			xplsn.PositionOffset = Vector(0,-20)
		end
		if espr:IsFinished("Remove"..edt.backdrop) then
			eft:Remove()
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.WallHole)

function denpnapi:Effects(eft)
	espr = eft:GetSprite()
	if eft.Variant == 5 and eft.SpawnerType == 412 then
		eft:SetColor(Color(1,1,1,1,150,150,150), 99999, 0, false, false)
	elseif eft.Variant == 3500 then
		local target = Game():GetPlayer(1)
		if eft.MinRadius < 80 then
			eft.MinRadius = 80
		end
		if eft.MaxRadius <= eft.MinRadius then
			eft.MaxRadius = eft.MinRadius + 1
		end
		if eft.FrameCount <= 1 then
			if eft.SubType ~= 2 then
				espr:PlayOverlay("ShortLaserStart",true)
			else
				espr:PlayOverlay("LongLaserStart",true)
			end
		end
		if eft.Parent and eft.SubType == 1 then
			eft.Position = eft.Parent.Position
		end
		if espr:IsOverlayFinished("ShortLaserStart") then
			espr:PlayOverlay("ShortLaserLoop",true)
		elseif espr:IsOverlayFinished("LongLaserStart") then
			espr:PlayOverlay("LongLaserLoop",true)
		elseif espr:IsFinished("Idle") then
			eft:Remove()
		end
		if eft.SubType == 0 and eft.FrameCount <= 20 then
			espr.Rotation = (target.Position - eft.Position):GetAngleDegrees()
		end
		if espr:IsEventTriggered("Fire") then
			espr:RemoveOverlay()
			if eft.Parent then
				local bshot = EntityLaser.ShootAngle(1, eft.Position, espr.Rotation, 18, Vector(0,-5), eft.Parent):ToLaser()
				if eft.SubType == 1 then
					bshot.MaxDistance = math.random(eft.MinRadius,eft.MaxRadius)
				end
			else
				local bshot = EntityLaser.ShootAngle(1, eft.Position, espr.Rotation, 18, Vector(0,-5), eft):ToLaser()
				if eft.SubType == 1 then
					bshot.MaxDistance = math.random(eft.MinRadius,eft.MaxRadius)
				end
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, denpnapi.Effects)

----------------------------
--Lasers
----------------------------
function denpnapi:Lasers(l)
	local data = l:GetData()
	if not data.pvl then
		data.pvl = 0
	end
	if not data.pdensity or data.pdensity < 6 then
		data.pdensity = 6
	end
	sprls = l:GetSprite()
	if l.Size >= 80 then
		if l.Variant == 1 then
			if l.SpawnerType == 406 then
				if sprls:GetFilename() ~= "gfx/007.006_giant coin laser.anm2" then
					sprls:Load("gfx/007.006_giant coin laser.anm2", true)
					sprls:Play("LargeRedLaser", true)
				end
				if l.FrameCount <= 1 then
					sound:Stop(5)
					sound:Play(239, 1, 0, false, 1)
					sound:Play(48, 0.75, 0, false, 0.5)
					Game():ShakeScreen(10)
				end
				if math.random(1,2) == 1 and l.Timeout > 0 then
					local cproj = Isaac.Spawn(9, 7, 0, l.Position + Vector.FromAngle(l.Angle):Resized(l.LaserLength-80),
					Vector.FromAngle(l.Angle+math.random(0,180)+90):Resized(10), l):ToProjectile()
					cproj.FallingAccel = -0.09
				end
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, denpnapi.Lasers)

function denpnapi:Others()
	local Entities = Isaac:GetRoomEntities()

	for k, v in pairs(Entities) do
		local enspr = v:GetSprite()
		local endata = v:GetData()
		local npc = v:ToNPC()
		if v.Type == 7 then
			if v.Variant == 1 and v.Size >= 80 and v.SpawnerType ~= 406 then
				if v:GetSprite():GetFilename() ~= "gfx/giant red laser.anm2" then
					v:GetSprite():Load("gfx/giant red laser.anm2", true)
					v:GetSprite():Play("LargeRedLaser", true)
				end
				if v.FrameCount <= 2 and v.SpawnerType ~= 407 then
					sound:Stop(5)
					sound:Play(239, 1, 0, false, 1)
				end
			end
		elseif v.Type == 78 then
			if enspr:IsPlaying("Death") and enspr:GetFrame() == 27
			and (Game().Difficulty == 1 or Game().Difficulty == 3) then
				v:Remove()
				if v.Variant == 0 then
					Isaac.Spawn(397, 0, 0, v.Position, Vector(0,0), v)
				elseif v.Variant == 1 then
					Isaac.Spawn(398, 0, 0, v.Position, Vector(0,0), v)
				end
			end
		elseif v.Type == 102 then
			if v.HitPoints <= 0 then
				if (enspr:IsPlaying("Death") or enspr:IsPlaying("Death2"))
				and enspr:GetFrame() >= 20 and enspr:GetFrame() % 2 == 0 then
					Game():SpawnParticles(v.Position, 352, math.random(3,7), 33 - enspr:GetFrame(), Color(1,1,1,1,0,0,0), (enspr:GetFrame()-20)*-50)
				end
				if (Game().Difficulty == 1 or Game().Difficulty == 3) and v.Variant <= 1 then
					if enspr:IsPlaying("Death") then
						enspr:SetLastFrame()
					elseif enspr:IsFinished("Death") then
						enspr:Play("Death2", true)
					end
				end
			end
		elseif v.Type == 217 then
			if enspr:GetFilename() == "gfx/dip_corn_dlrform.anm2" then
				v.SplatColor = Color(1,1,1,1,255,255,255)
			end
		elseif v.Type == 273 and v.Variant == 0 then
			if v.HitPoints <= 0 and enspr:IsPlaying("Death")
			and not v:GetData().planc then
				enspr:Play("Breaking", true)
			end

			if enspr:IsPlaying("Breaking") then
				v.Velocity = Vector(0,0)
				if enspr:GetFrame() == 5 or enspr:GetFrame() == 25 then
					Game():SpawnParticles(v.Position, 35, 7, 5, Color(1,0.95,0.9,1,0,10,0), -24)
				end
				if enspr:GetFrame() == 5 then
					npc:PlaySound(117, 1, 0, false, 1)
					npc:PlaySound(137, 1, 0, false, 1.5)
				elseif enspr:GetFrame() == 25 then
					npc:PlaySound(137, 1, 0, false, 1.65)
				elseif enspr:GetFrame() == 51 then
					npc:PlaySound(141, 1, 0, false, 1)
					Game():SpawnParticles(v.Position, 88, 5, 15, Color(1,1,1,1,135,126,90), -24)
					Game():SpawnParticles(v.Position, 35, 9, 7, Color(1,0.95,0.9,1,0,10,0), -24)
					for i=0,5 do
						Isaac.Spawn(1000, 359, i, v.Position, Vector(0,0), v)
					end
					v:Remove()
					Isaac.Spawn(555, 0, 0, v.Position, Vector(0,0), v)
				end
			end
		elseif v.Type == 555 then
			if not endata.planc and enspr:IsPlaying("Death") then
				enspr:Play("HeadDyingAttackStart", true)
				v.FlipX = false
				npc.ProjectileCooldown = 0
			end
			if enspr:IsPlaying("HeadDyingAttackStart") then
				if enspr:GetFrame() == 31 then
					npc:PlaySound(309 , 1, 0, false, 1)
				elseif enspr:GetFrame() == 33 then
					npc:PlaySound(5, 1, 0, false, 1)
					Game():ShakeScreen(7)
				elseif enspr:GetFrame() == 35 then
					enspr:Play("HeadDyingAttackLoop", true)
					local llaser = Isaac.Spawn(1000, 362, 0, v.Position+Vector(0,100), Vector(0,0), v)
					llaser.Parent = npc
					local llaser2 = Isaac.Spawn(1000, 362, 1, v.Position+Vector(-80,-80), Vector(0,0), v)
					llaser2.Parent = npc
					local llaser3 = Isaac.Spawn(1000, 362, 2, v.Position+Vector(80,-80), Vector(0,0), v)
					llaser3.Parent = npc
				end
			elseif enspr:IsPlaying("HeadDyingAttackLoop") then
				npc.ProjectileCooldown = npc.ProjectileCooldown + 1
				if npc.ProjectileCooldown >= 250 then
					enspr:Play("HeadDyingAttackEnd", true)
				end
			elseif enspr:IsPlaying("HeadDyingAttackEnd") then
				enspr.Rotation = enspr.Rotation * 0.8
				if enspr:GetFrame() == 39 then
					npc:PlaySound(418, 1, 0, false, 1)
					npc.State = 17
				end
			end
		end
		if #Isaac.FindByType(275, 0, 0, true, true) > 0 and v:IsVulnerableEnemy()
		and v.Type ~= 275 and v.Type ~= 399 then
			if v.Position.Y <= 340 + v.Size and v.Velocity.Y <= 0 then
				v.Velocity = Vector(v.Velocity.X,-v.Velocity.Y*0.5)
				v.Position = Vector(v.Position.X, 340 + v.Size)
			end
		end
		if Game().Difficulty == 1 or Game().Difficulty == 3 then
			if v:IsVulnerableEnemy() and FBossFight and not v:GetData().ChangedHP
			and v.Type ~= 84 and v.Type ~= 293 and v.Type ~= 412 then
				if v.Type == 81 then
					v.MaxHitPoints = math.max(v.MaxHitPoints, (v.MaxHitPoints/122)*GetPlayerDps)
				elseif v.Type == 102 then
					v.MaxHitPoints = math.max(v.MaxHitPoints*1.5, ((v.MaxHitPoints*1.5)/95)*GetPlayerDps)
				elseif v.Type == 406 then
					v.MaxHitPoints = math.max(v.MaxHitPoints, (v.MaxHitPoints/145)*GetPlayerDps)
				elseif v.Type == 407 then
					v.MaxHitPoints = math.max(v.MaxHitPoints, (v.MaxHitPoints/150)*GetPlayerDps)
				elseif not v:ToNPC():IsBoss() then
					v.MaxHitPoints = math.max(v.MaxHitPoints, (v.MaxHitPoints/140)*GetPlayerDps)
				else
					v.MaxHitPoints = math.max(v.MaxHitPoints, (v.MaxHitPoints/95)*GetPlayerDps)
				end
				if v.HitPoints < v.MaxHitPoints then
					v.HitPoints = v.MaxHitPoints
				end
				v:GetData().ChangedHP = true
			end
			if not v:GetData().ChangedHP and (v.Type == 78
			or v.Type == 396 or v.Type == 397) then
				v.MaxHitPoints = math.max(v.MaxHitPoints, (v.MaxHitPoints/75)*GetPlayerDps)
				v.HitPoints = v.MaxHitPoints
				v:GetData().ChangedHP = true
			end
		end
		if (v:IsVulnerableEnemy() or v:ToPlayer()) then
			if v:HasEntityFlags(1<<10) then
				if v:ToPlayer() then
					v:ToPlayer().ControlsEnabled = false
					if not endata.goldenfreeze then
						endata.envibration = 15
						endata.goldenfreeze = true
					end
					if endata.envibration > 0 then
						endata.envibration = endata.envibration - 1
						if endata.envibration/4 > 4 then
							v.PositionOffset = Vector((1-(math.random(-1,0)*2))*4,0)
						else
							v.PositionOffset = Vector((1-(math.random(-1,0)*2))*(endata.envibration/4),0)
						end
					end
				end
			else
				if endata.goldenfreeze then
					endata.goldenfreeze = false
					Game():SpawnParticles(v.Position, 95, 20, 7, Color(1.1,1,1,1,0,0,0), 0)
					sound:Play(427, 1, 0, false, 1)
					if v:ToPlayer() then
						v:ToPlayer().ControlsEnabled = true
					end
					Isaac.Spawn(1000, 357, 0, v.Position, Vector(0,0), ev)
				end
			end
		end
	end
end

denpnapi:AddCallback(ModCallbacks.MC_POST_UPDATE, denpnapi.Others)

denpnapi:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, ntt)
	if ntt.Type == 9 then
		p = ntt:ToProjectile()
		if p.ProjectileFlags >= 1 << 44 and p.ProjectileFlags < 1 << 45 then
			if ntt.Variant == 4 then
				local creep = Isaac.Spawn(1000, 22, 0, ntt.Position, Vector(0,0), ntt)
				creep.SpriteScale = Vector(2,2)
				creep:SetColor(Color(1,1,1,1,19,208,255), 99999, 0, false, false)
			else
				local creep = Isaac.Spawn(1000, 22, 0, ntt.Position, Vector(0,0), ntt)
				creep.SpriteScale = Vector(2,2)
			end
		end
		if ntt.Variant == 9 then
			Game():SpawnParticles(ntt.Position, 35, 8, 5, Color(ntt:GetColor().R*0.7,ntt:GetColor().G*0.7,ntt:GetColor().B*0.7,1,0,0,0), 2)
		end
	elseif ntt.Type == 552 then
		if ntt.Variant == 1 then
			local bpoof = Isaac.Spawn(1000, math.random(12,13), 0, ntt.Position, Vector(0,0), ntt)
			bpoof:GetSprite().Offset = Vector(0, ntt.PositionOffset.Y)
			bpoof:GetSprite().Scale = Vector(ntt.Size*0.2, ntt.Size*0.2)
		else
			local bpoof = Isaac.Spawn(1000, 11, 0, ntt.Position, Vector(0,0), ntt)
			bpoof:GetSprite().Offset = Vector(0, ntt.PositionOffset.Y)
			bpoof:GetSprite().Scale = Vector(ntt.Size*0.2, ntt.Size*0.2)
		end
	end
end)

denpnapi:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	DPhase = 0
	if #Isaac.FindByType(412, -1, -1, false, false) > 0 then
		DPhase = 5
		AdultForm = false
		eye = 0
		wig = false
		StAttackReady = 0
	elseif #Isaac.FindByType(45, -1, -1, false, false) > 0 then
		eye = 0
		Wig = false
		MomHand = 0
		WigStuckKnife = false
	elseif #Isaac.FindByType(78, 1, -1, false, false) > 0 then
		KilledCloatty = 0
	elseif #Isaac.FindByType(84, -1, -1, false, false) > 0 then
		StAttackReady = 0
	end

	if Room:GetType() == 5 and (Level:GetStage() == 6 or (Level:GetStage() >= 8 and Level:GetStage() <= 11)
	or (Level:GetStage() == 12 and #Isaac.FindByType(412, -1, -1, false, false) > 0)
	or #Isaac.FindByType(406, -1, -1, false, false) > 0) then
		FBossFight = true
	else
		FBossFight = false
	end
end)
