#!/bin/bash
RESPUESTA="X"
while [ $RESPUESTA != "0" ]
do
    echo "$(tput setaf 2) _____  _    _  _____ _____         _____ ____  _   _ ______ _____ _____ _    _ _____         _______ ____  _____  ____   ___   ___   ___ "
    echo "|  __ \| |  | |/ ____|  __ \       / ____/ __ \| \ | |  ____|_   _/ ____| |  | |  __ \     /\|__   __/ __ \|  __ \|___ \ / _ \ / _ \ / _ \ "
    echo "| |  | | |__| | |    | |__) |_____| |   | |  | |  \| | |__    | || |  __| |  | | |__) |   /  \  | | | |  | | |__) | __) | | | | | | | | | |"
    echo "| |  | |  __  | |    |  ___/______| |   | |  | | .   |  __|   | || | |_ | |  | |  _  /   / /\ \ | | | |  | |  _  / |__ <| | | | | | | | | | " 
    echo "| |__| | |  | | |____| |          | |___| |__| | |\  | |     _| || |__| | |__| | | \ \  / ____ \| | | |__| | | \ \ ___) | |_| | |_| | |_| |"
    echo "|_____/|_|  |_|\_____|_|           \_____\____/|_| \_|_|    |_____\_____|\____/|_|  \_\/_/    \_\_|  \____/|_|  \_\____/ \___/ \___/ \___/ "
    echo "                                                                                              ___  _   _     ____ _  _ ____ _    _  _ ____ "
    echo "                                                                                              |__]  \_/      |___ |\ | |  | |    |\/| |___ "
    echo "                                                                                              |__]   |   ___ |___ | \| |__| |___ |  | |  "
    echo ""
    echo "[1] Instalación del servicio DHCP" 
    echo "[2] Desinstalar el servicio DHCP"
    echo "[3] Empezar configuración del servidor DHCP"
    echo "[4] Reservar una IP"
    echo "[5] Reinicar el servidor"
    echo "[6] Ver el estado del servidor"
    echo "[0] Salir"
    read RESPUESTA

   case $RESPUESTA in
   "0") exit ;;
   "1") apt install isc-dhcp-server ;;
   "2") apt-get purge --auto-remove isc-dhcp-server;;
   "3") echo "¿Desea hacer una copia de seguridad de los archivos de configuración?"
        echo "s/n"
        read sn
        if [[ $sn = "s" ]]; then
            fecha=$(date "+%F-%T")
            mv /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.$fecha.bak
            mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$fecha.bak
            touch /etc/default/isc-dhcp-server
            touch /etc/dhcp/dhcpd.conf
            echo ">>>Especifique la interfaz:"
            read int
            echo "
 INTERFACESv4=\"$int\"
 INTERFACESv6="" " > /etc/default/isc-dhcp-server
            echo ">>>Dominio:"
            read dominio
            echo ">>>DNS:"
            read dns
            echo ">>>Tiempo por defecto en que la concesión de la IP es valida(segundos):"
            read tpd
            echo ">>>Tiempo máximo que se permite asignar a una concesión de dirección IP(segundos):"
            read tm
            echo ">>>Subred:"
            read subred
            echo ">>>Máscara"
            read mask
            echo ">>>Rango de direcciones(escribir el comando completo. EJ: range 10.31.3.100 10.31.3.199;)"
            echo ">>Si no se quiere configurar dejar en blanco"
            read pool
            echo ">>>Gateway:"
            read gate
            echo "
 option domain-name \"$dominio\";
 option domain-name-servers $dns;
 default-lease-time $tpd;
 max-lease-time $tm;
 authoritative;
 log-facility local7;
 subnet $subred netmask $mask {
  # si queremos un pool de ip’s de asignación libre sin necesidad de reserva de MAC: range
  $pool
  option domain-name-servers $dns;
  option domain-name \"$dominio\";
  option routers $gate;
 }
 ddns-update-style none; " > /etc/dhcp/dhcpd.conf
            systemctl restart isc-dhcp-server
            systemctl status isc-dhcp-server
       else
            rm /etc/default/isc-dhcp-server
            rm /etc/dhcp/dhcpd.conf
            touch /etc/default/isc-dhcp-server
            touch /etc/dhcp/dhcpd.conf
            echo ">>>Especifique la interfaz:"
            read int
            echo "
 INTERFACESv4=\"$int\"
 INTERFACESv6="" " > /etc/default/isc-dhcp-server
            echo ">>>Dominio:"
            read dominio
            echo ">>>DNS:"
            read dns
            echo ">>>Tiempo por defecto en que la concesión de la IP es valida(segundos):"
            read tpd
            echo ">>>Tiempo máximo que se permite asignar a una concesión de dirección IP(segundos):"
            read tm
            echo ">>>Subred:"
            read subred
            echo ">>>Máscara"
            read mask
            echo ">>>Rango de direcciones(escribir el comando completo. EJ: range 10.31.3.100 10.31.3.199;)"
            echo ">>Si no se quiere configurar dejar en blanco"
            read pool
            echo ">>>Gateway:"
            read gate
            echo "
 option domain-name \"$dominio\";
 option domain-name-servers $dns;
 default-lease-time $tpd;
 max-lease-time $tm;
 authoritative;
 log-facility local7;
 subnet $subred netmask $mask {
  # si queremos un pool de ip’s de asignación libre sin necesidad de reserva de MAC: range
  $pool
  option domain-name-servers $dns;
  option domain-name \"$dominio\";
  option routers $gate;
 }
 ddns-update-style none; " > /etc/dhcp/dhcpd.conf
            systemctl restart isc-dhcp-server
            systemctl status isc-dhcp-server
        fi ;;

   "4") echo ">>>Nombre de la máquina:"
        read nombre_maquina
        echo ">>>Dirección MAC de la máquina:"
        read mac_maquina
        echo ">>>Ip para la máquina:"
        read ip_fija
        echo "
            host $nombre_maquina {
            hardware ethernet $mac_maquina;
            fixed-address $ip_fija;
            }" >> /etc/dhcp/dhcpd.conf ;;

   "5") systemctl restart isc-dhcp-server ;;

   "6") systemctl status isc-dhcp-server ;;

   *) echo "Opción incorrecta" ;;
esac
  
done