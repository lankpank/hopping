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
        "6e7c28d3-ebe2-4404-a566-e4ec8150e7ff",
        "4627034f-15bc-4a64-9172-bdb714aff044",
        "93483ee1-a0e3-4ad9-9ca0-fb7446567da5",
        "16f71c29-9f8f-4a11-9abe-57935c634f1c",
        "42143cb2-c28a-4730-96de-c06c8b1a7c9e",
        "8652b1d0-1036-40ae-9fc0-2faa77089839",
        "3839bbbb-f3ac-4d7a-873b-7cb85218c90f",
        "6ff181ad-af49-4055-8b0e-92688d481691",
        "f9402e86-8301-4ce4-bcba-dad95ad02360",
        "1b10e5aa-2561-415a-a22f-05a366c5f565",
        "9a860ac9-5a3e-4e2a-af6e-4abd8241bcd6",
        "45f9f66b-129e-4e0d-98fe-c161ac051fbf",
        "f21f1c91-e519-4616-8243-21552eb61743",
        "3eeabb13-2532-4f48-bb13-c2142aea78b9",
        "1fe80b67-b1d6-4d5b-9d3b-ad21fa968e92",
        "f7aa76e3-b1c3-4d50-b9bc-d9c413447d75",
        "708530cd-1191-406b-a1b1-8181da880a15",
        "a0759bb1-75b0-4e10-bdb2-c2eb1914d046",
        "4e7172e5-0593-4410-a24d-b1d0d704e1d0",
        "1e7c5267-82dc-4373-8e29-795c875c845c",
        "20bd41b0-540e-448f-927a-797d702cd2e4",
        "5ee17386-8284-460e-b852-a0d7433c2fe2",
        "ad333901-82e8-460f-81e2-33eaa2190bf8",
        "c945cbf2-1bd6-499e-8d41-f70cdb76eb4c",
        "cb0a99b1-629c-4e81-a8c3-5db683e7f1da",
        "cc95fd5f-04a6-4b00-9b56-30fe2ef54b32",
        "247a6ee0-12ff-44e3-9e5d-73fce80b82e0",
        "37ff93ec-71bb-4d23-bb9e-609f6d8f9d23",
        "a9b1e001-35dc-4572-9f38-9deac319ab65",
        "c1fe7705-9340-45b4-aa49-47c84b7b069c",
        "3f239469-0470-408d-8710-51a69ab8df2c",
        "709bffcb-f81a-4bd1-a19c-fd2134e58ef2",
        "d0aabbca-5c01-4368-954e-853f34729329",
        "acf00e4c-54b8-497f-95b4-cd9b216f2313",
        "d96870b5-e2a6-4f6e-9626-680be69d05d1",
        "4d387f8e-d7c1-470f-a945-5b06a6a3494f",
        "87bdf396-464e-4364-9893-8f8a2d93196a",
        "572d445a-23d4-485c-8c3e-ddc8c9380f24",
        "da53c8bd-4c55-4e36-9de5-3ac81ff92dc4",
        "2c17df4a-1304-40e7-a76c-3ce552a05733",
        "41f92d5a-a3d4-4aa9-a60c-717bbfe082f3",
        "e393fdc8-3152-49e3-8fef-79a6cc44cd97",
        "c7b56313-92ec-494f-85da-f6ec18d26e20",
        "2904e33d-f3da-4daf-ba0f-de6e290b640a",
        "61385522-008d-4f60-86a1-fe4f1f754cd0",
        "3106de3f-3918-4ef6-be29-6703af44d2e7",
        "e02b0262-6007-4f59-ace8-1c3d9144247e",
        "2f837717-64e4-4fe9-9ca0-1fdd3571dc54",
        "6bbf7f3c-81f8-43d7-87d2-621bd164ef2f",
        "02b6f2e8-ee0b-4008-a20f-e6dc37784bf3",
        "13c4dafb-4f1f-4e5c-8c04-342d36847578",
        "c3493118-3036-4e93-b008-3d030369f257",
        "e70cf622-64a1-4d6c-9f3c-341f25063cf9",
        "d3a007b4-186b-47bb-9692-da72b761b513",
        "02fdbb35-8b99-4455-956f-edb7db71fbc3",
        "64cfd8e2-30eb-413d-bd80-12fbf76a198f",
        "0cb7454f-bc17-4632-be64-991d53a4bcb4",
        "4bf6eb33-6252-44dd-98d5-94d30f8662a3",
        "2b87596b-ad69-4270-aa8d-25b14f3bef0f",
        "111e9988-b4fa-4a4a-85a6-ea2c59f8d4d5",
        "f7d4d610-4920-4bd3-b88b-fd29c406bea3",
        "9c01e108-431c-43e4-84e4-28e8b0145c05",
        "e4aea852-af21-403f-a4f4-19a178f6e80a",
        "be8ce74c-c425-4ea6-bf58-706396a8b22e",
        "ffa14747-f048-4cfe-98ad-4cc75e52ce3f",
        "4da88e64-755d-4bbe-ab9a-0ef209909153",
        "3429191d-230b-4c13-82d8-cae0a4ca8b5c",
        "9aac80a6-b90c-45c5-8146-33d8237b2908",
        "d18d612c-a2a0-4552-8df1-f6390ae621cf",
        "062957bf-fb1e-4200-a104-c197fd6604ad",
        "2ec60582-1c43-4249-b522-8d917c345647",
        "70f77962-f7ad-466a-a54d-b05212c77d29",
        "4a7a1232-e3c4-4a6f-ad73-4c827d8259ea",
        "6fd42850-bad6-4751-9e8d-477b2e5c517b",
        "128ca89f-dc33-46cb-9b73-720fbb3e35be",
        "4f4ca2eb-371c-4607-9b06-33cde1ffa51b",
        "0e612eb9-ef3a-4e75-bb2b-853234b1786b",
        "57ecc719-ef4f-4b3f-a72b-26ee3cd08512",
        "d1d34310-9cc8-4833-80a6-f085be9584af",
        "3fb02a8b-2e36-481c-9d44-e62ddae907eb",
        "0ab474de-332b-40c9-bfb0-1893613ec7a2",
        "d2a5fc13-a80e-41c3-9d76-51293de76704",
        "60b3673a-f1cb-485a-b558-1c106ae70db7",
        "511056cc-df3c-4c9c-91eb-003f3c8d696e",
        "61942080-53e2-4403-aecc-6d933809b60c",
        "dba470aa-e0d0-4aa8-9a2d-cefc9b319b51",
        "28b9de14-15b6-4e20-8f65-72b608ee683e",
        "d17f1043-9a13-42a5-9403-1d6048e7b311",
        "cd00544f-68c5-46ca-9c36-c29bc16041e5",
        "6047fb89-c22c-475e-99f4-c07b985d87f4",
        "3bf98ecb-5b87-4bfa-bdba-8098afd1b155",
        "c8823649-3c23-44e2-b999-266ae463ea84",
        "c8823649-3c23-44e2-b999-266ae463ea84",
        "cb111473-bfd1-4894-a476-23a2c68c28b1",
        "de0268ea-b666-4f4a-9206-ebf146e5b889",
        "68f9522c-4729-49b2-8e28-3815518a968a",
        "7b284f47-8d78-4701-ba11-b01935455c47",
        "60b7aeac-0573-46f9-94e3-53ed68bafe51",
        "f54453a7-c7f4-48ee-b3bc-ef2081a64bb2",
        "fda92c4d-24dc-41ff-90c1-003ffa70007e",
        "a064ada1-f18e-4e64-b949-027dafe3731d",
        "269f7cc6-ad8e-4609-a327-86b70a311d90",
        "db702f3d-53e3-4c9b-acdd-aefb5950d275",
        "4f465b69-d66b-468d-9734-e978a54adc4f",
        "848b24dd-1df3-4f97-bd94-5b992779c877",
        "826a1723-e998-4c80-bae1-1df169a0e1b1",
        "95c1fed6-8a1f-48ff-8fd1-52e97ba33e63",
        "ca0349a9-2bd0-4188-9bdf-2be0ab1e97a2",
        "a536fed2-1fc7-43e0-a528-5a1891ca397a",
        "31f9fe2a-484d-4d95-a5ea-b5b82072ae58",
        "ca6c4d87-8906-4bf7-a657-35516fab138f",
        "68b585f5-542d-455d-9a07-c0ed79de135d",
        "00fa2dbf-41b6-438e-aa9c-a48a100d753d",
        "f1a7d9c1-6c61-4f4b-bf9d-62948d257e9e",
        "97f00e3b-6759-403c-b422-b084feae71d3",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "bcbfa6ac-b5aa-4392-9e6c-9a36142cd336",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "20877588-26f1-48c7-827d-ea2689d4cff3",
        "0a14bea7-0f22-4b78-bdc4-754dd9c03aab",
        "09984a05-b853-491e-9992-47c80ebe458a",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "a2e80080-a914-4ce0-83c3-7098d2e1ee3d",
        "93d5f473-0906-4af2-b8d2-e2af450f98df",
        "9f883f90-549a-4205-9fc4-846592a97f41",
        "9f4201cb-eab1-43ae-aeec-78fbdceeeeaf",
        "0298638d-b859-48e4-a3c6-10998aa0402f",
        "ae67c987-0cb7-4545-90fb-78fa1a1e6443",
        "6e26c0d8-dc66-4f74-8b9e-16d80d8c2f17",
        "ba134714-7f03-4b5c-9391-050eb313e45a",
        "0a9c0ab8-3d5e-47e5-a5a3-90498402184f",
        "78396fb3-39de-47e5-9cf5-5986fa7b9a40",
        "ff5c9a84-ac6c-4ef6-b505-088c97f62363",
        "cb0b6afc-85ef-4a4f-b5e8-405a0b9c47ef"
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