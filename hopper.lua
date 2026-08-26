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
        "31d68743-b5b2-43e9-8b04-d5d67077caa2",
        "a3d7e849-cf90-4ba6-8c9b-bf282b030b9d",
        "454baeec-dab9-4dee-9366-e88f2a1b585a",
        "cf2ea244-7ac0-4692-bb6d-faf23b6653ef",
        "6e26c0d8-dc66-4f74-8b9e-16d80d8c2f17",
        "d50916c8-aaa1-4b4a-b373-b394939f647b",
        "918def96-a44c-493a-a1ac-914953d74335",
        "de9cd106-5bdc-4c5e-8299-b3dca532f513",
        "bc5dd4ce-5951-4af6-a7a7-fe821b1bca8f",
        "01340f1f-0ed3-4b74-ab5b-9606dd06746f",
        "103822f9-45c4-4765-9acb-c8c88fc8184d",
        "77ca37b7-8f8b-4fc1-97d2-03feda73b96d",
        "fe973efd-6aa6-43b1-89f2-a0619212fec2",
        "de902a48-ff93-45c2-b8d0-86e40dc74eba",
        "b38e301d-7805-4398-a0a1-c2aad66058c1",
        "de0268ea-b666-4f4a-9206-ebf146e5b889",
        "d2c1bcaa-325b-4cce-a92c-d2c4666bee68",
        "8525ce6f-8c4e-421d-978a-38ae135f1800",
        "8648fd9b-8a52-4a66-a7aa-272d95109e7c",
        "fda92c4d-24dc-41ff-90c1-003ffa70007e",
        "0ac688d7-b1a6-44f3-8b68-30a8274d3d59",
        "673e96ce-7327-4587-8ce8-c9567646153a",
        "d9ece429-3e8c-4961-a560-8a7ad09cfe29",
        "dff83023-ba4d-44b8-8a3e-15ffd65623c2",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "74fb9d52-86fd-4952-b688-945651799271",
        "0a14bea7-0f22-4b78-bdc4-754dd9c03aab",
        "083d3707-5175-421b-b6cb-72aea4ca956f",
        "dd2d8d22-3258-430a-9cd4-06f507f80175",
        "9734ed35-b44e-4497-8d88-2484c07216ce",
        "cc6898a5-2faf-4457-ab95-04eb42ddc69c",
        "7b284f47-8d78-4701-ba11-b01935455c47",
        "d8c78b70-71ea-4d0b-9bbf-8f56a4da1451",
        "099106d3-dd4d-4f78-99bd-1f201632cf24",
        "e9264b9d-66b6-4a1a-a5b4-7205271de1f0",
        "99e95aa2-7de5-48ec-86dd-a66d6b551658",
        "9f4201cb-eab1-43ae-aeec-78fbdceeeeaf",
        "73a061ac-9fa1-41bf-9419-6a5a952bc5d2",
        "6c9521ff-8467-43e9-9bbd-d19d294ec2d9",
        "31f9fe2a-484d-4d95-a5ea-b5b82072ae58",
        "6773d7e2-b9fd-4816-b672-5f9cf01ef06d",
        "00f649f6-e4da-4a85-b834-e08357eb0cd6",
        "369dd3af-d515-406e-b954-e3318d3ad909",
        "424a5f07-cb37-45ef-b04f-8bb2bd1a70aa",
        "0a9c0ab8-3d5e-47e5-a5a3-90498402184f",
        "78396fb3-39de-47e5-9cf5-5986fa7b9a40",
        "d6b0090f-fdae-4d11-895c-60cd2f1ed61d",
        "b37a1873-4fe0-4b84-822a-ec32825da1e6",
        "a30a7f23-237b-4c6d-90ff-8f92dc0f7889",
        "010ed1da-886a-47ae-a1fc-7bd10258b2cd",
        "76430fef-8484-44cc-83d3-cd812b32d357",
        "e5060b05-f93f-4b9e-9830-3da87c6a0cbe",
        "1a051ed9-de6d-457f-aea6-7d2943587ac6",
        "c2e136fd-9bd9-4b27-aee7-76da481a626b",
        "522fc802-ad74-42be-b2af-5fd68bb213e9",
        "4627034f-15bc-4a64-9172-bdb714aff044",
        "73b6f9ec-233e-495f-8112-6cc2884c5fdf",
        "dd91c51f-4eda-40e7-ab6c-1e4cf6e3bf8d",
        "25338a7c-8dd3-4a05-877f-736315c7cb2d",
        "9038acfb-9655-498d-ad0c-7b2aa830c614",
        "ff5c9a84-ac6c-4ef6-b505-088c97f62363",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "68b585f5-542d-455d-9a07-c0ed79de135d",
        "600fb98a-4921-459d-a75c-0d191d862698",
        "9c007528-f452-4717-89dd-ed7840ca2c88",
        "09984a05-b853-491e-9992-47c80ebe458a",
        "ba134714-7f03-4b5c-9391-050eb313e45a",
        "e61650e0-142c-4e87-a436-2cefda0f59f9",
        "b0a62ff9-9ccd-40d3-a8e1-2d6bc3d1b8c2",
        "23e08023-8df7-4061-a71f-e6dc3e2b68a2",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "1e7c5267-82dc-4373-8e29-795c875c845c",
        "00923830-983f-4b08-8cc7-bbf6f93eaa72",
        "66cdbffa-9030-46ba-8e0c-347b7bf6a870",
        "208fb869-139e-4d78-af9b-93d1b931433e",
        "3017d132-8e20-494d-961f-f97dea173621",
        "30e3c5fe-6647-441f-a60b-e7568bb66b87",
        "cc4c785c-ed6c-4d68-9f07-0e9caf0d99fc",
        "de27c55c-e5b1-4c82-b3ab-9b7f61154c35",
        "a6d703e0-e4f4-45dc-8ec0-bb497c8b77ae",
        "16f71c29-9f8f-4a11-9abe-57935c634f1c",
        "6047fb89-c22c-475e-99f4-c07b985d87f4",
        "2ad3e547-89e5-414f-a952-08e3e1ca1eb2",
        "d01bb84b-0e24-4373-9c1a-d5d52b517cfd",
        "231840ee-6eb2-44d7-ba03-1bb1de77eaef",
        "9ca6df12-56f7-4f6d-9fbe-f0ce239e081d",
        "17bc44ee-7fa8-4427-a54d-702be64f7138",
        "16f71c29-9f8f-4a11-9abe-57935c634f1c",
        "6047fb89-c22c-475e-99f4-c07b985d87f4",
        "c2e136fd-9bd9-4b27-aee7-76da481a626b",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "97f00e3b-6759-403c-b422-b084feae71d3",
        "ba134714-7f03-4b5c-9391-050eb313e45a",
        "c932cd99-2af5-4071-bd6b-b3e9cb9cde89",
        "8f285f16-da4e-4d12-b4ab-f42a598fd5cd",
        "3ce4751e-4cca-4a29-a670-c848ca170c94",
        "23e3c3ae-25f8-4643-895b-7f5176332fbf",
        "1784a8bc-d441-49e5-b595-fa4e4196a2cc",
        "38fe2542-0ba3-4b8e-8702-af673bec9744",
        "751e3085-2952-4d0e-8ff2-d5cfd38840e9",
        "d5bb3fb8-391d-4fad-a92d-dd91f0bb9434",
        "b1d02269-851a-4098-87fb-ab7513b1654b",
        "3d5e70e3-3aef-4c9a-8f4f-8f92e775e38d",
        "e348872b-10bf-4949-a90e-c09262e2c93b",
        "d17f1043-9a13-42a5-9403-1d6048e7b311",
        "60b7aeac-0573-46f9-94e3-53ed68bafe51",
        "b405b020-2eec-40d1-bd36-13f1125cd5b4",
        "f126389a-c9b4-4e27-bb5f-c8f5d9f01c32",
        "1eefd3b2-5bf9-413f-ad45-7a1005f58153",
        "ba0a36e7-8b52-4768-8ada-99e0aee9fc90",
        "61942080-53e2-4403-aecc-6d933809b60c",
        "d3e46824-7932-4344-b364-b02d9631f5cb",
        "3bf98ecb-5b87-4bfa-bdba-8098afd1b155",
        "82718d74-4159-4b98-a607-6e2496deb997",
        "325c719d-a1e8-4426-8c3a-5eef71c58861",
        "abbaa04b-c729-4c99-bd45-bade76ad25ee",
        "e7c557e1-4ffc-4620-9c16-6ab175f8536c",
        "5be26d69-8356-4f91-8060-0961ee0910a5",
        "3c1a1333-7f2c-46bb-ba71-ddcc4ac53d87",
        "c4df8df7-5820-4fed-b699-8c81cb19d137",
        "2387e84b-49af-4a0a-862e-e690955ac222",
        "aba9d9fc-7387-4ec9-ba11-ebfa5d28283c",
        "269f7cc6-ad8e-4609-a327-86b70a311d90",
        "812ec8c8-bf2a-464a-9ed6-95d61ad3fffe",
        "cf292957-822f-497a-b149-ccc74af6b0fe",
        "9c01e108-431c-43e4-84e4-28e8b0145c05",
        "d1d34310-9cc8-4833-80a6-f085be9584af"
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