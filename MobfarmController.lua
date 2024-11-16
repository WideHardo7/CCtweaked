-- Computer Centrale (Controller)
-- Salva come startup.lua

-- Configurazione
local BROADCAST_CHANNEL = 1
local REGISTRATION_CHANNEL = 2
local BUTTON_HEIGHT = 3
local BUTTON_SPACING = 1

-- Inizializza periferiche
local modem = peripheral.find("modem")
if not modem then
    print("Modem wireless non trovato!")
    return
end

local monitor = peripheral.find("monitor")
if not monitor then
    print("Monitor non trovato!")
    return
end

-- Apri canali per la comunicazione
modem.open(BROADCAST_CHANNEL)
modem.open(REGISTRATION_CHANNEL)

-- Tabella per tenere traccia dei computer registrati
local registeredComputers = {}

-- Funzione per aggiornare l'interfaccia del monitor
local function updateMonitor()
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.setTextScale(1)
    monitor.write("Sistema Controllo Mob Farm")
    
    local yPos = 3
    for id, computer in pairs(registeredComputers) do
        monitor.setCursorPos(1, yPos)
        monitor.write(string.format("[ %s ]", computer.name))
        computer.buttonY = yPos
        yPos = yPos + BUTTON_HEIGHT + BUTTON_SPACING
    end
end

-- Funzione per gestire la registrazione di nuovi computer
local function handleRegistration()
    while true do
        local _, _, channel, _, message, distance = os.pullEvent("modem_message")
        
        if channel == REGISTRATION_CHANNEL and type(message) == "table" then
            if message.type == "register" then
                local computerId = message.id
                if not registeredComputers[computerId] then
                    registeredComputers[computerId] = {
                        id = computerId,
                        name = message.name or ("Computer " .. computerId),
                        state = false
                    }
                    print("Nuovo computer registrato: " .. computerId)
                    updateMonitor()
                end
                -- Invia conferma di registrazione
                modem.transmit(REGISTRATION_CHANNEL, REGISTRATION_CHANNEL, {
                    type = "ack",
                    id = computerId
                })
            elseif message.type == "heartbeat" then
                -- Aggiorna timestamp ultimo heartbeat
                if registeredComputers[message.id] then
                    registeredComputers[message.id].lastSeen = os.epoch("local")
                end
            end
        end
    end
end

-- Funzione per gestire i click sul monitor
local function handleClick()
    while true do
        local _, _, x, y = os.pullEvent("monitor_touch")
        
        for id, computer in pairs(registeredComputers) do
            if y == computer.buttonY then
                computer.state = not computer.state
                modem.transmit(BROADCAST_CHANNEL, BROADCAST_CHANNEL, {
                    type = "toggle",
                    id = id,
                    state = computer.state
                })
                break
            end
        end
    end
end

-- Funzione per rimuovere computer inattivi
local function cleanupInactiveComputers()
    while true do
        local currentTime = os.epoch("local")
        for id, computer in pairs(registeredComputers) do
            if computer.lastSeen and currentTime - computer.lastSeen > 30000 then -- 30 secondi timeout
                registeredComputers[id] = nil
                print("Computer rimosso per inattività: " .. id)
                updateMonitor()
            end
        end
        sleep(5)
    end
end

-- Avvia tutti i thread
parallel.waitForAll(handleRegistration, handleClick, cleanupInactiveComputers)

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
                redstone.setOutput("back", message.state)
                print("Stato redstone: " .. (message.state and "ON" or "OFF"))
            end
        end
    end
end

-- Registra il computer e avvia la gestione dei comandi
if register() then
    parallel.waitForAll(handleCommands, sendHeartbeat)
end