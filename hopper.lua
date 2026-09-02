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
        "31789507-ad4a-48a6-8d02-dcfe5cda3fa0",
        "3bfc8115-1088-4683-8d35-028f29462995",
        "e7b05c61-9667-4e40-bdbd-f7e4c71e1229",
        "fbf91b1c-4f43-4367-accc-2c53da229e50",
        "3ba886d8-6132-49a7-a887-4a848aaf9432",
        "8845fe18-1ee3-48f6-be39-e671c2ea2a84",
        "ebfdb89f-a158-4ba8-b72c-9cf4bcb50eda",
        "e6f83587-d3ab-4e4b-808d-df61270df96e",
        "cac85aaa-280c-4e4e-bc7b-21969d0d75f7",
        "e4b02f6c-8cc1-482d-828e-faaf3b8f95a4",
        "f0b2b135-e68b-4c1d-a29c-413b93dd7cdb",
        "5ca57de7-b40d-4df2-b376-b17c1e9931d3",
        "ba8835a0-21bd-400e-ba3e-c1aee0f8b0b3",
        "a785e00f-e619-4979-90c0-023d53f438d1",
        "3766a668-670d-4f42-9318-01d71c9ce1d9",
        "99a61b91-a10c-4c3b-b96a-ff52f1612144",
        "f84f8957-c16f-4b1d-b2cc-ce62122d334a",
        "1e395894-e66b-457e-9d2a-fce4090560da",
        "f2882e57-8bb8-4a5d-8dff-a75fe7340c36",
        "2687ce3e-4dca-4c89-855b-d9cb9ccf5460",
        "1e76eb36-b946-46df-aac7-1b283850ab92",
        "fe1d9134-18dc-464a-a35b-5affddf5af9b",
        "7d27757e-8ec6-4f7a-9d6f-fbbbe9abe9e3",
        "98b3231d-5e82-4b3f-b874-30a048ee34fd",
        "a8d19aa3-ddfc-499a-ac82-78f95ae38867",
        "84296baf-87fd-4c9f-b03e-24e5bc83e7ad",
        "af63b930-7685-4a6a-af2c-3daa077b7c75",
        "1d7977e0-d3af-4b87-b177-8cc68d4dc7ec",
        "53d575fc-9a53-4162-9bde-6d62d7b096e0",
        "c44f4da2-6af3-46b5-bfd0-8f2b0f6ca631",
        "e33b55ab-46a6-4113-959f-df0401dcffd5",
        "44ee7b71-67af-4e59-ad6f-70675bb8e997",
        "edb91230-b873-465d-b1f0-672c14570301",
        "c16f2741-1a76-459c-b733-54187e35a796",
        "d8b90f69-0629-4442-b08a-c7bb482beea4",
        "d8c3ab5f-0443-492c-9913-651ca7f54e7c",
        "49dd8413-da82-446d-9ea7-7c5dd6f89878",
        "698d5a08-92b5-451b-8283-1c91194d7f8e",
        "81126c89-b3ee-4c95-ba2b-03f6d15d533f",
        "d51237d3-9a53-4849-a0ee-e7f6f09d30b5",
        "470eb756-13a1-4afb-a6d3-9acec4eb4dcc",
        "f2cadf97-0abf-4d45-b7da-3ae5bd74f4be",
        "f0029600-7223-4af1-a867-e5d983be20a5",
        "341d505c-c05f-4c8f-8e7f-006a4926043f",
        "01fef4d9-1b86-47c2-9a4a-6d4864f6e3cf",
        "31cfd11d-64a3-497d-94f6-cad9a700d71b",
        "bee3260d-451c-4896-abae-2569cbf00401",
        "e47a4d51-1933-41cb-85d3-bd1ed54121f0",
        "8049469a-275b-49f7-b884-88d92f4147a1",
        "3388582f-98b2-469a-8b58-ec6fb5489a29",
        "05e11fc6-1242-45ba-bdae-2d2e6478f7a2",
        "c4229334-9f1c-4a97-aee5-3f9a4dca8469",
        "07b487bf-8a29-4f6c-8dac-7175e785d55f",
        "f6be94f5-52f2-47e7-9471-dba0346b9edf",
        "190897b3-a19a-4f58-ab5e-169d85ed885c",
        "7c17783c-c847-40e4-8f4c-cea6fb60cbb9",
        "ec8194e5-05f7-4846-bc5c-e682071bbadb",
        "7c903bda-9e34-475a-8275-31980b0168f5",
        "c7d53b2d-6825-413a-99e6-3f81a173d9bb",
        "0a0624f5-d82d-450c-b9e4-00be73c728b4",
        "250f245a-a06e-404e-827a-ba8971e2fb62",
        "360a0f6f-0d26-4956-8a36-f1e3bb9d9b2a",
        "9a070e4f-41a0-40c6-8719-f2c557d19011",
        "006ac152-3c77-440e-86a6-80724df11dd3",
        "d781a18c-d635-47da-b0dc-93bbc98a7bae",
        "e72e070b-7e19-4471-8e21-838a259ba6f1",
        "9451dce9-15a1-4ad5-95fd-aa5d39851180",
        "298a3013-d4bf-41ec-a4ec-7de2a3879d72",
        "16ef4ad4-3b14-48b8-826d-e0e2bd794c46",
        "85b43bc4-f945-47c4-864b-7a58a0ecc06f",
        "03b18ea9-aa0d-46ba-8072-a286c1a47f41",
        "60d7592d-3649-4ffd-8c76-9354aa4c3f72",
        "b681f530-78b6-4cd1-a011-27035ed572a1",
        "dce0282d-5f1c-4595-99d5-e10dbfd143de",
        "4b1cd157-6e8e-4d8a-b376-7fa0a9dfbce3",
        "f85a56cf-a7fe-45f3-b6ce-51faac630f89",
        "691aaad0-ec89-4f07-934a-502ef5ae4e53",
        "9f469f81-9dfa-4397-a6cb-545fec9a2e85",
        "f85a56cf-a7fe-45f3-b6ce-51faac630f89",
        "691aaad0-ec89-4f07-934a-502ef5ae4e53",
        "9f469f81-9dfa-4397-a6cb-545fec9a2e85",
        "be022d91-64c1-482c-8b99-2bb2236cbcf4",
        "74fc04a0-c101-4adf-b549-87d3461c05a5",
        "e91f5788-49d3-40dd-a963-887dbcd67894",
        "ae644a5f-1051-4772-9368-e1af79ad4ae9",
        "38f9526a-723b-44c7-9756-cb89e69fc838",
        "b26310f4-5faa-4c33-9352-3a61678bbbab",
        "6c80e228-edb4-487c-86c5-b7cadb6f0dae",
        "b5f3f436-fb9e-4e15-af1a-d266141a5aa8",
        "5f399607-ec7b-48a0-a533-e56b8eba9737",
        "841b789d-ddbe-4647-924c-449a1134a86f",
        "ae404058-42b6-4391-a5a6-1277348b8843",
        "0b718c14-9f23-47f9-8002-f9573223b0c8",
        "e11675b2-42c2-4840-ba0a-3ce39959d78b",
        "169b2c52-7afb-4493-96d6-770f315f6dce",
        "599183ff-9a06-488d-9e5c-eba6ffa677d4",
        "c6d889b4-ae52-43c9-a816-e3f72acf6c62",
        "49e0cee7-7ef9-4d7e-be48-478168d100fb",
        "1e2a80c5-5b1b-49cf-bfff-5ea38a93e3da",
        "8885f2a1-86ca-4939-b948-6d309db9f1ed",
        "b93f75ed-a0e5-4a12-a33f-027c527272fa",
        "9ca25f85-f101-4eb2-b028-0a82ee2d93fb",
        "295ce3ca-d156-4ab2-bb0c-626ac49b706a",
        "2253662a-f9eb-4f41-bda2-3e3f16b9f199",
        "0246968b-c9f5-4b9c-9c16-ee897c8d8d37",
        "14d95014-994e-4215-b90e-6d746258e708",
        "30b30999-8018-4e4f-8316-040beb1528a9",
        "7f8a81d2-da73-41a8-b4c8-4f892548aadd",
        "527a617d-d464-4d33-af5c-55ae24f8edec",
        "69c32a5c-aaae-4632-ad4c-1996b48f834f",
        "df6dac54-28b0-4f08-a48d-b272090517b6",
        "1c257f49-bda8-47f9-b3ed-7b5cad16270e",
        "0886a8e9-9f52-4e98-b7e4-23002a849973",
        "ec3597e0-29c9-43c6-baa2-d87b401826e2",
        "f7be9bcd-25a4-45dd-bf8b-6031a48dc2dc",
        "34150516-dd01-4f8d-91be-021f83249627",
        "00ea0e0f-ce35-46a5-a2a3-ecf68f9cf6f9",
        "27ac77e9-b482-407b-8844-83d0657f0f22",
        "070a2598-3706-4313-be3c-6aec7fef1302",
        "d7f84879-3232-41d8-93fc-e9e7a5665ab4",
        "fc580307-f184-4755-9865-5288e09326ba",
        "ee5017a4-d2ae-48ac-a0c3-a746cb96d63f",
        "f279b58d-6c48-4342-ab5e-d9c13f7f7f01",
        "4b97adbe-424a-45e2-8ff1-6086737e7ed2",
        "6292d7b1-bfa8-46f1-991b-66db15a807c2",
        "91cd03df-a675-4570-8583-f28808e8ceab",
        "59efe5ee-1999-45af-a03e-d52d01c0b92d",
        "6413ad73-6de7-442c-9bf7-ddd5f7f01928",
        "fa39a066-eac2-4b66-8d47-d37566e45d09",
        "cd0dfa89-b119-4ee0-b25b-e7a94bdc82f5",
        "2d4ec93b-2330-4a7b-98f3-cb0e7809ca94",
        "5e140cb2-7389-4bf7-bde7-282baab24cff",
        "97f1ab86-bcf4-48de-920b-3b233a9a0286",
        "362e3bdf-5a58-4a6b-b317-fcf4fa9b6cb1",
        "d6d48df2-bf8f-4eac-bb85-b9eaa8cf9c18",
        "cf966cc4-8e9c-4036-ae40-170e2a5e8031",
        "e644505c-96e7-4e69-bc74-5ae164425b71",
        "f3641b2c-3122-48b9-b6d4-bcf3df39e2aa",
        "1ab86cfb-f842-40a0-84a3-ade88992089a",
        "2bd38b4c-4d7e-4125-bc72-59893cdafeda",
        "52ab793a-6a7c-4eab-9ebe-1b1cea426839",
        "a35dc9b1-c25d-4ec1-946c-5434e73a9588",
        "158a586d-8be3-4d23-a1a9-0d831c70e440",
        "1086c7d7-6f54-4d4f-869b-bf5a8fdbfa89",
        "9f0c7f36-164c-430d-9d45-06b34c4cb134",
        "87e6051d-659e-4dae-af38-bcea937eddda",
        "0f54d71c-cc9c-4ced-940d-100ac9062b34",
        "8991d35c-763c-4a31-a6f2-af93971cba36",
        "1c2e8f8a-52db-47d5-9ffd-d7b6eb5d9c09",
        "3734d32f-159c-43ed-b40e-482059d9edfb",
        "bf479790-0d7f-495f-a2c5-653dd247c976",
        "07a44b01-da24-463b-8f0e-502d17028a77",
        "529b97ee-22e9-4363-a7bd-27c9418a30fb",
        "075d5695-fcbe-4b97-8cb2-0baec9fae492",
        "7da9f4d8-17d0-4584-8b0d-706b40051ec0",
        "d9e52aaf-f251-4bcc-b358-93d90f0217cb",
        "a6c5aca5-5c7f-4d21-9e55-ea507664fe0a",
        "8b47671a-9cfa-422a-b3e8-46acde34a831",
        "676aa8af-6353-4e42-9dd5-2ee280e9c177",
        "65e16d1b-438c-4d53-a16f-4a13d2474606",
        "eaac9c58-a03b-432c-b3ad-d105df05a047",
        "252e5771-e771-42eb-949d-aa9a71efbe29",
        "ed7e74f6-1448-4831-80f6-02c07e273e6d",
        "3d5476c8-ee82-4535-bb69-36e3e237543b",
        "02164a48-f3ae-4d6e-8748-8e095f8e8951",
        "9406987a-a183-49fc-a2bd-842c395dbb70",
        "07b7d293-6bd8-453f-8e6c-ea599ec5db4b",
        "d4fb506d-e9fb-4eff-8220-e4acd7f13799",
        "d969e5be-d9e7-4459-9b7d-08a4f20307a7",
        "a8c91ba2-1118-467d-8d4e-4889c9fbc5ee",
        "b76a56a6-d19c-4111-a175-e6f522d032d1",
        "d570726c-4974-4b6b-af80-c672c7ab8ad2",
        "f1f52d16-91e0-4d69-82f6-31fd112ce52d",
        "f2a43978-54a7-4bef-a640-714725eed225",
        "32133609-9003-4352-8810-d8fc38ebbbed",
        "e143bd69-5df3-4937-a61e-205569a2cf81",
        "73139df8-8e0d-4215-a7d6-0e83c559a775",
        "82e64d6c-8b3a-444b-92a5-68edc4f3b2bc",
        "4364358d-6e6d-4ec5-b58c-138f811cc599",
        "ef968daa-5cc2-42ac-9bfe-116eab9f90d4",
        "83119e4c-ae09-4b5c-a731-68c3c3f8c010",
        "439c0350-af66-4c4a-bbd7-5df4c615ca96",
        "b07e7223-bbc2-46d7-804c-ebf0eb17fe9f",
        "a00be75d-825a-47fc-b282-bb297ded4891",
        "3c1416c8-1a34-474f-8371-aa0fbae8e75f",
        "47e3cd86-d172-4402-a09a-5a811efe5fe9",
        "f86bd3de-1907-4df0-9dd4-a3131f09bad5",
        "3d486a77-ee61-4976-a9dc-a70ba16f51a4",
        "f80b5433-a658-4da5-962c-b4e74ad6f4c2",
        "3344b30c-cbac-4f15-8916-36a29e8a45f6",
        "93e05920-343a-43aa-a2eb-9fa25bb1f5de",
        "3ae858b6-5b3c-4164-9ed4-cb0c7d86ad86",
        "a861767a-81b1-4253-8c56-312cdfeacb8c",
        "676496d6-f847-4f77-9a70-4210114eac34",
        "11931de3-bc4a-4a06-a4be-d26f69bdad36",
        "e77f01f1-c9e2-4afb-8a2c-a1c06b72045f",
        "87ca4962-51a3-4230-8814-254f72718f7b"
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