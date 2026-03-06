local httpService = game:GetService("HttpService")

local function getServerToJoin()
    local servers = httpService:JSONDecode(readfile("asset taker/servers.json"))
    local join = nil
    for key, val in servers do
        if val == false then
            join = key
            break
        end
    end
    servers[join] = true
    print(join, servers[join])
    writefile("asset taker/servers.json", httpService:JSONEncode(servers))
    return join
end

local function joinServer(key)
    local q = queue_on_teleport or queueonteleport or queueteleport
    q(
        [[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/gay.lua"))()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/gay2.lua"))()
        ]]
    )
    print(key)
    print(game:GetService("ReplicatedStorage"):WaitForChild("PrivateServers"):WaitForChild("JoinServer"):InvokeServer(key, false, false))
end

local function checkServerList()
    makefolder("asset taker")
    local existingFiles = listfiles("asset taker")
    local out = {}
    local key = nil
    local found = false
    for _, file in existingFiles do
        if string.find(file, "servers.json") then
            found = true
            break
        end
    end
    if not found then
        local servers = game:GetService("ReplicatedStorage").PrivateServers.GetServers:InvokeServer()
        for _, server in servers do
            if type(server) == "table" and server.LiveryPack and not server.Locked and server.TierRequirement == 0 and server.GroupJoin == 0 then
                out[server.CurrKey] = false
            end
        end
        writefile("asset taker/servers.json", httpService:JSONEncode(out))
    end
    key = getServerToJoin()
    joinServer(key)
end

checkServerList()
