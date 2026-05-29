local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local LocalPlayer = Players.LocalPlayer

local SPEED_MULTIPLIER = 3

local swappedCars = {}

local WHEEL_PARTS = {
	FL = {
		{
			n = "Rim", cl = "MeshPart",
			offset = CFrame.new(-0.002014, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.113240, 2.159953, 2.163966),
			c = Color3.fromRGB(72, 72, 72), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://79855081419574", tid = "rbxassetid://98253925752297",
			sa = { ColorMap = "rbxassetid://125242088966264", MetalnessMap = "rbxassetid://96886616228553", RoughnessMap = "rbxassetid://133682292928356" },
		},
		{
			n = "Tire", cl = "MeshPart",
			offset = CFrame.new(0.000000, -0.003357, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.106516, 2.685338, 2.685337),
			c = Color3.fromRGB(25, 25, 25), tr = 0, mat = Enum.Material.Concrete, cc = false,
			mid = "rbxassetid://136089710908223",
		},
		{
			n = "Disc", cl = "MeshPart",
			offset = CFrame.new(0.003418, 0.067078, -0.000549, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(0.264459, 1.716188, 1.716188),
			c = Color3.fromRGB(134, 132, 130), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://16101782740",
		},
	},
	FR = {
		{
			n = "Disc", cl = "MeshPart",
			offset = CFrame.new(-0.003418, 0.067078, 0.000549, 0.000000, 0.000000, -1.000000, -1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000),
			sz = Vector3.new(0.264459, 1.716188, 1.716188),
			c = Color3.fromRGB(134, 132, 130), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://16101782740",
		},
		{
			n = "Tire", cl = "MeshPart",
			offset = CFrame.new(0.000000, -0.003357, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.106516, 2.685338, 2.685337),
			c = Color3.fromRGB(25, 25, 25), tr = 0, mat = Enum.Material.Concrete, cc = false,
			mid = "rbxassetid://136089710908223",
		},
		{
			n = "Rim", cl = "MeshPart",
			offset = CFrame.new(-0.002014, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.113240, 2.159953, 2.163966),
			c = Color3.fromRGB(72, 72, 72), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://79855081419574", tid = "rbxassetid://98253925752297",
			sa = { ColorMap = "rbxassetid://125242088966264", MetalnessMap = "rbxassetid://96886616228553", RoughnessMap = "rbxassetid://133682292928356" },
		},
	},
	RL = {
		{
			n = "Rim", cl = "MeshPart",
			offset = CFrame.new(-0.002014, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.154696, 2.240388, 2.244550),
			c = Color3.fromRGB(72, 72, 72), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://79855081419574", tid = "rbxassetid://98253925752297",
			sa = { ColorMap = "rbxassetid://125242088966264", MetalnessMap = "rbxassetid://96886616228553", RoughnessMap = "rbxassetid://133682292928356" },
		},
		{
			n = "Disc", cl = "MeshPart",
			offset = CFrame.new(0.003418, 0.067078, -0.000549, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(0.264459, 1.716188, 1.716188),
			c = Color3.fromRGB(134, 132, 130), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://16101782740",
		},
		{
			n = "Tire", cl = "MeshPart",
			offset = CFrame.new(0.000000, -0.003418, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.147721, 2.785337, 2.785337),
			c = Color3.fromRGB(25, 25, 25), tr = 0, mat = Enum.Material.Concrete, cc = false,
			mid = "rbxassetid://136089710908223",
		},
	},
	RR = {
		{
			n = "Tire", cl = "MeshPart",
			offset = CFrame.new(0.000000, -0.003479, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.147721, 2.785337, 2.785337),
			c = Color3.fromRGB(25, 25, 25), tr = 0, mat = Enum.Material.Concrete, cc = false,
			mid = "rbxassetid://136089710908223",
		},
		{
			n = "Rim", cl = "MeshPart",
			offset = CFrame.new(-0.001892, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, -1.000000, 0.000000, 0.000000, 0.000000, -1.000000, 0.000000),
			sz = Vector3.new(1.154696, 2.240388, 2.244550),
			c = Color3.fromRGB(72, 72, 72), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://79855081419574", tid = "rbxassetid://98253925752297",
			sa = { ColorMap = "rbxassetid://125242088966264", MetalnessMap = "rbxassetid://96886616228553", RoughnessMap = "rbxassetid://133682292928356" },
		},
		{
			n = "Disc", cl = "MeshPart",
			offset = CFrame.new(-0.003418, 0.067078, 0.000549, 0.000000, 0.000000, -1.000000, -1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000),
			sz = Vector3.new(0.264459, 1.716188, 1.716188),
			c = Color3.fromRGB(134, 132, 130), tr = 0, mat = Enum.Material.Metal, cc = false,
			mid = "rbxassetid://16101782740",
		},
	},
}

local FERDINAND_WHEEL_POS = {
	FL = Vector3.new(-3.125549, 0.376967, -4.897705),
	FR = Vector3.new(3.124451, 0.376967, -4.897705),
	RL = Vector3.new(-3.150513, 0.426970, 4.702332),
	RR = Vector3.new(3.149475, 0.426970, 4.702332),
}

local BODY_PARTS = {
	{
		n = "int",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 0.684993, -0.001587, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(7.231802, 2.402048, 17.516071),
		c = Color3.fromRGB(163, 162, 165),
		tr = 0.0000,
		mat = Enum.Material.Fabric,
		cc = false,
		mid = "rbxassetid://82707326068726",
		tid = "rbxassetid://120033245069657",
	},
	{
		n = "rollcage",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.709769, 3.440063, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.126005, 4.068047, 2.831780),
		c = Color3.fromRGB(159, 161, 172),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://106146492626989",
	},
	{
		n = "plastic",
		cl = "MeshPart",
		offset = CFrame.new(0.000244, 2.087145, 0.440186, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(7.899994, 1.541031, 16.024994),
		c = Color3.fromRGB(40, 40, 40),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://76273803616010",
	},
	{
		n = "COLOR",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.872493, -0.001343, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(7.902663, 4.417970, 17.660652),
		c = Color3.fromRGB(100, 100, 102),
		tr = 0.0000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://101671704673006",
		dc = {
			{ f = Enum.NormalId.Back, t = "rbxassetid://6990960300", tr = 1.0000 },
			{ f = Enum.NormalId.Left, t = "rbxassetid://6976939224", tr = 1.0000 },
			{ f = Enum.NormalId.Right, t = "rbxassetid://6976939224", tr = 1.0000 },
			{ f = Enum.NormalId.Right, t = "rbxassetid://120937750394251", tr = 0.1000 },
			{ f = Enum.NormalId.Right, t = "rbxassetid://11780913856", tr = 1.0000 },
			{ f = Enum.NormalId.Back, t = "rbxassetid://11780914548", tr = 1.0000 },
			{ f = Enum.NormalId.Left, t = "rbxassetid://11780913856", tr = 1.0000 },
			{ f = Enum.NormalId.Top, t = "rbxassetid://94843896488784", tr = 0.1000 },
			{ f = Enum.NormalId.Front, t = "rbxassetid://6990960300", tr = 1.0000 },
			{ f = Enum.NormalId.Front, t = "rbxassetid://106356745402437", tr = 0.1000 },
			{ f = Enum.NormalId.Front, t = "rbxassetid://11780914548", tr = 1.0000 },
			{ f = Enum.NormalId.Left, t = "rbxassetid://88116560881143", tr = 0.1000 },
			{ f = Enum.NormalId.Bottom, t = "rbxassetid://94843896488784", tr = 0.1000 },
		},
	},
	{
		n = "Mesh",
		cl = "MeshPart",
		offset = CFrame.new(0.086060, 0.444587, 8.258057, 1.000000, 0.000259, -0.000000, -0.000259, 1.000000, -0.000518, -0.000000, 0.000518, 1.000000),
		sz = Vector3.new(0.599396, 0.710017, 2.925696),
		c = Color3.fromRGB(248, 248, 248),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://17241734264",
	},
	{
		n = "Interior",
		cl = "MeshPart",
		offset = CFrame.new(-0.000366, 1.843123, 1.032532, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(6.364300, 4.290220, 10.244995),
		c = Color3.fromRGB(163, 162, 165),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://91468573949783",
		sa = {
			ColorMap = "rbxassetid://120033245069657",
			RoughnessMap = "rbxassetid://135038468919209",
		},
	},
	{
		n = "black",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.409209, 7.712402, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(2.603494, 2.691249, 2.167532),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://125311405315157",
	},
	{
		n = "badge",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.305846, -8.131775, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.189202, 0.117987, 0.226442),
		c = Color3.fromRGB(107, 100, 78),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://106989000209174",
	},
	{
		n = "badge",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.987391, 8.466797, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.221382, 0.274656, 0.112324),
		c = Color3.fromRGB(107, 100, 78),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://76645988419310",
	},
	{
		n = "grill",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.240153, -0.508972, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(7.111791, 3.081552, 16.315861),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.0000,
		mat = Enum.Material.Neon,
		cc = false,
		mid = "rbxassetid://139135293312075",
	},
	{
		n = "Windows",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 3.042548, 0.116821, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.826185, 1.301677, 4.201145),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.7000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://112373205894373",
	},
	{
		n = "CF",
		cl = "MeshPart",
		offset = CFrame.new(-0.000244, 3.785735, 7.703674, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(6.512985, 0.464441, 1.326004),
		c = Color3.fromRGB(30, 30, 30),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://76468426369515",
		dc = {
			{ f = Enum.NormalId.Left, t = "rbxassetid://121537084469902", tr = 0.0000 },
			{ f = Enum.NormalId.Right, t = "rbxassetid://106993200539153", tr = 0.0000 },
		},
	},
	{
		n = "trim",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 3.051779, 1.288574, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.909786, 1.415878, 10.597248),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.0000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://114325838654041",
	},
	{
		n = "Windows",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 3.275000, 4.863770, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(3.633542, 0.825443, 2.583083),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.7000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://108110184996911",
	},
	{
		n = "exhaust",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 0.164992, 7.580505, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.291085, 0.470000, 2.477802),
		c = Color3.fromRGB(100, 100, 100),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://77038269643292",
	},
	{
		n = "mirror",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 2.596491, -1.040283, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(7.728747, 0.418754, 0.189342),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.0000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://99202301171412",
	},
	{
		n = "Windows",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 3.056807, -2.239929, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.309722, 1.306574, 2.835849),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.7000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://75408651725055",
	},
	{
		n = "badge2",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.986712, 8.272278, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.249116, 0.307539, 0.488150),
		c = Color3.fromRGB(50, 50, 50),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://113829530617522",
	},
	{
		n = "Windows",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 3.002398, 3.240601, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.453822, 0.652945, 1.556530),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.7000,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://78751163181649",
	},
	{
		n = "CF",
		cl = "MeshPart",
		offset = CFrame.new(-0.000244, 1.786963, -0.021851, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(7.298996, 4.605962, 17.782990),
		c = Color3.fromRGB(30, 30, 30),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://138991996852832",
	},
	{
		n = "badge",
		cl = "MeshPart",
		offset = CFrame.new(-0.001831, 2.594397, 6.773560, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.350201, 0.081891, 0.124096),
		c = Color3.fromRGB(107, 100, 78),
		tr = 0.0000,
		mat = Enum.Material.Metal,
		cc = false,
		mid = "rbxassetid://85970289373866",
	},
	{
		n = "lens",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.625235, -6.985413, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(6.642925, 0.618395, 1.174636),
		c = Color3.fromRGB(0, 0, 0),
		tr = 0.8800,
		mat = Enum.Material.SmoothPlastic,
		cc = false,
		mid = "rbxassetid://74108940817268",
	},
	{
		n = "grille",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 2.735877, 4.600342, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.145473, 0.102360, 0.640506),
		c = Color3.fromRGB(100, 100, 100),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://110146201617005",
	},
	{
		n = "reflector",
		cl = "MeshPart",
		offset = CFrame.new(-0.000122, 0.650725, 8.181702, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.891765, 0.142605, 0.706160),
		c = Color3.fromRGB(117, 0, 0),
		tr = 0.0000,
		mat = Enum.Material.Plastic,
		cc = false,
		mid = "rbxassetid://111791299186957",
	},
	{
		n = "SteeringWheel",
		cl = "MeshPart",
		offset = CFrame.new(-1.514038, 2.052153, -1.453735, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.623541, 1.618898, 0.676797),
		c = Color3.fromRGB(163, 162, 165),
		tr = 0.0000,
		mat = Enum.Material.Fabric,
		cc = false,
		mid = "rbxassetid://92756168101656",
		tid = "rbxassetid://120033245069657",
		sa = {
			ColorMap = "rbxassetid://120033245069657",
			RoughnessMap = "rbxassetid://135038468919209",
		},
	},
}

