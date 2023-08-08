pm2 kill

username="adminUser"
password="ts3d"
hostname="localhost"
port="27017"
databases=("conversions" "caas_demo_app")

for database in "${databases[@]}"
do
   command="db.dropDatabase()"
   mongosh -u $username -p $password --authenticationDatabase admin --host $hostname:$port --eval "$command" $database
done


sudo rm -r /home/ubuntu/tempData
rm -r communicatorLicense.txt
touch communicatorLicense.txt
history -c
