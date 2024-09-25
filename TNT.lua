local args = {...}

if #args == 0 then
    print("Nessun argomento passato.")
    return
end

while args[1] do
    redstone.setOutput("back",true)
    sleep(1)
    redstone.setOutput("back",false)
    sleep(1)
end