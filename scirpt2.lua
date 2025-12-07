-- SPINELLY HUB LUA PURA — FUNCIONAL EN XENO
-- 100% Roblox Lua

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Limpiar GUI previa
if PlayerGui:FindFirstChild("SpinellyHub") then
	PlayerGui.SpinellyHub:Destroy()
end

-- Crear ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SpinellyHub"
gui.Parent = PlayerGui

-- ==================================================
-- Función para neón animado
-- ==================================================
local function Neon(obj, color)
	local glow = Instance.new("UIGradient")
	glow.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,color), ColorSequenceKeypoint.new(1,color)}
	glow.Rotation = 90
	glow.Parent = obj
	spawn(function()
		while task.wait(0.02) do
			glow.Rotation = glow.Rotation + 1
		end
	end)
end

-- ==================================================
-- Fondo principal
-- ==================================================
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,500,0,550)
frame.Position = UDim2.new(0.5,-250,0.5,-275)
frame.BackgroundColor3 = Color3.fromRGB(5,5,5)
frame.BorderSizePixel = 0
frame.Parent = gui
Neon(frame, Color3.fromRGB(0,255,255))

-- ==================================================
-- Panel lateral plegable
-- ==================================================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,150,1,0)
panel.Position = UDim2.new(0,-150,0,0)
panel.BackgroundColor3 = Color3.fromRGB(10,10,30)
panel.BorderSizePixel = 0
panel.Parent = frame
Neon(panel, Color3.fromRGB(255,0,255))

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,30,0,100)
toggleBtn.Position = UDim2.new(0,150,0,10)
toggleBtn.Text = "☰"
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 28
toggleBtn.TextColor3 = Color3.fromRGB(255,0,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame

local panelOpen = false
toggleBtn.MouseButton1Click:Connect(function()
	panelOpen = not panelOpen
	if panelOpen then
		panel:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.4,true)
	else
		panel:TweenPosition(UDim2.new(0,-150,0,0),"Out","Quad",0.4,true)
	end
end)

-- ==================================================
-- Título animado
-- ==================================================
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,60)
title.Position = UDim2.new(0,0,0,10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,255)
title.Font = Enum.Font.Code
title.TextSize = 36
title.Text = ""
title.Parent = frame

local fullTitle = "SPINELLY HUB"

spawn(function()
	for i=1,#fullTitle do
		local glitch = ""
		for j=1,i do
			if math.random(1,4)==1 then
				glitch = glitch .. string.char(math.random(33,126))
			else
				glitch = glitch .. fullTitle:sub(j,j)
			end
		end
		title.Text = glitch
		task.wait(0.07)
	end
	title.Text = fullTitle
end)

-- ==================================================
-- Función para crear botones
-- ==================================================
local function crearBoton(nombre, y, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,240,0,45)
	btn.Position = UDim2.new(0.5,-120,0,y)
	btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
	btn.TextColor3 = Color3.fromRGB(0,255,255)
	btn.Text = nombre
	btn.Font = Enum.Font.Code
	btn.TextSize = 22
	btn.Parent = frame

	Neon(btn, Color3.fromRGB(0,255,255))

	btn.MouseEnter:Connect(function()
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn:TweenSize(UDim2.new(0,260,0,50),"Out","Quad",0.2,true)
	end)
	btn.MouseLeave:Connect(function()
		btn.TextColor3 = Color3.fromRGB(0,255,255)
		btn:TweenSize(UDim2.new(0,240,0,45),"Out","Quad",0.2,true)
	end)

	btn.MouseButton1Click:Connect(callback)
end

-- ==================================================
-- BOTONES PRINCIPALES
-- ==================================================
crearBoton("Main", 100, function() title.Text = "MAIN MODE" end)
crearBoton("PvP", 160, function() title.Text = "PVP MODE" end)
crearBoton("Laser Lagger", 220, function() title.Text = "LASER LAGGER" end)
crearBoton("ZZZ", 280, function() title.Text = "ZZZ MODE" end)
crearBoton("Discord", 340, function()
	setclipboard("https://discord.gg/")
	title.Text = "DISCORD COPIED!"
end)
crearBoton("Cerrar Hub", 400, function()
	gui:Destroy()
end)
