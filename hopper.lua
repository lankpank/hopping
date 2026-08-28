task.wait(40)  -- Wait for game to fully load

-- Loaded from GitHub: lankpank/itesty
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local localUsername = player.Name

-- ============ CONFIGURATION ============
local ACCOUNT_LABEL = "HopperBot"
local MAX_PLAYER_COUNT = 7
local RIFT_NAME = "shadow-rift"
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 1  -- Seconds to wait before teleporting to rift

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = false  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "062957bf-fb1e-4200-a104-c197fd6604ad",
        "e70cf622-64a1-4d6c-9f3c-341f25063cf9",
        "c3493118-3036-4e93-b008-3d030369f257",
        "efc6ee25-c77a-49ac-ab14-678fc695cbb8",
        "6f8983b9-1ed8-4a43-9d9d-ce0d01a5bf39",
        "13c4dafb-4f1f-4e5c-8c04-342d36847578",
        "42143cb2-c28a-4730-96de-c06c8b1a7c9e",
        "74348224-88ed-41bc-8958-dcf4b9ac006c",
        "13764a57-e91e-4b68-a672-c772e96e80d5",
        "92a9896c-0787-4a4c-be3f-63330e1d8d2a",
        "4f98c6dd-357b-4a28-aa4d-5c9adfa447b1",
        "8c807d62-1ee5-4566-a705-939f0b428063",
        "e28ee19b-7969-40df-b199-896159bd0231",
        "20bd41b0-540e-448f-927a-797d702cd2e4",
        "e7ae2d01-2f53-4611-bbf1-b701c889a4fb",
        "d18d612c-a2a0-4552-8df1-f6390ae621cf",
        "c945cbf2-1bd6-499e-8d41-f70cdb76eb4c",
        "bb04ca34-f7fe-4ac2-9a07-bf9b5f3fcfcd",
        "acf00e4c-54b8-497f-95b4-cd9b216f2313",
        "cb0a99b1-629c-4e81-a8c3-5db683e7f1da",
        "dfb32b88-de41-4e6e-b56e-95ad9b4fe541",
        "f40be306-27ed-4df5-8b97-2eb6353732ff",
        "2f837717-64e4-4fe9-9ca0-1fdd3571dc54",
        "a0759bb1-75b0-4e10-bdb2-c2eb1914d046",
        "cc95fd5f-04a6-4b00-9b56-30fe2ef54b32",
        "6f61d4ce-54d8-4f5e-b1b9-9aa61c5d8c17",
        "4f465b69-d66b-468d-9734-e978a54adc4f",
        "e18fee5c-b0d3-4d05-98c9-b7d90bd46b78",
        "4f4ca2eb-371c-4607-9b06-33cde1ffa51b",
        "0ab474de-332b-40c9-bfb0-1893613ec7a2",
        "709bffcb-f81a-4bd1-a19c-fd2134e58ef2",
        "572d445a-23d4-485c-8c3e-ddc8c9380f24",
        "a064ada1-f18e-4e64-b949-027dafe3731d",
        "83d2ab48-05b9-4bf1-ae16-eb3b171ff980",
        "3fafaf6f-75fd-4665-b49d-aa85936f3eb4",
        "6e7c28d3-ebe2-4404-a566-e4ec8150e7ff",
        "b09cd7a0-4a94-408d-940d-f200321c14e4",
        "cb111473-bfd1-4894-a476-23a2c68c28b1",
        "61292f6e-f667-4d27-a257-6dba37160104",
        "0b7b1f58-3329-4737-9434-11fee45079c2",
        "61385522-008d-4f60-86a1-fe4f1f754cd0",
        "247a6ee0-12ff-44e3-9e5d-73fce80b82e0",
        "4d387f8e-d7c1-470f-a945-5b06a6a3494f",
        "d0aabbca-5c01-4368-954e-853f34729329",
        "e9b04a28-e1ed-40c1-aeb6-259129a79f50",
        "1fe80b67-b1d6-4d5b-9d3b-ad21fa968e92",
        "853332c7-fbe2-4301-a728-ab4407ff8de6",
        "2904e33d-f3da-4daf-ba0f-de6e290b640a",
        "3f239469-0470-408d-8710-51a69ab8df2c",
        "0fba8a50-97b2-49b1-a765-f2e7d8969fbd",
        "6fb1c07b-0d34-44e9-952e-2a6b683f83ba",
        "f21f1c91-e519-4616-8243-21552eb61743",
        "e393fdc8-3152-49e3-8fef-79a6cc44cd97",
        "6bbf7f3c-81f8-43d7-87d2-621bd164ef2f",
        "71943979-0187-4b1a-badb-7ccd980ff596",
        "4e5c0e84-da38-43e3-a906-e4a2182572bc",
        "64168c52-5151-44cb-b1fe-87eab714e17a",
        "267858ab-19df-4d3a-ac62-361dd2816d63",
        "655d1e45-905d-4e90-8ef9-6cde0f76b17f",
        "0e612eb9-ef3a-4e75-bb2b-853234b1786b",
        "8d0217de-6290-434c-8bd1-fff77182eeeb",
        "84fa9e6c-3bde-4b18-89b6-75ea244371e5",
        "02b6f2e8-ee0b-4008-a20f-e6dc37784bf3",
        "3fb02a8b-2e36-481c-9d44-e62ddae907eb",
        "64cfd8e2-30eb-413d-bd80-12fbf76a198f",
        "3106de3f-3918-4ef6-be29-6703af44d2e7",
        "a009e18e-0cb3-4d61-8551-b1f5d0a29f1f",
        "9bf789db-4a2b-4d8d-88a3-c25b53b52f94",
        "e621941c-5b88-4f55-bca8-650b0545f723",
        "d1e1ad26-497d-40f8-ae33-41b6d1b06a7f",
        "45f9f66b-129e-4e0d-98fe-c161ac051fbf",
        "4bf6eb33-6252-44dd-98d5-94d30f8662a3",
        "4e3ef0be-95df-43ea-ae01-1fcd7bb31913",
        "f7d4d610-4920-4bd3-b88b-fd29c406bea3",
        "5c4adf52-9a94-4cbc-baa5-dc4ba64f03cf",
        "70f77962-f7ad-466a-a54d-b05212c77d29",
        "8673c8a2-8eb4-44f6-9fef-03605488a248",
        "be8ce74c-c425-4ea6-bf58-706396a8b22e",
        "d9e2243a-1d52-4e1d-ab74-ce9ae64cbf6f",
        "de8216f2-ff50-40cf-9976-ccf68d770755",
        "02fdbb35-8b99-4455-956f-edb7db71fbc3",
        "212e0a45-2025-49ea-ac21-683206405839",
        "4656b26c-6b0c-4134-b0a5-ba98107cf1c4",
        "06aeb552-147e-4e31-8e4b-6c01c4f13eff",
        "8673c8a2-8eb4-44f6-9fef-03605488a248",
        "be8ce74c-c425-4ea6-bf58-706396a8b22e",
        "d9e2243a-1d52-4e1d-ab74-ce9ae64cbf6f",
        "de8216f2-ff50-40cf-9976-ccf68d770755",
        "02fdbb35-8b99-4455-956f-edb7db71fbc3",
        "212e0a45-2025-49ea-ac21-683206405839",
        "653b18ca-2717-4bd7-8f4b-e712f52aba2b",
        "64cfd8e2-30eb-413d-bd80-12fbf76a198f",
        "4656b26c-6b0c-4134-b0a5-ba98107cf1c4",
        "2904e33d-f3da-4daf-ba0f-de6e290b640a",
        "a6ed9a7d-f9cb-48d7-b9c3-d04d52d1b438",
        "5485b972-77b6-4f85-8eca-c538759536cd",
        "96f88839-c7e7-4153-bf82-6a4f0b7457df",
        "a3c7f0cd-1ea2-4a6d-b550-d9b559aeca31",
        "0cb7454f-bc17-4632-be64-991d53a4bcb4",
        "c0954baf-8956-4c62-a69a-0f6e41571ca8",
        "b92a274c-a348-475d-8e1a-2c67f0f2a35a",
        "68b585f5-542d-455d-9a07-c0ed79de135d",
        "9c01e108-431c-43e4-84e4-28e8b0145c05",
        "3bf98ecb-5b87-4bfa-bdba-8098afd1b155",
        "99e95aa2-7de5-48ec-86dd-a66d6b551658",
        "d2c1bcaa-325b-4cce-a92c-d2c4666bee68",
        "1e7c5267-82dc-4373-8e29-795c875c845c",
        "0a14bea7-0f22-4b78-bdc4-754dd9c03aab",
        "61942080-53e2-4403-aecc-6d933809b60c",
        "4fd3e55f-49ff-43af-87d8-9d0a7fd70d20",
        "9c8185a2-f4bf-4736-9134-edaa63d80032",
        "57671be7-a1c5-4015-8014-a168d8126e0b",
        "269f7cc6-ad8e-4609-a327-86b70a311d90",
        "d2a5fc13-a80e-41c3-9d76-51293de76704",
        "7b284f47-8d78-4701-ba11-b01935455c47",
        "f1a7d9c1-6c61-4f4b-bf9d-62948d257e9e",
        "db702f3d-53e3-4c9b-acdd-aefb5950d275"
    }

