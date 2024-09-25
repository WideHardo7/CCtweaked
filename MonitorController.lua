local defaultSide = "top"
local redstoneSide = "back"
local monitor = peripheral.wrap(defaultSide)
local colore = false
local running = false

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

-- Funzione per gestire il ciclo Redstone
function cicloRedstone()
    while running do
        redstone.setOutput(redstoneSide, true)
        sleep(1)
        redstone.setOutput(redstoneSide, false)
        sleep(1)
    end
end

while true do
    local evento, lato, x, y = os.pullEvent("monitor_touch")
    if x >= 1 and x <= 15 and y == 1 then
        -- Cambiamo stato del bottone
        colore = not colore
        disegnaBottone(colore)

        -- Invertiamo lo stato del ciclo Redstone
        running = not running

        if running then
            -- Se running è true, iniziamo il ciclo Redstone in un thread separato
            parallel.waitForAny(cicloRedstone)
        else
            -- Se running è false, assicuriamoci che il redstone sia spento
            redstone.setOutput(redstoneSide, false)
        end
    end
end
