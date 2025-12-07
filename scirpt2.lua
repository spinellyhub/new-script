--==================================================
--           SPINELLY HUB - LUX EDITION UI
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("SpinellyHub") then
    PlayerGui.SpinellyHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SpinellyHub"
gui.Parent = PlayerGui
gui.IgnoreGuiInset = true

local estadosInterruptores = {}

---------------------------------------------------------------------
-- 🔮 EFECTO GLASS (CRISTAL) + SOMBRA + ANIMACIÓN SUAVE DE APARICIÓN
---------------------------------------------------------------------

local function glass(obj)
    local blur = Instance.new("UIGradient")
    blur.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220,220,255))
    }
    blur.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.80),
        NumberSequenceKeypoint.new(1, 0.80)
    }
    blur.Rotation = 45
    blur.Parent = obj
end

local function shadow(obj)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49,49,450,450)
    shadow.Size = UDim2.new(1,35,1,35)
    shadow.Position = UDim2.new(0,-17,0,-17)
    shadow.ImageTransparency = 0.45
    shadow.Parent = obj
end

local function aparecer(obj)
    obj.BackgroundTransparency = 1
    obj.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, obj.Position.Y.Scale+0.02, obj.Position.Y.Offset)

    task.spawn(function()
        for i=1,20 do
            obj.BackgroundTransparency -= 0.05
            obj.Position = obj.Position:Lerp(
                UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, obj.Position.Y.Scale - 0.001, obj.Position.Y.Offset),
                0.3
            )
            task.wait(0.01)
        end
    end)
end

---------------------------------------------------------------------
-- 🟪 FRAME PRINCIPAL GLASS + SOMBRA + ANIMACIÓN
---------------------------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 580, 0, 600)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,18)
corner.Parent = frame

glass(frame)
shadow(frame)
aparecer(frame)

---------------------------------------------------------------------
-- ✨ TÍTULO ANIMADO + SUBRAYADO BRILLANTE
---------------------------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,70)
title.Position = UDim2.new(0,0,0,10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(210,160,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 42
title.Text = "SPINELLY HUB"
title.Parent = frame

local subrayado = Instance.new("Frame")
subrayado.Size = UDim2.new(0.4,0,0,3)
subrayado.Position = UDim2.new(0.3,0,0,65)
subrayado.BackgroundColor3 = Color3.fromRGB(210,160,255)
subrayado.BorderSizePixel = 0
subrayado.Parent = frame

local subCorner = Instance.new("UICorner")
subCorner.CornerRadius = UDim.new(1,0)
subCorner.Parent = subrayado

-- Animación vibrante
spawn(function()
    while true do
        subrayado:TweenSize(UDim2.new(0.45,0,0,4), "Out", "Quad", 1, true)
        task.wait(1)
        subrayado:TweenSize(UDim2.new(0.35,0,0,3), "Out", "Quad", 1, true)
        task.wait(1)
    end
end)

---------------------------------------------------------------------
-- ❌ BOTÓN CERRAR / 🔽 MINI-BOTÓN RESTAURAR
---------------------------------------------------------------------

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,35,0,35)
closeBtn.Position = UDim2.new(1,-45,0,8)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamMedium
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

local cbCorner = Instance.new("UICorner")
cbCorner.CornerRadius = UDim.new(1,0)
cbCorner.Parent = closeBtn

-- Mini botón restaurar
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0,60,0,60)
miniBtn.Position = UDim2.new(0.1,0,0.9,0)
miniBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
miniBtn.Text = "⚡"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.TextSize = 28
miniBtn.Visible = false
miniBtn.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1,0)
miniCorner.Parent = miniBtn

---------------------------------------------------------------------
-- 🎛 BOTONES BONITOS DEL MENÚ
---------------------------------------------------------------------

local function crearBoton(nombre, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 300, 0, 55)
    btn.Position = UDim2.new(0.5, -150, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(55, 35, 80)
    btn.Text = nombre
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = Color3.fromRGB(210,160,255)
    btn.TextSize = 26
    btn.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 14)
    c.Parent = btn

    shadow(btn)

    -- Hover suave
    btn.MouseEnter:Connect(function()
        btn:TweenSize(UDim2.new(0, 320, 0, 60), "Out", "Quad", 0.2, true)
        btn.TextColor3 = Color3.new(1,1,1)
    end)
    btn.MouseLeave:Connect(function()
        btn:TweenSize(UDim2.new(0, 300, 0, 55), "Out", "Quad", 0.2, true)
        btn.TextColor3 = Color3.fromRGB(210,160,255)
    end)

    return btn
end

---------------------------------------------------------------------
-- 🎛 SUBMENÚ MODERNO CON SCROLL
---------------------------------------------------------------------

local subMenuAbierto = nil

