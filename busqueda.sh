#!/bin/zsh
#
# Script que busca en todos los direcotrios archivos con extención .mp4, .avi
# .mkv y ignora si algún direcotrio tiene algún archivo con extención .part
#
# By. Jaime A. Feldman 2021
#
# MIT Licence.

Red='\033[0;31m'
Green='\033[0;32m'
Blue='\033[0;34m'
NC='\033[0m' # No Color
$haveMP4File=false
$havePartFile=false
$haveMkvFile=false
$movOption=false
$haveAviFile=true

dirsFound=0
cont=0

# Declare arreglo
arrVar=("")



if [[ $1 == "mov" ]] then 
    movOption=true
    echo "[ mov activado, reorganizando direcotrios... ]"
else
    echo "[ Chequeando directorios... ]"
fi


if [[ ! -d "complete" ]] then
    echo "crando directorio ${Blue}complete${NC}"
    mkdir complete
fi

for dirName in */
do
    haveMP4File=false
    havePartFile=false
    haveMkvFile=false
    if [[ ${dirName%/} == "complete" ]] then
        continue
    fi
    echo "buscando en [${Blue}${dirName%/}${NC}]"
    for file in $dirName/*; do
        filename=$(basename $file)
        extencion=${filename##*.}
        if [[ ${extencion} == "mp4" ]] then
            haveMP4File=true
        fi

        if [[ ${extencion} == "part" ]] then
            havePartFile=true
        fi

        if [[ ${extencion} == "mkv" ]] then
            haveMkvFile=true
        fi
        
        if [[ ${extencion} == "avi" ]] then
            haveAviFile=true
        fi



    done

    # Evaluando las busquedas en el directorio.
    if [[ ${haveMP4File} == true || ${haveMkvFile} == true ]] && [[ ${havePartFile} == false ]] then
        dirsFound=$((++cont))
        if [[ ${movOption} == true ]] then
            mv ${dirName%/} complete 
            echo "[ Moviendo ${dirName%/} ] -> ${Green}OK${NC}"
            arrVar+="[ Moviendo: ${dirName%/} ] -> ${Green}OK${NC}"
        else 
            echo "[ Encontrado ${dirName%/} ] -> ${Green}OK${NC}"
            arrVar+="[ Encontrado: ${dirName%/} ] -> ${Green}OK${NC}"
        fi
    fi
done

echo "-------------------------------------------------------"
echo "directorios listos: ${dirsFound}"
for value in "${arrVar[@]}"
do
    echo $value
done


#tips.
#echo "extencion: ${filename##*.}"
#echo "Only file name ${filename%.*}"
#echo "full file name: ${fullfile##*/}" 
#echo "Archivo de video encontrado en el directorio: ${dirName%/} nombre: ${filename%.*}"
#echo "[Directorio correto ${dirName%/}]: ${filename}"

