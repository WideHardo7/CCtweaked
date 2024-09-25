local defaultSide="top"
local redstoneSide="back"
local monitor=peripheral.wrap(defaultSide)
local colore=false
local running=false

monitor.setTextScale(0.5)
monitor.clear()


function disegnaBottone(colore)     
    if colore then
        monitor.setBackgroundColor(colors.green)
    else
        monitor.setBackgroundColor(colors.red)    
    end         
    monitor.clearLine()
    monitor.setCursorPos(1,1)   
    monitor.write("[ TNT DUPER ]")
end

disegnaBottone(colore)

while true do 
    local evento,lato,x,y = os.pullEvent("monitor_touch")
    if x>=1 and x<=15 and y==1 then  
        colore= not colore   
        disegnaBottone(colore)
        running = not running  -- Invertiamo lo stato di running

        if running then
            -- Inizia il ciclo redstone
            while running do
                redstone.setOutput(redstoneSide, true)
                sleep(1)
                redstone.setOutput(redstoneSide, false)
                sleep(1)
                
                -- Verifichiamo se il pulsante è stato premuto nuovamente
                local event, side, x2, y2 = os.pullEventRaw("monitor_touch")
                if x2 >= 1 and x2 <= 15 and y2 == 1 then
                    running = false
                    colore = not colore -- Cambia nuovamente il colore
                    disegnaBottone(colore)
                end
            end
        end
     end  
end

