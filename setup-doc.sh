current_dir="${PWD##*/}"
mkdir -p doc

README='doc/README.md'
SWAGGER='doc/swagger.json'
SOURCE_CODE='doc/source_code.md'
LICENSE_CODE='doc/license_code.md'

cp README_TEMPLATE.md $README
cp swagger_template.json $SWAGGER

REPO=$(echo "https://"$(echo $(git remote show origin) | egrep -o "(github\.com..*) URL") | sed "s/com:/com\//g")

REPO=${REPO%????}
REPO_NO_GIT=${REPO%????}

dialog --backtitle "Marketplace API service"  --title "Doc Generator - $current_dir" --clear --msgbox "Welcome to the Doc generator for $current_dir on repo $REPO_NO_GIT" 10 80

TITLE_OF_THE_SERVICE=""
SHORT_DESCRIPTION_OF_THE_SERVICE=""
LONG_DESCRIPTION_OF_THE_SERVICE=""
API_RESTPOINT_OPERATION="detect"
NB_INPUT_FIELDS=1
NB_OUTPUT_FIELDS=1

# open fd
exec 3>&1
VALUES=$(dialog \
		--ok-label "Submit" \
		--backtitle "Marketplace API service" \
		--title "API Service" \
		--form "Create a new API service" \
		15 80 0 \
		"TITLE_OF_THE_SERVICE:" 1 1	"$TITLE_OF_THE_SERVICE" 	1 22 80 0 \
		"SHORT_DESCRIPTION_OF_THE_SERVICE:"    2 1	"$SHORT_DESCRIPTION_OF_THE_SERVICE"  	2 34 80 0 \
		"LONG_DESCRIPTION_OF_THE_SERVICE:"    3 1	"$LONG_DESCRIPTION_OF_THE_SERVICE"  	3 34 80 0 \
		"API_RESTPOINT_OPERATION:"     4 1	"$API_RESTPOINT_OPERATION" 	4 25 80 0 \
		"number of input fields:"     5 1	"$NB_INPUT_FIELDS" 	5 25 80 0 \
		"number of output fields:"     6 1	"$NB_OUTPUT_FIELDS" 	6 25 80 0 \
		2>&1 1>&3)
# close fd
exec 3>&-

TITLE_OF_THE_SERVICE=$(echo "$VALUES" | sed -n 1p)
SHORT_DESCRIPTION_OF_THE_SERVICE=$(echo "$VALUES" | sed -n 2p)
LONG_DESCRIPTION_OF_THE_SERVICE=$(echo "$VALUES" | sed -n 3p)
API_RESTPOINT_OPERATION=$(echo "$VALUES" | sed -n 4p)
NB_INPUT_FIELDS=$(echo "$VALUES" | sed -n 5p)
NB_OUTPUT_FIELDS=$(echo "$VALUES" | sed -n 6p)

sed -i '' "s/LONG_DESCRIPTION_OF_THE_SERVICE/$LONG_DESCRIPTION_OF_THE_SERVICE/g" $SWAGGER
sed -i '' "s/SHORT_DESCRIPTION_OF_THE_SERVICE/$SHORT_DESCRIPTION_OF_THE_SERVICE/g" $SWAGGER
sed -i '' "s/TITLE_OF_THE_SERVICE/$TITLE_OF_THE_SERVICE/g" $SWAGGER
sed -i '' "s/API_RESTPOINT_OPERATION/$API_RESTPOINT_OPERATION/g" $SWAGGER



HEADER_TYPE_OPTIONS=(application_json "application/json" \
		application_xml "application/xml"
		text_html "text/html (.xhtml, .html or .htm)" \
		text_csv "text/csv (.csv)" \
		text_plain "text/plain (.txt)" \
		image "image/*" \
		image_bmp "Image/bmp" \
		image_gif "Image/gif" \
		image_jpeg "Image/jpeg (.jpg or .jpeg)" \
		image_png "image/png " \
		audio_gpp "audio/3gpp (.3gp)" \
		audio_midi "audio/midi (.mid or .midi)" \
		audio_mpeg "audio/mpeg (mp3)" \
		audio_mp4 "audio/mp4" \
		audio_wave "audio/wav" \
		audio_xwave "audio/x-wav" \
		video_gpp "video/3gpp" \
		video_mp4 "video/mp4")




