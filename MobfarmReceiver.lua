-- Computer Secondario (Receiver)
-- Salva come startup.lua nei computer collegati al redstone

local BROADCAST_CHANNEL = 1
local REGISTRATION_CHANNEL = 2
local COMPUTER_ID = os.getComputerID()
local COMPUTER_NAME = "Mob Farm " .. COMPUTER_ID -- Puoi personalizzare il nome

-- Inizializza il modem
local modem = peripheral.find("modem")
if not modem then
    print("Modem wireless non trovato!")
    return
end

modem.open(BROADCAST_CHANNEL)
modem.open(REGISTRATION_CHANNEL)

-- Funzione per registrarsi al controller
local function register()
    while true do
        print("Tentativo di registrazione...")
        modem.transmit(REGISTRATION_CHANNEL, REGISTRATION_CHANNEL, {
            type = "register",
            id = COMPUTER_ID,
            name = COMPUTER_NAME
        })
        
        -- Attendi conferma
        local timer = os.startTimer(5)
        while true do
            local event, param1, channel, _, message = os.pullEvent()
            if event == "modem_message" and channel == REGISTRATION_CHANNEL then
                if type(message) == "table" and message.type == "ack" and message.id == COMPUTER_ID then
                    print("Registrazione completata!")
                    return true
                end
            elseif event == "timer" and param1 == timer then
                break
            end
        end
        sleep(2)
    end
end

-- Funzione per inviare heartbeat
local function sendHeartbeat()
    while true do
        modem.transmit(REGISTRATION_CHANNEL, REGISTRATION_CHANNEL, {
            type = "heartbeat",
            id = COMPUTER_ID
        })
        sleep(5)
    end
end

-- Funzione per gestire i comandi
local function handleCommands()
    while true do
        local _, _, channel, _, message = os.pullEvent("modem_message")
        if channel == BROADCAST_CHANNEL and type(message) == "table" then
            if message.type == "toggle" and message.id == COMPUTER_ID then
                redstone.setOutput("bottom", message.state)
                print("Stato redstone: " .. (message.state and "ON" or "OFF"))
            end
        end
    end
end

-- Registra il computer e avvia la gestione dei comandi
if register() then
    parallel.waitForAll(handleCommands, sendHeartbeat)
end