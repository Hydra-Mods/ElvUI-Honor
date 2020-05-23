local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local floor = floor
local UnitHonor = UnitHonor
local UnitHonorMax = UnitHonorMax
local UnitHonorLevel = UnitHonorLevel
local BreakUpLargeNumbers = BreakUpLargeNumbers
local Honor = HONOR
local String = "%s: %s / %s"
local Panel

local OnEvent = function(self, event, unit)
	if (unit and unit ~= "player") then
		return
	end
	
	self.text:SetFormattedText(String, Honor, UnitHonor("player"), UnitHonorMax("player"))
	
	Panel = self
end

local OnClick = function()
	PVEFrame_ToggleFrame("PVPUIFrame", "HonorFrame")
end

local OnEnter = function(self)
	DT:SetupTooltip(self)
	
	local Honor = UnitHonor("player")
	local MaxHonor = UnitHonorMax("player")
	local Percent = floor((Honor / MaxHonor * 100 + 0.05) * 10) / 10
	local Remaining = MaxHonor - Honor
	local RemainingPercent = floor((Remaining / MaxHonor * 100 + 0.05) * 10) / 10
	local Kills = GetPVPLifetimeStats()
	
	DT.tooltip:AddLine(format(HONOR_LEVEL_TOOLTIP, UnitHonorLevel("player")))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine("Current honor")
	DT.tooltip:AddDoubleLine(format("%s / %s", BreakUpLargeNumbers(Honor), BreakUpLargeNumbers(MaxHonor)), format("%s%%", Percent), 1, 1, 1, 1, 1, 1)
	
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine("Remaining honor")
	DT.tooltip:AddDoubleLine(format("%s", BreakUpLargeNumbers(Remaining)), format("%s%%", RemainingPercent), 1, 1, 1, 1, 1, 1)
	
	if (Kills > 0) then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(HONORABLE_KILLS)
		DT.tooltip:AddLine(Kills, 1, 1, 1)
	end
	
	DT.tooltip:Show()
end

local ValueColorUpdate = function(hex)
	String = strjoin("", "%s: ", hex, "%s|r / ", hex, "%s|r")
	
	if (Panel ~= nil) then
		OnEvent(Panel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Honor", {"HONOR_XP_UPDATE", "HONOR_LEVEL_UPDATE", "PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick, OnEnter, nil, Honor)