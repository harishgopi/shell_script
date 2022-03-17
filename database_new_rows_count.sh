// script to get the latest records added to a database

total_count=0
while read table; do
    echo "$table"
    result=$(psql -U postgres -h host database_name -c "SELECT column_name
    FROM information_schema.columns
    WHERE table_name='$table' and column_name='created_at';")

    col=$(echo ${result}| awk '{print $3}')
    
    if [ $col == "created_at" ];
    then
        res_count=$(psql -U postgres -h host database_name -c "SELECT count(*)
                FROM $table
                WHERE created_at between '2022-02-17 00:00:00' and '2022-03-17 00:00:00';")
        count=$(echo ${res_count}| awk '{print $3}')
        total_count=$(($total_count + $count))
        echo "$table ---------- $count" >> "table_with_count"
    else
        echo $table >> "tables_with_no_creation_timestamp"
    fi

done < "./tables"
echo "$total_count"

//count all records of table 

while read table; do
    echo "$table"
    
    res_count=$(psql -U postgres -h host databasename -c "SELECT count(*)
            FROM $table")
    count=$(echo ${res_count}| awk '{print $3}')
    
    echo "$table ---------- $count" >> "table_with_count"

done < "./tables"
