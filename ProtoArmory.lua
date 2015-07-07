-----------------------------------------------------------------------------------------------
-- Client Lua Script for ProtoArmory
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------

require "Apollo" 
require "Window"
require "AchievementsLib"
require "GameLib"
require "Unit"
require "PlayerPathLib"
require "CraftingLib"
--require "Character"
 
-----------------------------------------------------------------------------------------------
-- ProtoArmory Module Definition
-----------------------------------------------------------------------------------------------
local ProtoArmory = {}
local eProperty = {"Brutality", "Finesse", "Moxie", "Tech", "Insight", "Grit"}
local classIdToString =
{
	[GameLib.CodeEnumClass.Warrior] 		= Apollo.GetString("ClassWarrior"),
	[GameLib.CodeEnumClass.Engineer] 		= Apollo.GetString("ClassEngineer"),
	[GameLib.CodeEnumClass.Esper] 			= Apollo.GetString("ClassESPER"),
	[GameLib.CodeEnumClass.Medic] 			= Apollo.GetString("ClassMedic"),
	[GameLib.CodeEnumClass.Stalker] 		= Apollo.GetString("ClassStalker"),
	[GameLib.CodeEnumClass.Spellslinger] 		= Apollo.GetString("ClassSpellslinger"),
}
local pathIdToString =
{
  	[PlayerPathLib.PlayerPathType_Soldier]    = Apollo.GetString("PlayerPathSoldier"),
 	[PlayerPathLib.PlayerPathType_Settler]    = Apollo.GetString("PlayerPathSettler"),
 	[PlayerPathLib.PlayerPathType_Scientist]  = Apollo.GetString("PlayerPathScientist"),
 	[PlayerPathLib.PlayerPathType_Explorer]   = Apollo.GetString("PlayerPathExplorer"),
}
local factionIdToString =
{
	[Unit.CodeEnumFaction.ExilesPlayer] 	= Apollo.GetString("CRB_Exile"),
	[Unit.CodeEnumFaction.DominionPlayer] 	= Apollo.GetString("CRB_Dominion"),
}
local raceIdToString =
{
	[GameLib.CodeEnumRace.Human] 	= Apollo.GetString("RaceHuman"),
	[GameLib.CodeEnumRace.Granok] 	= Apollo.GetString("RaceGranok"),
	[GameLib.CodeEnumRace.Aurin] 	= Apollo.GetString("RaceAurin"),
	[GameLib.CodeEnumRace.Draken] 	= Apollo.GetString("RaceDraken"),
	[GameLib.CodeEnumRace.Mechari] 	= Apollo.GetString("RaceMechari"),
	[GameLib.CodeEnumRace.Chua] 	= Apollo.GetString("RaceChua"),
	[GameLib.CodeEnumRace.Mordesh] 	= Apollo.GetString("CRB_Mordesh"),
}
local genderIdToString =
{
	[Unit.CodeEnumGender.Male]		= Apollo.GetString("CRB_Male"),
	[Unit.CodeEnumGender.Female]		= Apollo.GetString("CRB_Female"),
	[Unit.CodeEnumGender.Uni]		= "Uni"
}
local slotsIdToString = -- each one has the slot name and then the corresponding UI window
{
	[GameLib.CodeEnumEquippedItems.Chest] 				= Apollo.GetString("InventorySlot_Chest"),
	[GameLib.CodeEnumEquippedItems.Legs] 				= Apollo.GetString("InventorySlot_Legs"),
	[GameLib.CodeEnumEquippedItems.Head] 				= Apollo.GetString("InventorySlot_Head"),
	[GameLib.CodeEnumEquippedItems.Shoulder] 			= Apollo.GetString("InventorySlot_Shoulder"),
	[GameLib.CodeEnumEquippedItems.Feet] 				= Apollo.GetString("InventorySlot_Feet"),
	[GameLib.CodeEnumEquippedItems.Hands] 				= Apollo.GetString("InventorySlot_Hands"),
	[GameLib.CodeEnumEquippedItems.WeaponTool]			= "Tool",
	[GameLib.CodeEnumEquippedItems.WeaponAttachment]		= "Weapon Attachment",
	[GameLib.CodeEnumEquippedItems.System]				= "Support System",
	[GameLib.CodeEnumEquippedItems.Augment]				= Apollo.GetString("InventorySlot_Augment"),
	[GameLib.CodeEnumEquippedItems.Implant]				= "Implant",
	[GameLib.CodeEnumEquippedItems.Gadget]				= Apollo.GetString("InventorySlot_Gadget"),
	[GameLib.CodeEnumEquippedItems.Shields]				= Apollo.GetString("InventorySlot_Shields"),
	[GameLib.CodeEnumEquippedItems.WeaponPrimary] 			= Apollo.GetString("InventorySlot_WeaponPrimary")
}
local qualityIdToString =
{
	[Item.CodeEnumItemQuality.Inferior]			= Apollo.GetString("CRB_Inferior"),
	[Item.CodeEnumItemQuality.Average]			= Apollo.GetString("CRB_Average"),
	[Item.CodeEnumItemQuality.Good]				= Apollo.GetString("CRB_Good"),
	[Item.CodeEnumItemQuality.Excellent]			= Apollo.GetString("CRB_Excellent"),
	[Item.CodeEnumItemQuality.Superb]			= Apollo.GetString("CRB_Superb"),
	[Item.CodeEnumItemQuality.Legendary]			= Apollo.GetString("CRB_Legendary"),
	[Item.CodeEnumItemQuality.Artifact]			= Apollo.GetString("CRB_Artifact")
}
local runeIdToString =
{
	[Item.CodeEnumRuneType.Air] 				= Apollo.GetString("CRB_Air"),
	[Item.CodeEnumRuneType.Water] 				= Apollo.GetString("CRB_Water"),
	[Item.CodeEnumRuneType.Earth] 				= Apollo.GetString("CRB_Earth"),
	[Item.CodeEnumRuneType.Fire] 				= Apollo.GetString("CRB_Fire"),
	[Item.CodeEnumRuneType.Logic] 				= Apollo.GetString("CRB_Logic"),
	[Item.CodeEnumRuneType.Life] 				= Apollo.GetString("CRB_Life"),
	[Item.CodeEnumRuneType.Omni] 				= Apollo.GetString("CRB_Omni"),
	[Item.CodeEnumRuneType.Fusion] 				= Apollo.GetString("CRB_Fusion"),
}
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function ProtoArmory:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here
	self.CharAddon = Apollo.GetAddon("Character")
    return o
