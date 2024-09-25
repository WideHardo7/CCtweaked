local args = {...}

local defaultSide="back"
local monitorDefaultSide="top"
local monitor=peripheral.wrap(monitorDefaultSide)

if #args == 0 then
    print("Nessun argomento passato.")
    return
end

if args[2]==nil then
    print("Lato Redstone non specificato; usando default: back")
    else 
        defaultSide=args[2]
end

while args[1] do
    redstone.setOutput(defaultSide,true)
    sleep(1)
    redstone.setOutput(defaultSide,false)
    sleep(1)
    return 
end