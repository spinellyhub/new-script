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

-- Función para neón animado
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
frame.Size = UDim2.new(0, 500, 0, 550)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(35, 20, 60)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = frame

Neon(frame, Color3.fromRGB(200, 150, 255))

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.Font = Enum.Font.Code
title.TextSize = 36
title.Text = ""
title.TextStrokeColor3 = Color3.new(0, 0, 0)
title.TextStrokeTransparency = 0.5
title.Parent = frame

-- Animación del título
if not titleAnimado then
	titleAnimado = true
	spawn(function()
		local fullTitle = "SPINELLY HUB"
		for i = 1, #fullTitle do
			local glitch = ""
			for j = 1, i do
				if math.random(1, 4) == 1 then
					glitch = glitch .. string.char(math.random(33, 126))
				else
					glitch = glitch .. fullTitle:sub(j, j)
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
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Botón “S” morado para restaurar, ahora movible
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 50, 0, 50)
miniBtn.Position = UDim2.new(0, 50, 1, -70)
miniBtn.AnchorPoint = Vector2.new(0.5, 0.5)
miniBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
miniBtn.Text = "S"
miniBtn.Font = Enum.Font.Code
miniBtn.TextSize = 28
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Visible = false
miniBtn.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 25)
miniCorner.Parent = miniBtn

-- Hacer botón mini movible
local dragging = false
local dragInput, dragStart, startPos

miniBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = miniBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

miniBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(
			math.clamp(startPos.X.Scale, 0, 1),
			math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - miniBtn.AbsoluteSize.X),
			math.clamp(startPos.Y.Scale, 0, 1),
			math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - miniBtn.AbsoluteSize.Y)
		)
		miniBtn.Position = newPos
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniBtn.Visible = true
	menuAbierto = false

	-- Al minimizar, cerrar submenú si existe
	if subMenuAbierto then
		subMenuAbierto:Destroy()
		subMenuAbierto = nil
	end
end)

miniBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	miniBtn.Visible = false
	menuAbierto = true
end)

