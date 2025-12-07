local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Limpiar GUI previa
if PlayerGui:FindFirstChild("SpinellyHub") then
	PlayerGui.SpinellyHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SpinellyHub"
gui.Parent = PlayerGui

-- Neón animado
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

local menuAbierto = true
local subMenuAbierto = nil
local titleAnimado = false

-- Menú principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,500,0,550)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,15,45)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = gui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,15)
frameCorner.Parent = frame

Neon(frame, Color3.fromRGB(200,150,255))

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,60)
title.Position = UDim2.new(0,0,0,10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200,150,255)
title.Font = Enum.Font.Code
title.TextSize = 36
title.Text = ""
title.Parent = frame

-- Animación del título
if not titleAnimado then
	titleAnimado = true
	spawn(function()
		local fullTitle = "SPINELLY HUB"
		for i=1,#fullTitle do
			local glitch = ""
			for j=1,i do
				if math.random(1,4)==1 then
					glitch = glitch..string.char(math.random(33,126))
				else
					glitch = glitch..fullTitle:sub(j,j)
				end
			end
			title.Text = glitch
			task.wait(0.07)
		end
		title.Text = fullTitle
	end)
end

-- Botón cerrar/minimizar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(30,20,40)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

-- Botón “S” morado para restaurar
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0,50,0,50)
miniBtn.Position = UDim2.new(0,50,1,-70)
miniBtn.AnchorPoint = Vector2.new(0.5,0.5)
miniBtn.BackgroundColor3 = Color3.fromRGB(150,0,255)
miniBtn.Text = "S"
miniBtn.Font = Enum.Font.Code
miniBtn.TextSize = 28
miniBtn.TextColor3 = Color3.fromRGB(255,255,255)
miniBtn.Visible = false
miniBtn.Parent = gui
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0,25)
miniCorner.Parent = miniBtn

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniBtn.Visible = true
	menuAbierto = false
end)
miniBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	miniBtn.Visible = false
	menuAbierto = true
end)

-- Función crear interruptor
local function crearInterruptor(parent, y, nombre, callback)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0,180,0,40)
	lbl.Position = UDim2.new(0,10,0,y)
	lbl.BackgroundTransparency = 1
	lbl.Text = nombre
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 20
	lbl.TextColor3 = Color3.fromRGB(200,150,255)
	lbl.Parent = parent

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0,40,0,20)
	toggle.Position = UDim2.new(1,-50,0,y+10)
	toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
	toggle.BorderSizePixel = 0
	toggle.Parent = parent
	toggle.ClipsDescendants = true
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0,10)
	toggleCorner.Parent = toggle

	local estado = false
	local function actualizar()
		toggle.BackgroundColor3 = estado and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
	end

	toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			estado = not estado
			actualizar()
			callback(estado)
		end
	end)

	lbl.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			estado = not estado
			actualizar()
			callback(estado)
		end
	end)
end

-- Función crear submenú
local function crearSubmenu(titulo, opciones)
	if subMenuAbierto then
		subMenuAbierto:Destroy()
	end
	local sub = Instance.new("Frame")
	sub.Size = UDim2.new(0,300,0,50+#opciones*50)
	sub.Position = UDim2.new(0.5,-150,0.5,-25-#opciones*25)
	sub.BackgroundColor3 = Color3.fromRGB(25,15,45)
	sub.BorderSizePixel = 0
	sub.ClipsDescendants = true
	sub.Active = true
	sub.Draggable = true
	sub.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,12)
	corner.Parent = sub
	Neon(sub, Color3.fromRGB(200,150,255))

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,0,0,40)
	lbl.Position = UDim2.new(0,0,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = titulo
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 24
	lbl.TextColor3 = Color3.fromRGB(200,150,255)
	lbl.Parent = sub

	local btnCerrar = Instance.new("TextButton")
	btnCerrar.Size = UDim2.new(0,25,0,25)
	btnCerrar.Position = UDim2.new(1,-30,0,5)
	btnCerrar.Text = "X"
	btnCerrar.Font = Enum.Font.Code
	btnCerrar.TextSize = 20
	btnCerrar.TextColor3 = Color3.fromRGB(255,0,0)
	btnCerrar.BackgroundColor3 = Color3.fromRGB(30,20,40)
	btnCerrar.BorderSizePixel = 0
	btnCerrar.Parent = sub
	btnCerrar.MouseButton1Click:Connect(function()
		sub:Destroy()
		subMenuAbierto = nil
	end)

	for i,opt in ipairs(opciones) do
		crearInterruptor(sub, 40 + (i-1)*45, opt.nombre, opt.callback)
	end

	subMenuAbierto = sub
end

-- Función crear botón principal
local function crearBoton(nombre, y, opciones)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,240,0,45)
	btn.Position = UDim2.new(0.5,-120,0,y)
	btn.BackgroundColor3 = Color3.fromRGB(35,20,60)
	btn.TextColor3 = Color3.fromRGB(200,150,255)
	btn.Text = nombre
	btn.Font = Enum.Font.Code
	btn.TextSize = 22
	btn.Parent = frame
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = btn
	Neon(btn, Color3.fromRGB(200,150,255))

	btn.MouseEnter:Connect(function()
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn:TweenSize(UDim2.new(0,260,0,50),"Out","Quad",0.2,true)
	end)
	btn.MouseLeave:Connect(function()
		btn.TextColor3 = Color3.fromRGB(200,150,255)
		btn:TweenSize(UDim2.new(0,240,0,45),"Out","Quad",0.2,true)
	end)

	btn.MouseButton1Click:Connect(function()
		crearSubmenu(nombre, opciones)
	end)
end

-- Botones principales con sub-opciones
crearBoton("Main", 100, {
	{name="Speed Boost", callback=function(state) print("Speed Boost:", state) end},
	{name="Jump Boost", callback=function(state) print("Jump Boost:", state) end}
})
crearBoton("PvP", 160, {
	{name="Auto Hit", callback=function(state) print("Auto Hit:", state) end},
	{name="Auto Medusa", callback=function(state) print("Auto Medusa:", state) end}
})
crearBoton("Laser Lagger", 220, {
	{name="Activar Laser", callback=function(state) print("Laser Lagger:", state) end}
})
crearBoton("ZZZ", 280, {
	{name="Activar ZZZ", callback=function(state) print("ZZZ:", state) end}
})

-- Botón Discord redondo
local discordBtn = Instance.new("ImageButton")
discordBtn.Size = UDim2.new(0,50,0,50)
discordBtn.Position = UDim2.new(1,-60,1,-60)
discordBtn.BackgroundTransparency = 1
discordBtn.Image = "rbxassetid://9069883411" -- Logo Discord
discordBtn.Parent = frame
local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0,25)
discordCorner.Parent = discordBtn
Neon(discordBtn, Color3.fromRGB(200,150,255))

discordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/SB5AFaA5uW")
end)
