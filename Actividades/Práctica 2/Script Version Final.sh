################################################
#####ASIGNACIÓN DE IP'S A LOS HOST CLIENTES#####
################################################

ip 192.168.6.34 /27 192.168.6.33 #CONTA1
ip 192.168.6.35 /27 192.168.6.33 #CONTA2
ip 192.168.6.66 /27 192.168.6.65 #VENTAS1
ip 192.168.6.67 /27 192.168.6.65 #VENTAS2
ip 192.168.6.98 /27 192.168.6.97 #INFOR1
ip 192.168.6.99 /27 192.168.6.97 #INFOR2
ip 192.168.16.66 /26 192.168.16.65 #Administrador
ip 192.168.16.67 /26 192.168.16.65 #BDSVR
ip 192.168.16.130 /26 192.168.16.129 #WEBSVR

save #Para Guardar

################################################
#######################PING######################
################################################

ping 192.168.6.34
ping 192.168.6.35
ping 192.168.6.66
ping 192.168.6.67
ping 192.168.6.98
ping 192.168.6.99

################################################
#######################STP######################
################################################

show spantree [vlan_id] 
spanning-tree vlan vlan-id root secondary

show spantree 10
show spantree vlan 10
show spanning-tree vlan 10

################################################
#######################SW1######################
################################################

#Configuración de ethernet channel
conf t
interface range f1/1 - 2
channel-group 1 mode on
end
conf t
interface range f1/3 - 4
channel-group 2 mode on
end
conf t
interface range f1/0
channel-group 6 mode on
end
show etherchannel port-channel

#Configurando ethernet channel como enlace troncal
conf t
interface port-channel 1
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
conf t
interface port-channel 2
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
conf t
interface port-channel 6
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
show vlan-switch

#VTP
conf t
vtp domain redes1g6
vtp mode server
vtp password redes1g6
end

#Creación de las vlan
conf t
vlan 10
name CONTABILIDAD
vlan 20
name VENTAS
vlan 30
name INFORMATICA
end
show vlan-switch

################################################
#######################SW2######################
################################################

#Configuración de ethernet channel
conf t
interface range f1/0 - 1
channel-group 1 mode on
end
conf t
interface range f1/2 - 3
channel-group 3 mode on
end
conf t
interface range f1/4 - 6
channel-group 4 mode on
end
show etherchannel port-channel

#Configurando ethernet channel como enlace troncal
conf t
interface port-channel 1
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
conf t
interface port-channel 3
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
conf t
interface port-channel 4
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
show vlan-switch

#VTP
conf t
vtp domain redes1g6
vtp mode client
vtp password redes1g6
end

################################################
#######################SW3######################
################################################

#Configuración de ethernet channel
conf t
interface range f1/0 - 1
channel-group 2 mode on
end
conf t
interface range f1/2 - 3
channel-group 3 mode on
end
conf t
interface range f1/4 - 6
channel-group 5 mode on
end
show etherchannel port-channel

#Configurando ethernet channel como enlace troncal
conf t
interface port-channel 2
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
conf t
interface port-channel 3
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
conf t
interface port-channel 5
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
show vlan-switch

#VTP
conf t
vtp domain redes1g6
vtp mode client
vtp password redes1g6
end

################################################
#######################SW4######################
################################################

#Configuración de ethernet channel
conf t
interface range f1/0 - 2
channel-group 4 mode on
end
show etherchannel port-channel

#Configurando ethernet channel como enlace troncal
conf t
interface port-channel 4
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
show vlan-switch

#Configurar Puertos de Acceso
conf t
interface f1/3
switchport mode access
switchport access vlan 20
end
conf t
interface f1/4
switchport mode access
switchport access vlan 10
end
conf t
interface f1/5
switchport mode access
switchport access vlan 30
end

#VTP
conf t
vtp domain redes1g6
vtp mode client
vtp password redes1g6
end

################################################
#######################SW5######################
################################################

#Configuración de ethernet channel
conf t
interface range f1/0 - 2
channel-group 5 mode on
end
show etherchannel port-channel

#Configurando ethernet channel como enlace troncal
conf t
interface port-channel 5
switchport mode trunk
switchport trunk allowed vlan 1,10,20,30,1002-1005
end
show vlan-switch

#Configurar Puertos de Acceso
conf t
interface f1/3
switchport mode access
switchport access vlan 20
end
conf t
interface f1/4
switchport mode access
switchport access vlan 10
end
conf t
interface f1/5
switchport mode access
switchport access vlan 30
end

#VTP
conf t
vtp domain redes1g6
vtp mode client
vtp password redes1g6
end

################################################
#######################R1######################
################################################

#Enrutamiento inter vlan (router on a stick)
conf t
interface fastEthernet 0/1
no shut
interface fastethernet 0/1.10
encapsulation dot1Q 10
ip address 192.168.6.33 255.255.255.224
exit
interface fastethernet 0/1.20
encapsulation dot1Q 20
ip address 192.168.6.65 255.255.255.224
exit
interface fastethernet 0/1.30
encapsulation dot1Q 30
ip address 192.168.6.97 255.255.255.224
end

#Configuración de la ruta estática
enable
conf t
hostname Router1
interface fastethernet 0/1
ip address 192.168.6.33 255.255.255.224
no shutdown
exit
interface serial 0/0
ip address 172.16.0.2 255.255.0.0
no shutdown
clock rate 64000
exit
ip route 192.168.16.128 255.255.255.192 s0/0
do show ip route
do ping 192.168.16.128

################################################
#######################R2######################
################################################

#Enrutamiento inter vlan (router on a stick)

conf t
interface fastethernet 0/1
no shut
interface fastethernet 0/1.10
encapsulation dot1Q 10
ip address 192.168.16.65 255.255.255.192
exit

interface fastethernet 0/1.20
encapsulation dot1Q 20
ip address 192.168.16.129 255.255.255.192
exit

#Configuración de la ruta estática
enable
conf t
hostname Router2
interface serial 0/0
ip address 172.16.0.1 255.255.0.0
no shutdown
do ping 172.16.0.2
exit
int fastethernet 0/1
ip address 192.168.16.129 255.255.255.192
no shutdown
ip route 192.168.6.32 255.255.255.224 s0/0
ip route 192.168.6.64 255.255.255.224 s0/0
ip route 192.168.6.96 255.255.255.224 s0/0
do show ip route
do ping 192.168.6.32

#################################################
#######################STP#######################
#################################################
show spanning-tree brief


#GUARDANDO CAMBIOS
copy running-config startup-config
#enter
write

#RECUPERANDO INFORMACIÓN
copy startup-config running-config