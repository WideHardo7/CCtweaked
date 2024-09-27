-- QUESTO FILE USA L'UNIVERSAL SCANNER DELLA UNLIMITED PERIPHERAL WORKS

local args = {...}
local scannerSide = "down"

if not peripheral.isPresent(scannerSide) then
    error("No peripheral found on side: " .. scannerSide)
end

local scanner = peripheral.wrap(scannerSide)
if peripheral.getType(scannerSide) ~= "universal_scanner" then
    error("Peripheral on side " .. scannerSide .. " is not a Universal Scanner.")
end

function redstonePulse()
    redstone.setOutput("back", true)
    sleep(1)
    redstone.setOutput("back", false)
end

while true do
    local results = scanner.scan("block", 1)
    for _, block in pairs(results) do
        if block.name == args[1] then
            print("Blocco Trovato: " .. block.name .. " in posizione x: " .. block.x .. " y: " .. block.y .. " z: " .. block.z)
            redstonePulse()
        else
            print("Blocco diverso dal cercato trovato: " .. block.name .. " in posizione x: " .. block.x .. " y: " .. block.y .. " z: " .. block.z)
        end
    end
    sleep(1) -- Add a small delay to prevent excessive looping
end
