local defaultSide="up"

if #args == 1 then
    defaultSide=args[1] -- Cambio del side se riferito come argomento al lancio
end

local monitor=peripheral.wrap(defaultSide)

monitor.setTextScale(1)
monitor.clear()

local check 
function disegnaBottone(check)
    if check then
        monitor.setBackgroundColor(colors.green)
    else
        monitor.setBackgroundColor(colors.red)    
    end
    monitor.clearLine()
    monitor.setCursorPos(2,2)
end