local function crearSubmenu(titulo, lista)
    if subMenuAbierto then subMenuAbierto:Destroy() end

    local sub = Instance.new("Frame")
    sub.Size = UDim2.new(0, 350, 0, 450)
    sub.Position = UDim2.new(0.5, -175, 0.5, -225)
    sub.BackgroundColor3 = Color3.fromRGB(40,25,60)
    sub.BorderSizePixel = 0
    sub.Active = true
    sub.Draggable = true
    sub.Parent = gui

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,16)
    c.Parent = sub

    glass(sub)
    shadow(sub)
    aparecer(sub)

    -- Título
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,60)
    lbl.BackgroundTransparency = 1
    lbl.Text = titulo
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 32
    lbl.TextColor3 = Color3.fromRGB(210,160,255)
    lbl.Parent = sub

    -- Botón cerrar
    local x = Instance.new("TextButton")
    x.Size = UDim2.new(0,30,0,30)
    x.Position = UDim2.new(1,-40,0,10)
    x.BackgroundColor3 = Color3.fromRGB(255,80,80)
    x.Text = "✕"
    x.Font = Enum.Font.Gotham
    x.TextColor3 = Color3.new(1,1,1)
    x.TextSize = 20
    x.BorderSizePixel = 0
    x.Parent = sub
    local xc = Instance.new("UICorner")
    xc.CornerRadius = UDim.new(1,0)
    xc.Parent = x
    x.MouseButton1Click:Connect(function() sub:Destroy() subMenuAbierto=nil end)

    -- Scroll
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-20,1,-80)
    scroll.Position = UDim2.new(0,10,0,70)
    scroll.CanvasSize = UDim2.new(0,0,0,#lista * 55)
    scroll.BackgroundTransparency = 1
    scroll.Parent = sub

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,10)
    layout.Parent = scroll

    -- Interruptores
    local function toggleUI(nombre, callback)
        local cont = Instance.new("Frame")
        cont.Size = UDim2.new(1,-20,0,45)
        cont.BackgroundColor3 = Color3.fromRGB(55,35,80)
        cont.Parent = scroll

        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(0,14)
        cc.Parent = cont

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(0.6,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Text = nombre
        txt.Font = Enum.Font.Gotham
        txt.TextSize = 22
        txt.TextColor3 = Color3.fromRGB(210,160,255)
        txt.Parent = cont

        local sw = Instance.new("TextButton")
        sw.Size = UDim2.new(0,70,0,30)
        sw.Position = UDim2.new(1,-80,0.5,-15)
        sw.BackgroundColor3 = Color3.fromRGB(255,70,70)
        sw.Text = ""
        sw.BorderSizePixel = 0
        sw.Parent = cont

        local swc = Instance.new("UICorner")
        swc.CornerRadius = UDim.new(1,0)
        swc.Parent = sw

        local circ = Instance.new("Frame")
        circ.Size = UDim2.new(0,26,0,26)
        circ.Position = UDim2.new(0,2,0,2)
        circ.BackgroundColor3 = Color3.new(1,1,1)
        circ.Parent = sw

        local cc2 = Instance.new("UICorner")
        cc2.CornerRadius = UDim.new(1,0)
        cc2.Parent = circ

        if estadosInterruptores[nombre] == nil then estadosInterruptores[nombre]=false end

        local function update()
            if estadosInterruptores[nombre] then
                sw.BackgroundColor3 = Color3.fromRGB(100,255,100)
                circ:TweenPosition(UDim2.new(0,42,0,2), "Out", "Quad", 0.2, true)
            else
                sw.BackgroundColor3 = Color3.fromRGB(255,70,70)
                circ:TweenPosition(UDim2.new(0,2,0,2), "Out", "Quad", 0.2, true)
            end
        end

        sw.MouseButton1Click:Connect(function()
            estadosInterruptores[nombre] = not estadosInterruptores[nombre]
            update()
            callback(estadosInterruptores[nombre])
        end)

        update()
    end

    for _,opt in ipairs(lista) do
        toggleUI(opt.nombre, opt.callback)
    end

    subMenuAbierto = sub
end

---------------------------------------------------------------------
-- 📁 CONFIGURACIÓN DE BOTONES Y SUBMENÚS
---------------------------------------------------------------------

local mainBtn = crearBoton("Main", 120)
mainBtn.MouseButton1Click:Connect(function()
    crearSubmenu("Main", {
        {nombre="Speed Boost", callback=function(s) print("Speed:",s) end},
        {nombre="Jump Boost",  callback=function(s) print("Jump:",s) end},
    })
end)

local pvpBtn = crearBoton("PvP", 190)
pvpBtn.MouseButton1Click:Connect(function()
    crearSubmenu("PvP", {
        {nombre="Auto Hit", callback=function(s) print("Hit:",s) end},
        {nombre="Auto Medusa", callback=function(s) print("Medusa:",s) end},
    })
end)

local laserBtn = crearBoton("Laser Lagger", 260)
laserBtn.MouseButton1Click:Connect(function()
    crearSubmenu("Laser Lagger", {
        {nombre="Activar Laser", callback=function(s) print("Laser:",s) end},
    })
end)

local zzzBtn = crearBoton("ZZZ", 330)
zzzBtn.MouseButton1Click:Connect(function()
    crearSubmenu("ZZZ", {
        {nombre="Activar ZZZ", callback=function(s) print("ZZZ:",s) end},
    })
end)

---------------------------------------------------------------------
-- 🌐 DISCORD ICON BONITO
---------------------------------------------------------------------

local discordBtn = Instance.new("ImageButton")
discordBtn.Size = UDim2.new(0,60,0,60)
discordBtn.Position = UDim2.new(1,-75,1,-75)
discordBtn.BackgroundColor3 = Color3.fromRGB(80,50,120)
discordBtn.Image = "rbxassetid://9069883411"
discordBtn.Parent = frame

local dCorner = Instance.new("UICorner")
dCorner.CornerRadius = UDim.new(1,0)
dCorner.Parent = discordBtn

shadow(discordBtn)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/SB5AFaA5uW")
end)

---------------------------------------------------------------------
-- MINIMIZAR / RESTAURAR
---------------------------------------------------------------------

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    miniBtn.Visible = false
end)
