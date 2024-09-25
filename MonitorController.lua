local defaultSide="top"
local redstoneSide="back"
local monitor=peripheral.wrap(defaultSide)
local colore=false

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
        while os.pullEvent("monitor_touch")==nil do
            redstone.setOutput(redstoneSide,true)
            sleep(1)
            redstone.setOutput(redstoneSide,false)
            sleep(1)
        end
     end  
end