-- ============ STATE ============
local isHopping = false
local riftActive = false
local hasTeleportedToRift = false

-- ============ WEBHOOK ============
local function sendWebhook(targetUrl, payload)
    if targetUrl == "" then return end
    local requestBody = HttpService:JSONEncode(payload)
    pcall(function()
        if syn and syn.request then
            return syn.request({Url=targetUrl,Method="POST",Headers={["Content-Type"]="application/json"},Body=requestBody})
        elseif request then
            return request({Url=targetUrl,Method="POST",Headers={["Content-Type"]="application/json"},Body=requestBody})
        elseif http and http.request then
            return http.request({Url=targetUrl,Method="POST",Headers={["Content-Type"]="application/json"},Body=requestBody})
        end
    end)
end

-- ============ RIFT ============
local function isRiftValid()
    local rift = RIFT_PATH:FindFirstChild(RIFT_NAME)
    return rift and rift:FindFirstChild("Display") and rift.Display:IsA("BasePart") and rift or nil
end

-- ============ AUTO TELEPORT TO RIFT ============
local function teleportToRift()
    local riftInstance = isRiftValid()
    if not riftInstance then 
        print("❌ No rift found to teleport to!")
        return false 
    end
    
    if hasTeleportedToRift then
        print("⏳ Already teleported to this rift!")
        return true
    end
    
    print("🚀 Attempting to teleport to rift...")
    
    -- Get the character
    local character = player.Character
    if not character or not character.Parent then
        print("❌ Character not found! Waiting for respawn...")
        task.wait(2)
        character = player.Character
        if not character or not character.Parent then
            print("❌ Still no character! Cannot teleport.")
            return false
        end
    end
    
    -- Get the humanoid root part or primary part
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
    if not rootPart then
        print("❌ No root part found!")
        return false
    end
    
    -- Get rift position (slightly above the display for landing)
    local riftPosition = riftInstance.Display.Position + Vector3.new(0, 5, 0)
    
    -- Check if we're already at the rift
    local distance = (rootPart.Position - riftPosition).Magnitude
    if distance < 20 then
        print("✅ Already near the rift!")
        hasTeleportedToRift = true
        return true
    end
    
    -- Teleport using CFrame
    local success = pcall(function()
        rootPart.CFrame = CFrame.new(riftPosition)
        print("✅ Teleported to rift at height: " .. math.floor(riftPosition.Y) .. " meters!")
        hasTeleportedToRift = true
        
        -- Send confirmation webhook
        if w_notify ~= "" then
            local message = string.format(
                "%s | User **%s** teleported to rift!\n> **Height:** %d meters",
                ACCOUNT_LABEL,
                localUsername,
                math.floor(riftPosition.Y)
            )
            sendWebhook(w_notify, { content = message })
        end
    end)
    
    if not success then
        print("❌ Failed to teleport to rift! Trying alternative method...")
        -- Alternative: Use the character's Humanoid to move
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            pcall(function()
                humanoid:MoveTo(riftPosition)
                print("✅ Using MoveTo to approach rift!")
            end)
        end
        return false
    end
    
    return true
