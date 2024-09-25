print("Digitare la quantità di thermalily presente: ")
local timer = os.startTimer()
local quantita = read()

function loopLava(numTherm)
    for i=1, numTherm, 1 do
        redstone.setOutput("back", true)
        sleep(1)
        redstone.setOutput("back", false)
    end
end

while true do  

    if quantita==nil and timer>15 then
        quantita=1
        print("Valore predefinito a 1")
    end

    if quantita>8 then
        print("Valore non valido; massimo valore = 8")
        print("Reinserire valore: ")
        quantita=read()
    end
    
    loopLava(quantita)

    sleep(300)
   
end