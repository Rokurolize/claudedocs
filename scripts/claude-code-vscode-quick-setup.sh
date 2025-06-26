#!/bin/bash
# Claude Code Quick VS Code Setup Script
# Run this to configure VS Code as default editor in WSL

echo "Setting up VS Code as default editor for WSL..."

# Step 1: Create launcher script
cat > /home/ubuntu/vscode-launcher.sh << 'EOF'
#!/bin/bash
# VS Code launcher via PowerShell - bypasses Claude Code capture

# Get the file path
if [ $# -eq 0 ]; then
    FILE_PATH="."
else
    FILE_PATH="$1"
fi

# Get absolute path
ABS_PATH=$(realpath "$FILE_PATH")

# Convert WSL path to Windows path
WIN_PATH=$(wslpath -w "$ABS_PATH")

# Launch VS Code via PowerShell with proper working directory
cd /mnt/c && powershell.exe -NoProfile -Command "Start-Process code.cmd -ArgumentList \"$WIN_PATH\" -NoNewWindow" 2>/dev/null &

echo "VS Code opened: $FILE_PATH"
EOF

# Step 2: Make executable
chmod +x /home/ubuntu/vscode-launcher.sh

# Step 3: Update .bashrc
if ! grep -q "alias edit=" ~/.bashrc; then
    echo 'alias edit="/home/ubuntu/vscode-launcher.sh"' >> ~/.bashrc
    echo 'alias e="/home/ubuntu/vscode-launcher.sh"' >> ~/.bashrc
else
    sed -i 's|alias edit=.*|alias edit="/home/ubuntu/vscode-launcher.sh"|' ~/.bashrc
    sed -i 's|alias e=.*|alias e="/home/ubuntu/vscode-launcher.sh"|' ~/.bashrc
fi

# Step 4: Set editor environment variables
if ! grep -q "export EDITOR=" ~/.bashrc; then
    echo 'export EDITOR="code --wait"' >> ~/.bashrc
    echo 'export VISUAL="code --wait"' >> ~/.bashrc
fi

# Step 5: Configure git
git config --global core.editor "/home/ubuntu/vscode-launcher.sh --wait"

# Step 6: Apply to current session
alias edit='/home/ubuntu/vscode-launcher.sh'
alias e='/home/ubuntu/vscode-launcher.sh'
export EDITOR="code --wait"
export VISUAL="code --wait"

echo "✅ Setup complete!"
echo ""
echo "Usage:"
echo "  edit filename    # Open file in VS Code"
echo "  e filename       # Short version"
echo "  edit .           # Open current directory"
echo ""
echo "Note: New terminals will have these commands available automatically."