end

local function checkAndReportRift()
    local riftInstance = isRiftValid()
    if not riftInstance then return end
    
    print("🎯 RIFT FOUND!")
    
    -- Auto teleport to rift if enabled
    if AUTO_TELEPORT_TO_RIFT then
        print("⏳ Waiting " .. TELEPORT_DELAY .. " seconds before teleporting...")
        task.wait(TELEPORT_DELAY)
        teleportToRift()
    end
    
    if w_main ~= "" then
        -- Get rift info
        local height = math.floor(riftInstance.Display.Position.Y)
        local playerCount = #Players:GetPlayers()
        local gameId = game.PlaceId
        local jobId = game.JobId
        
        -- ============ GET RIFT TIMER ============
        local discordTimestampValue = ""
        local surfaceGui = riftInstance.Display:FindFirstChild("SurfaceGui")
        local timerGui = surfaceGui and surfaceGui:FindFirstChild("Timer")
        
        if timerGui and timerGui:IsA("TextLabel") then
            local timerText = timerGui.Text
            local minutes = tonumber(string.match(timerText, "(%d+) ?m")) or 0
            local seconds = tonumber(string.match(timerText, "(%d+) ?s")) or 0
            
            if (minutes + seconds) > 0 then
                discordTimestampValue = string.format(
                    "<t:%d:R>",
                    os.time() + (minutes * 60) + seconds
                )
            end
        end
        
        -- ============ GET LUCK VALUE ============
        local luckValue = ""
        local iconPart = riftInstance.Display:FindFirstChild("Icon")
        local luckLabel = iconPart and iconPart:FindFirstChild("Luck")
        
        if luckLabel and luckLabel:IsA("TextLabel") then
            luckValue = luckLabel.Text
        end
        
        -- Generate Direct Server Link and Teleport Script
        local joinLink = "roblox://experiences/start?placeId=" .. gameId .. "&gameInstanceId=" .. jobId
        local teleportScript = string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s")',
            gameId,
            jobId
        )
        
        -- Build ping message if enabled
        local pingMessage = ""
        if PING_EVERYONE then
            pingMessage = "@everyone **RIFT FOUND!** "
        end
        
        -- Add teleport status to fields
        local teleportStatus = "Not teleported"
        if hasTeleportedToRift then
            teleportStatus = "✅ Teleported!"
        end
        
        -- ============ BUILD EMBED FIELDS ============
        local embedFields = {
            { name = "Found By", value = localUsername .. " (" .. ACCOUNT_LABEL .. ")", inline = false },
            { name = "Rift Height", value = tostring(height) .. " meters", inline = false },
            { name = "Players", value = string.format("%d/12", playerCount), inline = false },
            { name = "Auto-Teleport Status", value = teleportStatus, inline = false }
        }
        
        -- Add Luck if available
        if luckValue and luckValue ~= "" then
            table.insert(embedFields, { name = "Luck", value = luckValue, inline = false })
        end
        
        -- Add Timer if available
        if discordTimestampValue and discordTimestampValue ~= "" then
            table.insert(embedFields, { name = "Ends", value = discordTimestampValue, inline = false })
        end
        
        -- Add Link and Teleport Script
        table.insert(embedFields, { name = "Direct Server Link", value = "```\n" .. joinLink .. "\n```", inline = false })
        table.insert(embedFields, { name = "Teleport Script", value = "```lua\n" .. teleportScript .. "\n```", inline = false })
        
        -- ============ BUILD PAYLOAD ============
        local payload = {
            embeds = {{
                title = RIFT_NAME .. " Found!",
                description = "A rift has been located.",
                color = 65280,
                fields = embedFields,
                footer = { text = "Webhook v7.4" }
            }}
        }
        
        -- Send the embed
        sendWebhook(w_main, payload)
        task.wait(0.5)
        
        -- Send the link with optional ping
        local linkPayload = { content = joinLink }
        if PING_EVERYONE then
            linkPayload = { content = pingMessage .. joinLink }
        end
        sendWebhook(w_main, linkPayload)
        
        if PING_EVERYONE then
            print("🔔 @everyone ping sent for rift at " .. height .. " meters!")
        end
    end
