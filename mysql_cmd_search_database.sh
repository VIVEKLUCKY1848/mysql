mysql [DATABASE] --silent -N -e "show tables;"|while read table; do mysql [DATABASE] --silent -N -e "select * from ${table};"|while read line;do if [[ "${line}" == *"[CHECKSTRING]"* ]]; then echo "${table}***${line}";fi;done;done

mysql [DATABASE] --silent -N -e "show tables;"|while read table; do mysql [DATABASE] --silent -N -e "select * from ${table};"|while read line;do if [[ "${line}" == *"[CHECKSTRING]"* ]]; then echo "${table}***${line}";fi;done;done
