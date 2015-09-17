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
require "HousingLib"
require "Residence"
require "CollectiblesLib"
 
-----------------------------------------------------------------------------------------------
-- ProtoArmory Module Definition
-----------------------------------------------------------------------------------------------
local ProtoArmory = {}
local XmlDocument = {}
local classIdToString = {
  [GameLib.CodeEnumClass.Warrior] = Apollo.GetString("ClassWarrior"),
  [GameLib.CodeEnumClass.Engineer] = Apollo.GetString("ClassEngineer"),
  [GameLib.CodeEnumClass.Esper] = Apollo.GetString("ClassESPER"),
  [GameLib.CodeEnumClass.Medic] = Apollo.GetString("ClassMedic"),
  [GameLib.CodeEnumClass.Stalker] = Apollo.GetString("ClassStalker"),
  [GameLib.CodeEnumClass.Spellslinger] = Apollo.GetString("ClassSpellslinger"),
}
local pathIdToString = {
  [PlayerPathLib.PlayerPathType_Soldier] = Apollo.GetString("PlayerPathSoldier"),
  [PlayerPathLib.PlayerPathType_Settler] = Apollo.GetString("PlayerPathSettler"),
  [PlayerPathLib.PlayerPathType_Scientist] = Apollo.GetString("PlayerPathScientist"),
  [PlayerPathLib.PlayerPathType_Explorer] = Apollo.GetString("PlayerPathExplorer"),
}
local factionIdToString = {
  [Unit.CodeEnumFaction.ExilesPlayer] = Apollo.GetString("CRB_Exile"),
  [Unit.CodeEnumFaction.DominionPlayer] = Apollo.GetString("CRB_Dominion"),
}
local raceIdToString = {
  [GameLib.CodeEnumRace.Human] = Apollo.GetString("RaceHuman"),
  [GameLib.CodeEnumRace.Granok] = Apollo.GetString("RaceGranok"),
  [GameLib.CodeEnumRace.Aurin] = Apollo.GetString("RaceAurin"),
  [GameLib.CodeEnumRace.Draken] = Apollo.GetString("RaceDraken"),
  [GameLib.CodeEnumRace.Mechari] = Apollo.GetString("RaceMechari"),
  [GameLib.CodeEnumRace.Chua] = Apollo.GetString("RaceChua"),
  [GameLib.CodeEnumRace.Mordesh] = Apollo.GetString("CRB_Mordesh"),
}
local genderIdToString = {
  [Unit.CodeEnumGender.Male]	= Apollo.GetString("CRB_Male"),
  [Unit.CodeEnumGender.Female]	= Apollo.GetString("CRB_Female"),
  [Unit.CodeEnumGender.Uni]	= Apollo.GetString("CRB_Unknown")
}
local slotsIdToString = {
	[GameLib.CodeEnumEquippedItems.Chest] = Apollo.GetString("InventorySlot_Chest"),
	[GameLib.CodeEnumEquippedItems.Legs] = Apollo.GetString("InventorySlot_Legs"),
	[GameLib.CodeEnumEquippedItems.Head] = Apollo.GetString("InventorySlot_Head"),
	[GameLib.CodeEnumEquippedItems.Shoulder] = Apollo.GetString("InventorySlot_Shoulder"),
	[GameLib.CodeEnumEquippedItems.Feet] = Apollo.GetString("InventorySlot_Feet"),
	[GameLib.CodeEnumEquippedItems.Hands] = Apollo.GetString("InventorySlot_Hands"),
	[GameLib.CodeEnumEquippedItems.WeaponTool]	= Apollo.GetString("CRB_Tool"),
	[GameLib.CodeEnumEquippedItems.WeaponAttachment]	= "Weapon Attachment",
	[GameLib.CodeEnumEquippedItems.System] = "Support System",
	[GameLib.CodeEnumEquippedItems.Augment]	= Apollo.GetString("InventorySlot_Augment"),
	[GameLib.CodeEnumEquippedItems.Implant]	= "Implant",
	[GameLib.CodeEnumEquippedItems.Gadget] = Apollo.GetString("InventorySlot_Gadget"),
	[GameLib.CodeEnumEquippedItems.Shields]	= Apollo.GetString("InventorySlot_Shields"),
	[GameLib.CodeEnumEquippedItems.WeaponPrimary]	= Apollo.GetString("InventorySlot_WeaponPrimary")
}
local qualityIdToString = {
	[Item.CodeEnumItemQuality.Inferior]	= Apollo.GetString("CRB_Inferior"),
	[Item.CodeEnumItemQuality.Average]	= Apollo.GetString("CRB_Average"),
	[Item.CodeEnumItemQuality.Good]	= Apollo.GetString("CRB_Good"),
	[Item.CodeEnumItemQuality.Excellent] = Apollo.GetString("CRB_Excellent"),
	[Item.CodeEnumItemQuality.Superb]	= Apollo.GetString("CRB_Superb"),
	[Item.CodeEnumItemQuality.Legendary] = Apollo.GetString("CRB_Legendary"),
	[Item.CodeEnumItemQuality.Artifact] = Apollo.GetString("CRB_Artifact")
}
local runeIdToString = {
	[Item.CodeEnumRuneType.Air]	= Apollo.GetString("CRB_Air"),
	[Item.CodeEnumRuneType.Water]	= Apollo.GetString("CRB_Water"),
	[Item.CodeEnumRuneType.Earth] = Apollo.GetString("CRB_Earth"),
	[Item.CodeEnumRuneType.Fire] = Apollo.GetString("CRB_Fire"),
	[Item.CodeEnumRuneType.Logic] = Apollo.GetString("CRB_Logic"),
	[Item.CodeEnumRuneType.Life] = Apollo.GetString("CRB_Life"),
	[Item.CodeEnumRuneType.Fusion] = Apollo.GetString("CRB_Fusion"),
}
local tradeskillTierToString = {
  [CraftingLib.CodeEnumTradeskillTier.Novice] = Apollo.GetString("CRB_Tradeskill_Novice"),
  [CraftingLib.CodeEnumTradeskillTier.Apprentice] = Apollo.GetString("CRB_Tradeskill_Apprentice"),
  [CraftingLib.CodeEnumTradeskillTier.Journeyman] = Apollo.GetString("CRB_Tradeskill_Journeyman"),
  [CraftingLib.CodeEnumTradeskillTier.Artisan] = Apollo.GetString("CRB_Tradeskill_Artisan"),
  [CraftingLib.CodeEnumTradeskillTier.Expert] = Apollo.GetString("CRB_Tradeskill_Expert"),
  [CraftingLib.CodeEnumTradeskillTier.Master] = Apollo.GetString("CRB_Tradeskill_Master")
}
local guildTypeToRatingType = {
  [GuildLib.GuildType_ArenaTeam_2v2] = MatchingGame.RatingType.Arena2v2,
  [GuildLib.GuildType_ArenaTeam_3v3] = MatchingGame.RatingType.Arena3v3,
  [GuildLib.GuildType_ArenaTeam_5v5] = MatchingGame.RatingType.Arena5v5,
  [GuildLib.GuildType_WarParty] = MatchingGame.RatingType.Warplot,
}

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
    arMounts = {},
    arPvP = {},
    arAbilities = {},
    arAMPs = {},
    arHousing = {},
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
  return true
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
  self:StoreCharacterAttribute("Realm", GameLib.GetRealmName())
  self:CollectGuildRank()