header_to_real(){
	HEADER_TYPE=$1
	case $HEADER_TYPE in
	  [application_json]*) HEADER_TYPE="application\/json";;
	  [application_xml]*) HEADER_TYPE="application\/xml";;
	  [text_html]*) HEADER_TYPE="text\/html";;
	  [text_csv]*) HEADER_TYPE="text\/csv";;
	  [text_plain]*) HEADER_TYPE="text\/plain";;
	  [image]*) HEADER_TYPE="image\/\*";;
	  [image_bmp]*) HEADER_TYPE="image\/bmp";;
	  [image_gif]*) HEADER_TYPE="image\/gif";;
	  [image_jpeg]*) HEADER_TYPE="image\/jpeg";;
	  [image_png]*) HEADER_TYPE="image\/png ";;
	  [audio_gpp]*) HEADER_TYPE="audio\/3gpp";;
	  [audio_midi]*) HEADER_TYPE="audio\/midi";;
	  [audio_mpeg]*) HEADER_TYPE="audio\/mpeg";;
	  [audio_mp4]*) HEADER_TYPE="audio\/mp4";;
	  [audio_wave]*) HEADER_TYPE="audio\/wav";;
	  [audio_xwave]*) HEADER_TYPE="audio\/x-wav";;
	  [video_gpp]*) HEADER_TYPE="video\/3gpp";;
	  [video_mp4]*) HEADER_TYPE="video\/mp4";;
	esac
	echo $HEADER_TYPE
}


exec 3>&1
ACCEPT_TYPE=$(dialog \
		--clear \
		--backtitle "Marketplace API service" \
		--title "Configuration of input field $i (page 1/2)" \
		--menu "Choose an type for The Accept header:" \
		15 80 15 \
		"${HEADER_TYPE_OPTIONS[@]}" \
		2>&1 1>&3)

# close fd
exec 3>&-


exec 3>&1
CONTENT_TYPE=$(dialog \
		--clear \
		--backtitle "Marketplace API service" \
		--title "Configuration of input field $i (page 1/2)" \
		--menu "Choose an type for The Content-Type header:" \
		15 80 15 \
		"${HEADER_TYPE_OPTIONS[@]}" \
		2>&1 1>&3)
# close fd
exec 3>&-


FIELD_TYPE_OPTIONS=(string "string (this includes dates and files)." \
		 number "Any numbers." \
		 number_float "Floating-point numbers." \
		 number_double "Floating-point numbers with double precision." \
		 integer "Integer numbers." \
		 integer_int32 "Signed 32-bit integers (commonly used integer type)." \
		 integer_int64 "Signed 64-bit integers (long type)." \
		 boolean "represents two values: true and false." \
		 array "array - not supported yet" \
		 object "object - not supported yet")

REQUIRED=""
PROPERTIES=""
CURL_DATA=""

