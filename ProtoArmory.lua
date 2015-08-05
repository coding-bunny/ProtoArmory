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
local XmlDocument = {}
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
local tradeskillTierToString =
{
  [CraftingLib.CodeEnumTradeskillTier.Novice] = Apollo.GetString("CRB_Tradeskill_Novice"),
  [CraftingLib.CodeEnumTradeskillTier.Apprentice] = Apollo.GetString("CRB_Tradeskill_Apprentice"),
  [CraftingLib.CodeEnumTradeskillTier.Journeyman] = Apollo.GetString("CRB_Tradeskill_Journeyman"),
  [CraftingLib.CodeEnumTradeskillTier.Artisan] = Apollo.GetString("CRB_Tradeskill_Artisan"),
  [CraftingLib.CodeEnumTradeskillTier.Expert] = Apollo.GetString("CRB_Tradeskill_Expert"),
  [CraftingLib.CodeEnumTradeskillTier.Master] = Apollo.GetString("CRB_Tradeskill_Master")
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
  self.tData = { 
    arCharacter = {},
    arProperties = {},
    arPrimaryAttributes = {},
    arSecondaryAttributes = {},
    arEquippedItems = {},
    arRuneSets = {},
    arAchievements = {},
    arPets = {},
    arMounts = {}
  }
  
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
		
		-- Load XmlDocument into memory so we can create proper XML documents
		XmlDocument = Apollo.GetPackage("Drafto:Lib:XmlDocument-1.0").tPackage
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

function ProtoArmory:StoreCharacterAttribute(strName, strValue)
  table.insert(self.tData["arCharacter"], { ["strName"] = strName, ["strValue"] = strValue })
end

function ProtoArmory:StorePrimaryAttribute(strName, strValue, strTooltip)
  table.insert(self.tData["arPrimaryAttributes"], { ["strName"] = strName, ["strValue"] = strValue, ["strTooltip"] = strTooltip })
end

function ProtoArmory:StoreSecondaryAttribute(strName, strValue, strTooltip)
  table.insert(self.tData["arSecondaryAttributes"], { ["strName"] = strName, ["strValue"] = strValue, ["strTooltip"] = strTooltip })
end
-- Collects all information about the currently played Character and stores
-- it in the self.tData.arCharacter table of the Addon.
function ProtoArmory:CollectCharacterInfo()
  local unitPlayer = GameLib.GetPlayerUnit() 
  
  self:StoreCharacterAttribute("Name", unitPlayer:GetName() or "")
  self:StoreCharacterAttribute("Title", unitPlayer:GetTitle() or "")
  self:StoreCharacterAttribute("Level", unitPlayer:GetLevel() or "")
  self:StoreCharacterAttribute("Faction", factionIdToString[unitPlayer:GetFaction()] or "")
  self:StoreCharacterAttribute("Achievement Points", AchievementsLib.GetAchievementPoints())
  self:StoreCharacterAttribute("Guild", unitPlayer:GetGuildName() or "")
  self:StoreCharacterAttribute("Race", raceIdToString[unitPlayer:GetRaceId()] or "")
  self:StoreCharacterAttribute("Gender", genderIdToString[unitPlayer:GetGender()] or "")
  self:StoreCharacterAttribute("Class", classIdToString[unitPlayer:GetClassId()] or "")
  self:StoreCharacterAttribute("Path", pathIdToString[unitPlayer:GetPlayerPathType()] or "")
  self:StoreCharacterAttribute("Path Level", PlayerPathLib.GetPathLevel())
  self:CollectGuildRank()
end

-- Collects the guild rank of the current Unit.
-- This is done by iterating over the "guilds" the character is part of and finding the
-- actual guild, then reading out the rank.
function ProtoArmory:CollectGuildRank()
  local unitPlayer = GameLib.GetPlayerUnit()
  local arGuilds = GuildLib.GetGuilds()
  
  for i = 1, #arGuilds do
    if arGuilds[i]:GetType() == 1 then
      self:StoreCharacterAttribute("nGuildRank", arGuilds[i]:GetMyRank())
    end
  end
end

-- Collects all properties of the character and stores the ones we're interested about
-- in the self.tData.arProperties table of the Addon.
function ProtoArmory:CollectProperties()
  local unitPlayer = GameLib:GetPlayerUnit()
  local arProperties = unitPlayer:GetUnitProperties()
  
  for i, v in pairs(arProperties) do
    for n = 1, 6 do
      if v["strDisplayName"] == eProperty[n] then
        table.insert(self.tData["arProperties"], { strName = v["strDisplayName"], nValue = v["fValue"] })
      end
    end
  end
end


-- Collects all primary attributes of the currently played character and stores them
-- in the self.tData.arPrimaryProperties table of the Addon.
function ProtoArmory:CollectPrimaryAttributes()
  local unitPlayer = GameLib.GetPlayerUnit() 
  
  self:StorePrimaryAttribute(Apollo.GetString("Character_MaxHealthLabel"), math.ceil(unitPlayer:GetMaxHealth() or 0), Apollo.GetString("CRB_Health_Description"))
  self:StorePrimaryAttribute(Apollo.GetString("Character_MaxShieldLabel"), math.ceil(unitPlayer:GetShieldCapacityMax() or 0), Apollo.GetString("Character_MaxShieldTooltip"))
  self:StorePrimaryAttribute(Apollo.GetString("AttributeAssaultPower"), math.floor(unitPlayer:GetAssaultPower() + .5 or 0), Apollo.GetString("Character_AssaultTooltip"))
  self:StorePrimaryAttribute(Apollo.GetString("AttributeSupportPower"), math.floor(unitPlayer:GetSupportPower() + .5 or 0), Apollo.GetString("Character_SupportTooltip"))
  self:StorePrimaryAttribute(Apollo.GetString("CRB_Armor"), math.floor(arProperties and arProperties.Armor and (arProperties.Armor.fValue + .5) or 0), Apollo.GetString("Character_ArmorTooltip"))
end

-- Collects all secondary attributes of the currently played character and stores them
-- in the self.tData.arSecondaryProperties table of the Addon.
function ProtoArmory:CollectSecondaryAttributes()
  local unitPlayer = GameLib.GetPlayerUnit()

  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_StrikethroughLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetStrikethroughChance() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_StrikethroughTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_AvoidReduce).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_CritChanceLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetCritChance() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_CritTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_CritChanceIncrease).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_CritSeverityLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetCritSeverity() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_CritSevTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingCritSeverityIncrease).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ArmorPenLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetIgnoreArmorBase() + 0.000005) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_ArmorPenTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ShieldPenLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetIgnoreShieldBase() + 0.000005) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_ShieldPenTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_LifestealLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetBaseLifesteal() + 0.000005) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_LifestealTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_HasteLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(-1 * math.floor((unitPlayer:GetCooldownReductionModifier() + 0.000005 - 1) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_HasteTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ShieldRegenPercentLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetShieldRegenPct() + 0.000005) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_ShieldRegenPercentTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ShieldRebootLabel"),
    String_GetWeaselString(Apollo.GetString("Character_SecondsLabel"), Apollo.FormatNumber(unitPlayer:GetShieldRebootTime() / 1000, 2, true)),
    Apollo.GetString("Character_ShieldRebootTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_PhysicalMitLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetPhysicalMitigation() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_PhysMitTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistPhysical).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_TechMitLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetTechMitigation() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_TechMitTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistTech).fValue))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_MagicMitLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetMagicMitigation() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_MagicMitTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistMagic).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_DeflectLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetDeflectChance() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_DeflectTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_AvoidIncrease).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_DeflectCritLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetDeflectCritChance() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_CritDeflectTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_CritChanceDecrease).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ResilianceLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((math.abs(unitPlayer:GetCCDurationModifier() -1) + 0.000005) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_ResilianceTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ManaRecoveryLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PerSecLabel"), Apollo.FormatNumber(unitPlayer:GetManaRegenInCombat() * 2, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_ManaRecoveryTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ManaPerFiveSeconds).fValue, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_ManaCostRedLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((math.abs(unitPlayer:GetManaCostModifier() -1) + 0.000005) * 10000) / 100, 2, true)),
    Apollo.GetString("Character_ManaCostRedTooltip")
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_PvPOffenseLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetPvPDamageI() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_PvPOffenseTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPOffensiveRating).fValue, 2, true), Apollo.FormatNumber(math.floor((unitPlayer:GetPvPDamageO() + 0.000005) * 10000) / 100, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_PvPHealLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((unitPlayer:GetPvPHealingI() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_PvPHealingTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPOffensiveRating).fValue, 2, true), Apollo.FormatNumber(math.floor((unitPlayer:GetPvPHealingO() + 0.000005) * 10000) / 100, 2, true))
  )
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_PvPDefLabel"),
    String_GetWeaselString(Apollo.GetString("Character_PercentAppendLabel"), Apollo.FormatNumber(math.floor((1 - unitPlayer:GetPvPDefenseI() + 0.000005) * 10000) / 100, 2, true)),
    String_GetWeaselString(Apollo.GetString("Character_PvPDefenseTooltip"), Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPDefensiveRating).fValue, 2, true), Apollo.FormatNumber(math.floor((1 - unitPlayer:GetPvPDefenseO() + 0.000005) * 10000) / 100, 2, true))
  )
