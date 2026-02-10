#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
DISPLAY=":99"
VNC_PORT="5900"
VS_CODE_DIR="/tmp/VSCode-linux-x64"
USER_DPI="dpi"
HOME_DPI="/home/dpi"
PYTHON_SCRIPT_PATH="python/runvs.py" # Relative to the script's execution directory

# List of packages to install via apt
APT_PACKAGES=(
    "xvfb" "x11vnc" "fluxbox" "xauth" "util-linux"
    "libcairo2-dev" "libgtk-3-0" "python3-pip" "python3-xlib" "python3-tk" "python3-dev"
    "libgbm1" "libnotify4" "libnss3" "libxkbfile1" "libxcomposite1" "libxdamage1" "libxfixes3" "libxrandr2"
    # xdotool removed as PyAutoGUI will handle GUI automation
)

# --- Helper Functions ---

# Function to run shell command with options
# Usage: run_command "command" [as_user USER] [background]
run_command() {
    local cmd="$1"
    shift
    local as_user=""
    local background=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            as_user)
                as_user="$2"
                shift 2
                ;;
            background)
                background=true
                shift
                ;;
            *)
                echo "Unknown option for run_command: $1" >&2
                exit 1
                ;;
        esac
    done

    local full_cmd=()
    if [[ -n "$as_user" ]]; then
        full_cmd=("sudo" "-E" "-u" "$as_user")
    fi

    # Handle commands that are bash -c "..."
    if [[ "$cmd" == bash -c * ]]; then
        full_cmd+=("$cmd")
    else
        # Simple command, split into words
        read -ra cmd_parts <<< "$cmd"
        full_cmd+=("${cmd_parts[@]}")
    fi

    echo "[DEBUG] Running: ${full_cmd[*]}"

    if [[ "$background" == true ]]; then
        "${full_cmd[@]}" &
        echo $! # Return PID
    else
        "${full_cmd[@]}"
    fi
}

# Function to check if a process is running
check_process() {
    local name="$1"
    echo "Checking for process: $name"
    if pgrep -x "$name" > /dev/null; then
        echo "$name is running:"
        pgrep -fa "$name"
    else
        echo "$name is NOT running!"
    fi
}

# Cleanup function to stop background processes
cleanup() {
    echo ""
    echo "Stopping background processes..."
    if [[ -n "$XVFB_PID" ]] && kill -0 "$XVFB_PID" 2>/dev/null; then
        echo "Stopping Xvfb (PID $XVFB_PID)..."
        kill "$XVFB_PID"
        wait "$XVFB_PID" 2>/dev/null # Wait for process to terminate
        echo "Xvfb stopped."
    fi
    if [[ -n "$FLUXBOX_PID" ]] && kill -0 "$FLUXBOX_PID" 2>/dev/null; then
        echo "Stopping Fluxbox (PID $FLUXBOX_PID)..."
        kill "$FLUXBOX_PID"
        wait "$FLUXBOX_PID" 2>/dev/null
        echo "Fluxbox stopped."
    fi
    if [[ -n "$X11VNC_PID" ]] && kill -0 "$X11VNC_PID" 2>/dev/null; then
        echo "Stopping x11vnc (PID $X11VNC_PID)..."
        kill "$X11VNC_PID"
        wait "$X11VNC_PID" 2>/dev/null
        echo "x11vnc stopped."
    fi
    # VS Code is handled by the Python script or by pkill if it's still running
    echo "Ensuring VS Code is stopped..."
    pkill -f "VSCode-linux-x64/bin/code" || true
    echo "Cleanup complete."
}

# Trap SIGINT (Ctrl+C) and SIGTERM to ensure cleanup runs
trap cleanup EXIT SIGINT SIGTERM

# --- Main Script ---

echo "Starting VS Code environment setup script..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo." >&2
   exit 1
fi

# 1. apt update
echo "Updating package lists..."
run_command "apt-get update -y"

# 2. apt install required packages
echo "Installing APT packages..."
run_command "apt-get install -y ${APT_PACKAGES[*]}"

# 3. Install PyAutoGUI through pip (global, as root)
echo "Installing PyAutoGUI..."
run_command "pip3 install pyautogui"

# 4. Set environment variables
export DONT_PROMPT_WSL_INSTALL='1'
export DISPLAY="$DISPLAY"
echo "Environment variables set: DISPLAY=$DISPLAY, DONT_PROMPT_WSL_INSTALL=$DONT_PROMPT_WSL_INSTALL"

# 5. (Commented out) Create user dpi with password 'password'
# input_data="password\npassword\nDpi User\n\n\n\n\nY\n"
# echo -e "$input_data" | run_command "adduser $USER_DPI"

# 6. (Commented out) Add to sudo group
# run_command "usermod -aG sudo $USER_DPI"

# 7. (Commented out) Install VS Code extension as dpi
# run_command "bash -c 'cd /tmp && $VS_CODE_DIR/bin/code --install-extension *.vsix --force'" as_user "$USER_DPI"

# 8. Start Xvfb in background
echo "Starting Xvfb on display $DISPLAY..."
XVFB_PID=$(run_command "Xvfb $DISPLAY -screen 0 1920x1080x24 +extension GLX +extension RANDR +render -noreset" background)
echo "Xvfb started with PID $XVFB_PID"
sleep 3 # Give Xvfb a moment to start

