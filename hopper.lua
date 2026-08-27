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
        "f54453a7-c7f4-48ee-b3bc-ef2081a64bb2",
        "0a9c0ab8-3d5e-47e5-a5a3-90498402184f",
        "3f239469-0470-408d-8710-51a69ab8df2c",
        "d6b0090f-fdae-4d11-895c-60cd2f1ed61d",
        "b0a62ff9-9ccd-40d3-a8e1-2d6bc3d1b8c2",
        "cf2ea244-7ac0-4692-bb6d-faf23b6653ef",
        "467d8d25-f28f-4bf2-b9f5-9d7694248257",
        "2ad3e547-89e5-414f-a952-08e3e1ca1eb2",
        "1e7c5267-82dc-4373-8e29-795c875c845c",
        "9f4201cb-eab1-43ae-aeec-78fbdceeeeaf",
        "de0268ea-b666-4f4a-9206-ebf146e5b889",
        "78396fb3-39de-47e5-9cf5-5986fa7b9a40",
        "6e26c0d8-dc66-4f74-8b9e-16d80d8c2f17",
        "2387e84b-49af-4a0a-862e-e690955ac222",
        "32b91343-ff03-4761-b83f-30d502ed5930",
        "8525ce6f-8c4e-421d-978a-38ae135f1800",
        "bc2985e7-5d21-4183-bb12-dd2b9a867d75",
        "269f7cc6-ad8e-4609-a327-86b70a311d90",
        "f1a7d9c1-6c61-4f4b-bf9d-62948d257e9e",
        "bdcf1b12-38b5-41b9-9a48-2b3b1020e25d",
        "ca0349a9-2bd0-4188-9bdf-2be0ab1e97a2",
        "2c17df4a-1304-40e7-a76c-3ce552a05733",
        "09984a05-b853-491e-9992-47c80ebe458a",
        "db702f3d-53e3-4c9b-acdd-aefb5950d275",
        "d5bb3fb8-391d-4fad-a92d-dd91f0bb9434",
        "6047fb89-c22c-475e-99f4-c07b985d87f4",
        "00fa2dbf-41b6-438e-aa9c-a48a100d753d",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "4627034f-15bc-4a64-9172-bdb714aff044",
        "d3e46824-7932-4344-b364-b02d9631f5cb",
        "fb41bfbb-b350-4025-a159-8a396a7ca97a",
        "e8b68a49-8fca-40ae-adb9-07ccb70aa5a9",
        "aba9d9fc-7387-4ec9-ba11-ebfa5d28283c",
        "60b3673a-f1cb-485a-b558-1c106ae70db7",
        "709bffcb-f81a-4bd1-a19c-fd2134e58ef2",
        "d9ece429-3e8c-4961-a560-8a7ad09cfe29",
        "68b585f5-542d-455d-9a07-c0ed79de135d",
        "e621941c-5b88-4f55-bca8-650b0545f723",
        "af5f4098-ae58-4cfd-8732-d65273aa3ac7",
        "d17f1043-9a13-42a5-9403-1d6048e7b311",
        "16f71c29-9f8f-4a11-9abe-57935c634f1c",
        "9c01e108-431c-43e4-84e4-28e8b0145c05",
        "6ff181ad-af49-4055-8b0e-92688d481691",
        "0298638d-b859-48e4-a3c6-10998aa0402f",
        "d1d34310-9cc8-4833-80a6-f085be9584af",
        "0a14bea7-0f22-4b78-bdc4-754dd9c03aab",
        "61942080-53e2-4403-aecc-6d933809b60c",
        "d2a5fc13-a80e-41c3-9d76-51293de76704",
        "1b10e5aa-2561-415a-a22f-05a366c5f565",
        "e348872b-10bf-4949-a90e-c09262e2c93b",
        "c8823649-3c23-44e2-b999-266ae463ea84",
        "31f9fe2a-484d-4d95-a5ea-b5b82072ae58",
        "4bf6eb33-6252-44dd-98d5-94d30f8662a3",
        "59cbc46f-adc8-4e0a-ba51-53f37d5bda4e",
        "c932cd99-2af5-4071-bd6b-b3e9cb9cde89",
        "1e1728bc-6025-49a4-9223-da270fd3ab9c",
        "d2c1bcaa-325b-4cce-a92c-d2c4666bee68",
        "74fb9d52-86fd-4952-b688-945651799271",
        "6773d7e2-b9fd-4816-b672-5f9cf01ef06d",
        "dcde7185-1da4-482d-b4fb-06fffc48caf3",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "99e95aa2-7de5-48ec-86dd-a66d6b551658",
        "ba134714-7f03-4b5c-9391-050eb313e45a",
        "60b7aeac-0573-46f9-94e3-53ed68bafe51",
        "8652b1d0-1036-40ae-9fc0-2faa77089839",
        "fda92c4d-24dc-41ff-90c1-003ffa70007e",
        "1a051ed9-de6d-457f-aea6-7d2943587ac6",
        "4a7a1232-e3c4-4a6f-ad73-4c827d8259ea",
        "17bc44ee-7fa8-4427-a54d-702be64f7138",
        "4e203fd5-6e6c-483b-b94d-c983cd4fee37",
        "3bf98ecb-5b87-4bfa-bdba-8098afd1b155",
        "3839bbbb-f3ac-4d7a-873b-7cb85218c90f",
        "9f883f90-549a-4205-9fc4-846592a97f41",
        "95c1fed6-8a1f-48ff-8fd1-52e97ba33e63",
        "765f610c-7d8d-409b-ad03-f75873b1761f",
        "97f00e3b-6759-403c-b422-b084feae71d3",
        "38fe2542-0ba3-4b8e-8702-af673bec9744",
        "e4aea852-af21-403f-a4f4-19a178f6e80a",
        "3eeabb13-2532-4f48-bb13-c2142aea78b9",
        "dff83023-ba4d-44b8-8a3e-15ffd65623c2",
        "66cdbffa-9030-46ba-8e0c-347b7bf6a870"
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