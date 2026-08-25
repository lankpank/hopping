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
        "ea6459c3-ef80-436d-8f56-4464f33d2fad",
        "18f5809e-08aa-4f9e-a4b8-d9db8e245dd4",
        "e8b68a49-8fca-40ae-adb9-07ccb70aa5a9",
        "dcdad6f1-bdd6-4348-ac7b-a889f7eecd7d",
        "9e58ada0-a953-4f8e-ae2a-04f0280a6698",
        "4627034f-15bc-4a64-9172-bdb714aff044",
        "7b284f47-8d78-4701-ba11-b01935455c47",
        "68b585f5-542d-455d-9a07-c0ed79de135d",
        "17bc44ee-7fa8-4427-a54d-702be64f7138",
        "2387e84b-49af-4a0a-862e-e690955ac222",
        "522fc802-ad74-42be-b2af-5fd68bb213e9",
        "99e95aa2-7de5-48ec-86dd-a66d6b551658",
        "b405b020-2eec-40d1-bd36-13f1125cd5b4",
        "1beff424-45f8-4544-9af4-3ad66fec5ed7",
        "31f9fe2a-484d-4d95-a5ea-b5b82072ae58",
        "01340f1f-0ed3-4b74-ab5b-9606dd06746f",
        "b37a1873-4fe0-4b84-822a-ec32825da1e6",
        "3017d132-8e20-494d-961f-f97dea173621",
        "0298638d-b859-48e4-a3c6-10998aa0402f",
        "5b4a7e75-7a91-437c-90bd-48a735b711b0",
        "de0268ea-b666-4f4a-9206-ebf146e5b889",
        "ebc141c9-4136-42cd-b0f3-1b3bb94229e9",
        "099106d3-dd4d-4f78-99bd-1f201632cf24",
        "5be26d69-8356-4f91-8060-0961ee0910a5",
        "97f00e3b-6759-403c-b422-b084feae71d3",
        "9ca6df12-56f7-4f6d-9fbe-f0ce239e081d",
        "23e3c3ae-25f8-4643-895b-7f5176332fbf",
        "d01bb84b-0e24-4373-9c1a-d5d52b517cfd",
        "9de6e3bc-3c10-466b-860e-67db59a2e267",
        "42a8e881-85bf-41b0-9046-a09df10fc9b4",
        "d3e46824-7932-4344-b364-b02d9631f5cb",
        "3ce4751e-4cca-4a29-a670-c848ca170c94",
        "3634c999-ae18-4540-b320-c1785f7b9e83",
        "9f4201cb-eab1-43ae-aeec-78fbdceeeeaf",
        "a3d7e849-cf90-4ba6-8c9b-bf282b030b9d",
        "e2b4e5e5-475c-403a-8629-650e2e613f10",
        "09984a05-b853-491e-9992-47c80ebe458a",
        "2a01126e-2969-476c-a341-02469b2e9868",
        "208fb869-139e-4d78-af9b-93d1b931433e",
        "cf2ea244-7ac0-4692-bb6d-faf23b6653ef",
        "a6d703e0-e4f4-45dc-8ec0-bb497c8b77ae",
        "8648fd9b-8a52-4a66-a7aa-272d95109e7c",
        "ac3521bf-d590-4e92-a80d-d3bb215cde5e",
        "62c8c292-3700-410d-baff-956ce7f92c56",
        "0ac688d7-b1a6-44f3-8b68-30a8274d3d59",
        "d5bb3fb8-391d-4fad-a92d-dd91f0bb9434",
        "73a061ac-9fa1-41bf-9419-6a5a952bc5d2",
        "74fb9d52-86fd-4952-b688-945651799271",
        "083d3707-5175-421b-b6cb-72aea4ca956f",
        "34ab96ff-ee54-4a5d-9900-58b7c42454b6",
        "abbaa04b-c729-4c99-bd45-bade76ad25ee",
        "9734ed35-b44e-4497-8d88-2484c07216ce",
        "58dce614-2d06-4682-8102-05086ac5d71b",
        "424a5f07-cb37-45ef-b04f-8bb2bd1a70aa",
        "de902a48-ff93-45c2-b8d0-86e40dc74eba",
        "d9ece429-3e8c-4961-a560-8a7ad09cfe29",
        "3bf98ecb-5b87-4bfa-bdba-8098afd1b155",
        "d7305d0e-332b-4c24-b5b0-d47a0b9e3316",
        "9c007528-f452-4717-89dd-ed7840ca2c88",
        "38fe2542-0ba3-4b8e-8702-af673bec9744",
        "600fb98a-4921-459d-a75c-0d191d862698",
        "86bdc83d-41db-4141-919e-9c22ea7d8ae2",
        "d50916c8-aaa1-4b4a-b373-b394939f647b",
        "ff5c9a84-ac6c-4ef6-b505-088c97f62363",
        "325c719d-a1e8-4426-8c3a-5eef71c58861",
        "d4676b75-06c1-400a-9d95-c6f98ddd33d1",
        "78c9e62f-958c-4ce7-a723-8161a547c9fe",
        "c37bc50d-3b8c-4d24-860b-11398bcc53d3",
        "454baeec-dab9-4dee-9366-e88f2a1b585a",
        "ba0a36e7-8b52-4768-8ada-99e0aee9fc90",
        "16f71c29-9f8f-4a11-9abe-57935c634f1c",
        "8525ce6f-8c4e-421d-978a-38ae135f1800",
        "58eabe14-06be-4494-b057-dd508f04533f",
        "a66a88c1-e5de-4228-aba2-bc5ec820825e",
        "db702f3d-53e3-4c9b-acdd-aefb5950d275",
        "739bf148-5128-4ef0-8a8f-1b0a01f49c06",
        "e1a4ef11-aeb7-49f2-82f8-596d3320c455",
        "cc6898a5-2faf-4457-ab95-04eb42ddc69c",
        "61942080-53e2-4403-aecc-6d933809b60c",
        "dff83023-ba4d-44b8-8a3e-15ffd65623c2",
        "8dad8e05-e3fd-49b1-980d-e4930d5b0fdd",
        "f4d1967d-55e5-4fdd-b213-e586c9ec600f",
        "a9b0d70b-086c-4514-a84e-44c463c6362b",
        "8cd2fea7-9c9f-4401-b650-c8456cf66183",
        "b1700bb5-dcb2-47fb-b940-d17bdbe97a0a",
        "231840ee-6eb2-44d7-ba03-1bb1de77eaef",
        "00923830-983f-4b08-8cc7-bbf6f93eaa72",
        "017b6dd4-3720-46d3-a816-13c49408b832",
        "e71c6691-80e4-49f8-bcab-e64be0a8c1e0",
        "d3fc9803-908f-4d69-8e17-7b4b1fbb6a56",
        "1784a8bc-d441-49e5-b595-fa4e4196a2cc",
        "a0d465d2-9d5f-4a6d-b1fd-1fe7c7d4d108",
        "dd91c51f-4eda-40e7-ab6c-1e4cf6e3bf8d",
        "ecb1bc11-36ae-40db-a739-3686a999bb43",
        "ecb1bc11-36ae-40db-a739-3686a999bb43",
        "85fd464c-9611-444d-bf61-40693cff7da7",
        "b36e48e5-083b-4cf7-8d71-80bbe8d42174",
        "32b91343-ff03-4761-b83f-30d502ed5930",
        "9cfa3831-66f1-4f33-afe0-c0b10fd0315c",
        "8c055655-8c24-477e-a4c5-8c49955a904d",
        "467d8d25-f28f-4bf2-b9f5-9d7694248257",
        "ce13d0d2-80ee-4404-8a7f-18f4ccd28fcb",
        "f6d5eb5d-6ce2-4317-a44e-5521559134ec",
        "f258caf4-ef66-45c9-9f2d-cab5cb7a14fa",
        "04ce09ed-5c69-41f3-9284-1d7ed5b6711d",
        "6c9521ff-8467-43e9-9bbd-d19d294ec2d9",
        "978a3209-b0d1-45d5-a760-925155818b8a",
        "103822f9-45c4-4765-9acb-c8c88fc8184d",
        "4d38040b-766e-4051-81a0-5c2a94fbc1f1",
        "57a7fe17-9cc2-42bb-8a40-00b2f19adb01",
        "010ed1da-886a-47ae-a1fc-7bd10258b2cd",
        "23e23911-5e0e-4b9f-b017-6c30156ecdc0",
        "9038acfb-9655-498d-ad0c-7b2aa830c614",
        "3c1a1333-7f2c-46bb-ba71-ddcc4ac53d87",
        "991c62a2-a9fd-4e0e-b74c-6910b0a7f1aa",
        "d8c78b70-71ea-4d0b-9bbf-8f56a4da1451",
        "79fa8fcb-cd16-4534-b91f-414f12a4105d",
        "5e728139-61d5-4d4a-950a-80fe38c3b8b6",
        "651e74f0-deca-42ea-bb35-c8796ad5858d",
        "89fde069-9745-4400-8f25-4d06433a5872",
        "876125ac-29ad-45a7-b7ad-def68523fb57",
        "09719a8a-51db-479c-807a-a2f6e4d9af10",
        "5fb6ced3-df95-4360-b99a-5eff0c358b13",
        "b0530d3f-6f3e-4a89-bae8-45063daa4fc8",
        "a217ba07-52d6-4ac2-9a77-b77e90a11f2b",
        "4a9e46fb-0a26-42ff-b54f-b6ebfba565d6",
        "de9cd106-5bdc-4c5e-8299-b3dca532f513",
        "2b38fa12-3496-4089-a4aa-e939b3306ce7",
        "0940d6e5-f0d1-4ebc-b492-618b4a184660",
        "0f5ccada-52d0-4606-b250-5b16e84caf12",
        "59331d88-1e23-4e92-a52c-32fe5500c394",
        "9c8e6a91-5511-4de2-944e-ffc82e723194",
        "3e571a60-50ab-4ab0-b8e8-b45b29718b87",
        "075966f3-82f5-4707-89fc-64af9686ed72",
        "9c2880fa-fa70-45e1-beab-8fd48b72bbd8",
        "d3a9bbbe-3f87-4a93-b05d-bd95b3224b8e",
        "da3318a0-f0e7-4d0a-be48-70fb18372309",
        "e5060b05-f93f-4b9e-9830-3da87c6a0cbe",
        "d00a1850-5f8e-4b48-a255-9a274781d72f",
        "27c88784-6fa8-4d59-be96-f06576e46a3f",
        "31d68743-b5b2-43e9-8b04-d5d67077caa2",
        "aba9d9fc-7387-4ec9-ba11-ebfa5d28283c",
        "4157e871-eade-4127-9cde-6133613c69f6",
        "23e65a78-1de3-44b4-a884-63b36d13f22d",
        "059235ba-c4e2-4f09-b727-6c81064c0912",
        "7bf070ce-de70-45e5-afbc-7356c5670b68",
        "68a81d83-5974-4267-aa1d-1ba86becb2e9",
        "6e8c8bde-e475-4cc4-97f8-bd0de4feaadd",
        "2e9b4158-49cc-4e56-9d31-0ddfa026391d",
        "77443add-647b-4eff-87c3-1f5aef266a1e",
        "140135ee-7461-477d-b826-14dfb1a4099a",
        "0dc25693-8ad3-46e6-b629-f3670309d1b7",
        "05d7f20b-4d60-43fc-b0d4-c58e364e8c2a",
        "055d9d27-dba5-4448-81fe-2d993a4f5c29",
        "de5a3ce8-7b22-471c-a7ee-f1f072be3b06",
        "369dd3af-d515-406e-b954-e3318d3ad909",
        "ccbb58e5-2ba0-425e-9979-d21c8f8c4da3",
        "7f14a4a8-7897-4d4a-96d5-ad26d9a8346d",
        "a30a7f23-237b-4c6d-90ff-8f92dc0f7889",
        "1eefd3b2-5bf9-413f-ad45-7a1005f58153",
        "c009e80b-d7b4-4ab0-b538-a44eeea867b3",
        "a20528ea-f992-4ce3-bfc9-2ef9153955b1",
        "fe973efd-6aa6-43b1-89f2-a0619212fec2",
        "afc1a27f-2d25-4a14-859b-8dc7bb03f56d",
        "c4ed1bec-f674-4f73-ab29-ef185242fe1e",
        "77ca37b7-8f8b-4fc1-97d2-03feda73b96d",
        "3a6b67c9-ea76-4d9b-8b21-6c034734a569",
        "66d43e67-1bb8-4c65-9463-3e6823a1ac24",
        "f97fa9ed-fe26-49ca-a3e5-61867e7c0029",
        "918def96-a44c-493a-a1ac-914953d74335",
        "e5e4f5ed-a3de-4bac-b1dc-77ea793c1e55",
        "90b33440-4be4-4a4a-abf3-1a3ccc4db491",
        "23e08023-8df7-4061-a71f-e6dc3e2b68a2",
        "951c33eb-5d56-4de1-bc8a-e5019a7761dd",
        "de27c55c-e5b1-4c82-b3ab-9b7f61154c35",
        "b38e301d-7805-4398-a0a1-c2aad66058c1",
        "3bd0b490-2471-421a-9c0d-133aee2e4eb0",
        "6dda9b34-e854-4d08-874d-f44576b808ee",
        "ed323196-e1c6-4901-88f4-d59401c0f4a3",
        "ec419f59-4eea-428b-823a-5ae4064c40b1",
        "41188a4f-7ee5-4326-a1b7-d8f87de9eb21",
        "5155ded8-9acd-4fd6-9fdd-93d8f8d5a641",
        "5983c5db-c404-4c60-b4ec-ecb2164bab4c",
        "26c4c7ad-7e57-4fb4-b467-7552e4329fb1",
        "7db03c60-8db6-4492-9d55-9c3ccef2d580",
        "a595933b-805e-478e-aef0-b327086145f4",
        "1b8baf03-cc52-49fb-9384-0bfcfbb8ce67",
        "aea7dc4e-dc19-4cd7-8042-c3ed6e4d4e0d",
        "cd666efb-0345-4c09-9696-ba4cb9544e42",
        "bff842a4-6491-4434-a2bb-ab22c77542bb",
        "84db7b4a-0b2c-40e4-87c7-c39558143c28"
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