end

function ProtoArmory:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		-- "UnitOrPackageName",
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end
 
function ProtoArmory:OnDependencyError(strDep, strError)
	-- if you don't care about this dependency, return true.
	-- if you return false, or don't define this function
	-- any Addons/Packages that list you as a dependency
	-- will also receive a dependency error

	--if strDep == "MountCustomization" or strDep == "Reputation" then
	   return true
	--end

	--return false
end

-----------------------------------------------------------------------------------------------
-- ProtoArmory OnLoad
-----------------------------------------------------------------------------------------------
function ProtoArmory:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("ProtoArmory.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- ProtoArmory OnDocLoaded
-----------------------------------------------------------------------------------------------
function ProtoArmory:OnDocLoaded()

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
	    self.wndMain = Apollo.LoadForm(self.xmlDoc, "ProtoArmoryForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		
	    self.wndMain:Show(false, true)

		-- if the xmlDoc is no longer needed, you should set it to nil
		-- self.xmlDoc = nil
		
		-- Register handlers for events, slash commands and timer, etc.
		-- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)
		Apollo.RegisterSlashCommand("armory", "OnProtoArmoryOn", self)
		Apollo.RegisterEventHandler("ToggleCharacterWindow", "InitUI", self)

		-- Do additional Addon initialization here
		self.wndChar = self.CharAddon.wndCharacter:FindChild("CharFrame_BGArt")
		local DoneUI = false
	end
end

-----------------------------------------------------------------------------------------------
-- ProtoArmory Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here
function	ProtoArmory:InitUI()
	if not DoneUI then
		self.wndCharFrame_Armory = Apollo.LoadForm(self.xmlDoc, "CharFrame_Armory", self.wndChar, self)
		
		self.wndArmoryCheckBtn = self.wndCharFrame_Armory:FindChild("SelectSetWindowToggle")
		self.wndArmorySelectionList = self.wndCharFrame_Armory:FindChild("ArmoryBtnHolder")
		self.wndArmoryCheckBtn:AttachWindow(self.wndArmorySelectionList)
		self.wndArmorySelectionList:Show(false)
		DoneUI = true
	end
end
-- on SlashCommand "/armory"
function ProtoArmory:OnProtoArmoryOn()
	
	local unitPlayer = GameLib.GetPlayerUnit()
	
	arCharacter = 
	{
		{
			strName		= "Name",
			strValue	= unitPlayer:GetName() or ""
		},
		{
			strName		= "Title",
			strValue	= unitPlayer:GetTitle() or ""
		},
		{
			strName		= "Level",
			strValue	= unitPlayer:GetLevel() or ""
		},
		{
			strName		= "Faction",
			strValue	= factionIdToString[unitPlayer:GetFaction()] or ""
		},
		{
			strName		= "Achievement Points",
			strValue	= AchievementsLib.GetAchievementPoints()
		},
		{
			strName		= "Guild",
			strValue	= unitPlayer:GetGuildName() or ""
		},
		{
			strName		= "Race",
			strValue	= raceIdToString[unitPlayer:GetRaceId()] or ""
		},
		{
			strName		= "Gender",
			strValue	= genderIdToString[unitPlayer:GetGender()] or ""
		},
		{
			strName		= "Class",
			strValue	= classIdToString[unitPlayer:GetClassId()] or ""
		},
		{	strName		= "Path",
			strValue	= pathIdToString[unitPlayer:GetPlayerPathType()] or ""
		},
		{	strName		= "Path Level",
			strValue	= PlayerPathLib.GetPathLevel()
		}
	}
		
	arProperties = unitPlayer:GetUnitProperties()
	arPropertiesFiltered = {}
	for i, v in pairs(arProperties) do
		for n = 1, 6 do
			if v["strDisplayName"] == eProperty[n] then
				arPropertiesFiltered[n] =
				{
					strName	= v["strDisplayName"],
					nValue = v["fValue"]
				}
			end
		end
	end
	
	arPrimaryAttributes =
	{
		{
			strName 	= Apollo.GetString("Character_MaxHealthLabel"),
			nValue 		= math.ceil(unitPlayer:GetMaxHealth() or 0),
			strTooltip 	= Apollo.GetString("CRB_Health_Description")
		},
		{
			strName 	= Apollo.GetString("Character_MaxShieldLabel"),
			nValue 		= math.ceil(unitPlayer:GetShieldCapacityMax() or 0),
			strTooltip 	= Apollo.GetString("Character_MaxShieldTooltip")
		},
		{
			strName 	= Apollo.GetString("AttributeAssaultPower"),
			nValue 		= math.floor(unitPlayer:GetAssaultPower() + .5 or 0),
			strTooltip 	= Apollo.GetString("Character_AssaultTooltip")
		},
		{
			strName 	= Apollo.GetString("AttributeSupportPower"),
			nValue 		= math.floor(unitPlayer:GetSupportPower() + .5 or 0),
			strTooltip 	= Apollo.GetString("Character_SupportTooltip")
		},
		{
			strName 	= Apollo.GetString("CRB_Armor"),
			nValue 		= math.floor(arProperties and arProperties.Armor and (arProperties.Armor.fValue + .5) or 0),
			strTooltip 	= Apollo.GetString("Character_ArmorTooltip")
		}
	}
	
	arSecondaryAttributes =
	{
		{
			strName 	= Apollo.GetString("Character_StrikethroughLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetStrikethroughChance() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_StrikethroughTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_AvoidReduce).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_CritChanceLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetCritChance() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_CritTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_CritChanceIncrease).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_CritSeverityLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetCritSeverity() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_CritSevTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingCritSeverityIncrease).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_ArmorPenLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetIgnoreArmorBase() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_ArmorPenTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_ShieldPenLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetIgnoreShieldBase() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_ShieldPenTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_LifestealLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetBaseLifesteal() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_LifestealTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_HasteLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(-1 * math.floor((unitPlayer:GetCooldownReductionModifier() + 0.000005 - 1) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_HasteTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_ShieldRegenPercentLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetShieldRegenPct() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_ShieldRegenPercentTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_ShieldRebootLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_SecondsLabel"), Apollo.FormatNumber(unitPlayer:GetShieldRebootTime() / 1000, 2, true)),
			strTooltip 	= Apollo.GetString("Character_ShieldRebootTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_PhysicalMitLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetPhysicalMitigation() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_PhysMitTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistPhysical).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_TechMitLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetTechMitigation() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_TechMitTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistTech).fValue))
		},
		{
			strName 	= Apollo.GetString("Character_MagicMitLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetMagicMitigation() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_MagicMitTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistMagic).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_DeflectLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetDeflectChance() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_DeflectTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_AvoidIncrease).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_DeflectCritLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetDeflectCritChance() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_CritDeflectTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_CritChanceDecrease).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_ResilianceLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((math.abs(unitPlayer:GetCCDurationModifier() -1) + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_ResilianceTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_ManaRecoveryLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PerSecLabel"), Apollo.FormatNumber(unitPlayer:GetManaRegenInCombat() * 2, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_ManaRecoveryTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ManaPerFiveSeconds).fValue, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_ManaCostRedLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((math.abs(unitPlayer:GetManaCostModifier() -1) + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= Apollo.GetString("Character_ManaCostRedTooltip")
		},
		{
			strName 	= Apollo.GetString("Character_PvPOffenseLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetPvPDamageI() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_PvPOffenseTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPOffensiveRating).fValue, 2, true),
						  Apollo.FormatNumber(math.floor((unitPlayer:GetPvPDamageO() + 0.000005) * 10000) / 100, 2, true))
		},
		{	-- GOTCHA: Healing actually uses PvPOffenseRating, which is called PvP Power to the player
			strName 	= Apollo.GetString("Character_PvPHealLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetPvPHealingI() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_PvPHealingTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPOffensiveRating).fValue, 2, true),
						  Apollo.FormatNumber(math.floor((unitPlayer:GetPvPHealingO() + 0.000005) * 10000) / 100, 2, true))
		},
		{
			strName 	= Apollo.GetString("Character_PvPDefLabel"),
			strValue 	= String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((1 - unitPlayer:GetPvPDefenseI() + 0.000005) * 10000) / 100, 2, true)),
			strTooltip 	= String_GetWeaselString(Apollo.GetString("Character_PvPDefenseTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPDefensiveRating).fValue, 2, true),
						  Apollo.FormatNumber(math.floor((1 - unitPlayer:GetPvPDefenseO() + 0.000005) * 10000) / 100, 2, true))
		},
	}
	
	arEquippedItems = {}
	for key, itemEquipped in pairs(unitPlayer:GetEquippedItems()) do
		if itemEquipped ~= nil and itemEquipped:GetSlot() <= 16 then
			local itemInfo = Item.GetDetailedInfo(itemEquipped)
			local itemSlot = slotsIdToString[itemEquipped:GetSlot()]
			arEquippedItems[itemSlot] =
			{
				strName		= itemSlot,
				strValue	= itemEquipped:GetName() .." ".. itemEquipped:GetItemId(),
				strQuality	= qualityIdToString[itemEquipped:GetItemQuality()]
			}
			
			local itemRuneData = itemEquipped:GetRuneSlots()
			--local itemEngravingInfo = CraftingLib.GetEngravingInfo(itemEquipped)
			if itemRuneData then
				arEquippedItems[itemSlot]["Runes"] = {}
				for nRuneIndex, tCurrRuneSlot in pairs(itemRuneData.arRuneSlots) do
					local itemRune = Item.GetDataFromId(tCurrRuneSlot.idRune)
					arEquippedItems[itemSlot]["Runes"][nRuneIndex] =
					{
						strName = itemRune:GetName(),
						strType	= runeIdToString[tCurrRuneSlot.eType]
					}
				end
			end
		end
	end
	
	arRuneSets = {}
	arRuneSetsTemp = {}
	for idx, itemCurr in pairs(CraftingLib.GetItemsWithRuneSlots(true, false)) do
		for idx2, tSetInfo in ipairs(itemCurr:GetSetBonuses()) do
			if tSetInfo and tSetInfo.strName and not arRuneSetsTemp[tSetInfo.strName] then
				arRuneSetsTemp[tSetInfo.strName] = tSetInfo
			end
		end
	end

	for idx, tSetInfo in pairs(arRuneSetsTemp) do
		--String_GetWeaselString(Apollo.GetString("EngravingStation_RuneSetText"), tSetInfo.strName, tSetInfo.nPower, tSetInfo.nMaxPower))
		arRuneSets[idx] =
		{
			strName 	= tSetInfo.strName,
			nValue 		= tSetInfo.nPower,
			nMaxValue	= tSetInfo.nMaxPower
		}
	end
	
	--Debug Print
	for i, v in pairs(arCharacter) do
		Print(v["strName"] .. ": " .. v["strValue"])
	end
	
	for i, v in pairs(arPrimaryAttributes) do
		Print(v["strName"] .. ": " .. v["nValue"])
	end
	for i, v in pairs(arPropertiesFiltered) do
		Print(v["strName"] .. ": " .. v["nValue"])
	end
	for i, v in pairs(arSecondaryAttributes) do
		Print(v["strName"] .. ": " .. v["strValue"])
	end
	for k, v in pairs(arEquippedItems) do
		Print(v["strName"] .. ": " .. v["strValue"])
		Print(v["strQuality"])
		if v["Runes"] then
			for idx, value in pairs(v["Runes"]) do
				Print(idx .. ": " .. value["strType"] .. " - " .. value["strName"])
			end
		end
	end
	for k, v in pairs(arRuneSets) do
		Print(v["strName"] .. " (" .. v["nValue"] .. "/" .. v["nMaxValue"] .. ")")
	end
	if self.tSavedData then
		for k, v in pairs(self.tSavedData) do
			Print(k .. ": " .. v["charName"])
		end
	end

	--Print(unit:GetId())	
	
	--self.wndMain:Invoke() -- show the window
end

function ProtoArmory:OnSave(eLevel)
	if eLevel == GameLib.CodeEnumAddonSaveLevel.General then return end
	local playerName = GameLib.GetPlayerUnit():GetName()
	local tPlayer = { charName = playerName, charUnit = { arPrimaryAttributes, arPropertiesFiltered, arSecondaryAttributes } }
	local playerExist = 0
	local n = 0
	local tSave = self.tSavedData or {}
	
	if self.tSavedData and eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then
		for k, v in pairs(tSave) do
			n = n + 1
			if v["charName"] == playerName then
				tSave[n] = tPlayer
				playerExist = 1
			end
		end
	else
		tSave = { tPlayer }
		playerExist = 1
	end
	
	if playerExist == 0 then
		tSave[n+1] = tPlayer
	end
	
	return tSave
end

function ProtoArmory:OnRestore(eLevel, tData)
	if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Account then return end
	self.tSavedData = tData
end

function ProtoArmory:GetJabbitholeItemId(item)
	local id="invalid"
	if item then
		id=item:GetChatLinkString()
		local info=item:GetDetailedInfo().tPrimary
		local rnp = 0
		if info.arRandomProperties then
			rnp = #info.arRandomProperties
		end
		local smin = 0
		local smax = 0
		if info.tSigils then
			if info.tSigils.nMaximum then
				smax=info.tSigils.nMaximum 
			end
			if info.tSigils.nMinimum then
				smin=info.tSigils.nMinimum 
			end
		end
		id = id.."-"..rnp.."-"..smin.."-"..smax
	end
	return id
end
-----------------------------------------------------------------------------------------------
-- ProtoArmoryForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function ProtoArmory:OnOK()
	self.wndMain:Close() -- hide the window
end

-- when the Cancel button is clicked
function ProtoArmory:OnCancel()
	self.wndMain:Close() -- hide the window
end


---------------------------------------------------------------------------------------------------
-- CharFrame_Armory Functions
---------------------------------------------------------------------------------------------------

function ProtoArmory:OnArmoryBtnToggle( wndHandler, wndControl, eMouseButton )
end

function ProtoArmory:OnSettingsBtn( wndHandler, wndControl, eMouseButton )
end

-----------------------------------------------------------------------------------------------
-- ProtoArmory Instance
-----------------------------------------------------------------------------------------------
local ProtoArmoryInst = ProtoArmory:new()
ProtoArmoryInst:Init()
