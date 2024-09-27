-- QUESTO FILE USA L'UNIVERSAL SCANNER DELLA UNLIMITED PERIPHERAL WORKS

local args= {...}
local scanner = peripheral.wrap("down")

function redstonePulse()
    redstone.setOutput("back", true)
    sleep(1)
    redstone.setOutput("back", false)
end


while true do
    local risultati = scanner.scan("block",1)
    for block in risultati do
        if block["name"]==args[1] then
            print("Blocco Trovato: ".. block["name"].. " in  posizione x: ".. block["x"] .. " y: "..block["y"].. " z: "..block["z"] )
            redstonePulse()
        else
             print("Blocco diverso dal cercato trovato: ".. block["name"])
        end
    end
end