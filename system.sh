# Definições de cores
GREEN="\033[0;32m"
CYAN="\033[0;36m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"  # Sem cor

line="--------------------------------------------------"

# Função para verificar a disponibilidade de um comando
check_command() {
  command -v "$1" &> /dev/null
}

# Exibição de informações de maneira agradável
clear

echo -e "${CYAN}"
echo "###############################################"
echo "#               SYSTEM INFO                  #"
echo "###############################################"
echo -e "${NC}"
echo $line

# CPU Info
echo -e "${GREEN}✔ CPU Information:${NC}"
echo $line
lscpu | awk -F: '/^Model name/ {print "Model: " $2} /^CPU MHz/ {print "Speed: " $2 " MHz"} /^Core(s) per socket/ {print "Cores: " $2} /^Thread(s) per core/ {print "Threads per core: " $2}'
echo $line

# GPU Info
echo -e "${YELLOW}✔ GPU Information:${NC}"
echo $line
if check_command "nvidia-smi"; then
    nvidia-smi --query-gpu=name,memory.free,memory.total,utilization.gpu --format=csv,noheader,nounits
else
    echo -e "${RED}No NVIDIA GPU detected.${NC}"
fi
echo $line

# Disk Usage Info
echo -e "${BLUE}✔ Disk Space Usage:${NC}"
echo $line
if check_command "column"; then
    df -h | column -t
else
    df -h
    echo -e "${RED}Warning: 'column' command not found, disk space info may not be formatted nicely.${NC}"
fi
echo $line

# Memory Usage Info
echo -e "${CYAN}✔ Memory Usage:${NC}"
echo $line
if check_command "column"; then
    free -h | column -t
else
    free -h
    echo -e "${RED}Warning: 'column' command not found, memory usage info may not be formatted nicely.${NC}"
fi
echo $line

# Network Info
echo -e "${GREEN}✔ Network Information:${NC}"
echo $line
if check_command "ip"; then
    ip a | grep -E "inet|ether" | awk '{print $1, $2}'
else
    echo -e "${RED}Warning: 'ip' command not found, network information may be incomplete.${NC}"
fi
echo $line

echo -e "${CYAN}###############################################"
echo "#       End of SYSTEM INFO. Enjoy!           #"
echo "###############################################"
echo -e "${NC}"