end

-- Collects the guild rank of the current Unit.
-- This is done by iterating over the "guilds" the character is part of and finding the
-- actual guild, then reading out the rank.
function ProtoArmory:CollectGuildRank()
  local unitPlayer = GameLib.GetPlayerUnit()
  local arGuilds = GuildLib.GetGuilds()
  
  for i = 1, #arGuilds do
    if arGuilds[i]:GetType() == GuildLib.GuildType_Guild then
      self:StoreCharacterAttribute("nGuildRank", arGuilds[i]:GetMyRank())
    end
  end
end

-- Collects all properties of the character and stores the ones we're interested about
-- in the self.tData.arProperties table of the Addon.
function ProtoArmory:CollectProperties()
  local unitPlayer = GameLib.GetPlayerUnit()
  local arProperties = unitPlayer:GetUnitProperties()
  
  for i, v in pairs(arProperties) do
    if v["strDisplayName"] and v["strDisplayName"] ~= "" then
      table.insert(
        self.tData.arProperties,
        {
          strName = v["strDisplayName"],
          nValue = v["fValue"] 
        }
      )
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
  self:StorePrimaryAttribute(Apollo.GetString("Character_AvgItemLevel"), unitPlayer:GetEffectiveItemLevel() or 0, Apollo.GetString("Character_AvgItemLevelTooltip"))
end

