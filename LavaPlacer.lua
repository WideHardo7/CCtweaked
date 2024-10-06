
print("Digitare la quantità di Thermalilies presenti (1-8): ")

local quantita  -- Dichiariamo 'quantita' come variabile locale all'inizio

local function readWithTimeout(timeout)
    local sInput = ""
    local nTimer = os.startTimer(timeout)
    while true do
        local event, param = os.pullEvent()
        if event == "char" then
            sInput = sInput .. param
            write(param)
        elseif event == "key" then
            if param == keys.enter then
                print()
                return sInput
            elseif param == keys.backspace then
                if #sInput > 0 then
                    sInput = sInput:sub(1, -2)
                    write("\b \b")
                end
            end
        elseif event == "timer" and param == nTimer then
            print()
            return nil  -- Timeout scaduto
        end
    end
end

function getUserInput()
    quantita = nil
    while quantita == nil do
        local input = readWithTimeout(15)
        if input then
            local num = tonumber(input)
            if num and num >= 1 and num <= 8 then
                quantita = num
            else
                print("\nValore non valido; inserire un numero tra 1 e 8:")
            end
        else
            quantita = 1
            print("Nessun input rilevato entro 15 secondi. Valore predefinito impostato a 1.")
        end
    end
end

function loopLava(numTherm)
    for i = 1, numTherm do
        redstone.setOutput("back", true)
        sleep(2)
        redstone.setOutput("back", false)
    end
end

-- Assicurati che l'API 'keys' sia caricata
if not keys then
    os.loadAPI("keys")
end

-- Ciclo principale
while true do
    getUserInput()  -- Ottieni il numero di Thermalilies
    loopLava(quantita)
    print("Attesa di 300 secondi prima del prossimo ciclo...")
    sleep(300)
end