end

-- Collects all equipped items and Runes on the currently played character and stores them
-- in the self.tData.arEquippedItems table of the Addon.
function ProtoArmory:CollectEquipment()
  local unitPlayer = GameLib.GetPlayerUnit()
  
  for key, itemEquipped in pairs(unitPlayer:GetEquippedItems()) do
    if itemEquipped ~= nil and itemEquipped:GetSlot() <= 16 then
      local itemInfo = Item.GetDetailedInfo(itemEquipped)
      local itemSlot = slotsIdToString[itemEquipped:GetSlot()]
      
      self.tData.arEquippedItems[itemSlot] = {
        strName = itemSlot, 
        strValue  = itemEquipped:GetName(),
        nId = itemEquipped:GetItemId(), 
        strQuality  = qualityIdToString[itemEquipped:GetItemQuality()],
        nItemPower = itemEquipped:GetItemPower(),
        nItemLevel = itemInfo.nEffectiveLevel,
        nRequiredLevel = itemEquipped:GetPowerLevel()
      }
      
      local itemRuneData = itemEquipped:GetRuneSlots()
      
      if itemRuneData then
        self.tData.arEquippedItems[itemSlot]["Runes"] = {}
        
        for nRuneIndex, tCurrRuneSlot in pairs(itemRuneData.arRuneSlots) do
          local itemRune = Item.GetDataFromId(tCurrRuneSlot.idRune)
          
          if itemRune then
            local runeInfo = itemRune:GetRuneInfo()
            
            self.tData.arEquippedItems[itemSlot]["Runes"][nRuneIndex] = {
              strName = itemRune:GetName(),
              strType = runeIdToString[tCurrRuneSlot.eType],
              nId = itemRune:GetItemId(),
              strAttribute = runeInfo.strUnitPropertyName,
              nBudget = itemInfo.tPrimary.tRunes.arRuneSlots[nRuneIndex].nBudget,
              strQuality = qualityIdToString[itemRune:GetItemQuality()]                        
            }
          end
        end
      end
    end
  end