# Create .Xauthority
echo "Setting up Xauthority..."
COOKIE=$(mcookie)
XAUTH_ROOT="$HOME/.Xauthority"
XAUTH_DPI="$HOME_DPI/.Xauthority"

touch "$XAUTH_ROOT"
chmod 600 "$XAUTH_ROOT"
xauth add "$DISPLAY" . "$COOKIE" # For root

if id "$USER_DPI" &>/dev/null; then
    sudo -u "$USER_DPI" touch "$XAUTH_DPI"
    sudo -u "$USER_DPI" chmod 600 "$XAUTH_DPI"
    sudo -u "$USER_DPI" xauth add "$DISPLAY" . "$COOKIE" # For user dpi
    echo ".Xauthority created for root at $XAUTH_ROOT and for $USER_DPI at $XAUTH_DPI"
else
    echo "User $USER_DPI not found. Skipping .Xauthority setup for this user."
    echo ".Xauthority created for root at $XAUTH_ROOT"
fi


# 9. Start fluxbox in background as dpi
echo "Starting fluxbox..."
if id "$USER_DPI" &>/dev/null; then
    FLUXBOX_PID=$(run_command "fluxbox" as_user "$USER_DPI" background)
    echo "Fluxbox started with PID $FLUXBOX_PID"
else
    FLUXBOX_PID=$(run_command "fluxbox" background)
    echo "Fluxbox started as root with PID $FLUXBOX_PID"
fi
sleep 3

# 10. Start x11vnc in background
echo "Starting x11vnc on port $VNC_PORT..."
X11VNC_PID=$(run_command "x11vnc -display $DISPLAY -rfbport $VNC_PORT -forever -shared -noxdamage" background)
echo "x11vnc started with PID $X11VNC_PID"
sleep 3

# 11. Start VS Code in background as dpi
echo "Starting VS Code..."
if id "$USER_DPI" &>/dev/null; then
    # Note: VS Code PID is not explicitly managed here as Python script will handle its lifecycle or it will be cleaned up by pkill
    run_command "bash -c 'cd /tmp && $VS_CODE_DIR/bin/code . --disable-gpu --no-sandbox --verbose > /tmp/vscode.log 2>&1'" as_user "$USER_DPI" background
    echo "VS Code started as $USER_DPI."
else
    run_command "bash -c 'cd /tmp && $VS_CODE_DIR/bin/code . --disable-gpu --no-sandbox --verbose > /tmp/vscode.log 2>&1'" background
    echo "VS Code started as root."
fi
echo "Waiting for VS Code to load (this might take a while)..."
sleep 30 # Increased sleep for VS Code

check_process "Xvfb"
check_process "fluxbox"
check_process "x11vnc"
check_process "code"

# 12. Execute Python script for VS Code automation
echo "Environment setup complete. Handing off to Python script for automation: $PYTHON_SCRIPT_PATH"
echo "Connect via VNC to localhost:$VNC_PORT to view the session."

# Ensure the Python script can find necessary environment variables
# The Python script will handle its own process management for VS Code and PyAutoGUI
if [[ -f "$PYTHON_SCRIPT_PATH" ]]; then
    # Run the python script. The trap will handle cleanup of background services on exit.
    python3 "$PYTHON_SCRIPT_PATH"
else
    echo "Error: Python script not found at $PYTHON_SCRIPT_PATH"
    # The trap EXIT will still call cleanup
fi

echo "Python script execution finished."
# Cleanup will be called automatically by the trap

echo "Step 8: Open chat (Ctrl+')"
xdotool key ctrl+apostrophe
sleep 3

echo "Step 9: Input chat message and press enter"
xdotool type 'Please solve how recursive function works in Python and append your answer to the file "/tmp/answer.log". Make sure that the existing content in the file is not deleted and the new answer is appended to the final line.'
xdotool key Return
sleep 2

echo "PyAutoGUI (xdotool) actions completed."

# Keep the script running to hold the processes
echo "All processes started. Connect via VNC to localhost:$VNC_PORT. Press Ctrl+C to stop."
cleanup() {
    echo ""
    echo "Stopping processes..."
    if [[ -n "$XVFB_PID" ]] && kill -0 "$XVFB_PID" 2>/dev/null; then
        kill "$XVFB_PID"
        echo "Xvfb (PID $XVFB_PID) stopped."
    fi
    if [[ -n "$FLUXBOX_PID" ]] && kill -0 "$FLUXBOX_PID" 2>/dev/null; then
        kill "$FLUXBOX_PID"
        echo "Fluxbox (PID $FLUXBOX_PID) stopped."
    fi
    if [[ -n "$X11VNC_PID" ]] && kill -0 "$X11VNC_PID" 2>/dev/null; then
        kill "$X11VNC_PID"
        echo "x11vnc (PID $X11VNC_PID) stopped."
    fi
    if [[ -n "$VS_CODE_PID" ]] && kill -0 "$VS_CODE_PID" 2>/dev/null; then
        kill "$VS_CODE_PID"
        echo "VS Code (PID $VS_CODE_PID) stopped."
    fi
    # Add a final pkill for safety, especially for code
    pkill -f "VSCode-linux-x64/bin/code" || true
    echo "Done."
    exit 0
}

# Trap SIGINT (Ctrl+C) and SIGTERM
trap cleanup SIGINT SIGTERM

# Loop to keep script alive
while true; do
    sleep 10
done