local LIGHT_PARTS = {
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(-0.000244, 1.916663, 7.450073, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(6.278000, 0.154220, 2.029022),
		c = Color3.fromRGB(126, 0, 0), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://87884316803457",
		children = {
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.494118, 0.000000, 0.000000) },
			} },
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.611765, 0.098039, 0.062745) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.5, range = 12, angle = 120, face = Enum.NormalId.Back, enabled = false, shadows = false, c = Color3.fromRGB(255, 32, 32) },
		},
	},
	{
		n = "Reverse", cl = "MeshPart",
		offset = CFrame.new(-0.000122, 0.682647, 8.567871, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(3.978731, 0.084469, 0.107260),
		c = Color3.fromRGB(60, 60, 60), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://133697424148793",
		children = {
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.235294, 0.235294, 0.235294) },
			} },
			{ type = "Folder", name = "On", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.690196, 0.666667, 0.615686) },
			} },
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.8, range = 11, angle = 155, face = Enum.NormalId.Back, enabled = false, shadows = false, c = Color3.fromRGB(255, 251, 233) },
		},
	},
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(-0.000366, 0.837104, -7.533447, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(6.172989, 1.614330, 2.069992),
		c = Color3.fromRGB(120, 120, 120), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://126975370317125",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.541176, 0.650980, 0.678431) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.470588, 0.470588, 0.470588) },
				{ type = "StringValue", name = "Material", value = "Metal" },
			} },
			{ type = "Configuration", name = "DRL" },
		},
	},
	{
		n = "Light", cl = "Part",
		offset = CFrame.new(-2.636841, 1.629763, -6.861206, 0.000053, -0.000000, 1.000000, 0.016602, 0.999862, -0.000000, -0.999862, 0.016602, 0.000053),
		sz = Vector3.new(0.471126, 0.471126, 0.471126),
		c = Color3.fromRGB(231, 231, 236), tr = 1.0000, mat = Enum.Material.SmoothPlastic, cc = false,
		children = {
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.7, range = 45, angle = 70, face = Enum.NormalId.Right, enabled = false, shadows = false, c = Color3.fromRGB(255, 255, 255) },
			{ type = "Attachment", name = "Attachment1", cf = CFrame.new(57.736050, -5.773602, 0.000000) },
			{ type = "Attachment", name = "Attachment0" },
			{ type = "BillboardGui", name = "GuiLight", children = {
				{ type = "ImageLabel", name = "Glare", image = "http://www.roblox.com/asset/?id=133355041" },
			} },
			{ type = "Beam", name = "" },
			{ type = "Configuration", name = "FR" },
		},
	},
	{
		n = "Brake", cl = "MeshPart",
		offset = CFrame.new(0.000488, 2.704672, 6.594543, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.601563, 0.047751, 0.089893),
		c = Color3.fromRGB(60, 60, 60), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://104052069696286",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.937255, 0.000000, 0.000000) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.235294, 0.235294, 0.235294) },
			} },
		},
	},
	{
		n = "Left", cl = "MeshPart",
		offset = CFrame.new(-3.475708, 1.704848, -2.976318, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.029999, 0.109970, 0.441986),
		c = Color3.fromRGB(100, 100, 100), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://125633892055678",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(1.000000, 0.580392, 0.384314) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.392157, 0.392157, 0.392157) },
			} },
		},
	},
	{
		n = "Left", cl = "MeshPart",
		offset = CFrame.new(-2.053711, 1.913790, 7.656555, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.579010, 0.281303, 1.261978),
		c = Color3.fromRGB(79, 78, 80), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://138987351526476",
		children = {
			{ type = "Folder", name = "Off", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.235294, 0.235294, 0.235294) },
				{ type = "StringValue", name = "Material", value = "Metal" },
			} },
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.937255, 0.000000, 0.000000) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.5, range = 12, angle = 120, face = Enum.NormalId.Back, enabled = false, shadows = false, c = Color3.fromRGB(255, 0, 0) },
		},
	},
	{
		n = "Right", cl = "MeshPart",
		offset = CFrame.new(2.054321, 1.913798, 7.656555, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.578995, 0.281310, 1.261993),
		c = Color3.fromRGB(79, 78, 80), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://102648177209057",
		children = {
			{ type = "Folder", name = "Off", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.235294, 0.235294, 0.235294) },
				{ type = "StringValue", name = "Material", value = "Metal" },
			} },
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.5, range = 12, angle = 120, face = Enum.NormalId.Back, enabled = false, shadows = false, c = Color3.fromRGB(255, 0, 0) },
			{ type = "Folder", name = "On", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.937255, 0.000000, 0.000000) },
			} },
		},
	},
	{
		n = "Brake", cl = "MeshPart",
		offset = CFrame.new(-0.000732, 1.916320, 7.640564, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.735001, 0.339593, 1.339996),
		c = Color3.fromRGB(90, 90, 90), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://79428131442266",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.937255, 0.000000, 0.000000) },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.352941, 0.352941, 0.352941) },
			} },
		},
	},
	{
		n = "Light", cl = "Part",
		offset = CFrame.new(2.634644, 1.629832, -6.861206, 0.000053, -0.000000, 1.000000, 0.016602, 0.999862, -0.000000, -0.999862, 0.016602, 0.000053),
		sz = Vector3.new(0.471126, 0.471126, 0.471126),
		c = Color3.fromRGB(231, 231, 236), tr = 1.0000, mat = Enum.Material.SmoothPlastic, cc = false,
		children = {
			{ type = "BillboardGui", name = "GuiLight", children = {
				{ type = "ImageLabel", name = "Glare", image = "http://www.roblox.com/asset/?id=133355041" },
			} },
			{ type = "Attachment", name = "Attachment1", cf = CFrame.new(57.736050, -5.773602, 0.000000) },
			{ type = "Beam", name = "" },
			{ type = "Configuration", name = "FR" },
			{ type = "Attachment", name = "Attachment0" },
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.7, range = 45, angle = 70, face = Enum.NormalId.Right, enabled = false, shadows = false, c = Color3.fromRGB(255, 255, 255) },
		},
	},
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(-0.000122, 1.634192, -6.762146, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(5.577011, 0.187820, 0.092987),
		c = Color3.fromRGB(120, 120, 120), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://73833146659166",
		children = {
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.470588, 0.470588, 0.470588) },
			} },
			{ type = "Folder", name = "On", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.984314, 0.980392, 1.000000) },
			} },
		},
	},
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(-2.557190, 1.619021, -6.994324, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.214996, 0.568480, 1.073990),
		c = Color3.fromRGB(120, 120, 120), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://129824071482645",
		children = {
			{ type = "Folder", name = "Off", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.470588, 0.470588, 0.470588) },
				{ type = "StringValue", name = "Material", value = "Metal" },
			} },
			{ type = "Folder", name = "Override", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(1.000000, 0.580392, 0.384314) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.541176, 0.650980, 0.678431) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Configuration", name = "Left" },
			{ type = "Configuration", name = "DRL" },
		},
	},
	{
		n = "Left", cl = "Part",
		offset = CFrame.new(-2.753296, 1.653426, -7.355347, -0.999966, 0.008287, -0.000052, 0.008286, 0.999931, 0.008287, 0.000121, 0.008286, -0.999966),
		sz = Vector3.new(0.471126, 0.471126, 0.471126),
		c = Color3.fromRGB(231, 231, 236), tr = 1.0000, mat = Enum.Material.SmoothPlastic, cc = false,
		children = {
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.5, range = 12, angle = 120, face = Enum.NormalId.Back, enabled = false, shadows = false, c = Color3.fromRGB(255, 108, 34) },
		},
	},
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(3.233032, 1.630954, -6.679443, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.128608, 0.518241, 0.519767),
		c = Color3.fromRGB(170, 85, 0), tr = 0.0000, mat = Enum.Material.SmoothPlastic, cc = false,
		mid = "rbxassetid://99400635181196",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.890196, 0.447059, 0.000000) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.545098, 0.290196, 0.062745) },
				{ type = "StringValue", name = "Material", value = "Plastic" },
			} },
		},
	},
	{
		n = "Right", cl = "Part",
		offset = CFrame.new(2.868408, 1.606833, -7.355713, -0.999966, 0.008287, -0.000052, 0.008286, 0.999931, 0.008287, 0.000121, 0.008286, -0.999966),
		sz = Vector3.new(0.471126, 0.471126, 0.471126),
		c = Color3.fromRGB(231, 231, 236), tr = 1.0000, mat = Enum.Material.SmoothPlastic, cc = false,
		children = {
			{ type = "SpotLight", name = "DynamicLight", brightness = 0.5, range = 12, angle = 120, face = Enum.NormalId.Back, enabled = false, shadows = false, c = Color3.fromRGB(255, 108, 34) },
		},
	},
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(-3.232666, 1.631530, -6.678955, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.128608, 0.518241, 0.519767),
		c = Color3.fromRGB(170, 85, 0), tr = 0.0000, mat = Enum.Material.SmoothPlastic, cc = false,
		mid = "rbxassetid://135163468086076",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.890196, 0.447059, 0.000000) },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Plastic" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.545098, 0.290196, 0.062745) },
			} },
		},
	},
	{
		n = "Light", cl = "MeshPart",
		offset = CFrame.new(2.557251, 1.619021, -6.994324, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(1.214005, 0.568480, 1.073990),
		c = Color3.fromRGB(120, 120, 120), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://87862450416671",
		children = {
			{ type = "Configuration", name = "Right" },
			{ type = "Configuration", name = "DRL" },
			{ type = "Folder", name = "Off", children = {
				{ type = "StringValue", name = "Material", value = "Metal" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.470588, 0.470588, 0.470588) },
			} },
			{ type = "Folder", name = "On", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(0.541176, 0.650980, 0.678431) },
			} },
			{ type = "Folder", name = "Override", children = {
				{ type = "StringValue", name = "Material", value = "Neon" },
				{ type = "Color3Value", name = "Color", value = Color3.new(1.000000, 0.580392, 0.384314) },
			} },
		},
	},
	{
		n = "Right", cl = "MeshPart",
		offset = CFrame.new(3.476318, 1.704848, -2.976318, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000),
		sz = Vector3.new(0.029999, 0.109970, 0.441986),
		c = Color3.fromRGB(100, 100, 100), tr = 0.0000, mat = Enum.Material.Ice, cc = false,
		mid = "rbxassetid://124298330602190",
		children = {
			{ type = "Folder", name = "On", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(1.000000, 0.580392, 0.384314) },
				{ type = "StringValue", name = "Material", value = "Neon" },
			} },
			{ type = "Folder", name = "Off", children = {
				{ type = "Color3Value", name = "Color", value = Color3.new(0.392157, 0.392157, 0.392157) },
				{ type = "StringValue", name = "Material", value = "Metal" },
			} },
		},
	},
}