-- Función para crear interruptor con animación (deslizante)
local function crearInterruptor(parent, y, nombre, callback)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 180, 0, 40)
	lbl.Position = UDim2.new(0, 10, 0, y)
	lbl.BackgroundTransparency = 1
	lbl.Text = nombre
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 20
	lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
	lbl.Parent = parent

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0, 50, 0, 25)
	toggle.Position = UDim2.new(1, -60, 0, y + 7)
	toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	toggle.BorderSizePixel = 0
	toggle.Parent = parent
	toggle.ClipsDescendants = true
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggle

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 23, 0, 23)
	circle.Position = UDim2.new(0, 1, 0, 1)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BorderSizePixel = 0
	circle.Parent = toggle
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

	local estado = false

	local function actualizar()
		if estado then
			toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			circle:TweenPosition(UDim2.new(0, 26, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			circle:TweenPosition(UDim2.new(0, 1, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		end
	end

	local function cambiarEstado()
		estado = not estado
		actualizar()
		callback(estado)
	end

	toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cambiarEstado()
		end
	end)

	circle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cambiarEstado()
		end
	end)

	lbl.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cambiarEstado()
		end
	end)

	actualizar()
end

-- Función para crear submenú
local function crearSubmenu(titulo, opciones)
	if subMenuAbierto then
		subMenuAbierto:Destroy()
		subMenuAbierto = nil
	end
	local sub = Instance.new("Frame")
	sub.Size = UDim2.new(0, 320, 0, 60 + #opciones * 50)
	sub.Position = UDim2.new(0.5, -160, 0.5, -30 - (#opciones * 25))
	sub.BackgroundColor3 = Color3.fromRGB(40, 25, 65)
	sub.BorderSizePixel = 0
	sub.ClipsDescendants = true
	sub.Active = true
	sub.Draggable = true
	sub.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = sub

	Neon(sub, Color3.fromRGB(200, 150, 255))

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 40)
	lbl.Position = UDim2.new(0, 0, 0, 10)
	lbl.BackgroundTransparency = 1
	lbl.Text = titulo
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 26
	lbl.TextColor3 = Color3.fromRGB(200, 150, 255)
	lbl.Parent = sub

	local btnCerrar = Instance.new("TextButton")
	btnCerrar.Size = UDim2.new(0, 30, 0, 30)
	btnCerrar.Position = UDim2.new(1, -35, 0, 10)
	btnCerrar.Text = "X"
	btnCerrar.Font = Enum.Font.Code
	btnCerrar.TextSize = 24
	btnCerrar.TextColor3 = Color3.fromRGB(255, 0, 0)
	btnCerrar.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
	btnCerrar.BorderSizePixel = 0
	btnCerrar.Parent = sub

	local btnCerrarCorner = Instance.new("UICorner")
	btnCerrarCorner.CornerRadius = UDim.new(0, 6)
	btnCerrarCorner.Parent = btnCerrar

	btnCerrar.MouseButton1Click:Connect(function()
		sub:Destroy()
		subMenuAbierto = nil
	end)

	for i, opt in ipairs(opciones) do
		crearInterruptor(sub, 60 + (i - 1) * 45, opt.nombre, opt.callback)
	end

	subMenuAbierto = sub
end

-- Función crear botón principal
local function crearBoton(nombre, y, opciones)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 240, 0, 45)
	btn.Position = UDim2.new(0.5, -120, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
	btn.TextColor3 = Color3.fromRGB(200, 150, 255)
	btn.Text = nombre
	btn.Font = Enum.Font.Code
	btn.TextSize = 22
	btn.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	Neon(btn, Color3.fromRGB(200, 150, 255))

	btn.MouseEnter:Connect(function()
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn:TweenSize(UDim2.new(0, 260, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)

	btn.MouseLeave:Connect(function()
		btn.TextColor3 = Color3.fromRGB(200, 150, 255)
		btn:TweenSize(UDim2.new(0, 240, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)

	btn.MouseButton1Click:Connect(function()
		-- Cerrar submenú abierto si hay alguno
		if subMenuAbierto then
			subMenuAbierto:Destroy()
			subMenuAbierto = nil
		end
		crearSubmenu(nombre, opciones)
	end)
end

-- Opciones con callbacks reales (puedes ajustar las funciones a lo que quieras que hagan)
local opcionesMain = {
	{nombre = "Speed Boost", callback = function(state) print("Speed Boost:", state) end},
	{nombre = "Jump Boost", callback = function(state) print("Jump Boost:", state) end}
}

local opcionesPvP = {
	{nombre = "Auto Hit", callback = function(state) print("Auto Hit:", state) end},
	{nombre = "Auto Medusa", callback = function(state) print("Auto Medusa:", state) end}
}

local opcionesLaser = {
	{nombre = "Activar Laser", callback = function(state) print("Laser Lagger:", state) end}
}

local opcionesZZZ = {
	{nombre = "Activar ZZZ", callback = function(state) print("ZZZ:", state) end}
}

-- Crear botones principales con opciones
crearBoton("Main", 100, opcionesMain)
crearBoton("PvP", 160, opcionesPvP)
crearBoton("Laser Lagger", 220, opcionesLaser)
crearBoton("ZZZ", 280, opcionesZZZ)

-- Botón Discord redondo
local discordBtn = Instance.new("ImageButton")
discordBtn.Size = UDim2.new(0, 50, 0, 50)
discordBtn.Position = UDim2.new(1, -60, 1, -60)
discordBtn.BackgroundTransparency = 1
discordBtn.Image = "rbxassetid://9069883411" -- Logo Discord oficial
discordBtn.Parent = frame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 25)
discordCorner.Parent = discordBtn

Neon(discordBtn, Color3.fromRGB(200, 150, 255))

discordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/SB5AFaA5uW")
end)