-- Collects all secondary attributes of the currently played character and stores them
-- in the self.tData.arSecondaryProperties table of the Addon.
function ProtoArmory:CollectSecondaryAttributes()
  local unitPlayer = GameLib.GetPlayerUnit()
  
  -- Strikethrough
  local nStrikethrough = unitPlayer:GetStrikethroughChance().nAmount
  local nStrikethroughRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_AvoidReduce).fValue
  local nBaseAvoidanceChance = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseAvoidReduceChance).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseAvoidReduceChance),
    self:WritePercentageString(nStrikethrough),
    String_GetWeaselString(
      Apollo.GetString("Character_StrikethroughTooltip"),
      Apollo.FormatNumber(nStrikethroughRating, 2, true),
      Apollo.FormatNumber(nStrikethrough - nStrikethroughRating, 2, true),
      Apollo.FormatNumber(nBaseAvoidanceChance, 2, true)
    )
  )
  
  -- Crit Chance
  local nCritChance = unitPlayer:GetCritChance().nAmount 
  local nCritSeverityIncrease = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_CritChanceIncrease).fValue
  local nCritChanceBase = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseCritChance).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseCritChance),
    self:WritePercentageString(nCritChance),
    String_GetWeaselString(
      Apollo.GetString("Character_CritTooltip"),
      Apollo.FormatNumber(nCritSeverityIncrease, 2, true),
      Apollo.FormatNumber(nCritChance - nCritChanceBase, 2, true),
      Apollo.FormatNumber(nCritChanceBase, 2, true)
    )
  )  
  
  -- Crit Severity
  local nCritSeverity = unitPlayer:GetCritSeverity().nAmount
  local nCritSeverityRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingCritSeverityIncrease).fValue
  local nCritSeverityMultiplier = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.CriticalHitSeverityMultiplier).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.CriticalHitSeverityMultiplier),
    self:WritePercentageString(nCritSeverity),
    String_GetWeaselString(
      Apollo.GetString("Character_CritSevTooltip"), 
      Apollo.FormatNumber(nCritSeverityRating, 2, true),
      Apollo.FormatNumber(nCritSeverity - nCritSeverityMultiplier, 2, true),
      Apollo.FormatNumber(nCritSeverityMultiplier, 2, true)
    )
  )
  
  -- Multi Hit Chance
  local nMultiHitChance = unitPlayer:GetMultiHitChance().nAmount
  local nRatingMultiHitChance = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingMultiHitChance).fValue * 100
  local nBaseMultiHitChance = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseMultiHitChance).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseMultiHitChance),
    self:WritePercentageString(nMultiHitChance),
    String_GetWeaselString(
      Apollo.GetString("Character_MultiHitChanceTooltip"),
      Apollo.FormatNumber(nRatingMultiHitChance, 2, true),
      Apollo.FormatNumber(nMultiHitChance - nBaseMultiHitChance, 2, true),
      Apollo.FormatNumber(nBaseMultiHitChance, 2, true)
    )
  )
  
  -- Multi Hit Severity
  local nMultiHitSeverity = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingMultiHitAmount).fValue
  local nMultiHitAmount = unitPlayer:GetMultiHitAmount().nAmount
  local nMultiHitBaseAmount = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseMultiHitAmount).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseMultiHitAmount),
    self:WritePercentageString(nMultiHitAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_MultiHitSeverityTooltip"),
      Apollo.FormatNumber(nMultiHitSeverity, 2, true),
      Apollo.FormatNumber(nMultiHitAmount - nMultiHitBaseAmount, 2, true), 
      Apollo.FormatNumber(nMultiHitBaseAmount, 2, true)
    )
  )
  
  -- Vigor
  local nVigor = unitPlayer:GetVigor().nAmount
  local nVigorRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingVigor).fValue
  local nBaseVigor = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseVigor).fValue * 100
    
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseVigor),
    self:WritePercentageString(nVigor),
    String_GetWeaselString(
      Apollo.GetString("Character_VigorTooltip"),
      Apollo.FormatNumber(nVigorRating, 2, true),
      Apollo.FormatNumber(nVigor - nBaseVigor, 2, true),
      Apollo.FormatNumber(nBaseVigor, 2, true)
    )
  )
  
  -- Armor Pierce
  local nArmorPenetration = unitPlayer:GetArmorPierce().nAmount
  local nArmorPenetrationRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingArmorPierce).fValue
  local nArmorPenetrationBase = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.IgnoreArmorBase).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.IgnoreArmorBase),
    self:WritePercentageString(nArmorPenetration),
    String_GetWeaselString(
      Apollo.GetString("Character_ArmorPenTooltip"),
      Apollo.FormatNumber(nArmorPenetrationRating, 2, true),
      Apollo.FormatNumber(nArmorPenetration - nArmorPenetrationBase, 2, true),
      Apollo.FormatNumber(nArmorPenetrationBase, 2, true)
    )
  )
  
  -- Physical Mitigation
  local nPhysicalMitigation = unitPlayer:GetPhysicalMitigation().nAmount
  local nPhysicalMitigationRating = unitPlayer:GetPhysicalMitigationRating()
  local nArmor = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Armor).fValue
  local nPhysicalMitigationOffset = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.DamageMitigationPctOffsetPhysical).fValue
  local nPhysicalMitigationPctOffset = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.DamageMitigationPctOffset).fValue
  local nResistPhysical = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistPhysical).fValue
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.DamageMitigationPctOffsetPhysical),
    self:WritePercentageString(nPhysicalMitigation),
    String_GetWeaselString(
      Apollo.GetString("Character_PhysMitTooltip"),
      Apollo.FormatNumber(nPhysicalMitigationRating + nArmor, 2, true), 
      Apollo.FormatNumber(nPhysicalMitigation - ((nPhysicalMitigationOffset + nPhysicalMitigationPctOffset) * 100), 2, true), 
      Apollo.FormatNumber(nResistPhysical, 2, true),
      Apollo.FormatNumber(nArmor, 2, true), 
      Apollo.FormatNumber((nPhysicalMitigationOffset + nPhysicalMitigationPctOffset) * 100, 2, true)
    )
  )

  -- Technology Mitigation
  local nTechMitigation = unitPlayer:GetTechMitigation().nAmount
  local nTechMitigationRating = unitPlayer:GetTechMitigationRating()
  local nResistTech = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistTech).fValue
  local nTechMitigationPctOffset = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.DamageMitigationPctOffsetTech).fValue
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.DamageMitigationPctOffsetTech),
    self:WritePercentageString(nTechMitigation),
    String_GetWeaselString(
      Apollo.GetString("Character_TechMitTooltip"),
      Apollo.FormatNumber(nTechMitigationRating + nArmor, 2, true), 
      Apollo.FormatNumber(nTechMitigation - ((nTechMitigationPctOffset + nPhysicalMitigationPctOffset) * 100), 2, true),
      Apollo.FormatNumber(nResistTech, 2, true),
      Apollo.FormatNumber(nArmor, 2, true), 
      Apollo.FormatNumber((nTechMitigationPctOffset + nPhysicalMitigationPctOffset) * 100, 2, true))
  )

  -- Magic Mitigation
  local nMagicMitigation = unitPlayer:GetMagicMitigation().nAmount
  local nMagicMitigationRating = unitPlayer:GetMagicMitigationRating()
  local nMagicMitigationOffset = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.DamageMitigationPctOffsetMagic).fValue
  local nResistMagic = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.ResistMagic).fValue
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.DamageMitigationPctOffsetMagic),
    self:WritePercentageString(unitPlayer:GetMagicMitigation().nAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_MagicMitTooltip"), 
      Apollo.FormatNumber(nMagicMitigationRating + nArmor, 2, true), 
      Apollo.FormatNumber(nMagicMitigation - ((nMagicMitigationOffset + nPhysicalMitigationPctOffset) * 100), 2, true),
      Apollo.FormatNumber(nResistMagic, 2, true), 
      Apollo.FormatNumber(nArmor, 2, true),
      Apollo.FormatNumber((nMagicMitigationOffset + nPhysicalMitigationPctOffset) * 100, 2, true)
    )
  )
  
  -- Glance Mitigation
  local nGlance = unitPlayer:GetGlanceAmount().nAmount
  local nGlanceRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingGlanceAmount).fValue
  local nBaseGlance = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseGlanceAmount).fValue  * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseGlanceAmount),
    self:WritePercentageString(nGlance),
    String_GetWeaselString(
      Apollo.GetString("Character_GlanceSeverityTooltip"), 
      Apollo.FormatNumber(nGlanceRating, 2, true),
      Apollo.FormatNumber(nGlance - nBaseGlance, 2, true), 
      Apollo.FormatNumber(nBaseGlance, 2, true)
    )
  )
  
  -- Glance Chance
  local nGlanceChance = unitPlayer:GetGlanceChance().nAmount
  local nGlanceChanceRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingGlanceChance).fValue
  local nBaseGlanceChance = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseGlanceChance).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseGlanceChance),
    self:WritePercentageString(nGlanceChance),
    String_GetWeaselString(
      Apollo.GetString("Character_GlanceChanceTooltip"),
      Apollo.FormatNumber(nGlanceChanceRating, 2, true), 
      Apollo.FormatNumber(nGlanceChance - nBaseGlanceChance, 2, true), 
      Apollo.FormatNumber(nBaseGlanceChance, 2, true)
    )
  )

  -- Critical Mitigation
  local nCriticalMitigation = unitPlayer:GetCriticalMitigation().nAmount
  local nCriticalMitigationRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingCriticalMitigation).fValue
  local nBaseCriticalMitigation = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseCriticalMitigation).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseCriticalMitigation),
    self:WritePercentageString(nCriticalMitigation),
    String_GetWeaselString(
      Apollo.GetString("Character_CritMitigationTooltip"),
      Apollo.FormatNumber(nCriticalMitigationRating, 2, true), 
      Apollo.FormatNumber(nCriticalMitigation - nBaseCriticalMitigation, 2, true), 
      Apollo.FormatNumber(nBaseCriticalMitigation, 2, true)
    )
  )
 
  -- Deflect Chance
  local nDeflectChance = unitPlayer:GetDeflectChance().nAmount
  local nDeflectChanceRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_AvoidIncrease).fValue
  local nBaseDeflectChance = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseAvoidChance).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseAvoidChance),
    self:WritePercentageString(nDeflectChance),
    String_GetWeaselString(
      Apollo.GetString("Character_DeflectTooltip"), 
      Apollo.FormatNumber(nDeflectChanceRating, 2, true),
      Apollo.FormatNumber(nDeflectChance - nBaseDeflectChance, 2, true), 
      Apollo.FormatNumber(nBaseDeflectChance, 2, true)
    )
  )
  
  -- Deflect Critical Hit Chance
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseAvoidCritChance),
    self:WritePercentageString(unitPlayer:GetDeflectCritChance().nAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_CritDeflectTooltip"), 
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.Rating_CritChanceDecrease).fValue, 2, true), 
      Apollo.FormatNumber(unitPlayer:GetDeflectCritChance().nAmount - (unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseAvoidCritChance).fValue * 100), 2, true),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseAvoidCritChance).fValue * 100, 2, true)
    )
  )
  
  -- Shield Mitigation
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.ShieldMitigationMax),
    self:WritePercentageString(unitPlayer:GetShieldMitigationPct()),
    Apollo.GetString("Character_ShieldMitigation_Tooltip")
  )
  
  -- Shield Regen Rate
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.ShieldRegenPct),
    self:WritePercentageString(unitPlayer:GetShieldRegenPct()),
    Apollo.GetString("Character_ShieldRegenPercentTooltip")
  )

  -- Shield Reboot Time
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.ShieldRebootTime),
    self:WritePercentageString(unitPlayer:GetShieldRebootTime()),
    Apollo.GetString("Character_ShieldRebootTooltip")
  )

  -- Shield Tick Time
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.ShieldTickTime),
    self:WritePercentageString(unitPlayer:GetShieldTickTime()),
    Apollo.GetString("Character_ShieldTickTime_Tooltip")
  )
  
  -- Cooldown Reduction
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.CooldownReductionModifier),
    self:WritePercentageString(unitPlayer:GetCooldownReductionModifier()),
    Apollo.GetString("Character_HasteTooltip")
  )

  -- CC Duration
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.CCDurationModifier),
    self:WritePercentageString(unitPlayer:GetCCDurationModifier().nAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_CCDurationTooltip"),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingCCResilience).fValue, 2, true), 
      Apollo.FormatNumber(unitPlayer:GetCCDurationModifier().nAmount - (unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.CCDurationModifier).fValue * 100), 2, true), 
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.CCDurationModifier).fValue * 100, 2, true)
    )
  )
  
  -- Lifesteal
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseLifesteal),
    self:WritePercentageString(unitPlayer:GetLifesteal().nAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_LifestealTooltip"),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingLifesteal).fValue, 2, true), 
      Apollo.FormatNumber(unitPlayer:GetLifesteal().nAmount - (unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseLifesteal).fValue * 100), 2, true),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseLifesteal).fValue * 100, 2, true)
    )
  )
  
  -- Focus Pool
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseFocusPool),
    Apollo.FormatNumber(unitPlayer:GetMaxFocus(), 0, true),
    Apollo.GetString("Character_FocusPool")
  )
  
  -- Focus Recovery Rate
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseFocusRecoveryInCombat),
    Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingFocusRecovery).fValue, 2, true),
    String_GetWeaselString(
      Apollo.GetString("Character_ManaRecoveryTooltip"),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingFocusRecovery).fValue, 2, true),
      Apollo.FormatNumber(unitPlayer:GetFocusRegenInCombat().nAmount - (unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseFocusRecoveryInCombat).fValue * 100), 2, true), 
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseFocusRecoveryInCombat).fValue * 100, 2, true)
    )
  )
  
  -- Focus Cost Reduction
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.FocusCostModifier),
    self:WritePercentageString(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.FocusCostModifier).fValue * 100),
    Apollo.GetString("Character_ManaCostRedTooltip")
  )
  
  -- Reflect Chance
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseDamageReflectChance),
    self:WritePercentageString(unitPlayer:GetDamageReflectChance().nAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_ReflectChanceTooltip"),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingDamageReflectChance).fValue, 2, true),
      Apollo.FormatNumber(unitPlayer:GetDamageReflectChance().nAmount - (unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseDamageReflectChance).fValue * 100), 2, true), 
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseDamageReflectChance).fValue * 100, 2, true)
    )
  )
  
  -- Reflect Damage
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseDamageReflectAmount),
    self:WritePercentageString(unitPlayer:GetDamageReflectAmount().nAmount),
    String_GetWeaselString(
      Apollo.GetString("Character_ReflectSeverityTooltip"), 
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingDamageReflectAmount).fValue, 2, true), 
      Apollo.FormatNumber(unitPlayer:GetDamageReflectAmount().nAmount - (unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseDamageReflectAmount).fValue * 100), 2, true),
      Apollo.FormatNumber(unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseDamageReflectAmount).fValue * 100, 2, true)
    )
  )
  
  -- Intensity
  local nIntensity = unitPlayer:GetIntensity().nAmount
  local nBaseIntensity = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.BaseIntensity).fValue * 100
  local nIntensityRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.RatingIntensity).fValue
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.BaseIntensity),
    self:WritePercentageString(nIntensity),
    String_GetWeaselString(
      Apollo.GetString("Character_IntensityTooltip"), 
      Apollo.FormatNumber(nIntensityRating, 2, true), 
      Apollo.FormatNumber(nIntensity - nBaseIntensity, 2, true), 
      Apollo.FormatNumber(nBaseIntensity, 2, true)
    )
  )
  
  -- PvP Power
  local nPvPDamageO = unitPlayer:GetPvPDamageO()
  local nPvPDamageI = unitPlayer:GetPvPDamageI()
  local nPvPOffensiveRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPOffensiveRating).fValue
  local nPvPOffensePctOffset = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPOffensePctOffset).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.PvPOffensePctOffset),
    self:WritePercentageString(nPvPDamageI),
    String_GetWeaselString(
      Apollo.GetString("Character_PvPOffenseTooltip"), 
      Apollo.FormatNumber(nPvPOffensiveRating, 2, true),
      Apollo.FormatNumber(nPvPOffensePctOffset, 2, true),
      Apollo.FormatNumber(nPvPDamageO, 2, true),
      Apollo.FormatNumber(nPvPDamageI - nPvPOffensePctOffset, 2, true)
    )
  )
  
  -- PvP Healing
  local nPvPHealingO = unitPlayer:GetPvPHealingO()
  local nPvPHealingI = unitPlayer:GetPvPHealingI()
  
  self:StoreSecondaryAttribute(
    Apollo.GetString("Character_PvPHealLabel"),
    self:WritePercentageString(nPvPHealingI),
    String_GetWeaselString(
      Apollo.GetString("Character_PvPHealingTooltip"), 
      Apollo.FormatNumber(nPvPOffensiveRating, 2, true),
      Apollo.FormatNumber(nPvPOffensePctOffset, 2, true),
      Apollo.FormatNumber(nPvPHealingO, 2, true), 
      Apollo.FormatNumber(nPvPHealingI - nPvPOffensePctOffset, 2, true)
    )
  )
  
  -- PvP Defense
  local nPvPDefenseO = unitPlayer:GetPvPDefenseO()
  local nPvPDefenseI = unitPlayer:GetPvPDefenseI()
  local nPvPDefenseRating = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPDefensiveRating).fValue
  local nPvPDefensePctOffset = unitPlayer:GetUnitProperty(Unit.CodeEnumProperties.PvPDefensePctOffset).fValue * 100
  
  self:StoreSecondaryAttribute(
    Item.GetPropertyName(Unit.CodeEnumProperties.PvPDefensePctOffset),
    self:WritePercentageString(nPvPDefenseI),
    String_GetWeaselString(
      Apollo.GetString("Character_PvPDefenseTooltip"),
      Apollo.FormatNumber(nPvPDefenseRating, 2, true),
      Apollo.FormatNumber(nPvPDefensePctOffset, 2, true),
      Apollo.FormatNumber(nPvPDefenseO, 2, true),
      Apollo.FormatNumber(nPvPDefenseI - nPvPDefensePctOffset, 2, true)
    )
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
        strSlot = itemSlot, 
        strName  = itemEquipped:GetName(),
        nId = itemEquipped:GetItemId(), 
        strQuality  = qualityIdToString[itemEquipped:GetItemQuality()],
        nItemPower = itemEquipped:GetItemPower(),
        nItemLevel = itemInfo.tPrimary.nEffectiveLevel,
        nRequiredLevel = itemEquipped:GetPowerLevel()
      }
      
      local itemRuneData = itemEquipped:GetRuneSlots()
      
      if itemRuneData and itemRuneData.arRuneSlots then
        self.tData.arEquippedItems[itemSlot]["Runes"] = {}
        
        for nRuneIndex, tCurrRuneSlot in pairs(itemRuneData.arRuneSlots) do
          local tDetailedInfo = Item.GetDetailedInfo(tCurrRuneSlot.itemRune)
          
          if tDetailedInfo and tDetailedInfo.tPrimary then            
            local tData = {
              strName = tDetailedInfo.tPrimary.strName,
              strType = runeIdToString[tDetailedInfo.tPrimary.eType],
              nId = tDetailedInfo.tPrimary.nId,
              strQuality = qualityIdToString[tDetailedInfo.tPrimary.eQuality],
              nBudget = tDetailedInfo.tPrimary.arBudgetBasedProperties[1].nValue,
              strAttribute = tDetailedInfo.tPrimary.arBudgetBasedProperties[1].strName
            }
            
            table.insert(self.tData.arEquippedItems[itemSlot]["Runes"], tData)
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
  local arPets = CollectiblesLib.GetVanityPetList()
  
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
  local arMounts = CollectiblesLib.GetMountList()
  
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

