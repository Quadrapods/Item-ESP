--[[
///////////////////////////////////////////////////////////////////////////
        @Name: Item ESP
        @Date: 12/7/2021
---------------------------------------------------------------------------
        @Engine: Luau
        @Author: pluto ☆#9760
///////////////////////////////////////////////////////////////////////////
]]--

---------------------------------------------------------------------------------------------------- // Dependencies
local ESP = loadstring(syn.request({Url = 'https://raw.githubusercontent.com/Quadrapods/ESP-Library/main/Library.lua', Method = 'GET'}).Body)()

---------------------------------------------------------------------------------------------------- // Declarations
local a = game:GetService('Players').LocalPlayer
local b = game:GetService('UserInputService')
local c = game:GetService('HttpService')
local d = game:GetService('RunService')
local e = game:GetService('Workspace')

local f = Color3.fromRGB
local g = Vector2.new

local h = math.floor
local i = math.ceil

local j = g(e.CurrentCamera.ViewportSize.X / 2, e.CurrentCamera.ViewportSize.Y - 135)

---------------------------------------------------------------------------------------------------- // Tables
local Colors = {Default = f(255, 127, 255), Outline = f(0, 0, 0)}

local Properties = {
    Line = {
        From         = j,
        Color        = Colors.Default,
        ZIndex       = 3,
        Thickness    = 1.5,
        Transparency = 0.5,
    },
    Text = {
        Size         = 18,
        Font         = Drawing.Fonts.UI,
        Color        = Colors.Default,
        ZIndex       = 1,
        Center       = true,
        Outline      = true,
        OutlineColor = Colors.Outline,
        Transparency = 1,
    },
    TSub = {
        Size         = 16,
        Font         = Drawing.Fonts.UI,
        Color        = Colors.Default,
        ZIndex       = 2,
        Center       = true,
        Outline      = true,
        OutlineColor = Colors.Outline,
        Transparency = 1,
    },
    Circle = {
        Color        = Colors.Default,
        ZIndex       = 4,
        Radius       = 10,
        Filled       = false,
        NumSides     = 30,
        Thickness    = 1.5,
        Transparency = 0.5,
    },
}

---------------------------------------------------------------------------------------------------- // Functions
function ESP:GetProperty(a)
    if (a and a:IsA('Tool')) then
        if (a.CanBeDropped) then
            return ('Droppable'), (true)
        else
            return ('Undroppable'), (false)
        end
    else
        return ('BasePart'), (false)
    end
end

function ESP.Create(a, b, ...)
    local y = {...}
    local z = {
        Part1 = ESP.new('Line', y[1]),
        Part2 = ESP.new('Text', y[2]),
        Part3 = ESP.new('Text', y[3]),
        Part4 = ESP.new('Circle', y[4]),
    }

    local Part5 = ESP.Outline(a, y[1])
    z.Part2.Text = tostring(b.Name)

    local function Update()
        local c
        c = d.RenderStepped:Connect(function()
            if (e:IsAncestorOf(a)) then
                if (ESP:GetObjectRender(a)) then
                    z.Part1.To = ESP:GetObjectVector(a)
                    z.Part4.Position = ESP:GetObjectVector(a)
                    z.Part2.Position = ESP:GetObjectVector(a, 0, 40)
                    z.Part3.Position = ESP:GetObjectVector(a, 0, 25)

                    z.Part3.Text = string.format('[%s] [%s]', ESP:GetMagnitude(a), ESP:GetProperty(b))

                    for _, v in pairs(z) do
                        v.Visible = true
                    end
                else
                    for _, v in pairs(z) do
                        v.Visible = false
                    end
                end
            else
                for _, v in pairs(z) do
                    v:Remove()
                end
                c:Disconnect()
            end
        end)
    end
    task.spawn(Update)
end

function ESP.Add(a, b)
    ESP.Create(a, b, Properties.Line, Properties.Text, Properties.TSub, Properties.Circle)
end

---------------------------------------------------------------------------------------------------- // Runtime
for _, v in ipairs(e:GetDescendants()) do
    if (v and v:IsA('Tool') and v:FindFirstChild('Handle')) then
        local x = v:WaitForChild('Handle'); ESP.Add(x, v)
    end
end

e.DescendantAdded:Connect(function(v)
    d.RenderStepped:Wait()
    if (v and v:IsA('Tool') and v:FindFirstChild('Handle')) then
        local x = v:WaitForChild('Handle'); ESP.Add(x, v)
    end
end)
