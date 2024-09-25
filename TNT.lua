local args = {...}

if #args == 0 then
    print("Nessun argomento passato.")
    return
end

if args[2]==nil then
    print("Lato Redstone non specificato")
end

while args[1] do
    redstone.setOutput(args[2],true)
    sleep(1)
    redstone.setOutput(args[2],false)
    sleep(1)
end