local function getCarFromSeat(seat)
	local current = seat.Parent
	while current and current ~= workspace do
		if current:IsA("Model") then
			if current:FindFirstChild("Body") or current:FindFirstChild("Wheels") then
				return current
			end
		end
		current = current.Parent
	end
	return nil
end

local function findCarBase(carModel)
	for _, child in ipairs(carModel:GetChildren()) do
		if child:IsA("BasePart") and child.Name == "Base" then
			return child
		end
	end
	if carModel.PrimaryPart then
		return carModel.PrimaryPart
	end
	return nil
end

local function findWheelAnchor(wheelFolder)
	if wheelFolder:IsA("BasePart") then
		return wheelFolder
	end
	for _, child in ipairs(wheelFolder:GetChildren()) do
		if child:IsA("BasePart") then
			return child
		end
	end
	return nil
end

local function hideAllVisuals(carModel)
	local character = LocalPlayer.Character

	local body = carModel:FindFirstChild("Body")
	if body then
		local lp = body:FindFirstChild("LicensePlate")
		if lp then
			lp:Destroy()
		end
		for _, desc in ipairs(body:GetDescendants()) do
			if character and desc:IsDescendantOf(character) then
				continue
			end
			if desc:IsA("BasePart") and not desc:IsA("VehicleSeat") and desc.Name ~= "CollisionPart" then
				desc.Transparency = 1
			elseif desc:IsA("Decal") or desc:IsA("Texture") then
				desc.Transparency = 1
			end
		end
	end

	local wheels = carModel:FindFirstChild("Wheels")
	if wheels then
		for _, wheelFolder in ipairs(wheels:GetChildren()) do
			local parts = wheelFolder:FindFirstChild("Parts")
			if parts then
				for _, desc in ipairs(parts:GetDescendants()) do
					if desc:IsA("BasePart") then
						desc.Transparency = 1
					end
				end
			end
		end
	end

	for _, child in ipairs(carModel:GetChildren()) do
		if child:IsA("BasePart") and not child:IsA("VehicleSeat")
			and child.Name ~= "Base" and child.Name ~= "CollisionPart" then
			if child.Transparency < 1 then
				child.Transparency = 1
			end
		end
	end
