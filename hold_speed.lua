
local function toggle_speed(is_pressed)
    mp.set_property("speed", is_pressed and 2.0 or 1.0)
end

local timer = nil

mp.add_key_binding("MOUSE_BTN0", "mouse_hold_speed", function(event)
    if event.event == "down" then
        timer = mp.add_timeout(0.5, function()
            toggle_speed(true)
        end)
    elseif event.event == "up" then
        if timer then
            timer:kill()
            timer = nil
            toggle_speed(false)
        end
    end
end, {complex=true})