# Definições de cores
GREEN="\033[0;32m"
CYAN="\033[0;36m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"  # Sem cor

line="--------------------------------------------------"

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
if command -v nvidia-smi &> /dev/null
then
    nvidia-smi --query-gpu=name,memory.free,memory.total,utilization.gpu --format=csv,noheader,nounits
else
    echo -e "${RED}No NVIDIA GPU detected.${NC}"
fi
echo $line

# Disk Usage Info
echo -e "${BLUE}✔ Disk Space Usage:${NC}"
echo $line
df -h | awk 'NR==1{print $0} NR>1{print $0}' | column -t
echo $line

# Memory Usage Info
echo -e "${CYAN}✔ Memory Usage:${NC}"
echo $line
free -h | awk 'NR==1{print $0} NR>1{print $0}' | column -t
echo $line

# Network Info
echo -e "${GREEN}✔ Network Information:${NC}"
echo $line
ifconfig | grep -E "inet|ether" | awk '{print $1, $2}'
echo $line

echo -e "${CYAN}###############################################"
echo "#       End of SYSTEM INFO. Enjoy!           #"
echo "###############################################"
echo -e "${NC}"