end

-- ============ HOPPING WITH RETRY LOGIC ============
local function hopServers()
    if isHopping or isRiftValid() then return end
    
    isHopping = true
    print("🔍 Finding random server... Available:", #SERVER_LIST)
    
    if #SERVER_LIST > 0 then
        -- Create a copy of the server list to work with
        local availableServers = {}
        for _, id in ipairs(SERVER_LIST) do
            if id ~= game.JobId then
                table.insert(availableServers, id)
            end
        end
        
        if #availableServers > 0 then
            -- Try up to MAX_RETRY_ATTEMPTS different servers
            local maxAttempts = math.min(MAX_RETRY_ATTEMPTS, #availableServers)
            local success = false
            
            for attempt = 1, maxAttempts do
                -- Check if rift appeared during retries
                if isRiftValid() then
                    print("🎯 Rift appeared! Stopping retries.")
                    break
                end
                
                -- Pick a random server from remaining list
                local randomIndex = math.random(1, #availableServers)
                local target = availableServers[randomIndex]
                
                -- Remove it so we don't try again
                table.remove(availableServers, randomIndex)
                
                print(string.format("🔄 Attempt %d/%d - Hopping to: %s", attempt, maxAttempts, target))
                
                -- Send notification to Discord
                if w_notify ~= "" then
                    local message = string.format(
                        "%s | User **%s** is hopping.\n> **To:** %s\n> **Players:** Under %d\n> **Attempt:** %d/%d",
                        ACCOUNT_LABEL,
                        localUsername,
                        target,
                        MAX_PLAYER_COUNT,
                        attempt,
                        maxAttempts
                    )
                    sendWebhook(w_notify, { content = message })
                end
                
                task.wait(1)
                
                -- Try to teleport
                local teleportSuccess = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, target, Players.LocalPlayer)
                end)
                
                if teleportSuccess then
                    print("✅ Teleport successful!")
                    success = true
                    break
                else
                    print("❌ Teleport failed! (Server may be full, dead, or private)")
                    print("🔄 Trying another server...")
                    task.wait(2)  -- Brief pause before next attempt
                end
            end
            
            -- If all attempts failed
            if not success then
                print("❌ All teleport attempts failed. Rejoining...")
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                end)
            end
        else
            print("❌ No other servers available. Rejoining...")
            pcall(function()
                TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
            end)
        end
    else
        print("❌ No servers in list. Rejoining...")
        pcall(function()
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end)
    end
    
    task.delay(HOP_COOLDOWN, function()
        print("✅ Hop cooldown finished!")
        isHopping = false
    end)