for (( i = 1; i <= $NB_INPUT_FIELDS; ++i )); do
	FIELD_KEY=""

	FIELD_DESCRIPTION=""
	FIELD_EXAMPLE=""

	FIELD_TYPE=""
	FIELD_FORMAT=""

	exec 3>&1
	VALUES=$(dialog \
			--clear \
			--ok-label "Submit" \
			--backtitle "Marketplace API service" \
			--title "Configuration of INPUT field $i (page 2/2)" \
			--form "Field $i configuration :" \
			15 80 0 \
			"FIELD_KEY:" 1 1	"$FIELD_KEY" 	1 22 80 0 \
			"FIELD_DESCRIPTION:"    2 1	"$FIELD_DESCRIPTION"  	2 22 80 0 \
			"FIELD_EXAMPLE:"    3 1	"$FIELD_EXAMPLE"  	3 22 80 0 \
			2>&1 1>&3)
	# close fd
	exec 3>&-


	exec 3>&1
	FIELD_TYPE=$(dialog \
			--clear \
			--backtitle "Marketplace API service" \
			--title "Configuration of INPUT field $i (page 1/2)" \
			--menu "Choose an type for field $i:" \
			15 80 15 \
			"${FIELD_TYPE_OPTIONS[@]}" \
			2>&1 1>&3)
	# close fd
	exec 3>&-

	FIELD_KEY=$(echo "$VALUES" | sed -n 1p)
	FIELD_DESCRIPTION=$(echo "$VALUES" | sed -n 2p)
	FIELD_EXAMPLE=$(echo "$VALUES" | sed -n 3p)

	case $FIELD_TYPE in
	  number_float) FIELD_FORMAT='"format":"float",'; FIELD_TYPE="number";;
	  number_double) FIELD_FORMAT='"format":"double",'; FIELD_TYPE="number";;
	  integer_int32) FIELD_FORMAT='"format":"int32",'; FIELD_TYPE="integer";;
	  integer_int64) FIELD_FORMAT='"format":"int64",'; FIELD_TYPE="integer";;
	  *) FIELD_FORMAT="";;
	esac

	REQUIRED="$REQUIRED\"$FIELD_KEY\","
	PROPERTIES=$PROPERTIES'"'$FIELD_KEY'":{"type":"'$FIELD_TYPE'",'$FIELD_FORMAT'"description":"'$FIELD_DESCRIPTION'","example":"'$FIELD_EXAMPLE'"},'
	CURL_DATA='"'$FIELD_KEY'":"'$FIELD_EXAMPLE'",'
done

#trim last comma
REQUIRED=$(echo $REQUIRED | sed 's/.$//')
PROPERTIES=$(echo $PROPERTIES | sed 's/.$//')
CURL_DATA=$(echo $CURL_DATA | sed 's/.$//')
CURL_DATA="{$CURL_DATA}"


SCHEMA='"Body":{"type":"object","required":['$REQUIRED'],"properties":{'$PROPERTIES'}'

sed -i '' "s!SCHEMA!$SCHEMA!g" $SWAGGER


RESPONSE_PROPERTIES=""

for (( i = 1; i <= $NB_OUTPUT_FIELDS; ++i )); do
	FIELD_KEY=""

	FIELD_DESCRIPTION=""
	FIELD_EXAMPLE=""

	FIELD_TYPE=""
	FIELD_FORMAT=""

	exec 3>&1
	VALUES=$(dialog \
			--clear \
			--ok-label "Submit" \
			--backtitle "Marketplace API service" \
			--title "Configuration of OUTPUT field $i (page 2/2)" \
			--form "Field $i configuration :" \
			15 80 0 \
			"FIELD_KEY:" 1 1	"$FIELD_KEY" 	1 22 80 0 \
			"FIELD_DESCRIPTION:"    2 1	"$FIELD_DESCRIPTION"  	2 22 80 0 \
			"FIELD_EXAMPLE:"    3 1	"$FIELD_EXAMPLE"  	3 22 80 0 \
			2>&1 1>&3)
	# close fd
	exec 3>&-

	exec 3>&1
	FIELD_TYPE=$(dialog \
			--clear \
			--backtitle "Marketplace API service" \
			--title "Configuration of OUTPUT field $i (page 1/2)" \
			--menu "Choose an type for field $i:" \
			15 80 15 \
			"${FIELD_TYPE_OPTIONS[@]}" \
			2>&1 1>&3)
	# close fd
	exec 3>&-

	FIELD_KEY=$(echo "$VALUES" | sed -n 1p)
	FIELD_DESCRIPTION=$(echo "$VALUES" | sed -n 2p)
	FIELD_EXAMPLE=$(echo "$VALUES" | sed -n 3p)

	case $FIELD_TYPE in
	  number_float) FIELD_FORMAT='"format":"float",'; FIELD_TYPE="number";;
	  number_double) FIELD_FORMAT='"format":"double",'; FIELD_TYPE="number";;
	  integer_int32) FIELD_FORMAT='"format":"int32",'; FIELD_TYPE="integer";;
	  integer_int64) FIELD_FORMAT='"format":"int64",'; FIELD_TYPE="integer";;
  	  *) FIELD_FORMAT="";;
	esac


	RESPONSE_PROPERTIES=$RESPONSE_PROPERTIES'"'$FIELD_KEY'":{"type":"'$FIELD_TYPE'",'$FIELD_FORMAT'"description":"'$FIELD_DESCRIPTION'","example":"'$FIELD_EXAMPLE'"},'	

