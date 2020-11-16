coin_GUID = '3f8f80'
pot_GUID = '39c189'

white_total_GUID = '72d080'
white_bag_GUID = '01573b'
white_ping_GUID = 'cd0305'

pink_total_GUID = 'e6db4c'
pink_bag_GUID = '9a3c83'
pink_ping_GUID = '9d0ca3'

purple_total_GUID = 'a09bec'
purple_bag_GUID = 'ce6096'
purple_ping_GUID = 'd0d45e'

blue_total_GUID = 'e269b8'
blue_bag_GUID = '0bc4e1'
blue_ping_GUID = '53ef73'

green_total_GUID = '09d12a'
green_bag_GUID = 'd66c15'
green_ping_GUID = '0d3a5e'

yellow_total_GUID = '4f90ae'
yellow_bag_GUID = '42ea41'
yellow_ping_GUID = '8d6829'

orange_total_GUID = '5c6a34'
orange_bag_GUID = 'a929e5'
orange_ping_GUID = '054c54'

red_total_GUID = '0e96ac'
red_bag_GUID = '928439'
red_ping_GUID = '1d2cd1'


function onLoad()
    coin_button = getObjectFromGUID(coin_GUID)
    pot = getObjectFromGUID(pot_GUID)
    pot_total_text = {
        getObjectFromGUID('8e0d31'),
        getObjectFromGUID('bd6e01'),
        getObjectFromGUID('0a85cf'),
        getObjectFromGUID('82117f')
    }
    player_assets = {
        White = {
            bag = getObjectFromGUID(white_bag_GUID),
            total = getObjectFromGUID(white_total_GUID),
            pings = getObjectFromGUID(white_ping_GUID)
        },
        Pink = {
            bag = getObjectFromGUID(pink_bag_GUID),
            total = getObjectFromGUID(pink_total_GUID),
            pings = getObjectFromGUID(pink_ping_GUID)
        },
        Purple = {
            bag = getObjectFromGUID(purple_bag_GUID),
            total = getObjectFromGUID(purple_total_GUID),
            pings = getObjectFromGUID(purple_ping_GUID)
        },
        Blue = {
            bag = getObjectFromGUID(blue_bag_GUID),
            total = getObjectFromGUID(blue_total_GUID),
            pings = getObjectFromGUID(blue_ping_GUID)
        },
        Green = {
            bag = getObjectFromGUID(green_bag_GUID),
            total = getObjectFromGUID(green_total_GUID),
            pings = getObjectFromGUID(green_ping_GUID)
        },
        Yellow = {
            bag = getObjectFromGUID(yellow_bag_GUID),
            total = getObjectFromGUID(yellow_total_GUID),
            pings = getObjectFromGUID(yellow_ping_GUID)
        },
        Orange = {
            bag = getObjectFromGUID(orange_bag_GUID),
            total = getObjectFromGUID(orange_total_GUID),
            pings = getObjectFromGUID(orange_ping_GUID)
        },
        Red = {
            bag = getObjectFromGUID(red_bag_GUID),
            total = getObjectFromGUID(red_total_GUID),
            pings = getObjectFromGUID(red_ping_GUID)
        }
    }

    coin_button.createButton({
        function_owner = self,
        click_function = 'stack',
        position = {0, 0.1, 0},
        width = 900,
        height = 900,
        label = 'stack',
        font_size = 250
    })
end

function onObjectEnterScriptingZone(zone, obj)
    handleScriptingZoneEvent(zone, obj)
end

function onObjectLeaveScriptingZone(zone, obj)
    handleScriptingZoneEvent(zone, obj)
end

function onPlayerChangeColor(color)
    hideUnusedColors()
end

function handleScriptingZoneEvent(zone, obj)
    if obj.getName() == 'chip' then
        Wait.time(function()
            update_pot_totals(obj)
        end, 0.5)
    end
end

function onObjectEnterContainer(container, obj)
    if container.name == 'Bag' then
        updatePlayerFunds(container)
    end
end

function onObjectLeaveContainer(container, obj)
    if container.name == 'Bag' then
        obj.setColorTint(container.getColorTint())
        updatePlayerFunds(container)
    end
end

