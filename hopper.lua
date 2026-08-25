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
        "f97fa9ed-fe26-49ca-a3e5-61867e7c0029",
        "afc1a27f-2d25-4a14-859b-8dc7bb03f56d",
        "5983c5db-c404-4c60-b4ec-ecb2164bab4c",
        "04ce09ed-5c69-41f3-9284-1d7ed5b6711d",
        "de27c55c-e5b1-4c82-b3ab-9b7f61154c35",
        "d00a1850-5f8e-4b48-a255-9a274781d72f",
        "0dc25693-8ad3-46e6-b629-f3670309d1b7",
        "6c9521ff-8467-43e9-9bbd-d19d294ec2d9",
        "37dc507c-ccb1-4ec2-87a0-0f5c86c970a3",
        "1eefd3b2-5bf9-413f-ad45-7a1005f58153",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "92dbe765-1b7a-4317-a672-e368dd6e6405",
        "c009e80b-d7b4-4ab0-b538-a44eeea867b3",
        "59331d88-1e23-4e92-a52c-32fe5500c394",
        "b0530d3f-6f3e-4a89-bae8-45063daa4fc8",
        "2b38fa12-3496-4089-a4aa-e939b3306ce7",
        "ecb1bc11-36ae-40db-a739-3686a999bb43",
        "a30a7f23-237b-4c6d-90ff-8f92dc0f7889",
        "a595933b-805e-478e-aef0-b327086145f4",
        "f6d5eb5d-6ce2-4317-a44e-5521559134ec",
        "c582d1aa-8e2f-48c7-bf49-567a4a10a6e0",
        "62a8cc38-5876-4114-abe6-c45cf7b4b189",
        "325c719d-a1e8-4426-8c3a-5eef71c58861",
        "d8c78b70-71ea-4d0b-9bbf-8f56a4da1451",
        "a5c0f2ae-693d-4634-b4ea-005904d950ae",
        "26c4c7ad-7e57-4fb4-b467-7552e4329fb1",
        "66d43e67-1bb8-4c65-9463-3e6823a1ac24",
        "bff842a4-6491-4434-a2bb-ab22c77542bb",
        "3a6b67c9-ea76-4d9b-8b21-6c034734a569",
        "aba9d9fc-7387-4ec9-ba11-ebfa5d28283c",
        "103822f9-45c4-4765-9acb-c8c88fc8184d",
        "a20528ea-f992-4ce3-bfc9-2ef9153955b1",
        "23e08023-8df7-4061-a71f-e6dc3e2b68a2",
        "89fde069-9745-4400-8f25-4d06433a5872",
        "dd91c51f-4eda-40e7-ab6c-1e4cf6e3bf8d",
        "f4d1967d-55e5-4fdd-b213-e586c9ec600f",
        "ed323196-e1c6-4901-88f4-d59401c0f4a3",
        "90b33440-4be4-4a4a-abf3-1a3ccc4db491",
        "5fb6ced3-df95-4360-b99a-5eff0c358b13",
        "b87baedd-496c-4f48-b13d-9fca565f86cd",
        "a0d465d2-9d5f-4a6d-b1fd-1fe7c7d4d108",
        "3c1a1333-7f2c-46bb-ba71-ddcc4ac53d87",
        "6e8c8bde-e475-4cc4-97f8-bd0de4feaadd",
        "85fd464c-9611-444d-bf61-40693cff7da7",
        "651e74f0-deca-42ea-bb35-c8796ad5858d",
        "36ca4ca4-3236-4239-8c79-ba1c652ba9e6",
        "68a81d83-5974-4267-aa1d-1ba86becb2e9",
        "0f5ccada-52d0-4606-b250-5b16e84caf12",
        "ed7b1957-2e66-4105-9b74-18550d6e6504",
        "ba0a36e7-8b52-4768-8ada-99e0aee9fc90",
        "23e65a78-1de3-44b4-a884-63b36d13f22d",
        "b36e48e5-083b-4cf7-8d71-80bbe8d42174",
        "77443add-647b-4eff-87c3-1f5aef266a1e",
        "b38e301d-7805-4398-a0a1-c2aad66058c1",
        "d3a9bbbe-3f87-4a93-b05d-bd95b3224b8e",
        "2e9b4158-49cc-4e56-9d31-0ddfa026391d",
        "140135ee-7461-477d-b826-14dfb1a4099a",
        "4e7887c0-b100-4de2-8cfa-9a78cd3df818",
        "e5e4f5ed-a3de-4bac-b1dc-77ea793c1e55",
        "32b91343-ff03-4761-b83f-30d502ed5930",
        "58eabe14-06be-4494-b057-dd508f04533f",
        "28633bca-483a-4d32-a3b0-6f592406d3c4",
        "23e3c3ae-25f8-4643-895b-7f5176332fbf",
        "de9cd106-5bdc-4c5e-8299-b3dca532f513",
        "9243b33c-2cff-439a-bdf6-4332f34ac379",
        "3bd0b490-2471-421a-9c0d-133aee2e4eb0",
        "951c33eb-5d56-4de1-bc8a-e5019a7761dd",
        "f258caf4-ef66-45c9-9f2d-cab5cb7a14fa",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "9cfa3831-66f1-4f33-afe0-c0b10fd0315c",
        "0940d6e5-f0d1-4ebc-b492-618b4a184660",
        "da4334d5-fa96-4e9a-98e5-bc6bab59ce75",
        "3c583aac-3e2d-4663-b285-b18d5406037b",
        "ec419f59-4eea-428b-823a-5ae4064c40b1",
        "6dda9b34-e854-4d08-874d-f44576b808ee",
        "ec419f59-4eea-428b-823a-5ae4064c40b1",
        "6dda9b34-e854-4d08-874d-f44576b808ee",
        "7db03c60-8db6-4492-9d55-9c3ccef2d580",
        "369dd3af-d515-406e-b954-e3318d3ad909",
        "075966f3-82f5-4707-89fc-64af9686ed72",
        "3e571a60-50ab-4ab0-b8e8-b45b29718b87",
        "de5a3ce8-7b22-471c-a7ee-f1f072be3b06",
        "7f14a4a8-7897-4d4a-96d5-ad26d9a8346d",
        "ccbb58e5-2ba0-425e-9979-d21c8f8c4da3",
        "2a01126e-2969-476c-a341-02469b2e9868",
        "9c2880fa-fa70-45e1-beab-8fd48b72bbd8",
        "da3318a0-f0e7-4d0a-be48-70fb18372309",
        "57a7fe17-9cc2-42bb-8a40-00b2f19adb01",
        "31d68743-b5b2-43e9-8b04-d5d67077caa2",
        "41188a4f-7ee5-4326-a1b7-d8f87de9eb21",
        "4d38040b-766e-4051-81a0-5c2a94fbc1f1",
        "5155ded8-9acd-4fd6-9fdd-93d8f8d5a641",
        "cc6898a5-2faf-4457-ab95-04eb42ddc69c",
        "77ca37b7-8f8b-4fc1-97d2-03feda73b96d",
        "e5060b05-f93f-4b9e-9830-3da87c6a0cbe",
        "23e23911-5e0e-4b9f-b017-6c30156ecdc0",
        "fe973efd-6aa6-43b1-89f2-a0619212fec2",
        "aea7dc4e-dc19-4cd7-8042-c3ed6e4d4e0d",
        "010ed1da-886a-47ae-a1fc-7bd10258b2cd",
        "71a459c6-626b-435f-ac00-300dc36c9b64",
        "84db7b4a-0b2c-40e4-87c7-c39558143c28",
        "3017d132-8e20-494d-961f-f97dea173621",
        "09719a8a-51db-479c-807a-a2f6e4d9af10",
        "4a9e46fb-0a26-42ff-b54f-b6ebfba565d6",
        "978a3209-b0d1-45d5-a760-925155818b8a",
        "8c055655-8c24-477e-a4c5-8c49955a904d",
        "05d7f20b-4d60-43fc-b0d4-c58e364e8c2a",
        "e71c6691-80e4-49f8-bcab-e64be0a8c1e0",
        "27c88784-6fa8-4d59-be96-f06576e46a3f",
        "467d8d25-f28f-4bf2-b9f5-9d7694248257",
        "1b8baf03-cc52-49fb-9384-0bfcfbb8ce67",
        "269f7cc6-ad8e-4609-a327-86b70a311d90"
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