function ProtoArmory:CollectPvP()
  local arArenaTeams = self:Helper_CollectArenaTeams()
  
  for i = 1, #arArenaTeams do
    local tRatings = arArenaTeams[i]:GetPvpRatings()
    local tData = {
      strName = arArenaTeams[i]:GetName(),
      nDraws = tRatings.nDraws,
      nLosses = tRatings.nLosses,
      nRating = tRatings.nRating,
      nWins = tRatings.nWins,
      nPersonalRating = MatchingGame.GetPvpRating(guildTypeToRatingType[arArenaTeams[i]:GetType()] or 0)
    }
    
    table.insert(self.tData.arPvP, tData)
  end
end

-- Collects all active abilities on the current LAS Configuration of the player.
-- This is done by getting the current LAS and the abilities with a nTier higher
-- then 0, are active, and a maximum tier of 9.
function ProtoArmory:CollectAbilities()
  self.tData.arAbilities = {
    nLAS = AbilityBook.GetCurrentSpec(),
    arAbilities = {}
  }
  
  local arAbilities = AbilityBook.GetAbilitiesList()
  
  for i = 1, #arAbilities do
    if arAbilities[i].bIsActive and arAbilities[i].nCurrentTier > 0 and arAbilities[i].nMaxTiers == 9 then
      local tAbility = {
        nId = arAbilities[i].nId,
        strName = arAbilities[i].strName,
        nCurrentTier = arAbilities[i].nCurrentTier,
        nSpellId = arAbilities[i].tTiers[arAbilities[i].nCurrentTier].splObject:GetId(),
        strSpellName = arAbilities[i].tTiers[arAbilities[i].nCurrentTier].splObject:GetName()
      }
      
      table.insert(self.tData.arAbilities.arAbilities, tAbility)
    end
  end
