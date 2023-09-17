$nvim-config = "$env:LOCALAPPDATA\nvim"

Remove-Item -Path "$nvim-config\.git\hooks\*"
Remove-Item -Path "$nvim-config\scripts\bin\*"

cd "$nvim-config\scripts\nvim-utils"

cargo build --release

# copy git hooks
Copy-Item -Path ".\target\release\post-merge.exe" -Destination "$nvim-config\.git\hooks\post-merge.exe"

# copy other binaries
Copy-Item -Path ".\target\release\bootstrap.exe" -Destination "$nvim-config\scripts\bin\bootstrap.exe"
# Copy-Item -Path ".\target\release\ts-parsers-download.exe" -Destination "$nvim-config\scripts\bin\ts-parsers-download.exe"
# Copy-Item -Path ".\target\release\ts-parsers-compile.exe" -Destination "$nvim-config\scripts\bin\ts-parsers-compile.exe"
# Copy-Item -Path ".\target\release\ts-parsers-compile-local.exe" -Destination "$nvim-config\scripts\bin\ts-parsers-compile-local.exe"
