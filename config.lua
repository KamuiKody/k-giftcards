Config = {}

Config.UseTarget = true -- have not setup text yet please keep true
Config.ItemName = 'giftcard'
Config.MarkedMult = 1.0 -- multiplier for value of marked money so 1.0 gets u $1 on giftcard for $1 marked 0.75 gives you $0.75 giftcard for $1 marked

Config.Buy = { -- gift card buy options
    [1] = {
        ['coords'] = vector4(-603.44, -1783.08, 23.64, 291.49),
        ["targetLabel"] = 'Buy Gift Cards',
        ['UseDirty'] = true -- able to choose between buying with cash or dirty cash
    },
    [2] = {
        ['coords'] = vector4(2676.12, 3499.13, 53.3, 50.74),
        ["targetLabel"] = 'Buy Gift Cards',
        ['UseDirty'] = true -- able to choose between buying with cash or dirty cash
    }
}

Config.CardTypes = { 
   [1] = {
        label = 'BurgerShot', 
        jobname = 'burgershot', 
        commission = 0.15
    },
    [2] = {
         label = 'Mechanic', 
         jobname = 'mechanic', 
         commission = 0.15
     }
}