end

-- Collects all Rune sets on the currently played character and stores them
-- in the self.tData.arRuneSets table of the Addon.
function ProtoArmory:CollectRuneSets()
  local arRuneSetsTemp = {}
  
  for idx, itemCurr in pairs(CraftingLib.GetItemsWithRuneSlots(true, false)) do
    for idx2, tSetInfo in ipairs(itemCurr:GetSetBonuses()) do
      if tSetInfo and tSetInfo.strName and not arRuneSetsTemp[tSetInfo.strName] then
        arRuneSetsTemp[tSetInfo.strName] = tSetInfo
      end
    end
  end

  for k,v in pairs(arRuneSetsTemp) do
    self.tData.arRuneSets[k] = { strName = v.strName, nPower = v.nPower, nMaxPower = v.nMaxPower }
  end
end

-- Collects all the pets available for the player and stores them inside the
-- arPets array.
function ProtoArmory:CollectPets()
  local arPets = GameLib.GetVanityPetList()
  
  for i = 1, #arPets do
    if arPets[i].bIsKnown then
      local tPet = {
        nId = arPets[i].nId,
        strName = arPets[i].strName
      }
      
      table.insert(self.tData.arPets, tPet)
    end
  end
end

function ProtoArmory:CollectMounts()
  local arMounts = GameLib.GetMountList()
  
  for i = 1, #arMounts do
    if arMounts[i].bIsKnown then
      local tMount = {
        nId = arMounts[i].nId,
        strName = arMounts[i].strName
      }
      
      table.insert(self.tData.arMounts, tMount)
    end
  end
end

-- on SlashCommand "/armory"
function ProtoArmory:OnProtoArmoryOn()
	self:CollectCharacterInfo()
	self:CollectProperties()
	self:CollectPrimaryAttributes()
  self:CollectSecondaryAttributes()
	self:CollectEquipment()
  self:CollectRuneSets()
  self:CollectPets()
  self:CollectMounts()
  self:GenerateXML()
	
	--self.wndMain:Invoke() -- show the window
