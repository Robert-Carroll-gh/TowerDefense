local towerUpgrades = {}

function towerUpgrades.fireRate(modifier)
    local upgrade = function(tower)
        tower.fireRate = tower.fireRate / modifier
        if tower.shotTimer ~= nil then
            tower.shotTimer.duration = tower.fireRate
        end
    end
    local downgrade = function(tower)
        tower.fireRate = tower.fireRate * modifier
        if tower.shotTimer ~= nil then
            tower.shotTimer.duration = tower.fireRate
        end
    end
    return { upgrade = upgrade, downgrade = downgrade }
end

return towerUpgrades
