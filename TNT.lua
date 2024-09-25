local args = {...}

local defaultSide="back"

if #args == 0 then
    print("Nessun argomento passato.")
    return
end

if args[2]==nil then
    print("Lato Redstone non specificato")
    else 
        defaultSide=args[2]
end

while args[1] do
    redstone.setOutput(defaultSide,true)
    sleep(1)
    redstone.setOutput(defaultSide,false)
    sleep(1)
end