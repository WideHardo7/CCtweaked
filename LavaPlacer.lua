print("Digitare la quantità di Thermalilies presenti (1-8): ")
local quantita
local timerID = os.startTimer(15)  -- Start a 15-second timer for default value

-- Function to handle user input with a timeout
local function getUserInput()
    while true do
        local event, param = os.pullEvent()

        if event == "timer" and param == timerID then
            -- Timer expired, set default value
            quantita = 1
            print("Nessun input rilevato entro 15 secondi. Valore predefinito impostato a 1.")
            break
        elseif event == "char" then
            -- User started typing, reset the timer
            os.cancelTimer(timerID)
            timerID = nil
        elseif event == "key" then
            -- Ignore key events
        elseif event == "terminate" then
            error("Script terminato dall'utente.")
        elseif event == "mouse_click" then
            -- Ignore mouse clicks
        elseif event == "paste" then
            -- Ignore paste events
        elseif event == "rednet_message" then
            -- Ignore rednet messages
        elseif event == "modem_message" then
            -- Ignore modem messages
        elseif event == "monitor_touch" then
            -- Ignore monitor touches
        elseif event == "mouse_drag" then
            -- Ignore mouse drags
        elseif event == "mouse_scroll" then
            -- Ignore mouse scrolls
        elseif event == "key_up" then
            -- Ignore key up events
        elseif event == "char" then
            -- Ignore char events
        elseif event == "term_resize" then
            -- Ignore terminal resize events
        elseif event == "task_complete" then
            -- Ignore task complete events
        elseif event == "turtle_inventory" then
            -- Ignore turtle inventory events
        elseif event == "turtle_changed" then
            -- Ignore turtle changed events
        elseif event == "disk" then
            -- Ignore disk events
        elseif event == "disk_eject" then
            -- Ignore disk eject events
        elseif event == "peripheral" then
            -- Ignore peripheral events
        elseif event == "peripheral_detach" then
            -- Ignore peripheral detach events
        elseif event == "redstone" then
            -- Ignore redstone events
        elseif event == "timer" then
            -- Ignore other timers
        elseif event == "http_success" then
            -- Ignore HTTP success events
        elseif event == "http_failure" then
            -- Ignore HTTP failure events
        elseif event == "websocket_success" then
            -- Ignore websocket success events
        elseif event == "websocket_failure" then
            -- Ignore websocket failure events
        elseif event == "websocket_message" then
            -- Ignore websocket messages
        elseif event == "websocket_closed" then
            -- Ignore websocket closed events
        elseif event == "mouse_up" then
            -- Ignore mouse up events
        elseif event == "mouse_hover" then
            -- Ignore mouse hover events
        else
            -- Handle other events
            if timerID then
                os.cancelTimer(timerID)
                timerID = nil
            end
        end

        if not quantita then
            quantita = read()
            if quantita ~= "" then
                quantita = tonumber(quantita)
                if quantita and quantita >= 1 and quantita <= 8 then
                    break  -- Valid input received
                else
                    print("Valore non valido; inserire un numero tra 1 e 8:")
                    quantita = nil  -- Reset quantita to prompt again
                end
            else
                print("Input vuoto. Inserire un numero tra 1 e 8:")
                quantita = nil  -- Reset quantita to prompt again
            end
        end
    end
end

function loopLava(numTherm)
    for i = 1, numTherm do
        redstone.setOutput("back", true)
        sleep(1)
        redstone.setOutput("back", false)
    end
end

-- Main Loop
while true do
    quantita = nil
    timerID = os.startTimer(15)  -- Reset the timer for user input
    getUserInput()  -- Get the number of Thermalilies

    loopLava(quantita)
    print("Attesa di 300 secondi prima del prossimo ciclo...")
    sleep(300)
end
