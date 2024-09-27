-- QUESTO FILE USA L'UNIVERSAL SCANNER DELLA UNLIMITED PERIPHERAL WORKS

local args = {...}

-- Trova lo scanner sulla rete
local scanner = peripheral.find("universal_scanner")

if not scanner then
    error("Scanner universale non trovato sulla rete.")
end

function redstonePulse()
    redstone.setOutput("right", true)
    sleep(1)
    redstone.setOutput("right", false)
end

while true do
    local risultati = scanner.scan("block", 1)
    for _, block in pairs(risultati) do
        if block.name == args[1] then
            print("Blocco Trovato: " .. block.name .. " in posizione x: " .. block.x .. " y: " .. block.y .. " z: " .. block.z)
            redstonePulse()
        else
            print("Blocco diverso dal cercato trovato: " .. block.name .. " in posizione x: " .. block.x .. " y: " .. block.y .. " z: " .. block.z)
        end
    end
    sleep(1) -- Aggiungi un piccolo ritardo per evitare cicli eccessivi
end
