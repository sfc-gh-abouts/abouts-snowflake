

echo -e "\ncalling snowsql"
echo -e "  using key pair auth"
echo -e "  logging as john to citibike"

echo -e "\nor you could call to get jwt"
echo -e "$ snowsql -a mva55597.us-east-1 -u john --private-key-path /Users/abouts/Documents/Key/snf_user_key.p8 --generate-jwt\n"

snowsql -c abouts_demo