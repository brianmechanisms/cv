#!/bin/bash



[[ $(tail -c1 cvDataRepos.md) && ! $(echo) ]] && echo >> cvDataRepos.md


while read line; do link="https://github.com/${line%%#*}"; link=$(echo $link| sed 's/[[:space:]]*$//'); dir=$(echo "$link" | sed 's/\//__/g');link=$(echo "$link.git"); cd cvData && rm -rf $dir && git clone $link $dir; cd ..; done < cvDataRepos.md 

rm  -rf cvPhotos
for dir in ./cvData/*; do
    if [ -d "$dir" ]; then
        if [ -e "$dir/datasheets.txt" ]; then
            cat  "$dir/datasheets.txt"
            mkdir -p "$dir/csvs/"
            while IFS=, read -r docId sheetId; do
                wget --output-file="logs.csv" "https://docs.google.com/spreadsheets/d/$docId/export?format=csv&gid=$sheetId" -O "$dir/csvs/$docId$sheetId.csv"
            done < "$dir/datasheets.txt"
            name=$(grep -rh "bio,Name" $dir/csvs/ | sed 's/bio,Name,//')
            if [ -z "$name" ]; then
                echo "" # Fatal, no name found
            else
                echo $name
                cvName="$(echo $name | sed 's/[[:space:]]*$//' | sed 's/[^a-zA-Z0-9]/_/g')_cv"
                cp index.html "$cvName.html"
                echo $cvName
                sed -i "/^author:/ s/.*/author: $name/" "$cvName.html"
                # if assets.txt exists
                if test -f "$dir/assets.txt"; then
                    ## Get photoFileName
                    photoFile=$(head -n 1 "$dir/assets.txt" | sed -e 's/photo,//')
                    echo $photoFile
                     ## Check if photoFile exists
                    if test -f "$dir/$photoFile"; then
                        mkdir -p "cvPhotos/$cvName"
                        cp "$dir/$photoFile" "cvPhotos/$cvName/" ## rename and put in assets folder
                        sed -i "/^profilephoto:/ s|.*|profilephoto: cvPhotos/$cvName/$photoFile|" "$cvName.html"  ## edit link in html file
                    fi
                fi   
                tel=$(grep -roPh "^tel,[^,]+,.*" $dir/csvs/ | sed 's/tel,[^,]*,//')
                if [ -z "$tel" ]; then
                    echo "" # Fatal, no tel found  
                else
                    tels=$(echo "$tel" | awk -F'/' '{for(i=1;i<=NF;i++){if($i~/^[0-9]/)sub(/^[^0-9+]*/,"+",$i); printf("\r\n- %s\r\n", $i)}}')
                    echo $tels > tmpnumbers
                    sed -i "/^tel:.*/r /dev/stdin" "$cvName.html" <<< $(cat tmpnumbers)
                    rm tmpnumbers
                fi   
                email=$(grep -roPh "^email,[^,]+,.*" $dir/csvs/ | sed 's/email,[^,]*,//')
                if [ -z "$email" ]; then
                    echo "" # Fatal, no tel email  
                else
                    email=${email//\"/}
                    emails=$(echo $email | awk -v RS=',' '{print "\r\n- " $0}')
                    echo $emails > tmpnumbers
                    sed -i "/^email:.*/r /dev/stdin" "$cvName.html" <<< $(cat tmpnumbers)
                    rm tmpnumbers
                fi    
                website=$(grep -roPh "^website,[^,]+,.*" $dir/csvs/ | sed 's/website,[^,]*,//')
                if [ -z "$website" ]; then
                    echo "" # Fatal, no tel website  
                else
                    website=${website//\"/}
                    website=$(echo $website | sed -E 's/(https?|ftp):\/\/([^\s]+)/\2/g')
                    websites=$(echo $website | awk -v RS=',' '{print "\r\n- " $0}')
                    echo $websites > tmpnumbers
                    sed -i "/^website:.*/r /dev/stdin" "$cvName.html" <<< $(cat tmpnumbers)
                    rm tmpnumbers
                fi 
                github=$(grep -roPh "^github,[^,]+,.*" $dir/csvs/ | sed 's/github,[^,]*,//')
                if [ -z "$github" ]; then
                    echo "" # Fatal, no tel github  
                else
                    github=${github//\"/}
                    github=$(echo $github | sed -E 's/(https?|ftp):\/\/([^\s]+)/\2/g')
                    githubs=$(echo $github | awk -v RS=',' '{print "\r\n- " $0}')
                    echo $githubs > tmpnumbers
                    sed -i "/^github:.*/r /dev/stdin" "$cvName.html" <<< $(cat tmpnumbers)
                    rm tmpnumbers
                fi  
                twitter=$(grep -roPh "^twitter,[^,]+,.*" $dir/csvs/ | sed 's/twitter,[^,]*,//')
                if [ -z "$twitter" ]; then
                    echo "" # Fatal, no tel twitter  
                else
                    twitter=${twitter//\"/}
                    twitter=$(echo $twitter | sed -E 's/(https?|ftp):\/\/([^\s]+)/\2/g')
                    twitters=$(echo $twitter | awk -v RS=',' '{print "\r\n- " $0}')
                    echo $twitters > tmpnumbers
                    sed -i "/^twitter:.*/r /dev/stdin" "$cvName.html" <<< $(cat tmpnumbers)
                    rm tmpnumbers
                fi   
                linkedin=$(grep -roPh "^linkedin,[^,]+,.*" $dir/csvs/ | sed 's/linkedin,[^,]*,//')
                if [ -z "$linkedin" ]; then
                    echo "" # Fatal, no tel linkedin  
                else
                    linkedin=${linkedin//\"/}
                    linkedin=$(echo $linkedin | sed -E 's/(https?|ftp):\/\/([^\s]+)/\2/g')
                    linkedins=$(echo $linkedin | awk -v RS=',' '{print "\r\n- " $0}')
                    echo $linkedins > tmpnumbers
                    sed -i "/^linkedin:.*/r /dev/stdin" "$cvName.html" <<< $(cat tmpnumbers)
                    rm tmpnumbers
                fi     
            fi
        fi
    fi
done