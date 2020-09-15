#!/bin/sh

DIRNAME=`realpath $(dirname "$0")`
source $DIRNAME/config.sh

while getopts w:p:rf: OPTNAME; do
  case "${OPTNAME}" in
    w) WATERMARK_TEXT=${OPTARG};;
    p) PASSWORD=${OPTARG};;
    r) USE_RAR=1;;
    f) FONT_SIZE=${OPTARG};;
  esac
done

if [ -z "$WATERMARK_TEXT" ]; then
  echo "You must specify the watermark text with -w"
  exit 1;
fi

if [ -z "$PASSWORD" ]; then
  echo "Generating random password, override with -p"
  PASSWORD=`openssl rand -base64 12`
fi

if [ -z "$FONT_SIZE" ]; then
  FONT_SIZE=144
fi

if [ ! -z "$OTS_KEY" ]; then
  OTS_RESULT=`curl -s -d "secret=$PASSWORD&ttl=$OTS_TTL" -u "$OTS_KEY" https://onetimesecret.com/api/v1/share`
  # OTS_RESULT='{"secret_key":"a1b2c3d4e5f6"}' # testing
  OTS_LINK=`echo $OTS_RESULT | jq -r '.secret_key'`
fi

TMP_DIR="$DIRNAME/tmp"
WATERMARK_PNG="$TMP_DIR/watermark.png"
WATERMARK_PDF="$TMP_DIR/watermark.pdf"
ARCHIVE_DIR="$TMP_DIR/$ARCHIVE_NAME"
OUT_DIR="$DIRNAME/output"
ZIP_FILE="$OUT_DIR/$ARCHIVE_NAME.zip"
RAR_FILE="$OUT_DIR/$ARCHIVE_NAME.rar"

# cleanup
rm -rf "$TMP_DIR"
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$OUT_DIR"

convert -background transparent -fill 'graya(50%,0.25)' -size 1000x$FONT_SIZE -gravity center -pointsize $FONT_SIZE -rotate -54.753 label:"$WATERMARK_TEXT" "$WATERMARK_PNG"
convert -page A4 -size 595x842 canvas:none -draw "image SrcOver 0,0 595,842 '$WATERMARK_PNG'" -gravity center "$WATERMARK_PDF"

find $DIRNAME/files/* -print0 | while read -d $'\0' FILE_SRC; do
  FILE_DST="$ARCHIVE_DIR/`basename "$FILE_SRC"`"
  if [[ $FILE_SRC == *.pdf ]]; then
    pdftk "$FILE_SRC" stamp "$WATERMARK_PDF" output "$FILE_DST"
  else
    cp -R "$FILE_SRC" "$FILE_DST"
  fi
done

if [ ! -z "$USE_RAR" ]; then
  rm -rf "$RAR_FILE"
  rar a -p$PASSWORD -k -ep -ap"$ARCHIVE_NAME" "$RAR_FILE" "$ARCHIVE_DIR"
  echo "Created archive $RAR_FILE"
else
  rm -rf "$ZIP_FILE"
  cd "$ARCHIVE_DIR" && zip --encrypt --password="$PASSWORD" -r "$ZIP_FILE" .
  echo "Created archive $ZIP_FILE"
fi

if [ ! -z "$OTS_LINK" ]; then
  echo "OTS: https://onetimesecret.com/private/$OTS_LINK"
fi
echo "Password: $PASSWORD"