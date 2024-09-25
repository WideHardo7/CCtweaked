local defaultSide = "top"
local redstoneSide = "back"
local monitor = peripheral.wrap(defaultSide)
local colore = false
local running = false

monitor.setTextScale(0.5)
monitor.clear()

-- Funzione per disegnare il bottone
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

while true do
    -- Rilevamento del tocco del monitor
    local evento, lato, x, y = os.pullEvent("monitor_touch")
    if x >= 1 and x <= 15 and y == 1 then
        -- Cambia lo stato del ciclo
        running = not running
        -- Cambia il colore del bottone
        colore = not colore
        disegnaBottone(colore)

        if running then
            -- Se running è vero, avviamo il ciclo Redstone
            print("Ciclo Redstone iniziato")
            while running do
                -- Accensione e spegnimento del Redstone
                redstone.setOutput(redstoneSide, true)
                sleep(1)
                redstone.setOutput(redstoneSide, false)
                sleep(1)

                -- Verifica se il pulsante è stato toccato nuovamente
                local evento, lato, x2, y2 = os.pullEvent("monitor_touch")
                if x2 >= 1 and x2 <= 15 and y2 == 1 then
                    -- Se toccato di nuovo, interrompi il ciclo
                    running = false
                    colore = not colore
                    disegnaBottone(colore)
                    redstone.setOutput(redstoneSide, false) -- Spegne il segnale Redstone
                    print("Ciclo Redstone fermato")
                end
            end
        else
            -- Se running è falso, assicuriamoci che il Redstone sia spento
            redstone.setOutput(redstoneSide, false)
        end
    end
end