end

local function makeMeshPart(meshId)
	local ok, part = pcall(function()
		return InsertService:CreateMeshPartAsync(meshId, Enum.CollisionFidelity.Box, Enum.RenderFidelity.Automatic)
	end)
	if ok and part then
		return part
	end
	local p = Instance.new("MeshPart")
	p.MeshId = meshId
	return p
end

local function buildPart(partData, weldTarget, parent)
	local part
	if partData.cl == "MeshPart" and partData.mid then
		part = makeMeshPart(partData.mid)
		if partData.tid then
			part.TextureID = partData.tid
		end
	else
		part = Instance.new("Part")
		if partData.shape then
			part.Shape = partData.shape
		end
	end

	part.Size = partData.sz
	part.Color = partData.c
	part.Transparency = partData.tr
	part.Material = partData.mat
	part.CanCollide = partData.cc
	part.Anchored = false
	part.Massless = true
	part.CastShadow = true
	part.CFrame = weldTarget.CFrame * partData.offset

	if partData.sa then
		local sa = Instance.new("SurfaceAppearance")
		if partData.sa.ColorMap then sa.ColorMap = partData.sa.ColorMap end
		if partData.sa.MetalnessMap then sa.MetalnessMap = partData.sa.MetalnessMap end
		if partData.sa.RoughnessMap then sa.RoughnessMap = partData.sa.RoughnessMap end
		if partData.sa.NormalMap then sa.NormalMap = partData.sa.NormalMap end
		pcall(function()
			if partData.sa.TexturePack then sa.TexturePack = partData.sa.TexturePack end
		end)
		sa.Parent = part
	end

	if partData.dc then
		for _, d in ipairs(partData.dc) do
			local decal = Instance.new("Decal")
			decal.Face = d.f
			decal.Texture = d.t
			decal.Transparency = d.tr
			decal.Parent = part
		end
	end

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = weldTarget
	weld.Part1 = part
	weld.Parent = part

	part.Parent = parent
	return part
