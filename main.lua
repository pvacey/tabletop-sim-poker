coin_GUID = '3f8f80'
pot_GUID = '39c189'

white_money_GUID = '72d080'
white_bag_GUID = '01573b'
pink_money_GUID = 'e6db4c'
pink_bag_GUID = '9a3c83'
purp_money_GUID = 'a09bec'
purp_bag_GUID = 'ce6096'
blue_money_GUID = 'e269b8'
blue_bag_GUID = '0bc4e1'
green_money_GUID = '09d12a'
green_bag_GUID = 'd66c15'
yellow_money_GUID = '4f90ae'
yellow_bag_GUID = '42ea41'
orange_money_GUID = '5c6a34'
orange_bag_GUID = 'a929e5'
red_money_GUID = '0e96ac'
red_bag_GUID = '928439'

function onLoad()
    coin_button = getObjectFromGUID(coin_GUID)
    pot = getObjectFromGUID(pot_GUID)
    total_text_1 = getObjectFromGUID('8e0d31')
    total_text_2 = getObjectFromGUID('bd6e01')
    total_text_3 = getObjectFromGUID('0a85cf')
    total_text_4 = getObjectFromGUID('82117f')

    white_money = getObjectFromGUID(white_money_GUID)
    pink_money = getObjectFromGUID(pink_money_GUID)
    purp_money = getObjectFromGUID(purp_money_GUID)
    blue_money = getObjectFromGUID(blue_money_GUID)
    green_money = getObjectFromGUID(green_money_GUID)
    yellow_money = getObjectFromGUID(yellow_money_GUID)
    orange_money = getObjectFromGUID(orange_money_GUID)
    red_money = getObjectFromGUID(red_money_GUID)

    coin_button.createButton({
        function_owner=self,
        click_function = 'stack',
        position = {0, 0.1, 0},
        width = 900,
        height = 900,
        label = 'stack',
        font_size = 250
    })
end

function update_total_text(object)
    if object.getName() == 'chip' then
        money_value =  getPotTotal() * 0.25
        text = string.format("$%.2f", money_value)
        total_text_1.setValue(text)
        total_text_2.setValue(text)
        total_text_3.setValue(text)
        total_text_4.setValue(text)
    end
end

function onObjectEnterScriptingZone(zone, obj)
    Wait.time(function() update_total_text(obj) end, 0.5)
end

function onObjectLeaveScriptingZone(zone, obj)
    Wait.time(function() update_total_text(obj) end, 0.5)
end

function updatePlayerFunds(bag, obj)
    count = 0
    objects = bag.getObjects()
    for _,o in ipairs(objects) do
        if o.name == "chip" then
            count = count + 1
        end
    end
    text = string.format("$%.2f", (count * 0.25))
    if bag.guid == white_bag_GUID then
        white_money.setValue(text)
    end
    if bag.guid == pink_bag_GUID then
        pink_money.setValue(text)
    end
    if bag.guid == purp_bag_GUID then
        purp_money.setValue(text)
    end
    if bag.guid == blue_bag_GUID then
        blue_money.setValue(text)
    end
    if bag.guid == green_bag_GUID then
        green_money.setValue(text)
    end
    if bag.guid == yellow_bag_GUID then
        yellow_money.setValue(text)
    end
    if bag.guid == orange_bag_GUID then
        orange_money.setValue(text)
    end
    if bag.guid == red_bag_GUID then
        red_money.setValue(text)
    end
end

function onObjectEnterContainer(bag, obj)
    updatePlayerFunds(bag, obj)
end


function onObjectLeaveContainer(bag, obj)
    obj.setColorTint(bag.getColorTint())
    updatePlayerFunds(bag, obj)
end

function getPotTotal()
    count = 0
    player_total = {}
    chips = getPotChips()
    for _,o in ipairs(chips) do
        if o.getName() == 'chip' then
            count = count +1
        end
    end
    return count
end
l
function getPotChips()
    chips = {}
    for _,o in ipairs(pot.getObjects()) do
        if o.getName() == 'chip' then
            table.insert(chips, o)
        end
    end
    return chips
end

function stack()
    buffer = 1.25
    total = 0
    stack_num = 0
    row_num = 0
    x = -0.5
    y = 0
    z = -1
    for _,o in ipairs(getPotChips()) do
        total = total + 1
        stack_num = stack_num + 1
        y = y + 1
        slowMove(o,{x,y,z})
        if stack_num >= 4 then
            stack_num = 0
            row_num = row_num + 1
            y = 0
            x = x + buffer
            if row_num >= 5 then
                row_num = 0
                x = -0.5
                z = z + buffer
            end
        end
    end
end

function slowMove(object, vector)
    object.setRotationSmooth({0,0,0}, false, true)
    Wait.time(function() object.setPositionSmooth(vector, false, true) end, 1.25)
    -- Wait.time(function() object.setPositionSmooth(vector, false, true) end, 4)
    -- Wait.time(function() object.setPositionSmooth(vector, false, true) end, 6)
end
