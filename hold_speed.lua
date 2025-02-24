
local function toggle_speed(is_pressed)
    mp.set_property("speed", is_pressed and 2.0 or 1.0)
end

local timer = nil
local speed_toggled = false

local function handle_event(event, original_action)
    if event.event == "down" then
        timer = mp.add_timeout(0.5, function()
            toggle_speed(true)
            speed_toggled = true
        end)
    elseif event.event == "up" then
        if timer then
            if not speed_toggled then
                timer:kill()
                timer = nil
                original_action() -- Call the original action if it's a short press
                return
            end
            timer:kill()
            timer = nil
            if speed_toggled then
                toggle_speed(false)
                speed_toggled = false
            end
        end
    end
end

mp.add_key_binding("MOUSE_BTN0", "mouse_hold_speed", function(event)
    handle_event(event, function() end)
end, {complex = true})

mp.add_key_binding("SPACE", "space_hold_speed", function(event)
    handle_event(event, function()
        mp.command("cycle pause") -- Original action for SPACE (toggle pause)
    end)
end, {complex = true})

-- Bindings for middle mouse button
mp.add_key_binding("MBTN_MID", "middle_button_toggle_speed", function()
    speed_toggled = not speed_toggled
    toggle_speed(speed_toggled)
end)

local update_interval = 0.5

local function show_osd_message(name, value)
    if speed_toggled then
        mp.osd_message(" »", 0.6)
    end
end

local timer = mp.add_periodic_timer(update_interval, show_osd_message)