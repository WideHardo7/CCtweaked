local args= {...}

local defaultSide="top"

if #args == 1 then
    defaultSide=args[1] -- Cambio del side se riferito come argomento al lancio
end

local monitor=peripheral.wrap(defaultSide)

monitor.setTextScale(0.5)
monitor.clear()

local check=false

function disegnaBottone(check)     
    if check then
        monitor.setBackgroundColor(colors.green)
    else
        monitor.setBackgroundColor(colors.red)    
    end         
    monitor.clearLine()
    monitor.setCursorPos(1,1)   
    monitor.write("[ TNT DUPER ]")
end

disegnaBottone(check)

while true do 
    local evento,lato,x,y = os.pullEvent("monitor_touch")
    if x>=1 and x<=15 and y==1 then     
        if check == false and fs.exists("TNT.lua") then
            check = not check 
            disegnaBottone(check)    
            shell.run("TNT.lua check")
        elseif fs.exists("TNT.lua")==false then
            shell.run("wget https://raw.githubusercontent.com/WideHardo7/CCtweaked/refs/heads/main/TNT.lua")
            shell.run("TNT.lua check")
        end
    end
end
