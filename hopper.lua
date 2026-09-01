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
local MAX_PLAYER_COUNT = 10
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
        "907c112f-3823-4818-8b57-855e9013b1c8",
        "b9ca9af1-ad7e-4fcb-accf-4eaa692aa292",
        "d570726c-4974-4b6b-af80-c672c7ab8ad2",
        "edb08474-0367-4d01-b619-6837de81bf78",
        "3d486a77-ee61-4976-a9dc-a70ba16f51a4",
        "4190e1e7-9b56-4452-8e12-951b4ad066fa",
        "a5190ba7-4929-43ef-8889-ce0cce9bf422",
        "b7916f15-b460-40a8-87e9-937f79a82261",
        "d1b69024-179f-4220-b542-d93f4f16e442",
        "a6c5aca5-5c7f-4d21-9e55-ea507664fe0a",
        "18f82a2c-0133-47cd-8b16-fed1bbd5ef77",
        "69c34cb9-6ed6-438f-bb24-e5c65cae5ee3",
        "f2224066-4e72-4c98-8f81-c40284fcf724",
        "83476bbe-b939-4d8a-8841-4c77b46cd1d4",
        "0f78229e-3ed5-4c88-9e06-9cddd9776e12",
        "8b47671a-9cfa-422a-b3e8-46acde34a831",
        "d28b41dc-5c04-4a7b-8e1d-29d799dc3c55",
        "e72e070b-7e19-4471-8e21-838a259ba6f1",
        "8dbbc414-0cad-481d-bbf8-aa6872c6d868",
        "f300cddf-59f2-4b9a-b911-f762bf02b4a3",
        "1ab86cfb-f842-40a0-84a3-ade88992089a",
        "2d62df65-a4c7-4bf3-815d-f3e520b50918",
        "529b97ee-22e9-4363-a7bd-27c9418a30fb",
        "a8c91ba2-1118-467d-8d4e-4889c9fbc5ee",
        "9728e540-957f-465d-a7bf-9f42f914466b",
        "af2284ff-5a81-4220-881f-454aeaa9df3c",
        "51059325-4ff9-47f8-8408-245147f40d97",
        "15c23b85-6f0d-4058-80e6-88637e134113",
        "360a0f6f-0d26-4956-8a36-f1e3bb9d9b2a",
        "3ef9172b-0400-475e-8c26-e3f2f6017abe",
        "e315cce7-b327-4db3-a112-afdd11b4279c",
        "f7172463-4034-496e-952b-601ff8e7844e",
        "94f3b6c3-ff83-4a11-8672-9db596ce160b",
        "439c0350-af66-4c4a-bbd7-5df4c615ca96",
        "21e27438-cea3-403a-9fe5-096c93d81be3",
        "04824c92-697b-455a-9ef8-4737afc97cad",
        "416599bd-ce66-4dea-bab9-c7990a85db1b",
        "e47a4d51-1933-41cb-85d3-bd1ed54121f0",
        "a4a94edc-2097-4a56-8c76-fc4b8a69f261",
        "17d3885e-e686-4990-8dab-16bdaaeb5834",
        "bf479790-0d7f-495f-a2c5-653dd247c976",
        "27c7e9da-9653-4f3f-82cd-64ab762b06da",
        "82b4e56e-efba-4202-8058-ec774a441a5b",
        "87e6051d-659e-4dae-af38-bcea937eddda",
        "fe5c6ffd-4a48-4b42-a01f-616a6b83c833",
        "872590b3-45a3-497c-bcec-b8abb38c65c1",
        "676aa8af-6353-4e42-9dd5-2ee280e9c177",
        "8c82c088-6ce1-448f-8a79-0d46c19eb9c2",
        "ed1a1cf6-0585-4087-8622-c9873605cd3a",
        "454df5f2-bf1d-4e8a-add2-f9765266d9cc",
        "a35dc9b1-c25d-4ec1-946c-5434e73a9588",
        "ed7e74f6-1448-4831-80f6-02c07e273e6d",
        "0f54d71c-cc9c-4ced-940d-100ac9062b34",
        "8f5a9241-0f53-45ca-8668-c62ead94bc9d",
        "a00be75d-825a-47fc-b282-bb297ded4891",
        "e143bd69-5df3-4937-a61e-205569a2cf81",
        "b4e71bf5-095e-4ee6-a697-2e39bf4f5d65",
        "93e05920-343a-43aa-a2eb-9fa25bb1f5de",
        "bb9919ed-35a0-426f-aedc-f28f786852a9",
        "3d5476c8-ee82-4535-bb69-36e3e237543b",
        "31cfd11d-64a3-497d-94f6-cad9a700d71b",
        "6c80e228-edb4-487c-86c5-b7cadb6f0dae",
        "1c2e8f8a-52db-47d5-9ffd-d7b6eb5d9c09",
        "0a0624f5-d82d-450c-b9e4-00be73c728b4",
        "f84f8957-c16f-4b1d-b2cc-ce62122d334a",
        "3ae858b6-5b3c-4164-9ed4-cb0c7d86ad86",
        "c544d5eb-64cb-4b32-bc4e-d32590936607",
        "f33420a1-80c9-48a5-9051-e7b4e00b8663",
        "f86bd3de-1907-4df0-9dd4-a3131f09bad5",
        "d4209007-0f48-41c9-aad2-530fdc6a1b3f",
        "07b7d293-6bd8-453f-8e6c-ea599ec5db4b",
        "3344b30c-cbac-4f15-8916-36a29e8a45f6",
        "11931de3-bc4a-4a06-a4be-d26f69bdad36",
        "d4209007-0f48-41c9-aad2-530fdc6a1b3f",
        "07b7d293-6bd8-453f-8e6c-ea599ec5db4b",
        "3344b30c-cbac-4f15-8916-36a29e8a45f6",
        "11931de3-bc4a-4a06-a4be-d26f69bdad36",
        "8b8b2340-4e66-4c78-a497-1970498ea9a6",
        "01c7019a-3073-49d3-9185-93a24774779c",
        "b76a56a6-d19c-4111-a175-e6f522d032d1",
        "87ca4962-51a3-4230-8814-254f72718f7b",
        "4364358d-6e6d-4ec5-b58c-138f811cc599",
        "c8f9f86e-5a6a-4996-bc79-3a48326a1124",
        "397a3257-18e2-4ddd-9898-f4eeee94d16e",
        "d4fb506d-e9fb-4eff-8220-e4acd7f13799",
        "d8c3ab5f-0443-492c-9913-651ca7f54e7c",
        "7da9f4d8-17d0-4584-8b0d-706b40051ec0",
        "c6d889b4-ae52-43c9-a816-e3f72acf6c62",
        "91cd03df-a675-4570-8583-f28808e8ceab",
        "07a44b01-da24-463b-8f0e-502d17028a77",
        "3a0af9f9-4034-4f2f-933f-ec2e15933a5b",
        "e77f01f1-c9e2-4afb-8a2c-a1c06b72045f",
        "9432ce2f-1fdc-4c95-a339-299cf1e15126",
        "e9ea0310-c682-40fe-b6b7-bb2c92e2158a",
        "f80b5433-a658-4da5-962c-b4e74ad6f4c2",
        "9f8306e3-a8f9-41b2-801d-9139342299d9",
        "24dc3d26-35cf-4285-8339-b1ab67d920ee",
        "afd04552-f964-4b84-9e04-8fad2486eabc",
        "3ca82c66-9bc2-4474-a9ad-8973f9e62ce7",
        "e548041b-21a5-4567-8166-dda90b17e538",
        "4549920d-d4e8-463c-bcf0-762c87b770cc",
        "841b789d-ddbe-4647-924c-449a1134a86f",
        "420ccebf-2e64-4dbe-b0e9-6f2fde46e97d",
        "4a9572a7-a039-4558-a265-8f89cfc123dc",
        "53d575fc-9a53-4162-9bde-6d62d7b096e0",
        "5f5e818e-283c-4ae8-8a2a-1989741a0f0a",
        "75510973-14e3-42aa-bb32-9d457ce68cd1",
        "075d5695-fcbe-4b97-8cb2-0baec9fae492",
        "d392ca79-2a84-4658-a326-b94dd13e55ef",
        "03d9fd49-81b0-4907-b97b-07be4e2aa42d",
        "8de4727b-8e4e-45ae-a5b9-54fb5f5d777f",
        "c8f6e48e-1719-41dc-9f45-c5a6a9ccdf95",
        "73139df8-8e0d-4215-a7d6-0e83c559a775",
        "ef968daa-5cc2-42ac-9bfe-116eab9f90d4",
        "9406987a-a183-49fc-a2bd-842c395dbb70",
        "a9fb395e-4ae3-4830-8045-6314109cdbaf",
        "b07e7223-bbc2-46d7-804c-ebf0eb17fe9f",
        "83119e4c-ae09-4b5c-a731-68c3c3f8c010",
        "54682717-0f24-4064-ac5f-782a49de1c7b",
        "847cc440-f549-46e6-bd2a-48e914878374",
        "a70475cd-b974-4eea-95fd-326ad20740f7",
        "10c6aeca-5db1-454f-88bd-05ddb54f8b25",
        "6cdf61ab-8334-426e-b62c-27bea92f3574",
        "a990b383-ae60-4234-92f9-49da97d4d525",
        "65e16d1b-438c-4d53-a16f-4a13d2474606",
        "eaac9c58-a03b-432c-b3ad-d105df05a047",
        "7724b55c-a7ab-4fb9-87f1-df78f7703058",
        "4e85b974-b6c0-416e-9ceb-686af9f1fa79",
        "6ed84549-7e72-4195-84f2-3a42d3fc7ce4",
        "d969e5be-d9e7-4459-9b7d-08a4f20307a7",
        "2687ce3e-4dca-4c89-855b-d9cb9ccf5460",
        "fbf91b1c-4f43-4367-accc-2c53da229e50",
        "f3b78059-8e5d-407b-9901-4debbc0089ac",
        "676496d6-f847-4f77-9a70-4210114eac34",
        "a3e55b94-fe56-475c-8714-69fb1d9ad54e",
        "90486432-5ddb-4b9e-be27-c034e978d3da",
        "6e567e23-4ff7-4e17-9902-dfa960845fa6",
        "5c62620a-eb0d-448c-8ff2-0eac46fd17cd",
        "f3641b2c-3122-48b9-b6d4-bcf3df39e2aa",
        "3d889886-472e-47ab-8763-ddc9e4bf3428",
        "5a9863ea-59c4-420b-b2af-0c946e03d895",
        "dfa655da-1514-4874-a5c8-2d48aab57059",
        "4201f6d0-290c-4ae9-a96c-d166e4cd1205",
        "529afa50-2fcc-4f8b-9bf7-00ed58dc5dc5",
        "f2a43978-54a7-4bef-a640-714725eed225",
        "32133609-9003-4352-8810-d8fc38ebbbed",
        "d9e52aaf-f251-4bcc-b358-93d90f0217cb",
        "a0890486-8fb4-46d9-b71e-9738de8cdcfe",
        "f636e1e4-53bf-4b50-891d-1b6e7aaeceb9",
        "96c7c083-0575-4a06-9217-b77447ba82c9",
        "b687739d-2b0c-4c77-a08d-8a49d5aecd7b",
        "01901833-9e9c-4eb5-8de3-1b2688f80404",
        "228f2f5c-0cfb-4ba3-9f78-88b92b9cbaac",
        "21fdd67a-29e3-4536-b631-acae6c6486df",
        "bb3d75e1-e81c-4fe4-b695-459ed68b2851",
        "52ab793a-6a7c-4eab-9ebe-1b1cea426839",
        "4f06ab20-ce83-4c7d-b8f7-4680a3ddbddf",
        "84b20ede-dae3-415c-9194-e6639b6667ba"
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