end

local function buildLightChildren(childrenData, parent)
	for _, cd in ipairs(childrenData) do
		if cd.type == "Folder" then
			local folder = Instance.new("Folder")
			folder.Name = cd.name
			if cd.children then
				buildLightChildren(cd.children, folder)
			end
			folder.Parent = parent
		elseif cd.type == "StringValue" then
			local sv = Instance.new("StringValue")
			sv.Name = cd.name
			sv.Value = cd.value or ""
			sv.Parent = parent
		elseif cd.type == "Color3Value" then
			local cv = Instance.new("Color3Value")
			cv.Name = cd.name
			cv.Value = cd.value or Color3.new(1, 1, 1)
			cv.Parent = parent
		elseif cd.type == "SpotLight" then
			local sl = Instance.new("SpotLight")
			sl.Name = cd.name
			sl.Brightness = cd.brightness or 1
			sl.Range = cd.range or 16
			sl.Angle = cd.angle or 120
			sl.Face = cd.face or Enum.NormalId.Front
			sl.Enabled = cd.enabled
			sl.Shadows = cd.shadows or false
			sl.Color = cd.c or Color3.new(1, 1, 1)
			sl.Parent = parent
		elseif cd.type == "PointLight" then
			local pl = Instance.new("PointLight")
			pl.Name = cd.name
			pl.Brightness = cd.brightness or 1
			pl.Range = cd.range or 8
			pl.Enabled = cd.enabled
			pl.Color = cd.c or Color3.new(1, 1, 1)
			pl.Parent = parent
		elseif cd.type == "Configuration" then
			local cfg = Instance.new("Configuration")
			cfg.Name = cd.name
			cfg.Parent = parent
		elseif cd.type == "Attachment" then
			local att = Instance.new("Attachment")
			att.Name = cd.name
			if cd.cf then
				att.CFrame = cd.cf
			end
			att.Parent = parent
		elseif cd.type == "BillboardGui" then
			local bg = Instance.new("BillboardGui")
			bg.Name = cd.name
			bg.AlwaysOnTop = false
			bg.Size = UDim2.new(8, 0, 8, 0)
			bg.LightInfluence = 0
			bg.Adornee = parent:IsA("BasePart") and parent or nil
			if cd.children then
				buildLightChildren(cd.children, bg)
			end
			bg.Parent = parent
		elseif cd.type == "ImageLabel" then
			local il = Instance.new("ImageLabel")
			il.Name = cd.name
			il.Image = cd.image or ""
			il.Size = UDim2.new(1, 0, 1, 0)
			il.BackgroundTransparency = 1
			il.Parent = parent
		elseif cd.type == "Beam" then
			local beam = Instance.new("Beam")
			beam.Name = cd.name
			beam.Parent = parent
		end
	end
