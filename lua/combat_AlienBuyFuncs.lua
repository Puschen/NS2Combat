//________________________________
//
//   	Combat Mod     
//	Made by JimWest, 2012
//	
//________________________________

// combat_AlienBuyFuncs.lua
      
// helper Functions for the List, text etc  



function CombatAlienBuy_GetAbilitiesFor(lifeFormTechId)

    local abilityIds = {}

    local player = Client.GetLocalPlayer()
    
    /* currently not working
    if player and player:isa("Alien") then
    
        local tierTwoTech = GetAlienTierTwoFor(lifeFormTechId)
        if tierTwoTech then
            table.insert(abilityIds, tierTwoTech)
        end
        
        local tierThreeTech = GetAlienTierThreeFor(lifeFormTechId)
        if tierThreeTech then
            table.insert(abilityIds, tierThreeTech)
        end
        
        
    
    end
    */
    
    return abilityIds

end


local function GetUnpurchasedTechIds(techId)

    // get All ups for the aliens
    //TODO : delete purchased ups
    local allUps = GetAllUpgrades("Allien") 
    local techUps = GetUpgradesOfType(allUps, kCombatUpgradeTypes.Tech)
    
    local addOnUpgrades = {}   
    local player = Client.GetLocalPlayer()
    
    for i, upgrade in ipairs(techUps) do
        if not player:GotItemAlready(upgrade) then
            table.insert(addOnUpgrades, upgrade:GetTechId())
        end
    end
        
    return addOnUpgrades
    
end


local function GetPurchasedTechIds(techId)
    
    local player = Client.GetLocalPlayer()
    
    if player then
        // get All ups from the personal combat table (send from the server via OnCommandSetUpgrades(upgradeId)
        local purchasedList = {}
        for i, upgradeId in ipairs (player.combatUpgrades) do
            local upgrade =  GetUpgradeFromId(tonumber(upgradeId))
            if upgrade then
                table.insert(purchasedList, upgrade:GetTechId())
            end
        end
        
        return purchasedList
    end
        
    return nil
    
end

// iconx, icony, name, tooltip, research, cost. Need to change that to change the costs
function CombatAlienBuy_GetUnpurchasedUpgradeInfoArray(techIdTable)

    local t = {}
    
    local player = Client.GetLocalPlayer()
    
    if player then
    
        for index, techId in ipairs(techIdTable) do
        
            if not player:GetIsUpgradeForbidden(techId) then
        
                local iconX, iconY = GetMaterialXYOffset(techId, false)
                
                if iconX and iconY then

                    local techTree = GetTechTree(player:GetTeamNumber())
                    local upgradeName = GetDisplayNameForTechId(techId, string.format("<name not found - %s>", EnumToString(kTechId, techId)))
                    local upgrade = GetUpgradeFromTechId(techId)
                    
                    table.insert(t, iconX)
                    table.insert(t, iconY)                    
                    table.insert(t, upgradeName)                    
                    table.insert(t, GetTooltipInfoText(techId))                 
                    table.insert(t, GetTechTree():GetResearchProgressForNode(techId))
                    // cost
                    table.insert(t, upgrade:GetLevels()) 
                    table.insert(t, techId)
                    if techTree then
                        table.insert(t, techTree:GetIsTechAvailable(techId))
                    else
                        table.insert(t, false)
                    end
                end
            
            end
            
        end
    
    end
    
    return t
    
end

function CombatAlienBuy_GetPurchasedUpgradeInfoArray(techIdTable)

    local t = {}
    
    local player = Client.GetLocalPlayer()
    
    for index, techId in ipairs(techIdTable) do

        local iconX, iconY = GetMaterialXYOffset(techId, false)
        if iconX and iconY then

            local techTree = GetTechTree(player:GetTeamNumber())
        
            table.insert(t, iconX)
            table.insert(t, iconY)
            table.insert(t, GetDisplayNameForTechId(techId, string.format("<not found - %s>", EnumToString(kTechId, techId))))
            table.insert(t, GetTooltipInfoText(techId))
            table.insert(t, techId)
            table.insert(t, true)

            if techTree then
                table.insert(t, true)
            else
                table.insert(t, false)
            end
            
        else
        
            Print("GetPurchasedUpgradeInfoArray():GetAlienUpgradeIconXY(%s): Couldn't find upgrade icon.", ToString(techId))
            
        end
    end
    
    return t
    
end


// return the unpurchased ups from the UpsList
function CombatAlienBuy_GetUnpurchasedUpgrades(idx)
    if idx == nil then
        Print("AlienBuy_GetUnpurchasedUpgrades(nil) called")
        return {}
    end
    
    return CombatAlienBuy_GetUnpurchasedUpgradeInfoArray(GetUnpurchasedTechIds(IndexToAlienTechId(idx)))   

end


function CombatAlienBuy_GetPurchasedUpgrades(idx)

    local player = Client.GetLocalPlayer()
    return CombatAlienBuy_GetPurchasedUpgradeInfoArray(GetPurchasedTechIds(IndexToAlienTechId(idx)))
    
end


function CombatAlienBuy_GetGotRequirements(techId)

    local player = Client.GetLocalPlayer()
    if player then    
        local upgrade = GetUpgradeFromTechId(techId)
        if upgrade then
            return player:GotRequirements(upgrade)
        end    
    end
    
    return false
end


function CombatAlienBuy_Purchase(purchaseId)

    local player = Client.GetLocalPlayer()
    if player then
        local upgrade = GetUpgradeFromTechId(purchaseId)
        if upgrade then
            local textCode = upgrade:GetTextCode()
            player:Combat_PurchaseItemAndUpgrades(textCode)
        end
    end

end



