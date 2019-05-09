IN=.images
OUT=inspect.out
docker images | grep amd64 | awk 'NR>1{print $1}' > $IN
echo "" > $OUT
while read line; do
    echo "inspecting $line"
    HASH=$(docker inspect $line | grep -m 1 hash | awk -F: '{print $2}' | cut -c3-8)
    echo "$line,$HASH" >> $OUT
done < $IN
rm $IN
echo -e "\n\noutput file:"
cat $OUT
