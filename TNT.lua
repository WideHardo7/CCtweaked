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
    local evento,lato,x,y = os.pullEvent("monitor_touch")
    if x>=1 and x<=15 and y==1 then     
        monitor.setBackgroundColor(colors.red)
        monitor.clearLine()
        monitor.setCursorPos(1,1)   
        monitor.write("[ TNT DUPER ]")
        shell.exit()
    end
end