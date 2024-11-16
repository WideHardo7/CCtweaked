if fs.exists("GeodeScanner") then
    shell.run("GeodeScanner ")
else 
    shell.run("wget https://raw.githubusercontent.com/WideHardo7/CCtweaked/refs/heads/main/GeodeScanner.lua")
    shell.run("GeodeScanner ")
end

if fs.exists("MobfarmReceiver") then
    shell.run("MobfarmReceiver")
else 
    shell.run("wget https://raw.githubusercontent.com/WideHardo7/CCtweaked/refs/heads/main/MobfarmReceiver.lua")
    shell.run("MobfarmReceiver")
end

if fs.exists("MobfarmController") then
    shell.run("MobfarmController")
else 
    shell.run("wget https://raw.githubusercontent.com/WideHardo7/CCtweaked/refs/heads/main/MobfarmController.lua")
    shell.run("MobfarmController")
end