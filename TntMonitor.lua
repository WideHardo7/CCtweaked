local args= {...}

local defaultSide="up"

if #args == 1 then
    defaultSide=args[1] -- Cambio del side se riferito come argomento al lancio
end

local monitor=peripheral.wrap(defaultSide)

monitor.setTextScale(1)
monitor.clear()

local check=false

function disegnaBottone(check)
    if check then
        monitor.setBackgroundColor(colors.green)
    else
        monitor.setBackgroundColor(colors.red)    
    end
    monitor.clearLine()
    monitor.setCursorPos(2,2)
    monitor.write("[ TNT DUPER ]")
end

disegnaBottone(check)

while true do 
    local evento lato,x,y = os.pullEvent("monitor_touch")
    if x>=2 and x<=15 and y==2 then
        check = not check 
        disegnaBottone(check)       
        if fs.exists("TNT") then
            shell.run("TNT",check)
        else
            shell.run("wget https://github.com/WideHardo7/CCtweaked/blob/main/TNT.lua")
        end
    end
end
