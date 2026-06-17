-- REPLACED PROCEDURAL CREEPY LIMP ENGINE (With John Doe Arm)
local function toggleCreepyWalk()
    if creepyWalkActive then
        creepyWalkActive = false
        restoreJoints()
        return
    end

    creepyWalkActive = true
    cacheJoints() 
    
    local timer = 0
    creepyWalkConnection = RunService.RenderStepped:Connect(function(dt)
        if not character or not character.Parent or not humanoid then
            restoreJoints()
            return
        end

        local isMoving = humanoid.MoveDirection.Magnitude > 0
        local speedMultiplier = isMoving and 1.5 or 0.3
        timer = timer + (dt * 5 * speedMultiplier)

        local wave = math.sin(timer)
        local absoluteWave = math.abs(math.sin(timer))

        if joints.Type == "R15" or joints.Type == "R6" then
            -- 1. Unnatural Head Tilt
            if joints.Neck and originalC0s.Neck then
                joints.Neck.C0 = originalC0s.Neck * CFrame.Angles(math.rad(12 + wave * 3), 0, math.rad(12))
            end

            -- 2. Asymmetric Limping Legs
            if joints.LeftLeg and originalC0s.LeftLeg then
                if isMoving then
                    joints.LeftLeg.C0 = originalC0s.LeftLeg * CFrame.new(0, -absoluteWave * 0.4, -wave * 0.3) * CFrame.Angles(math.rad(-10 + wave * 20), 0, 0)
                else
                    joints.LeftLeg.C0 = originalC0s.LeftLeg * CFrame.Angles(math.rad(-5), 0, math.rad(-5))
                end
            end

            if joints.RightLeg and originalC0s.RightLeg then
                if isMoving then
                    joints.RightLeg.C0 = originalC0s.RightLeg * CFrame.new(0, 0, wave * 0.5) * CFrame.Angles(math.rad(wave * -25), 0, 0)
                else
                    joints.RightLeg.C0 = originalC0s.RightLeg * CFrame.Angles(0, 0, math.rad(5))
                end
            end

            -- 3. FIXED: John Doe / Dead Broken Arm Modification
            if joints.LeftArm and originalC0s.LeftArm then
                -- Forces the arm straight down parallel to the torso, with a tiny unnerving twitch
                joints.LeftArm.C0 = originalC0s.LeftArm * CFrame.Angles(math.rad(wave * 1.5), 0, math.rad(-5))
            end

            if joints.RightArm and originalC0s.RightArm then
                -- The other arm raises up slightly or twitches forward awkwardly like a zombie
                if isMoving then
                    joints.RightArm.C0 = originalC0s.RightArm * CFrame.Angles(math.rad(30 + wave * 10), 0, math.rad(10))
                else
                    joints.RightArm.C0 = originalC0s.RightArm * CFrame.Angles(math.rad(15), 0, math.rad(5))
                end
            end
            
            -- 4. Torso Slouch
            if joints.Root and originalC0s.Root then
                if isMoving then
                    joints.Root.C0 = originalC0s.Root * CFrame.new(0, -absoluteWave * 0.2, 0) * CFrame.Angles(math.rad(10), 0, 0)
                else
                    joints.Root.C0 = originalC0s.Root * CFrame.Angles(math.rad(5), 0, 0)
                end
            end
        end
    end)
end