end

-- Collects all the AMPs that have been activated by the player.
-- To do this we need to loop over the information for the current LAS and 
-- load the AMP data, then select those who are activated and unlocked.
function ProtoArmory:CollectAMPs()
  self.tData.arAMPs = {
    nLAS = AbilityBook.GetCurrentSpec(),
    arAMPs = {}
  }
  
  local arAMPs = AbilityBook.GetEldanAugmentationData(self.tData.arAMPs.nLAS).tAugments
  
  for i = 1, #arAMPs do
    if arAMPs[i].eEldanAvailability == AbilityBook.CodeEnumEldanAvailability.Activated then
      local tAMP = {
        nId = arAMPs[i].nId,
        nItemIdUnlock = arAMPs[i].nItemIdUnlock,
        nSpellIdAugment = arAMPs[i].nSpellIdAugment,
        strName = arAMPs[i].strTitle,
        nPowerCost = arAMPs[i].nPowerCost
      }
      
      table.insert(self.tData.arAMPs.arAMPs, tAMP)
    end
  end
end

-- Collects all the housing information that a player has, and stores them in a
-- specific table structure for further usage.
function ProtoArmory:CollectHousing()
  local rResidence = HousingLib.GetResidence()
  
  if rResidence then
    self.tData.arHousing = {
      strName = rResidence:GetPropertyName(),
      nInternalDecor = rResidence:GetNumPlacedDecorInterior(),
      nExternalDecor = rResidence:GetNumPlacedDecorExterior(),
      nInternalLimit = rResidence:GetMaxPlacedDecorInterior(),
      nExternalLimit = rResidence:GetMaxPlacedDecorExterior(),
      nMaxOwnedDecor = rResidence:GetMaxOwnedDecor(),
      nOwnedDecor = rResidence:GetNumOwnedDecor()    
    }
  end  
