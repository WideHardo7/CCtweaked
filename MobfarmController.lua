-- Computer Centrale (Controller)
-- Salva come startup.lua

-- Configurazione
local BROADCAST_CHANNEL = 1
local REGISTRATION_CHANNEL = 2
local BUTTON_HEIGHT = 1  -- Ridotto da 3 a 1
local BUTTON_SPACING = 1

-- Colori per gli stati
local COLORS = {
    TEXT = colors.white,
    BACKGROUND = colors.black,
    BUTTON_ON = colors.green,
    BUTTON_OFF = colors.red,
    TITLE = colors.yellow
}

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

-- Funzione per disegnare un bottone
local function drawButton(name, y, isActive)
    local width = monitor.getSize()
    monitor.setCursorPos(1, y)
    
    -- Imposta i colori in base allo stato
    monitor.setBackgroundColor(isActive and COLORS.BUTTON_ON or COLORS.BUTTON_OFF)
    monitor.setTextColor(COLORS.TEXT)
    
    -- Disegna il bottone con padding
    local buttonText = string.format(" %s %s ", name, isActive and "ON" or "OFF")
    monitor.write(buttonText)
    
    -- Resetta i colori
    monitor.setBackgroundColor(COLORS.BACKGROUND)
    monitor.setTextColor(COLORS.TEXT)
end

-- Funzione per aggiornare l'interfaccia del monitor
local function updateMonitor()
    monitor.setBackgroundColor(COLORS.BACKGROUND)
    monitor.clear()
    
    -- Titolo
    monitor.setTextColor(COLORS.TITLE)
    monitor.setCursorPos(1,1)
    monitor.setTextScale(0.5)  -- Riduce la dimensione del testo
    monitor.write("Sistema Controllo Mob Farm")
    
    -- Bottoni
    local yPos = 3
    for id, computer in pairs(registeredComputers) do
        drawButton(computer.name, yPos, computer.state)
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
                updateMonitor()  -- Aggiorna immediatamente l'interfaccia
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