end

local function buildLights(carModel, carBase, container)
	local body = carModel:FindFirstChild("Body")
	if not body then return end

	local vl = body:FindFirstChild("Vehicle_Lights")
	if not vl then
		vl = Instance.new("Folder")
		vl.Name = "Vehicle_Lights"
		vl.Parent = body
	end

	for _, desc in ipairs(vl:GetDescendants()) do
		if desc:IsA("BasePart") then
			desc:Destroy()
		end
	end
	task.wait()

	for _, ld in ipairs(LIGHT_PARTS) do
		local part
		if ld.cl == "MeshPart" and ld.mid then
			part = makeMeshPart(ld.mid)
			if ld.tid then
				part.TextureID = ld.tid
			end
		else
			part = Instance.new("Part")
		end

		part.Name = ld.n
		part.Size = ld.sz
		part.Color = ld.c
		part.Transparency = ld.tr
		part.Material = ld.mat
		part.CanCollide = ld.cc
		part.Anchored = false
		part.Massless = true
		part.CastShadow = true
		part.CFrame = carBase.CFrame * ld.offset

		if ld.children then
			buildLightChildren(ld.children, part)
		end

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = carBase
		weld.Part1 = part
		weld.Parent = part

		part.Parent = vl
	end
end


local function moveWheelPositions(carModel, carBase)
	local wheels = carModel:FindFirstChild("Wheels")
	if not wheels then return end

	local seat = carModel:FindFirstChild("DriverSeat")
	if not seat then return end

	for wheelName, targetLocal in pairs(FERDINAND_WHEEL_POS) do
		local wheelFolder = wheels:FindFirstChild(wheelName)
		if not wheelFolder then continue end

		local sa = wheelFolder:FindFirstChild("#SA")
		if not sa then continue end

		local weld = nil
		for _, child in ipairs(seat:GetChildren()) do
			if child:IsA("Weld") and child.Part1 == sa then
				weld = child
				break
			end
		end
		if not weld then continue end

		local currentLocal = carBase.CFrame:PointToObjectSpace(wheelFolder.CFrame.Position)
		local delta = targetLocal - currentLocal
		local worldDelta = carBase.CFrame:VectorToWorldSpace(delta)

		local desiredSACF = sa.CFrame + worldDelta
		weld.C1 = desiredSACF:Inverse() * weld.Part0.CFrame * weld.C0
	end
