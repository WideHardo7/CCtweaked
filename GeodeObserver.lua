local observer = peripheral.wrap("down")
local args = {...}
if observer then
    local blockData = observer.getBlockData()
    if blockData.name==args[1] then
        redstone.setOutput("back", true) 
        sleep(1)
        redstone.setOutput("back", false)
    end
end