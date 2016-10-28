# recreate_buckets.sh
# This script requires 1 parameter, the Couchbase administrator password

. ./settings

for b in contacts customer reviews product purchases user_profile customer_profile
do
    echo "Deleting bucket $b..."
    curl -XDELETE ${cluster}/pools/default/buckets/$b -u Administrator:$pw
    qry='name='
    qry+=$b
    let "port += 1"
    echo "Creating bucket $b..."
    curl ${cluster}/pools/default/buckets -XPOST -d "$qry" -u Administrator:$pw  -v  -d authType=none -d proxyPort=$port  -d ramQuotaMB=200
done

# install the travel-sample
curl -XDELETE ${cluster}/pools/default/buckets/travel-sample -u Administrator:$pw
curl ${cluster}/sampleBuckets/install -u Administrator:$pw -X POST -d '["travel-sample"]'