end

-----------------------------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------------------------

-- Write the provided value as a 2-digit string by utilizing the Apollo Library
-- and WeaselString functions.
function ProtoArmory:WritePercentageString(nValue)
  String_GetWeaselString(
    Apollo.GetString("Character_PercentAppendLabel"), 
    Apollo.FormatNumber(nValue, 2, true)
  )
end

-- Collects all the PvP Teams that a player belongs to and returns them in a specific
-- Table structure for further usage.
function ProtoArmory:Helper_CollectArenaTeams()
  local arArenaTeams = {}
  local arGuilds = GuildLib.GetGuilds()
  
  for i = 1, #arGuilds do
    if arGuilds[i]:GetType() == GuildLib.GuildType_ArenaTeam_2v2 then
      table.insert(arArenaTeams, arGuilds[i])
    end
     
    if arGuilds[i]:GetType() == GuildLib.GuildType_ArenaTeam_3v3 then
      table.insert(arArenaTeams, arGuilds[i])
    end
    
    if arGuilds[i]:GetType() == GuildLib.GuildType_ArenaTeam_5v5 then
      table.insert(arArenaTeams, arGuilds[i])
    end
    
    if arGuilds[i]:GetType() == GuildLib.GuildType_WarParty then
      table.insert(arArenaTeams, arGuilds[i])
    end
  end
  
  return arArenaTeams
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
  self:CollectPvP()
  self:CollectAbilities()
  self:CollectAMPs()
  self:CollectHousing()
  
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
  self:WritePvP(xDoc, characterNode)
  self:WriteAbilities(xDoc, characterNode)
  self:WriteAMPs(xDoc, characterNode)
  self:WriteHousing(xDoc, characterNode)
  
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
       
    local tAttributes = { 
      strSlot = v.strSlot, 
      strName  = v.strName, 
      nId = v.nId, 
      strQuality = v.strQuality,
      nItemPower = v.nItemPower, 
      nItemLevel = v.nItemLevel,
      nRequireLevel = v.nRequiredLevel 
    }
    local propertyNode = xmlDoc:NewNode("properties", tAttributes)
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
        achievement.strDescription = string.gsub(arAchievements[j]:GetDescription(), "%b<>", "")
      end
           
      -- Collect the reward
      local reward = arAchievements[j]:GetRewards()
      if reward.GetTitle ~= nil then
        achievement.strReward = reward:GetTitle() 
      else
        achievement.strReward = "n.a"
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
    
    if tInfo.bIsActive then
      local tTradeskill = {
        strName = arTradeskills[i].strName,
        strLevel = tradeskillTierToString[tInfo.eTier],
        nLevel = tInfo.eTier,
        nMaxLevel = tInfo.nTierMax,
        nTalentPoints = tInfo.nTalentPoints,
        nExp = tInfo.nXp,
        nMaxExp = tInfo.nXpMax
      }
      local node = xmlDoc:NewNode("tradeskill", tTradeskill)
      xTradeskills:AddChild(node)
    end
  end
