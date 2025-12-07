-- SPINELLY HUB LUA PURA — FUNCIONAL EN XENO
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

-- Función de neón animado
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

-- Ventana principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,500,0,550)
frame.Position = UDim2.new(0.5,-250,0.5,-275)
frame.BackgroundColor3 = Color3.fromRGB(5,5,5)
frame.BorderSizePixel = 0
frame.Parent = gui
Neon(frame, Color3.fromRGB(0,255,255))
frame.Active = true
frame.Draggable = true

-- Botón cerrar X
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(255,100,100) end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(255,0,0) end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Función para crear interruptor
local function crearInterruptor(parent, y, nombre, callback)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0,180,0,40)
	lbl.Position = UDim2.new(0,10,0,y)
	lbl.BackgroundTransparency = 1
	lbl.Text = nombre
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 20
	lbl.TextColor3 = Color3.fromRGB(0,255,255)
	lbl.Parent = parent

	local toggle = Instance.new("Frame")
	toggle.Size = UDim2.new(0,40,0,20)
	toggle.Position = UDim2.new(1,-50,0,y+10)
	toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
	toggle.BorderSizePixel = 0
	toggle.Parent = parent

	local estado = false

	local function actualizar()
		local color = estado and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		toggle:TweenSize(UDim2.new(0,40,0,20),"Out","Quad",0.2,true)
		toggle.BackgroundColor3 = color
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

-- Función para crear submenús
local function crearSubmenu(titulo, opciones)
	local sub = Instance.new("Frame")
	sub.Size = UDim2.new(0,300,0,50 + #opciones*50)
	sub.Position = UDim2.new(0.5,-150,0.5,-25 - #opciones*25)
	sub.BackgroundColor3 = Color3.fromRGB(15,15,15)
	sub.BorderSizePixel = 0
	sub.Parent = gui
	sub.Active = true
	sub.Draggable = true
	Neon(sub, Color3.fromRGB(0,255,255))

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,0,0,40)
	lbl.Position = UDim2.new(0,0,0,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = titulo
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 24
	lbl.TextColor3 = Color3.fromRGB(0,255,255)
	lbl.Parent = sub

	local btnCerrar = Instance.new("TextButton")
	btnCerrar.Size = UDim2.new(0,25,0,25)
	btnCerrar.Position = UDim2.new(1,-30,0,5)
	btnCerrar.Text = "X"
	btnCerrar.Font = Enum.Font.Code
	btnCerrar.TextSize = 20
	btnCerrar.TextColor3 = Color3.fromRGB(255,0,0)
	btnCerrar.BackgroundColor3 = Color3.fromRGB(20,20,20)
	btnCerrar.BorderSizePixel = 0
	btnCerrar.Parent = sub
	btnCerrar.MouseButton1Click:Connect(function() sub:Destroy() end)

	-- Crear botones/interruptores
	for i,opt in ipairs(opciones) do
		crearInterruptor(sub, 40 + (i-1)*45, opt.nombre, opt.callback)
	end
end

-- Función para crear botones principales
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

-- BOTONES PRINCIPALES Y SUBMENÚS CON INTERRUPTORES
crearBoton("Main", 100, function()
	crearSubmenu("MAIN MODE", {
		{nombre="Speed Boost", callback=function(state) print("Speed Boost:", state) end},
		{nombre="Jump Boost", callback=function(state) print("Jump Boost:", state) end}
	})
end)

crearBoton("PvP", 160, function()
	crearSubmenu("PVP MODE", {
		{nombre="Auto Hit", callback=function(state) print("Auto Hit:", state) end},
		{nombre="Auto Medusa", callback=function(state) print("Auto Medusa:", state) end}
	})
end)

crearBoton("Laser Lagger", 220, function()
	crearSubmenu("LASER LAGGER", {
		{nombre="Activar Laser", callback=function(state) print("Laser Lagger:", state) end}
	})
end)

crearBoton("ZZZ", 280, function()
	crearSubmenu("ZZZ MODE", {
		{nombre="Activar ZZZ", callback=function(state) print("ZZZ:", state) end}
	})
end)

crearBoton("Discord", 340, function()
	setclipboard("https://discord.gg/")
	print("Discord copiado!")
end)

