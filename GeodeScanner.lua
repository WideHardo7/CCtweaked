-- QUESTO FILE USA L'UNIVERSAL SCANNER DELLA UNLIMITED PERIPHERAL WORKS

local args = {...}

-- Trova lo scanner
local scanner = peripheral.find("universal_scanner")
if not scanner then
    error("Universal Scanner non trovato")
end

function redstonePulse()
    redstone.setOutput("back", true)
    sleep(1)
    redstone.setOutput("back", false)
end

while true do
    local risultati = scanner.scan("block", 1)
    if risultati then
        for _, block in pairs(risultati) do
            if block.name == args[1] then
                print("Blocco Trovato: " .. block.name .. " in posizione x: " .. block.x .. " y: " .. block.y .. " z: " .. block.z)
                redstonePulse()
            else
                print("Blocco diverso dal cercato trovato: " .. block.name .. " in posizione x: " .. block.x .. " y: " .. block.y .. " z: " .. block.z)
            end
        end
    else
        print("Nessun blocco rilevato nella scansione.")
    end
    sleep(1)  -- Aggiungi una pausa per evitare loop troppo rapidi
end
