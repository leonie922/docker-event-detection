#!/usr/bin/env bash

# Fix relative paths
####################
echo ;echo ">Running the BDE initialization script."; echo ;

# get and set properties files
##############################

# get potentially user supplied properties files

# print help
if [ "$#" -eq 1  ] && [ "$1" == "help" ]; then
	echo "Initialization usage:"
	echo "User-provided override file (container) paths:"
	echo "news properties [$SUPPLIED_NEWS_PROPS_FILE]"
	echo "news urls [$SUPPLIED_NEWS_URLS_FILE]"
	echo "clustering properties [$SUPPLIED_CLUSTER_PROPS_FILE]"
	echo "location properties [$SUPPLIED_LOCATION_PROPS_FILE]"
	echo "twitter queries [$SUPPLIED_TWITTER_QUERIES_FILE]"
	echo "twitter properties [$SUPPLIED_TWITTER_PROPS_FILE]" 
	echo
	exit 0
fi

#SUPPLIED_NEWS_PROPS_FILE="$MOUNT_DIR/newsproperties"
#SUPPLIED_NEWS_URLS_FILE="$MOUNT_DIR/newsurls"
#SUPPLIED_CLUSTER_PROPS_FILE="$MOUNT_DIR/clusterproperties"
#SUPPLIED_LOCATION_PROPS_FILE="$MOUNT_DIR/locationproperties"
#SUPPLIED_TWITTER_QUERIES_FILE="$MOUNT_DIR/twitterqueries"
#SUPPLIED_TWITTER_PROPS_FILE="$MOUNT_DIR/twitterproperties"

newsprops="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties";
if [ -f "$SUPPLIED_NEWS_PROPS_FILE" ]; then
	echo "Fetching user supplied news properties."
	cp "$SUPPLIED_NEWS_PROPS_FILE" "$newsprops"
fi
sed -i "s<urls_file_name=.*<urls_file_name=$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news_urls.txt<g" "$newsprops"
newsurls="$BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news_urls.txt";
if [ -f "$SUPPLIED_NEWS_URLS_FILE" ]; then
	echo "Fetching user supplied news urls."
	cp "$SUPPLIED_NEWS_URLS_FILE" "$newsurls"
fi

clusterprops="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/clustering.properties";
if [ -f "$SUPPLIED_CLUSTER_PROPS_FILE" ]; then
	echo "Fetching user supplied twitter properties."
	cp "$SUPPLIED_CLUSTER_PROPS_FILE" "$clusterprops"
fi
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/en-sent.bin<g" "$clusterprops"
sed -i "s<stopwords_file_path=.*<stopwords_file_path=$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/stopwords_en.txt<g" "$clusterprops"

locationprops="$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties";
if [ -f "$SUPPLIED_LOCATION_PROPS_FILE" ]; then
	echo "Fetching user supplied location properties."
	cp "$SUPPLIED_LOCATION_PROPS_FILE" "$locationprops"
fi
sed -i "s<ne_models_path=.*<ne_models_path=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/ne_models<g" "$locationprops"
sed -i "s<sentence_splitter_model=.*<sentence_splitter_model=$BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/en-sent.bin<g" "$locationprops"

twitterqueries="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.queries"
if [ -f "$SUPPLIED_TWITTER_QUERIES_FILE" ]; then
	echo "Fetching user supplied twitter queries."
	cp "$SUPPLIED_TWITTER_QUERIES_FILE" "$twitterqueries"
fi
twitterprops="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
if [ -f "$SUPPLIED_TWITTER_PROPS_FILE" ]; then
	echo "Fetching user supplied twitter properties."
	cp "$SUPPLIED_TWITTER_PROPS_FILE" "$twitterprops"
fi

# initialize cassandra connections and twitter credentials. This is useful to quickly change host+port
# without supplying new properties files for each module
$EXEC_DIR/connections_config.sh "$CONNECTIONS_CONFIG_FILENAME"


echo "-Done running the BDE initialization script."; echo 