end

local function swapCarVisuals(carModel)
	if swappedCars[carModel] then return end
	swappedCars[carModel] = true

	local carBase = findCarBase(carModel)
	if not carBase then
		warn("[CarSwap] No Base part found in " .. carModel.Name)
		return
	end

	moveWheelPositions(carModel, carBase)
	task.wait(0.1)

	hideAllVisuals(carModel)

	local container = Instance.new("Folder")
	container.Name = "FerdinandVisuals"
	container.Parent = carModel

	for _, partData in ipairs(BODY_PARTS) do
		buildPart(partData, carBase, container)
	end

	buildLights(carModel, carBase, container)

	local wheels = carModel:FindFirstChild("Wheels")
	if wheels then
		for wheelName, wheelParts in pairs(WHEEL_PARTS) do
			local targetWheel = wheels:FindFirstChild(wheelName)
			if targetWheel then
				local anchor = findWheelAnchor(targetWheel)
				if anchor then
					for _, partData in ipairs(wheelParts) do
						buildPart(partData, anchor, container)
					end
				end
			end
		end
	end

	if SPEED_MULTIPLIER > 1 then
		local driveController = carModel:FindFirstChild("Drive Controller")
		if driveController then
			pcall(function()
				local drive = require(driveController)
				local defaults = {
					Horsepower = drive.Horsepower,
					FinalDrive = drive.FinalDrive,
					RevAccel = drive.RevAccel,
					FAntiRoll = drive.FAntiRoll,
					SteerDecay = drive.SteerDecay,
				}
				local newHp = math.max(rawget(defaults, "Horsepower") * SPEED_MULTIPLIER, 2000)
				if newHp < 2160 and SPEED_MULTIPLIER > 1.5 then
					newHp = rawget(defaults, "Horsepower") * 1.7 * SPEED_MULTIPLIER
				end
				rawset(drive, "Horsepower", newHp)
				rawset(drive, "FinalDrive", rawget(defaults, "FinalDrive") / math.sqrt(SPEED_MULTIPLIER))
				rawset(drive, "RevAccel", rawget(defaults, "RevAccel") * SPEED_MULTIPLIER)
				rawset(drive, "FAntiRoll", rawget(defaults, "FAntiRoll") * SPEED_MULTIPLIER)
				rawset(drive, "SteerDecay", rawget(defaults, "SteerDecay") * SPEED_MULTIPLIER)
			end)
		end
	end

	print("[CarSwap] Ferdinand visuals applied to " .. carModel.Name)