end

-- Generates the XML dump file for the currently played character and stores it inside the Addon folder's location.
function ProtoArmory:GenerateXML()
  -- Create the document
  local xDoc = XmlDocument.New()
  
  -- Add the child element to represent our character
  local characterNode = xDoc:NewNode("character")
  xDoc:SetRoot(characterNode)
  
  self:WriteCharacterInfo(xDoc, characterNode)
  self:WritePropertiesInfo(xDoc, characterNode)
  self:WritePrimaryAttributes(xDoc, characterNode)
  self:WriteSecondaryAttributes(xDoc, characterNode)
  self:WriteEquipment(xDoc, characterNode)
  self:WriteRuneSets(xDoc, characterNode)
  self:WriteAchievements(xDoc, characterNode)
  self:WritePets(xDoc, characterNode)
  self:WriteMounts(xDoc, characterNode)
  self:WriteReputations(xDoc, characterNode)
  self:WriteTradeskills(xDoc, characterNode)
  
  -- Output
  self.strXml = "<?xml version=\"1.0\"?>\r\n"..xDoc:Serialize()
    
end

function ProtoArmory:WriteCharacterInfo(xmlDoc, xNode)
  local xInfo = xmlDoc:NewNode("character_info")
  xNode:AddChild(xInfo)
     
  for i = 1, #self.tData.arCharacter do
    local nNode = xmlDoc:NewNode("character", self.tData.arCharacter[i])
    xInfo:AddChild(nNode)
  end
end

function ProtoArmory:WritePropertiesInfo(xmlDoc, xNode)
  local xProperties = xmlDoc:NewNode("properties")
  xNode:AddChild(xProperties)
  
  for i = 1, #self.tData.arProperties do
    local nNode = xmlDoc:NewNode("rattribute", self.tData.arProperties[i])
    xProperties:AddChild(nNode)
  end
end

function ProtoArmory:WritePrimaryAttributes(xmlDoc, xNode)
  local xAttributes = xmlDoc:NewNode("primary_attributes")
  xNode:AddChild(xAttributes)
  
  for i = 1, #self.tData.arPrimaryAttributes do
    local nNode = xmlDoc:NewNode("pattribute", self.tData.arPrimaryAttributes[i])
    xAttributes:AddChild(nNode)
  end
end

function ProtoArmory:WriteSecondaryAttributes(xmlDoc, xNode)
  local xAttributes = xmlDoc:NewNode("secondary_attributes")
  xNode:AddChild(xAttributes)
  
  for i = 1, #self.tData.arSecondaryAttributes do
    local nNode = xmlDoc:NewNode("sattribute", self.tData.arSecondaryAttributes[i])
    xAttributes:AddChild(nNode)
  end
end

function ProtoArmory:WriteEquipment(xmlDoc, xNode)
  local xEquipment = xmlDoc:NewNode("equipment")
  xNode:AddChild(xEquipment)
   
  for k,v in pairs(self.tData.arEquippedItems) do
    local itemNode = xmlDoc:NewNode("item", { itemslot = k })
    xEquipment:AddChild(itemNode)
    
    local propertyNode = xmlDoc:NewNode("properties", { strName = v.strName, strValue = v.strValue, strQuality = v.strQuality, nId = v.nId, nLevel = v.nLevel })
    itemNode:AddChild(propertyNode)
    
    -- Now the runes of it.    
    if self.tData.arEquippedItems[k]["Runes"] then
      local runeNode = xmlDoc:NewNode("runes")
      itemNode:AddChild(runeNode)
      
      for i = 1, #self.tData.arEquippedItems[k]["Runes"] do            
        local nNode = xmlDoc:NewNode("rune", self.tData.arEquippedItems[k]["Runes"][i])
        runeNode:AddChild(nNode)
      end
    end
  end
end
  
function ProtoArmory:WriteRuneSets(xmlDoc, xNode)
  local xRuneSets = xmlDoc:NewNode("rune_sets")
  xNode:AddChild(xRuneSets)
  
  for k,v in pairs(self.tData.arRuneSets) do
    local nNode = xmlDoc:NewNode("set", v)
    xRuneSets:AddChild(nNode)
  end
end
  