function format_currency(number_of_chips)
    return string.format("$%.2f", (number_of_chips * 0.25))
end

function getColor(obj)
    return obj.getColorTint():toString()
    -- return string.lower(obj.getColorTint():toString())
end

function update_pot_totals(chip)
    update_total_text()
    update_player_ping_text(chip)
end

function update_total_text()
    -- get the length of the chips in the pot array, convert to currency text
    text = format_currency(#getPotChips())
    -- update the pot total text fields 
    for idx, text_label in ipairs(pot_total_text) do
        text_label.setValue(text)
    end
end

function update_player_ping_text(trigger_chip)
    trigger_chip_color = getColor(trigger_chip)

    count = 0
    for idx, chip in ipairs(getPotChips()) do
        if getColor(chip) == trigger_chip_color then
            count = count + 1
        end
    end

    text = ' '
    if count > 0 then
        text = string.format('%d pings', count)
    end
    player_assets[trigger_chip_color].pings.setValue(text)
end

function getBagChipCount(bag)
    -- count the chips in the bag, ignore other objects
    bag_count = 0
    for idx, object in ipairs(bag.getObjects()) do
        if object.name == "chip" then
            bag_count = bag_count + 1
        end
    end
    return bag_count
end

function updatePlayerFunds(bag, obj)
    bag_count = getBagChipCount(bag)
    -- get the total text obj for this bag color and update the value
    player_assets[getColor(bag)].total.setValue(format_currency(bag_count))
end

function getPotChips()
    chips = {}
    for idx, object in ipairs(pot.getObjects()) do
        if object.getName() == 'chip' then
            table.insert(chips, object)
        end
    end
    return chips
end

function getActivePlayerColors()
    colors = {}
    for idx, player in pairs(Player.getPlayers()) do
        colors[player.color] = 1
    end
    return colors
end

function isActivePlayer(this_color)
    ret_val = false
    for player_color, _ in pairs(getActivePlayerColors()) do
        if player_color == this_color then
            ret_val = true
        end
    end
    return ret_val
end

function getColorsExceptThisOne(this_color)
    the_other_colors = {}
    for color, _ in pairs(player_assets) do
        if color ~= this_color then
            table.insert(the_other_colors, color)
        end
    end
    return the_other_colors
end

function hideUnusedColors()
    active_colors_kv = getActivePlayerColors()
    active_color_array = {}
    for color, _ in pairs(active_colors_kv) do
        table.insert(active_color_array, color)
    end

    for color, assets in pairs(player_assets) do
        if active_colors_kv[color] == nil then
            assets.total.setValue(' ')
            assets.pings.setValue(' ')
        end
    end

    hideOtherColorsBags()
end

function hideOtherColorsBags()
    for color, assets in pairs(player_assets) do
        assets.bag.setInvisibleTo(getColorsExceptThisOne(color))
    end
end

function stack()
    buffer = 1.25
    total = 0
    stack_num = 0
    row_num = 0
    x = -0.5
    y = 0
    z = -1
    for _, o in ipairs(getPotChips()) do
        total = total + 1
        stack_num = stack_num + 1
        y = y + 1
        slowMove(o, {x, y, z})
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
    -- calculateDrift(30.00)
end

function slowMove(object, vector)
    object.setRotationSmooth({0, 0, 0}, false, true)
    Wait.time(function()
        object.setPositionSmooth(vector, false, true)
    end, 1.25)
    -- Wait.time(function() object.setPositionSmooth(vector, false, true) end, 4)
    -- Wait.time(function() object.setPositionSmooth(vector, false, true) end, 6)
end

function calculateDrift(starting_amount)
    print('=====\nplayer standings\n=====')
    drift = {}
    for color, assets in pairs(player_assets) do
        if isActivePlayer(color) then
            player_funds = getBagChipCount(assets.bag) * 0.25
            standing = player_funds - 30
            player_name = Player[color].steam_name
            drift[player_name] = standing
            print(string.format('%s = $%.2f', player_name, standing))
        end
    end
    return drift
end

function payoutPlan(starting_amount)
    -- sort winners and loser, apply loser debt to winner credit until resolved
    -- big problem if it all doesn't add up to zero
end