end

-- ============ MAIN LOOP ============
print("🚀 Auto-Hopper Started! Loaded", #SERVER_LIST, "servers from GitHub")
print("📊 Looking for servers with under", MAX_PLAYER_COUNT, "players")
print("🔄 Will retry up to", MAX_RETRY_ATTEMPTS, "servers if teleport fails")
if PING_EVERYONE then
    print("🔔 @everyone ping is ENABLED for rift finds!")
else
    print("🔕 @everyone ping is DISABLED")
end
if AUTO_TELEPORT_TO_RIFT then
    print("🚀 Auto-teleport to rift is ENABLED (delay: " .. TELEPORT_DELAY .. "s)")
else
    print("🚫 Auto-teleport to rift is DISABLED")
end
print("⏳ Waiting for rift detection...")

while true do
    if isRiftValid() then
        if not riftActive then
            riftActive = true
            hasTeleportedToRift = false  -- Reset for new rift
            print("🎯 RIFT FOUND! Stopping hops.")
            checkAndReportRift()
        else
            print("⏳ Rift still active - waiting...")
        end
    else
        if riftActive then
            riftActive = false
            hasTeleportedToRift = false
            print("❌ Rift ended! Resuming hops.")
        end
        
        if not isHopping then
            hopServers()
        end
    end
    
    task.wait(RIFT_CHECK_DELAY)
end