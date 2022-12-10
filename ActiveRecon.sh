#!/bin/bash

# Colours
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
end="\e[0m"

# Banner
echo -e $red"
 _______  _______ __________________          _______  _______  _______  _______  _______  _
(  ___  )(  ____ \\__   __/\__   __/|\     /|(  ____ \(  ____ )(  ____ \(  ____ \(  ___  )( (    /|
| (   ) || (    \/   ) (      ) (   | )   ( || (    \/| (    )|| (    \/| (    \/| (   ) ||  \  ( |
| (___) || |         | |      | |   | |   | || (__    | (____)|| (__    | |      | |   | ||   \ | |
|  ___  || |         | |      | |   ( (   ) )|  __)   |     __)|  __)   | |      | |   | || (\ \) |
| (   ) || |         | |      | |    \ \_/ / | (      | (\ (   | (      | |      | |   | || | \   |
| )   ( || (____/\   | |   ___) (___  \   /  | (____/\| ) \ \__| (____/\| (____/\| (___) || )  \  |
|/     \|(_______/   )_(   \_______/   \_/   (_______/|/   \__/(_______/(_______/(_______)|/    )_)

"$end

# Environment Variables
bot_token=$bot_telegram_token
chat_ID=$chat_ID
url="https://api.telegram.org/bot$bot_token/sendMessage"
date=$(date '-I')
URLSCAN_API_KEY=$URLSCAN_API_KEY
VTCLI_APIKEY=$VTCLI_APIKEY
OrganizationName=$OrganizationName

# Functions

check_root(){
	if [ "$(id -u)" != "0" ]; then
		echo -e $red"[X] Este programa solo puede ejecutarse siendo ROOT!"$end
		exit 1
	fi
}

check_dependencies(){
	echo -e $green"[+] "$end"Chequeando dependencias...\n"
	mkdir -p /opt/tools_ActiveRecon
    mkdir -p /opt/BugBounty/Programs
    mkdir -p /opt/BugBounty/Targets
	grep 'deb http://http.kali.org/kali kali-rolling main contrib non-free' /etc/apt/sources.list > /dev/null
	if [ "$(echo $?)" -ne "0" ]; then
		echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" | sudo tee /etc/apt/sources.list > /dev/null
		wget -q -O - archive.kali.org/archive-key.asc | sudo apt-key add &> /dev/null
		sudo apt update &> /dev/null
	fi
	export PATH="$PATH:/opt/tools_ActiveRecon"
	dependencies=(findomain assetfinder amass subfinder httprobe AnalyticsIDCoincidence.py waybackurl aquatone vt zile.py linkfinder.py urlscan subjs dirsearch.py sub404.py)
	for dependency in "${dependencies[@]}"; do
		which $dependency > /dev/null 2>&1
		if [ "$(echo $?)" -ne "0" ]; then
			echo -e $red"[X] $dependency "$end"no esta instalado."
			case $dependency in
				findomain)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					wget -q --show-progress https://github.com/Findomain/Findomain/releases/download/8.2.1/findomain-aarch64.zip -O /opt/tools_ActiveRecon/findomain.zip && unzip -qq /opt/tools_ActiveRecon/findomain.zip -d /opt/tools_ActiveRecon/ && rm /opt/tools_ActiveRecon/findomain.zip && chmod +x /opt/tools_ActiveRecon/findomain && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				assetfinder)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					sudo apt install $dependency -y > /dev/null 2>&1 && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				amass)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					sudo apt install $dependency -y > /dev/null 2>&1 && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				subfinder)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					sudo apt install $dependency -y > /dev/null 2>&1 && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				httprobe)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					sudo apt install $dependency -y > /dev/null 2>&1 && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
                AnalyticsIDCoincidence)
                    echo -e "${yellow}[..]${end} Instalando $dependency"
                    wget -q --show-progress https://raw.githubusercontent.com/p0ch4t/AnalyticsIDCoincidence/main/AnalyticsIDCoincidence.py -O /opt/tools_ActiveRecon/AnalyticsIDCoincidence.py && chmod +x /opt/tools_ActiveRecon/AnalyticsIDCoincidence.py && sed -i '1s/^/#!\/usr\/bin\/python3\n/' /opt/tools_ActiveRecon/AnalyticsIDCoincidence.py && echo -e "${green}[V] $dependency${end} instalado correctamente!"
				    ;;
                waybackurl)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					git clone -q https://github.com/tomnomnom/waybackurls /opt/tools_ActiveRecon/waybackurls; go build /opt/tools_ActiveRecon/waybackurls/main.go && mv main /opt/tools_ActiveRecon/waybackurl && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				aquatone)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					wget -q --show-progress https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_arm64_1.7.0.zip -O /opt/tools_ActiveRecon/aquatone.zip && unzip -q /opt/tools_ActiveRecon/aquatone.zip -d /opt/tools_ActiveRecon && rm /opt/tools_ActiveRecon/aquatone.zip /opt/tools_ActiveRecon/README.md /opt/tools_ActiveRecon/LICENSE.txt && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
                vt)
                    echo -e "${yellow}[..]${end} Instalando $dependency"
                    git clone -q https://github.com/VirusTotal/vt-cli /opt/tools_ActiveRecon/vt-cli; make -s -C /opt/tools_ActiveRecon/vt-cli/ && mv /opt/tools_ActiveRecon/vt-cli/build/vt /opt/tools_ActiveRecon/ && echo -e "${green}[V] $dependency${end} instalado correctamente!"
                    ;;
				zile.py)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					wget https://raw.githubusercontent.com/bonino97/new-zile/master/zile.py -q --show-progress -O /opt/tools_ActiveRecon/zile.py && chmod +x /opt/tools_ActiveRecon/zile.py && sed -i '1s/^/#!\/usr\/bin\/python3\n/' /opt/tools_ActiveRecon/zile.py && pip3 install termcolor --root-user-action=ignore -q && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				linkfinder.py)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					cd /opt/tools_ActiveRecon; git clone https://github.com/GerbenJavado/LinkFinder.git -q && pip3 install -r LinkFinder/requirements.txt --root-user-action=ignore -q && ln -s /opt/tools_ActiveRecon/LinkFinder/linkfinder.py /opt/tools_ActiveRecon/linkfinder.py && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				urlscan)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					pip3 install urlscan --root-user-action=ignore -q && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				subjs)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					wget -q --show-progress https://github.com/lc/subjs/releases/download/v1.0.1/subjs_1.0.1_linux_amd64.tar.gz -O /opt/tools_ActiveRecon/subjs.tar.gz && tar -xzf /opt/tools_ActiveRecon/subjs.tar.gz -C /opt/tools_ActiveRecon/ && rm /opt/tools_ActiveRecon/subjs.tar.gz /opt/tools_ActiveRecon/LICENSE /opt/tools_ActiveRecon/README.md && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				dirsearch.py)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					wget -q --show-progress https://github.com/maurosoria/dirsearch/archive/refs/tags/v0.4.0.zip -O /opt/tools_ActiveRecon/dirsearch.zip && unzip -q /opt/tools_ActiveRecon/dirsearch.zip -d /opt/tools_ActiveRecon/ && rm /opt/tools_ActiveRecon/dirsearch.zip && ln -s /opt/tools_ActiveRecon/dirsearch-0.4.0/dirsearch.py /opt/tools_ActiveRecon/dirsearch.py && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
				sub404.py)
					echo -e "${yellow}[..]${end} Instalando $dependency"
					cd /opt/tools_ActiveRecon; git clone https://github.com/r3curs1v3-pr0xy/sub404 -q && pip3 install -r sub404/requirements.txt --root-user-action=ignore -q && ln -s /opt/tools_ActiveRecon/sub404/sub404.py /opt/tools_ActiveRecon/sub404.py && echo -e "${green}[V] $dependency${end} instalado correctamente!"
					;;
			esac
		else
			echo -e $green"[V] $dependency"$end
		fi
	done
}

main(){
    # Validaciones
    ls /opt/BugBounty/Targets/$file > /dev/null 2>&1
    if [[ "$(echo $?)" != "0" ]]; then
        echo -e $red"\n[X]"$end $bold"No se encontró '$file'. Cree un archivo target_{program}.txt en la ruta /opt/BugBounty/Targets/"$end && exit 1
    fi
    file=/opt/BugBounty/Targets/$file
    mkdir -p /opt/BugBounty/Programs/$program/Directories
    mkdir -p /opt/BugBounty/Programs/$program/Images
    sudo mount --bind /var/www/html/ /opt/BugBounty/Programs/$program/Images
    mkdir -p /opt/BugBounty/Programs/$program/Data
    mkdir -p /opt/BugBounty/Programs/$program/Data/Domains
    cd /opt/BugBounty/Programs/$program/Data/Domains
    get_domains
    get_alive
    get_subdomain_takeover
    get_waybackurl
    get_open_redirects
    get_paths
    new_domains
    sudo umount /opt/BugBounty/$program/Images
    find /opt/BugBounty/$program/ -type f -empty -delete
}

get_domains() {
    echo -e $red"\n[+]"$end $bold"Escaneo de dominios..."$end
    findomain -f $file -r -u findomain_domains.txt
    cat $file | assetfinder --subs-only | tee -a assetfinder_domains.txt
    amass enum -df $file -passive -o ammas_passive_domains.txt
    subfinder -dL $file -o subfinder_domains.txt
    sort -u *_domains.txt -o subdomains.txt
    cat subdomains.txt | rev | cut -d . -f 1-3 | rev | sort -u | tee root_subdomains.txt
    cat *.txt | sort -u > all_domains.txt
    find . -type f -not -name 'all_domains.txt' -delete
    number_domains=$(wc -l /opt/BugBounty/Programs/$program/Data/Domains/all_domains.txt)
    echo -e $green"\n[V] "$end"Escaneo finalizado. Dominios obtenidos: $number_domains"
}

get_alive() {
    echo -e $red"\n[+]"$end $bold"Escaneo de dominios vivos..."$end

    cat all_domains.txt | httprobe -c 50 -t 3000 > /opt/BugBounty/Programs/$program/Data/Domains/dominios_vivos_$date.txt
    number_domains=$(wc -l /opt/BugBounty/Programs/$program/Data/Domains/dominios_vivos_$date.txt)

    echo -e $green"\n[V] "$end"Escaneo finalizado. Dominios vivos: $number_domains"
}

get_waybackurl() {
    echo -e $red"\n[+]"$end $bold"Escaneo de dominios en Waybackurl"$end

    cat /opt/BugBounty/Programs/$program/Data/Domains/dominios_vivos_$date.txt | waybackurl > dominios_a_analizar
    cat dominios_a_analizar | sort -u | grep -P "\w+\.php(\?|$)" | sort -u >> /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt
    cat dominios_a_analizar | sort -u | grep -P "\w+\.aspx(\?|$)" | sort -u >> /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt
    cat dominios_a_analizar | sort -u | grep -P "\w+\.jsp(\?|$)" | sort -u >> /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt
    cat dominios_a_analizar | sort -u | grep -P "\w+\.pl(\?|$)" | sort -u >> /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt
    cat dominios_a_analizar | sort -u | grep -P "\w+\.rb(\?|$)" | sort -u >> /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt
    cat dominios_a_analizar | sort -u | grep -P "(%253D|%3D|=)http(s|)(%253A|%3A|:)(%252F|%2F|\/)(%252F|%2F|\/)[A-Za-z0-9-]+\." | sort -u > /opt/BugBounty/Programs/$program/Data/open_redirect.txt

    rm dominios_a_analizar
    number_domains=$(wc -l /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt)


    echo -e $green"\n[V] "$end"Waybackurl machine consultada correctamente. Dominios a revisar: $number_domains"
}

get_aquatone() {
    echo -e $red"\n[+]"$end $bold"Sacando capturas de dominios a revisar..."$end
    cat /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt | aquatone --ports xlarge -out /opt/BugBounty/$program/Images -scan-timeout 500 -screenshot-timeout 50000 -http-timeout 6000
    echo -e $green"\n[V] "$end"Capturas realizadas correctamente."
}

get_subdomain_takeover(){
	echo -e $red"\n[+]"$end $bold"Escaneo en busqueda de subdomains takeovers"$end
	python3 /opt/tools_ActiveRecon/sub404/sub404.py -f /opt/BugBounty/Programs/$program/Data/Domains/dominios_vivos_$date.txt | grep -P "Reading file|Total Unique Subdomain|URL Checked|Vulnerability Possible" | tee -a /opt/BugBounty/Programs/$program/Data/possible_subdomains_takeover.txt
}

get_especial_domains(){
    echo -e $red"\n[+]"$end $bold"Busqueda especial de dominios con Crt.sh y AnalyticsID"$end
    AnalyticsIDCoincidence.py -u $dominio | tee -a /opt/BugBounty/Programs/$program/Data/Domains/dominios_a_revisar_$date.txt
    if [[ $OrganizationName ]]; then
        curl -s "https://crt.sh/?O=$OrganizationName&output=json" | jq -r '.[].common_name' | grep -v null | sed 's/\*\.//g' | sort -u > temp_dominios
    fi
    echo -e $green"\n[V] "$end"Busqueda finalizada!"
}

#get_js() {
#    echo -e $red"[+]"$end $bold"Get JS"$end
#
#    mkdir jslinks
#
#    cat dominios_vivos_$date.txt | subjs >> jslinks/all_jslinks.txt && echo -e $green"[V] "$end"Archivos JS obtenidos correctamente."
#}

#get_tokens() {
#    echo -e $red"[+]"$end $bold"Get Tokens"$end
#
#    mkdir tokens
#
#    cat dominios_vivos_$date.txt waybackdata/jsurls.txt jslinks/all_jslinks.txt >tokens/all_js_urls.txt
#    sort -u tokens/all_js_urls.txt -o tokens/all_js_urls.txt
#    cat tokens/all_js_urls.txt | zile.py --request >>tokens/all_tokens.txt && echo -e $green"[V] "$end"Tokens obtenidos correctamente."
#    sort -u tokens/all_tokens.txt -o tokens/all_tokens.txt
#}

#get_endpoints() {
#    echo -e $red"[+]"$end $bold"Get Endpoints"$end
#
#    mkdir endpoints
#
#    for link in $(cat jslinks/all_jslinks.txt); do
#        links_file=$(echo $link | sed -E 's/[\.|\/|:]+/_/g').txt
#        python3 /opt/tools_ActiveRecon/LinkFinder/linkfinder.py -i $link -o cli >> endpoints/$links_file
#    done
#
#    echo -e $green"[V] "$end"Endpoints obtenidos correctamente."
#}

get_open_redirects() {
    echo -e $red"\n[+]"$end $bold"Buscando URLs susceptibles a Open Redirect"$end
    if [[ $URLSCAN_API_KEY ]]; then
        echo -e $yellow"\n[*]"$end $bold"Buscando en 'URLScan.io'"$end
        for dominio in $(cat $file); do
            uuid_scan=$(urlscan scan --url $dominio | jq '.uuid' | tr -d '"')
            urlscan --uuid $uuid_scan | jq '.lists.urls[]?' | grep $dominio | grep "?" | sort -u | tr -d '"' >> /opt/BugBounty/Programs/$program/Data/open_redirect.txt
        done
    else
        echo -e $yellow"\n[*]"$end $bold"Configure la variable de entorno URLSCAN_API_KEY para usar el servicio de URLScan.io"$end
    fi
    if [[ $VTCLI_APIKEY ]]; then
        echo -e $yellow"\n[*]"$end $bold"Buscando en 'VirusTotal'"$end
        for dominio in $(cat $file); do
            vt url $dominio --include=outgoing_links | grep -oP \".*\" | grep $dominio | grep "?" | sort -u | tr -d '"' >> /opt/BugBounty/Programs/$program/Data/open_redirect
        done
    else
        echo -e $yellow"\n[*]"$end $bold"Configure la variable de entorno VTCLI_APIKEY para usar el servicio de VirusTotal"$end
    fi
    cat /opt/BugBounty/Programs/$program/Data/open_redirect.txt | sort -u > /opt/BugBounty/Programs/$program/Data/possible_open_redirect.txt
    rm /opt/BugBounty/Programs/$program/Data/open_redirect.txt
    number_domains=$(wc -l /opt/BugBounty/Programs/$program/Data/possible_open_redirect.txt)

    echo -e $green"\n[V] "$end"Busqueda finalizada!"
}

scan_open_redirect(){
    echo -e $red"\n[+]"$end $bold"Comenzando escaneo Open Redirect..."$end
    #lista_urls=$(cat /opt/BugBounty/Programs/$program/Data/possible_open_redirect.txt)
    #payloads=('=https://pfelilpe.com/ping?' '=//pfelilpe.com/ping?' '=pfelilpe.com/ping' '=\/\/pfelilpe.com/ping?' '=https:pfelilpe.com/ping?')
    #for url in $lista_urls; do
        #parametros_url=$(echo $url | cut -d "?" -f2)
        #url=$(echo $url | cut -d "?" -f1)
        #redirect_url=$(echo $parametros_url | grep -oP (%253D|%3D|=)http(s|)(%253A|%3A|:)(%252F|%2F|\/)(%252F|%2F|\/)[A-Za-z0-9-]+\.
        #for payload in "${payloads[@]}"; do
        #    nueva_url=$(echo $url | sed "s/$redirect_url/$payload/g")
        #    curl "$nueva_url" -vs 2>&1 | grep -P "8441280b0c35cbc1147f8ba998a563a7" > /dev/null && echo $nueva_url >> vulnerable_open_redirect
        #done
        scan_open_redirect.py -f /opt/BugBounty/Programs/$program/Data/possible_open_redirect.txt | tee vulnerable_open_redirect.txt
        if [[ $(wc -c vulnerable_open_redirect.txt) != 0 ]]; fi
             echo -e $green"[V] "$end"URLs vulnerables encontradas!." && send_alert1
        fi
    done
    echo -e $green"[V] "$end"Escaneo finalizado!"
}

send_alert2(){
    echo -e $red"\n[+]"$end $bold"Enviando alerta..."$end
    vulnerable_open_redirect="cat vulnerable_open_redirect.txt"
    message="[ + ] ActiveRecon Alert:
    [ --> ] Nuevos dominios encontrados en el programa: $program
    $($vulnerable_open_redirect)"
    curl --silent --output /dev/null -F chat_id="$chat_ID" -F "text=$message" $url -X POST && echo -e $green"\n[V] "$end"Alerta enviada!."
}

get_paths() {
    echo -e $red"\n[+]"$end $bold"Busqueda de directorios con 'dirsearch'"$end

    for host in $(cat /opt/BugBounty/Programs/$program/Data/dominios_a_revisar_$date.txt); do
        dirsearch_file=$(echo $host | sed -E 's/[\.|\/|:]+/_/g').txt
        python3 /opt/tools_ActiveRecon/dirsearch-0.4.0/dirsearch.py -E -t 50 --plain-text /opt/BugBounty/Programs/$program/Directories/$dirsearch_file -u $host -w /opt/tools_ActiveRecon/dirsearch-0.4.0/db/dicc.txt | grep Target && tput sgr0
    done
    echo -e $green"[V] "$end"Busqueda finalizada!"
}

new_domains(){
    echo -e $red"\n[+]"$end $bold"Buscando diferencias de escaneos anteriores..."$end
    shopt -s extglob && result=$(cat !(/opt/BugBounty/Programs/$program/Data/Domains/dominios_vivos_$date.txt) 2>/dev/null)
    lista_dominios=$(cat /opt/BugBounty/Programs/$program/Data/Domains/dominios_vivos_$date.txt)
    for dominio in $lista_dominios; do
         echo $result | grep $dominio > /dev/null 2>&1
        if [ "$(echo $?)" -ne "0" ]; then
            echo $dominio > /opt/BugBounty/Programs/$program/Data/Domains/nuevos_dominios_$date.txt
        fi
    done

    ls nuevos_dominios_$date.txt > /dev/null 2>&1 && echo -e $green"[V] "$end"Diferencias encontradas!." && send_alert1
}

send_alert1(){
    echo -e $red"\n[+]"$end $bold"Enviando alerta..."$end
    nuevos_dominios="cat nuevos_dominios_$date.txt"
    message="[ + ] ActiveRecon Alert:
    [ --> ] Nuevos dominios encontrados en el programa: $program
    $($nuevos_dominios)"
    curl --silent --output /dev/null -F chat_id="$chat_ID" -F "text=$message" $url -X POST && echo -e $green"\n[V] "$end"Alerta enviada!."
}

helpPanel(){
    echo -e $red"\n[X]"$end $bold"Debe ingresar los parametros:"$end
    echo -e "       -p / --program --> Escriba el nombre del programa"
    echo -e "       -f / --file --> Cree un archivo archivo target_{program}.txt con los dominios y coloquelo en /opt/BugBounty/Targets"
}

parameter_counter=0

while getopts ":p:f:" arg; do
    case $arg in
        p) program=$OPTARG && let parameter_counter+=1;;
        f) file=$OPTARG && file=$(basename $file) && let parameter_counter+=1;;
    esac
done

if [ $file ] && [ $program ]; then
    check_root
    check_dependencies
    main
else
    helpPanel
fi