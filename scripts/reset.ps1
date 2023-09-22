Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Temp\nvim"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim-data"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim\bootstrap-lock.json"
Remove-Item -Recurse -Force "$env:TMP\nvim"
