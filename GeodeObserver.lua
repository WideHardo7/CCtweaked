local observer = peripheral.wrap("down")
local args = {...}

if observer then
    -- Ascoltiamo l'evento 'block_change'
    while true do
        local event, blockPos, oldState, newState = os.pullEvent("block_change")

        -- Verifichiamo se il blocco nuovo è quello che ci interessa
        if newState.name == args[1] then
            print("Matching block detected: " .. newState.name)
            redstone.setOutput("back", true)
            sleep(1)
            redstone.setOutput("back", false)
        else
            print("Block changed but does not match: " .. newState.name)
        end
    end
else
    print("Observer peripheral not found")
end
