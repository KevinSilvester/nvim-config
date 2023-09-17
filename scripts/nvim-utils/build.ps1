$nvim_config = "$env:LOCALAPPDATA\nvim"

Remove-Item -Path "$nvim_config\.git\hooks\*"
Remove-Item -Path "$nvim_config\scripts\bin\*"
New-Item -Path "$nvim_config\scripts\bin\.gitkeep" -ItemType File

cd "$nvim_config\scripts\nvim-utils"

cargo build --release

# copy git hooks
Copy-Item -Path ".\target\release\post-merge.exe" -Destination "$nvim_config\.git\hooks\post-merge.exe"

# copy other binaries
Copy-Item -Path ".\target\release\bootstrap.exe" -Destination "$nvim_config\scripts\bin\bootstrap.exe"
# Copy-Item -Path ".\target\release\ts-parsers-download.exe" -Destination "$nvim_config\scripts\bin\ts-parsers-download.exe"
# Copy-Item -Path ".\target\release\ts-parsers-compile.exe" -Destination "$nvim_config\scripts\bin\ts-parsers-compile.exe"
# Copy-Item -Path ".\target\release\ts-parsers-compile-local.exe" -Destination "$nvim_config\scripts\bin\ts-parsers-compile-local.exe"