end

repeat task.wait() until _G.WindUI and _G.Window

local WindUI = _G.WindUI
local Window = _G.Window

local function notif(title, text, time)
	WindUI:Notify({
		Title = title or "Car Swap",
		Content = text or "No text",
		Duration = time or 3,
	})
end

local function getCurrentCar()
	local character = LocalPlayer.Character
	if not character then return nil end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or not humanoid.SeatPart then return nil end
	local seat = humanoid.SeatPart
	if seat:IsA("VehicleSeat") and seat.Name == "DriverSeat" then
		return getCarFromSeat(seat)
	end
	return nil
end

local carSwapTab = Window:Tab({
	Title = "Car Swap",
	Icon = "car",
})

carSwapTab:Button({
	Title = "Swap to Ferdinand",
	Desc = "Swaps the current car's visuals to Ferdinand Rapido GTR3 2023 (use the free car for best results)",
	Callback = function()
		local car = getCurrentCar()
		if not car then
			notif("Car Swap", "No car found! Sit in the driver seat first.", 3)
			return
		end
		if car:FindFirstChild("FerdinandVisuals") then
			notif("Car Swap", "This car is already swapped!", 3)
			return
		end
		swapCarVisuals(car)
		notif("Car Swap", "Ferdinand visuals applied!", 3)
	end,
})

print("[CarSwap] Ferdinand Rapido GTR3 2023 swap script loaded")