-- Writes out the entire Achievement tree
-- ALL OF IT!
function ProtoArmory:WriteAchievements(xmlDoc, xNode)
  local xAchievements = xmlDoc:NewNode("achievements")
  xNode:AddChild(xAchievements)
  
  -- Collect all the categories that exist for achievements.
  -- This is a complete tree we will have to navigate.
  local arTree = AchievementsLib.GetAchievementCategoryTree()
  
  -- Iterate over the entire tree, and let's collect the achievements per category.
  for i = 1, #arTree do
    -- Create the table that will store the category holding every achievement.
    local tCategory = {}
    
    -- Store the Category Information and prepare the achievement array 
    -- as well as the group array to hold all groups of this category.
    tCategory.nId = arTree[i].nCategoryId
    tCategory.strName = arTree[i].strCategoryName
    
    -- Add the node to our parent
    local nodeCategory = xmlDoc:NewNode("category", tCategory)
    xAchievements:AddChild(nodeCategory)
    
    -- Collect the achievements for the Category.
    local arAchievements = AchievementsLib.GetAchievementsForCategory(arTree[i].nCategoryId, true)    
    
    -- Iterate over each achievement we have found for this category.
    for j = 1, #arAchievements do
      local achievement = {
        strName = string.gsub(arAchievements[j]:GetName(), '"', "'"),
        nId = arAchievements[j]:GetId(),
        nPoints = arAchievements[j]:GetPoints(),
        strDescription = string.gsub(arAchievements[j]:GetProgressText(), "%b<>", ""),
        nNeeded = arAchievements[j]:GetNumNeeded() or "n.a",
        nCompleted = arAchievements[j]:GetNumCompleted() or "n.a",
        bCompleted = tostring(arAchievements[j]:IsComplete())
      }
      
      -- Set some additional values when the Achievement is complete.
      if arAchievements[j]:IsComplete() then
        achievement.strCompletedOn = arAchievements[j]:GetDateCompleted()
        
        local reward = arAchievements[j]:GetRewards()
        
        if reward.GetTitle ~= nil then
          achievement.strReward = reward:GetTitle() 
        else
          achievement.strReward = "n.a"
        end
        
        achievement.strDescription = string.gsub(arAchievements[j]:GetDescription(), "%b<>", "")
      end
          
      -- Create the node for it using the table and add it to the category.
      local node = xmlDoc:NewNode("achievement", achievement)
      nodeCategory:AddChild(node)
    end
  end 
end

-- Writes out all the pets stored.
function ProtoArmory:WritePets(xmlDoc, xNode)
    local xPets = xmlDoc:NewNode("pets")
    xNode:AddChild(xPets)
    
    for i = 1, #self.tData.arPets do
      local nNode = xmlDoc:NewNode("pet", self.tData.arPets[i])
      xPets:AddChild(nNode)
    end
end

function ProtoArmory:WriteMounts(xmlDoc, xNode)
    local xMounts = xmlDoc:NewNode("mounts")
    xNode:AddChild(xMounts)
    
    for i = 1, #self.tData.arMounts do
      local nNode = xmlDoc:NewNode("mount", self.tData.arMounts[i])
      xMounts:AddChild(nNode)
    end
end

function ProtoArmory:WriteReputations(xmlDoc, xNode)
  local xReputations = xmlDoc:NewNode("reputations")
  xNode:AddChild(xReputations)
  
  local arReputations = GameLib.GetReputationInfo()
  
  for i = 1, #arReputations do
    local tReputation = {
      strName = arReputations[i].strName,
      strParent = arReputations[i].strParent,
      nLevel = arReputations[i].nLevel,
      nCurrent = arReputations[i].nCurrent
    }
    local node = xmlDoc:NewNode("reputation", tReputation)
    xReputations:AddChild(node)    
  end
end

function ProtoArmory:WriteTradeskills(xmlDoc, xNode)
  local xTradeskills = xmlDoc:NewNode("tradeskills")
  xNode:AddChild(xTradeskills)
  
  local arTradeskills = CraftingLib.GetKnownTradeskills()
  
  for i = 1, #arTradeskills do
    local tInfo = CraftingLib.GetTradeskillInfo(arTradeskills[i].eId)    
    local tTradeskill = {
      strName = arTradeskills[i].strName,
      strTier = tradeskillTierToString[tInfo.eTier],
      nExp = tInfo.nXp,
      nMaxExp = tInfo.nXpMax
    }
    local node = xmlDoc:NewNode("tradeskill", tTradeskill)
    xTradeskills:AddChild(node)
  end
end

function ProtoArmory:OnSave(eLevel)
	if eLevel == GameLib.CodeEnumAddonSaveLevel.General then return end	
	if self.strXml and eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then
    return { strXml = self.strXml }		
	end
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
