if fs.exists("GeodeScanner") then
    shell.run("GeodeScanner ")
else 
    shell.run("wget https://raw.githubusercontent.com/WideHardo7/CCtweaked/refs/heads/main/GeodeScanner.lua")
    shell.run("GeodeScanner ")
end