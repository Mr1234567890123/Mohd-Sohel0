#!/data/data/com.termux/files/usr/bin/bash

clear

# 🎨 Colors
RED=$(printf "\033[1;31m")
GREEN=$(printf "\033[1;32m")
YELLOW=$(printf "\033[1;33m")
BLUE=$(printf "\033[1;34m")
CYAN=$(printf "\033[1;36m")
NC=$(printf "\033[0m")

# 🌐 Internet Check
check_internet() {
  echo -e "${BLUE}🔍 Checking internet connection...${NC}"
  if ping -c 1 1.1.1.1 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Internet is working!${NC}"
  else
    echo -e "${RED}❌ No internet connection!${NC}"
    echo -e "${RED}📴 Please connect to the internet and try again.${NC}"
    exit 1
  fi
}

# 🌈 Rainbow Banner
rainbow_banner() {
  local text=$1
  local colors=(31 33 32 36 34 35)
  local i=0
  for ((c=0; c<${#text}; c++)); do
    printf "\e[1;${colors[i]}m${text:$c:1}"
    ((i=(i+1)%${#colors[@]}))
  done
  printf "\e[0m\n"
}

# 🔊 Beep Sound
play_beep() {
  if command -v mpv > /dev/null; then
    mpv --no-video --really-quiet ~/.sfx/beep.wav > /dev/null 2>&1 &
  fi
}

# 🎵 Setup beep.wav
setup_sfx() {
  mkdir -p ~/.sfx
  if [ ! -f ~/.sfx/beep.wav ]; then
    curl -s -L -o ~/.sfx/beep.wav https://www.soundjay.com/button/beep-07.wav
  fi
}

# 🔄 Spinner
spin() {
  pid=$!
  spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    for i in $(seq 0 3); do
      printf "\r${YELLOW}[%c] ${TASK_MSG}...${NC} " "${spinstr:$i:1}"
      sleep 0.1
    done
  done
  printf "\r${GREEN}[✓] ${TASK_MSG}...Done!     ${NC}\n"
}

# 📅 System Info
DATE=$(date +"%Y-%m-%d")
DEVICE="Android | Termux"

# 🚀 Start
clear
check_internet
setup_sfx

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}   🩺  Starting Doctor Setup...${NC}"
figlet -f slant "DOCTOR SETUP" | lolcat
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "📅 Date: ${YELLOW}$DATE${NC}"
echo -e "📱 Device: ${YELLOW}$DEVICE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 🔧 Installing
TASK_MSG="Updating packages"
(play_beep; pkg update -y > /dev/null 2>&1) & spin

TASK_MSG="Installing Python"
(play_beep; pkg install python -y > /dev/null 2>&1) & spin

TASK_MSG="Installing Cloudflared"
(play_beep; pkg install cloudflared -y > /dev/null 2>&1) & spin

TASK_MSG="Finalizin Setup"
(play_beep; pkg install mpv -y > /dev/null 2>&1) & spin

# ✅ Done
echo -e "${GREEN}✅ All tasks completed successfully!${NC}"
rainbow_banner "READY TO GO! 🚀"
play_beep