done
#trim last comma
RESPONSE_PROPERTIES=$(echo $RESPONSE_PROPERTIES | sed 's/.$//')

sed -i '' "s!RESPONSE_PROPERTIES!$RESPONSE_PROPERTIES!g" $SWAGGER

CONTENT_TYPE=$(header_to_real $CONTENT_TYPE)
ACCEPT_TYPE=$(header_to_real $ACCEPT_TYPE)

CALL="curl -X POST \"http:\\/\\/MY_SUPER_API_IP:5000\\/$API_RESTPOINT_OPERATION\" -H \"accept: $ACCEPT_TYPE\" -H \"Content-Type: $CONTENT_TYPE\" -d '$CURL_DATA'"

sed -i '' "s!CALL!$CALL!g" $README


sed -i '' "s/REPO_NAME/$current_dir/g" $README

echo "
This API use the following Github project : 
[$REPO_NO_GIT]($REPO_NO_GIT)" > $SOURCE_CODE




dialog --backtitle "Marketplace API service" --title "Fetching license in $REPO_NO_GIT" --clear --msgbox "Next step will fetch the license in repo $REPO_NO_GIT it might take few seconds click ok to continue" 10 80


LICENSE_URL=""
if $(curl  -s --head "$REPO_NO_GIT/blob/master/LICENSE.txt" | grep "Status" | grep -q 200); then LICENSE_URL="$REPO_NO_GIT/blob/master/LICENSE.txt";fi
if $(curl  -s --head "$REPO_NO_GIT/blob/master/LICENSE" | grep "Status" | grep -q 200); then LICENSE_URL="$REPO_NO_GIT/blob/master/LICENSE";fi
	
if [[ ! LICENSE_URL = "" ]]; then
	RAW_LICENSE_URL=$(echo $LICENSE_URL | sed 's/github.com/raw.githubusercontent.com/g' | sed 's/\/blob//g')
	tmp_license_file="/tmp/license-$(openssl rand -base64 4)"
	
	wget -q -O $tmp_license_file $RAW_LICENSE_URL
	
	dialog --clear --title "license : $LICENSE_URL" --backtitle "Marketplace API service" --textbox $tmp_license_file 60 100
					
					
	

	rm $tmp_license_file
fi
	


LICENSE_OPTIONS=(None "None" \
		APACHE2 "Apache License 2.0"
		AGPL3 "GNU Affero General Public License v3.0" \
		GPL3 "GNU General Public License v3.0" \
		GPL2 "GNU General Public License v2.0" \
		MIT "MIT License" \
		BSD2 "BSD 2-Clause \"Simplified\" License" \
		BSD3 "BSD 3-Clause \"New\" or \"Revised\" License")

exec 3>&1
LICENSE_VERSION=$(dialog \
		--clear \
		--backtitle "Marketplace API service" \
		--title "Configuration of the license (page 1/2)" \
		--menu "Choose a License:" \
		15 80 15 \
		"${LICENSE_OPTIONS[@]}" \
		2>&1 1>&3)
# close fd
exec 3>&-


# open fd
exec 3>&1
LICENSE_URL=$(dialog \
		--ok-label "Submit" \
		--backtitle "Marketplace API service" \
		--title "Configuration of the license (page 2/2)" \
		--form "URL of the License" \
		15 80 0 \
		"LICENSE_URL:" 1 1	"$LICENSE_URL" 	1 22 80 0 \
		2>&1 1>&3)
# close fd
exec 3>&-

echo "
The project is under $LICENSE_VERSION License :
[$LICENSE_URL]($LICENSE_URL)
" > $LICENSE_CODE

reset
