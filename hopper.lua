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
        "59cbc46f-adc8-4e0a-ba51-53f37d5bda4e",
        "fb41bfbb-b350-4025-a159-8a396a7ca97a",
        "0a9c0ab8-3d5e-47e5-a5a3-90498402184f",
        "a9b1e001-35dc-4572-9f38-9deac319ab65",
        "99e95aa2-7de5-48ec-86dd-a66d6b551658",
        "6773d7e2-b9fd-4816-b672-5f9cf01ef06d",
        "d2a5fc13-a80e-41c3-9d76-51293de76704",
        "70f77962-f7ad-466a-a54d-b05212c77d29",
        "3839bbbb-f3ac-4d7a-873b-7cb85218c90f",
        "52825170-ca52-4274-9fa9-cf3715c06e4f",
        "fda92c4d-24dc-41ff-90c1-003ffa70007e",
        "2c17df4a-1304-40e7-a76c-3ce552a05733",
        "09984a05-b853-491e-9992-47c80ebe458a",
        "60b7aeac-0573-46f9-94e3-53ed68bafe51",
        "38fe2542-0ba3-4b8e-8702-af673bec9744",
        "93d5f473-0906-4af2-b8d2-e2af450f98df",
        "9f883f90-549a-4205-9fc4-846592a97f41",
        "6ff181ad-af49-4055-8b0e-92688d481691",
        "e621941c-5b88-4f55-bca8-650b0545f723",
        "dff83023-ba4d-44b8-8a3e-15ffd65623c2",
        "c8823649-3c23-44e2-b999-266ae463ea84",
        "4da88e64-755d-4bbe-ab9a-0ef209909153",
        "09719a8a-51db-479c-807a-a2f6e4d9af10",
        "f54453a7-c7f4-48ee-b3bc-ef2081a64bb2",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "9c01e108-431c-43e4-84e4-28e8b0145c05",
        "cf2ea244-7ac0-4692-bb6d-faf23b6653ef",
        "8652b1d0-1036-40ae-9fc0-2faa77089839",
        "d2c1bcaa-325b-4cce-a92c-d2c4666bee68",
        "45f9f66b-129e-4e0d-98fe-c161ac051fbf",
        "c1fe7705-9340-45b4-aa49-47c84b7b069c",
        "6047fb89-c22c-475e-99f4-c07b985d87f4",
        "ffa14747-f048-4cfe-98ad-4cc75e52ce3f",
        "84e9483f-6fbc-4540-bdb2-f6bf358360b8",
        "e7c557e1-4ffc-4620-9c16-6ab175f8536c",
        "3429191d-230b-4c13-82d8-cae0a4ca8b5c",
        "6bbf7f3c-81f8-43d7-87d2-621bd164ef2f",
        "0298638d-b859-48e4-a3c6-10998aa0402f",
        "ba134714-7f03-4b5c-9391-050eb313e45a",
        "78396fb3-39de-47e5-9cf5-5986fa7b9a40",
        "bcbfa6ac-b5aa-4392-9e6c-9a36142cd336",
        "d17f1043-9a13-42a5-9403-1d6048e7b311",
        "f1a7d9c1-6c61-4f4b-bf9d-62948d257e9e",
        "31f9fe2a-484d-4d95-a5ea-b5b82072ae58",
        "709bffcb-f81a-4bd1-a19c-fd2134e58ef2",
        "1b10e5aa-2561-415a-a22f-05a366c5f565",
        "68f9522c-4729-49b2-8e28-3815518a968a",
        "111e9988-b4fa-4a4a-85a6-ea2c59f8d4d5",
        "a5098132-6e6d-489b-bc1c-f5761ffa1033",
        "269f7cc6-ad8e-4609-a327-86b70a311d90",
        "a0759bb1-75b0-4e10-bdb2-c2eb1914d046",
        "0a14bea7-0f22-4b78-bdc4-754dd9c03aab",
        "d6b0090f-fdae-4d11-895c-60cd2f1ed61d",
        "61942080-53e2-4403-aecc-6d933809b60c",
        "a9d322b5-edbf-45ec-81f0-9fd65aaaac49",
        "21bd8137-df1f-43ce-a1d9-b1d8689a1648",
        "2ad3e547-89e5-414f-a952-08e3e1ca1eb2",
        "8525ce6f-8c4e-421d-978a-38ae135f1800",
        "68b585f5-542d-455d-9a07-c0ed79de135d",
        "37ff93ec-71bb-4d23-bb9e-609f6d8f9d23",
        "247a6ee0-12ff-44e3-9e5d-73fce80b82e0",
        "3f239469-0470-408d-8710-51a69ab8df2c",
        "de0268ea-b666-4f4a-9206-ebf146e5b889",
        "41f92d5a-a3d4-4aa9-a60c-717bbfe082f3",
        "511056cc-df3c-4c9c-91eb-003f3c8d696e",
        "42143cb2-c28a-4730-96de-c06c8b1a7c9e",
        "9a860ac9-5a3e-4e2a-af6e-4abd8241bcd6",
        "7b284f47-8d78-4701-ba11-b01935455c47",
        "3106de3f-3918-4ef6-be29-6703af44d2e7",
        "db702f3d-53e3-4c9b-acdd-aefb5950d275",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "3eeabb13-2532-4f48-bb13-c2142aea78b9",
        "67004770-9927-47d4-bb7f-e00a38ba5927",
        "c932cd99-2af5-4071-bd6b-b3e9cb9cde89",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "4bf6eb33-6252-44dd-98d5-94d30f8662a3",
        "e4aea852-af21-403f-a4f4-19a178f6e80a",
        "cb0b6afc-85ef-4a4f-b5e8-405a0b9c47ef",
        "ca0349a9-2bd0-4188-9bdf-2be0ab1e97a2",
        "2ec60582-1c43-4249-b522-8d917c345647",
        "0fba8a50-97b2-49b1-a765-f2e7d8969fbd",
        "95c1fed6-8a1f-48ff-8fd1-52e97ba33e63",
        "ff5c9a84-ac6c-4ef6-b505-088c97f62363",
        "128ca89f-dc33-46cb-9b73-720fbb3e35be",
        "93483ee1-a0e3-4ad9-9ca0-fb7446567da5",
        "4e203fd5-6e6c-483b-b94d-c983cd4fee37",
        "3bf98ecb-5b87-4bfa-bdba-8098afd1b155",
        "acf00e4c-54b8-497f-95b4-cd9b216f2313",
        "2b87596b-ad69-4270-aa8d-25b14f3bef0f",
        "765f610c-7d8d-409b-ad03-f75873b1761f",
        "708530cd-1191-406b-a1b1-8181da880a15",
        "87bdf396-464e-4364-9893-8f8a2d93196a",
        "20bd41b0-540e-448f-927a-797d702cd2e4",
        "a536fed2-1fc7-43e0-a528-5a1891ca397a",
        "1fe80b67-b1d6-4d5b-9d3b-ad21fa968e92",
        "826a1723-e998-4c80-bae1-1df169a0e1b1",
        "062957bf-fb1e-4200-a104-c197fd6604ad",
        "1e1728bc-6025-49a4-9223-da270fd3ab9c",
        "bc2985e7-5d21-4183-bb12-dd2b9a867d75",
        "00fa2dbf-41b6-438e-aa9c-a48a100d753d",
        "848b24dd-1df3-4f97-bd94-5b992779c877",
        "f9402e86-8301-4ce4-bcba-dad95ad02360",
        "e393fdc8-3152-49e3-8fef-79a6cc44cd97",
        "e5848a40-72a1-4d3d-b0af-a5c2e41204d0"
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