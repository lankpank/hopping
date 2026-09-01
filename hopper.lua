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
local RIFT_NAME = "overlord-rift"
local RIFT_PATH = workspace.Rendered.Rifts
local RIFT_CHECK_DELAY = 1
local HOP_COOLDOWN = 10
local MAX_RETRY_ATTEMPTS = 10  -- How many servers to try before giving up
local AUTO_TELEPORT_TO_RIFT = true  -- Set to true to auto-teleport to rift when found
local TELEPORT_DELAY = 1  -- Seconds to wait before teleporting to rift

-- ============ PING CONFIGURATION ============
local PING_EVERYONE = true  -- Set to true to ping @everyone when rift is found

-- Webhooks
local w_main = "https://discord.com/api/webhooks/1443518513934237706/SYlpNc5bZqXECZAYf98HD5yjrIZqmsKhSyzTArormuUv_V5HAZWB7nv2yQxufw0ix4v7"
local w_notify = "https://discord.com/api/webhooks/1497653143981396051/y64QfolU0nyeIMaQfGhLOrOFRenDfrBSI15SGMYMy1iUNCQSubtpNf_QO-kL-5ThBiJg"

-- ============ SERVER LIST (Auto-updated) ============
local SERVER_LIST = {
        "93f6dff1-23d4-4919-86e7-1842f64ca6d3",
        "03d9fd49-81b0-4907-b97b-07be4e2aa42d",
        "3d486a77-ee61-4976-a9dc-a70ba16f51a4",
        "ab409e09-5e7c-4abf-84a4-fac90ea78120",
        "4e85b974-b6c0-416e-9ceb-686af9f1fa79",
        "d4209007-0f48-41c9-aad2-530fdc6a1b3f",
        "f636e1e4-53bf-4b50-891d-1b6e7aaeceb9",
        "b7916f15-b460-40a8-87e9-937f79a82261",
        "90486432-5ddb-4b9e-be27-c034e978d3da",
        "f3b78059-8e5d-407b-9901-4debbc0089ac",
        "ed1a1cf6-0585-4087-8622-c9873605cd3a",
        "e9ea0310-c682-40fe-b6b7-bb2c92e2158a",
        "15c23b85-6f0d-4058-80e6-88637e134113",
        "4549920d-d4e8-463c-bcf0-762c87b770cc",
        "17d3885e-e686-4990-8dab-16bdaaeb5834",
        "3c1416c8-1a34-474f-8371-aa0fbae8e75f",
        "397a3257-18e2-4ddd-9898-f4eeee94d16e",
        "1086c7d7-6f54-4d4f-869b-bf5a8fdbfa89",
        "a0890486-8fb4-46d9-b71e-9738de8cdcfe",
        "54682717-0f24-4064-ac5f-782a49de1c7b",
        "96ac76e8-4a7f-4f76-b559-8f686fa1c8e9",
        "2d4ec93b-2330-4a7b-98f3-cb0e7809ca94",
        "8f5a9241-0f53-45ca-8668-c62ead94bc9d",
        "0f54d71c-cc9c-4ced-940d-100ac9062b34",
        "8c82c088-6ce1-448f-8a79-0d46c19eb9c2",
        "7da9f4d8-17d0-4584-8b0d-706b40051ec0",
        "94f3b6c3-ff83-4a11-8672-9db596ce160b",
        "83476bbe-b939-4d8a-8841-4c77b46cd1d4",
        "f84f8957-c16f-4b1d-b2cc-ce62122d334a",
        "b76a56a6-d19c-4111-a175-e6f522d032d1",
        "9f8306e3-a8f9-41b2-801d-9139342299d9",
        "d5004d5d-c9f3-4345-aed9-6be9b6422460",
        "2145687e-ff36-43f6-b11c-1f95de46bab6",
        "e143bd69-5df3-4937-a61e-205569a2cf81",
        "841b789d-ddbe-4647-924c-449a1134a86f",
        "a3e55b94-fe56-475c-8714-69fb1d9ad54e",
        "4a9572a7-a039-4558-a265-8f89cfc123dc",
        "a35dc9b1-c25d-4ec1-946c-5434e73a9588",
        "9432ce2f-1fdc-4c95-a339-299cf1e15126",
        "24dc3d26-35cf-4285-8339-b1ab67d920ee",
        "3d889886-472e-47ab-8763-ddc9e4bf3428",
        "075d5695-fcbe-4b97-8cb2-0baec9fae492",
        "6e567e23-4ff7-4e17-9902-dfa960845fa6",
        "65d7789b-b6be-4b3a-aaa6-6e85fdfacc00",
        "d8c3ab5f-0443-492c-9913-651ca7f54e7c",
        "5cece415-5079-44c6-85f3-4c04d7a77e6d",
        "c8f6e48e-1719-41dc-9f45-c5a6a9ccdf95",
        "02164a48-f3ae-4d6e-8748-8e095f8e8951",
        "87e6051d-659e-4dae-af38-bcea937eddda",
        "4364358d-6e6d-4ec5-b58c-138f811cc599",
        "8de4727b-8e4e-45ae-a5b9-54fb5f5d777f",
        "3a0af9f9-4034-4f2f-933f-ec2e15933a5b",
        "b4e71bf5-095e-4ee6-a697-2e39bf4f5d65",
        "4aae80d2-521a-4369-a525-c10ca3db23bb",
        "4f06ab20-ce83-4c7d-b8f7-4680a3ddbddf",
        "3807d814-a623-4cfe-8740-e564ef7f46c7",
        "af2284ff-5a81-4220-881f-454aeaa9df3c",
        "be022d91-64c1-482c-8b99-2bb2236cbcf4",
        "d392ca79-2a84-4658-a326-b94dd13e55ef",
        "416599bd-ce66-4dea-bab9-c7990a85db1b",
        "2687ce3e-4dca-4c89-855b-d9cb9ccf5460",
        "a70475cd-b974-4eea-95fd-326ad20740f7",
        "65e16d1b-438c-4d53-a16f-4a13d2474606",
        "10c6aeca-5db1-454f-88bd-05ddb54f8b25",
        "8dbbc414-0cad-481d-bbf8-aa6872c6d868",
        "360a0f6f-0d26-4956-8a36-f1e3bb9d9b2a",
        "b687739d-2b0c-4c77-a08d-8a49d5aecd7b",
        "9406987a-a183-49fc-a2bd-842c395dbb70",
        "18f82a2c-0133-47cd-8b16-fed1bbd5ef77",
        "f2224066-4e72-4c98-8f81-c40284fcf724",
        "d1b69024-179f-4220-b542-d93f4f16e442",
        "9ae6a896-4810-42a6-9605-f104266bb29a",
        "fe5c6ffd-4a48-4b42-a01f-616a6b83c833",
        "5a9863ea-59c4-420b-b2af-0c946e03d895",
        "51059325-4ff9-47f8-8408-245147f40d97",
        "158a586d-8be3-4d23-a1a9-0d831c70e440",
        "01901833-9e9c-4eb5-8de3-1b2688f80404",
        "04824c92-697b-455a-9ef8-4737afc97cad",
        "21e27438-cea3-403a-9fe5-096c93d81be3",
        "51059325-4ff9-47f8-8408-245147f40d97",
        "158a586d-8be3-4d23-a1a9-0d831c70e440",
        "01901833-9e9c-4eb5-8de3-1b2688f80404",
        "04824c92-697b-455a-9ef8-4737afc97cad",
        "21e27438-cea3-403a-9fe5-096c93d81be3",
        "47e3cd86-d172-4402-a09a-5a811efe5fe9",
        "a5190ba7-4929-43ef-8889-ce0cce9bf422",
        "3ef9172b-0400-475e-8c26-e3f2f6017abe",
        "439c0350-af66-4c4a-bbd7-5df4c615ca96",
        "6ed84549-7e72-4195-84f2-3a42d3fc7ce4",
        "847cc440-f549-46e6-bd2a-48e914878374",
        "5c62620a-eb0d-448c-8ff2-0eac46fd17cd",
        "a9fb395e-4ae3-4830-8045-6314109cdbaf",
        "676aa8af-6353-4e42-9dd5-2ee280e9c177",
        "a861767a-81b1-4253-8c56-312cdfeacb8c",
        "75510973-14e3-42aa-bb32-9d457ce68cd1",
        "3d5476c8-ee82-4535-bb69-36e3e237543b",
        "ed7e74f6-1448-4831-80f6-02c07e273e6d",
        "69c34cb9-6ed6-438f-bb24-e5c65cae5ee3",
        "93e05920-343a-43aa-a2eb-9fa25bb1f5de",
        "f7172463-4034-496e-952b-601ff8e7844e",
        "73139df8-8e0d-4215-a7d6-0e83c559a775",
        "19d51001-7ea7-4e54-9984-d292005e489e",
        "d28b41dc-5c04-4a7b-8e1d-29d799dc3c55",
        "0f78229e-3ed5-4c88-9e06-9cddd9776e12",
        "2d5ca19c-2eb7-4de6-9984-dc62cdda1426",
        "8b47671a-9cfa-422a-b3e8-46acde34a831",
        "3ae858b6-5b3c-4164-9ed4-cb0c7d86ad86",
        "c544d5eb-64cb-4b32-bc4e-d32590936607",
        "07b7d293-6bd8-453f-8e6c-ea599ec5db4b",
        "11931de3-bc4a-4a06-a4be-d26f69bdad36",
        "e47a4d51-1933-41cb-85d3-bd1ed54121f0",
        "87ca4962-51a3-4230-8814-254f72718f7b",
        "872590b3-45a3-497c-bcec-b8abb38c65c1",
        "f300cddf-59f2-4b9a-b911-f762bf02b4a3",
        "01c7019a-3073-49d3-9185-93a24774779c",
        "8b8b2340-4e66-4c78-a497-1970498ea9a6",
        "d4fb506d-e9fb-4eff-8220-e4acd7f13799",
        "91cd03df-a675-4570-8583-f28808e8ceab",
        "c6d889b4-ae52-43c9-a816-e3f72acf6c62",
        "2d62df65-a4c7-4bf3-815d-f3e520b50918",
        "9728e540-957f-465d-a7bf-9f42f914466b",
        "3344b30c-cbac-4f15-8916-36a29e8a45f6",
        "f1f52d16-91e0-4d69-82f6-31fd112ce52d",
        "edb08474-0367-4d01-b619-6837de81bf78",
        "1ab86cfb-f842-40a0-84a3-ade88992089a",
        "7e4cefdf-cee2-4982-beb4-dc750893840e",
        "4a9572a7-a039-4558-a265-8f89cfc123dc",
        "529afa50-2fcc-4f8b-9bf7-00ed58dc5dc5",
        "4190e1e7-9b56-4452-8e12-951b4ad066fa",
        "03d17546-8d7d-4825-9dbf-a52191545e34",
        "3734d32f-159c-43ed-b40e-482059d9edfb",
        "83119e4c-ae09-4b5c-a731-68c3c3f8c010",
        "80973907-88b4-4929-b140-dbb8ce17566c",
        "6cdf61ab-8334-426e-b62c-27bea92f3574",
        "d9e52aaf-f251-4bcc-b358-93d90f0217cb",
        "27c7e9da-9653-4f3f-82cd-64ab762b06da",
        "e315cce7-b327-4db3-a112-afdd11b4279c",
        "bb3d75e1-e81c-4fe4-b695-459ed68b2851",
        "f3641b2c-3122-48b9-b6d4-bcf3df39e2aa",
        "a00be75d-825a-47fc-b282-bb297ded4891",
        "07a44b01-da24-463b-8f0e-502d17028a77",
        "3ca82c66-9bc2-4474-a9ad-8973f9e62ce7",
        "e548041b-21a5-4567-8166-dda90b17e538",
        "a990b383-ae60-4234-92f9-49da97d4d525",
        "7724b55c-a7ab-4fb9-87f1-df78f7703058",
        "1c2e8f8a-52db-47d5-9ffd-d7b6eb5d9c09",
        "afd04552-f964-4b84-9e04-8fad2486eabc",
        "4201f6d0-290c-4ae9-a96c-d166e4cd1205",
        "79145809-b1c9-4261-8191-02b6830fcf6e",
        "dfa655da-1514-4874-a5c8-2d48aab57059",
        "32133609-9003-4352-8810-d8fc38ebbbed",
        "b10473ab-87dd-4cbf-b148-aaa15c0c8acc",
        "228f2f5c-0cfb-4ba3-9f78-88b92b9cbaac",
        "21fdd67a-29e3-4536-b631-acae6c6486df",
        "a144afdc-447f-4973-b07c-ff23610f4014",
        "96c7c083-0575-4a06-9217-b77447ba82c9",
        "f2a43978-54a7-4bef-a640-714725eed225",
        "f6bc97ef-86b3-40b6-acf9-34f944f117fe"
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