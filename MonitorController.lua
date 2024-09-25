-- MONITOR PER IL DUPING TNT
local defaultSide = "top"
local redstoneSide = "back"
local monitor = peripheral.wrap(defaultSide)
local colore = false

monitor.setTextScale(0.5)
monitor.clear()

function disegnaBottone(colore)
    if colore then
        monitor.setBackgroundColor(colors.green)
    else
        monitor.setBackgroundColor(colors.red)
    end
    monitor.clearLine()
    monitor.setCursorPos(1, 1)
    monitor.write("[ TNT DUPER ]")
end

disegnaBottone(colore)

local timerID = nil
local redstoneState = false

while true do
    local event, p1, p2, p3 = os.pullEvent()
    if event == "monitor_touch" then
        local side, x, y = p1, p2, p3
        if x >= 1 and x <= 15 and y == 1 then
            colore = not colore
            disegnaBottone(colore)
            if colore then
                -- Start the timer to toggle redstone signal
                if not timerID then
                    timerID = os.startTimer(1)
                    redstoneState = false
                    redstone.setOutput(redstoneSide, redstoneState)
                end
            else
                -- Stop the timer and reset redstone signal
                if timerID then
                    timerID = nil
                    redstone.setOutput(redstoneSide, false)
                end
            end
        end
    elseif event == "timer" then
        local id = p1
        if id == timerID and colore then
            -- Toggle redstone output
            redstoneState = not redstoneState
            redstone.setOutput(redstoneSide, redstoneState)
            -- Restart the timer
            timerID = os.startTimer(1)
        end
    end
end