end

function ProtoArmory:WritePvP(xmlDoc, xNode)
  local xPvP = xmlDoc:NewNode("pvp")
  xNode:AddChild(xPvP)
  
  for i = 1, #self.tData.arPvP do
    local node = xmlDoc:NewNode("group", self.tData.arPvP[i])
    xPvP:AddChild(node)
  end
end

function ProtoArmory:WriteAbilities(xmlDoc, xNode)
  local xAbilities = xmlDoc:NewNode("abilities", { nActiveLas = self.tData.arAbilities.nLAS })
  xNode:AddChild(xAbilities)
  
  for i = 1, #self.tData.arAbilities.arAbilities do
    local node = xmlDoc:NewNode("ability", self.tData.arAbilities.arAbilities[i])
    xAbilities:AddChild(node)
  end
end

function ProtoArmory:WriteAMPs(xmlDoc, xNode)
  local xAMPs = xmlDoc:NewNode("amps", { nActiveLas = self.tData.arAMPs.nLAS })
  xNode:AddChild(xAMPs)
  
  for i = 1, #self.tData.arAMPs.arAMPs do
    local node = xmlDoc:NewNode("amp", self.tData.arAMPs.arAMPs[i])
    xAMPs:AddChild(node)
  end
end

function ProtoArmory:WriteHousing(xmlDoc, xNode)
  local xHousing = xmlDoc:NewNode("housing", self.tData.arHousing)
  xNode:AddChild(xHousing)
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
