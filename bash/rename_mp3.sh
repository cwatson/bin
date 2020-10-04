#!/bin/bash
# Simple script to rename MP3 or FLAC files by their id3 tags

printred=$(tput bold; tput setaf 1)
printgreen=$(tput bold; tput setaf 2)
printyellow=$(tput bold; tput setaf 3)
printblue=$(tput bold; tput setaf 4)
printmagenta=$(tput bold; tput setaf 5)

usage() {
    cat << !

 Rename an ${printgreen}mp3$(tput sgr0) or ${printgreen}flac$(tput sgr0) file based on id3 tags and/or the filename itself.
 The output will be formatted as ${printblue}ARTIST_-_ALBUM_-_XX_This_Is_the_Title.{mp3|flac}$(tput sgr0)
 where ${printblue}XX$(tput sgr0) is the track number.

 Uses ${printblue}id3info$(tput sgr0) and ${printblue}id3tag$(tput sgr0) for ${printgreen}mp3$(tput sgr0) and ${printblue}metaflac$(tput sgr0) for ${printgreen}flac$(tput sgr0) files.

 ${printyellow}USAGE:
     ${printgreen}$(basename $0) [-vh] -f FILENAME

 ${printyellow}OPTIONS:$(tput sgr0)
     ${printmagenta}-h$(tput sgr0)
         Show this message

     ${printmagenta}-v$(tput sgr0)
         Print what the resulting file will be renamed to but do not execute

     ${printmagenta}-f [FILENAME]$(tput sgr0)
         The filename

!
    exit
}


verbose=0
while getopts ":hvf:" OPTION; do
    case ${OPTION} in
        v) verbose=1 ;;
        f) orig="$OPTARG" ;;
        *) usage ;;
    esac
done
[[ $# -eq 0 ]] && usage

# Convert any spaces in the filename to underscores
file_ext=${orig##*.}
pattern=" |'"
if [[ ${orig} =~ ${pattern} ]]; then
    ff=$(echo ${orig} | sed 's/\s/_/g' | sed "s/'//g")
    if [[ ${verbose} -eq 0 ]]; then
        mv "${orig}" "${ff}"
        orig=${ff}
    fi
fi

# Remove spaces, single quotes, leading track numbers, and extraneous info
# Also, convert articles to lowercase if they are not at the start of the string
# Mostly use APA rules: https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
sed_args="
s/^\s//
s/\s$//
s/[0-9][0-9]\(\s\|_\)-\(\s\|_\)//
s/\(_\|\s\)And\(_\|\s\)/ and /g
s/\(_\|\s\)As\(_\|\s\)/ as /g
s/\(_\|\s\)But\(_\|\s\)/ but /g
s/\(_\|\s\)For\(_\|\s\)/ for /g
s/\(_\|\s\)If\(_\|\s\)/ if /g
s/\(_\|\s\)Nor\(_\|\s\)/ nor /g
s/\(_\|\s\)Or\(_\|\s\)/ or /g
s/\(_\|\s\)So\(_\|\s\)/ so /g
s/\(_\|\s\)Yet\(_\|\s\)/ yet /g
s/\(_\|\s\)A\(_\|\s\)/ a /g
s/\(_\|\s\)An\(_\|\s\)/ an /g
s/\(_\|\s\)The\(_\|\s\)/ the /g
s/\(_\|\s\)At\(_\|\s\)/ at /g
s/\(_\|\s\)By\(_\|\s\)/ by /g
s/\(_\|\s\)In\(_\|\s\)/ in /g
s/\(_\|\s\)Of\(_\|\s\)/ of /g
s/\(_\|\s\)To\(_\|\s\)/ to /g
s/\s/_/g
s/'//g
s/_\(\[\|(\)[Bb]onus[[:graph:]]*\(\]\|)\)//
s/_\(\[\|(\)[Jj]apan[[:graph:]]*\(\]\|)\)//
s/_\(\[\|(\)[Rr]e-issue\(\]\|)\)//
s/_\(\[\|(\)[Rr]eissue\(\]\|)\)//
s/_\(\[\|(\)[Rr]emaster\(\]\|)\)//
s/-amrc//
"

if [[ ${file_ext} == [Mm][Pp]3 ]]; then
    artist=$(id3info "${orig}" | grep -E 'TPE1|TP1' | cut -d: -f2 | sed -e "${sed_args}")
    if [[ -z ${artist} ]]; then
        echo "No artist tag present; please create one with 'id3tag -a'"
        exit 2
    fi
    album=$(id3info "${orig}" | grep -E '\<TALB\>|\<TAL\>' | cut -d: -f2 | sed -e "${sed_args}")
    if [[ -z ${album} ]]; then
        echo "No album tag present; please create one with 'id3tag -A'"
        exit 3
    fi

    #-------------------------------------------------------------------------------
    # Handle the track number
    #-------------------------------------------------------------------------------
    track=$(id3info "${orig}" | grep -E 'TRCK|TRK' | cut -d: -f2 | cut -d/ -f1 | sed 's/\s//')
    # If there is no track tag, see if it's in the filename
    if [[ -z ${track} ]]; then
        track=$(echo "${orig}" | grep -oE '\<[0-9][0-9]\>|_[0-9][0-9]_' | sed 's/_//g')
        if [[ -z ${track} ]]; then
            track=00
        else
            id3tag -t "${track}" "${orig}"
        fi
    fi

    #-------------------------------------------------------------------------------
    # Handle the track title
    #-------------------------------------------------------------------------------
    trackNumStart=".*\(\[\)\?[0-9][0-9]\(\]\)\?\(\s\|_\)\(-\)\?\(\s\|_\)\?"
    title=$(id3info "${orig}" | grep -E 'TIT2|TT2' | cut -d: -f2 | sed -e "${sed_args}")
    # Remove any leading characters, plus track numbers (possibly in brackets) separated by space or underscore
    title=$(echo "${title}" | sed "s/$trackNumStart//")

    # If there is no title, see if it's in the filename
    if [[ -z ${title} ]]; then
        tt=$(basename "${orig}" .${file_ext} | sed -n 's/[[:graph:]]*\(\[\)\?[0-9][0-9]\(\]\)\?\(\s\|_\)\(-\)\?\(\s\|_\)\?//p')
        # If the year is in the filename, then remove it first
        #TODO but what if *any* year is part of the actual track/album title?
        tt=$(echo "${tt}" | sed 's/([0-9]*)//' | sed 's/\s$//')
        if [[ -n ${tt} ]]; then
            id3tag -s "${tt}" "${orig}"
            tt=$(echo "${tt}" | sed -e "${sed_args}")
            title="${tt}"
        else
            title="TODO"
        fi
    fi

elif [[ ${file_ext} == flac ]]; then
    artist=$(metaflac --show-tag=ARTIST "${orig}" | cut -d= -f2 | sed -e "${sed_args}")
    album=$(metaflac --show-tag=ALBUM "${orig}" | cut -d= -f2 | sed -e "${sed_args}")
    track=$(metaflac --show-tag=TRACKNUMBER "${orig}" | cut -d= -f2 | sed 's/\s//')
    title=$(metaflac --show-tag=TITLE "${orig}" | cut -d= -f2 | sed -e "${sed_args}")
fi

[[ ${#track} -lt 2 ]] && printf -v track "%02d" ${track}
newname="${artist}"_-_"${album}"_-_"${track}"_"${title}".${file_ext,,}  # Make extension lowercase if necessary
if [[ ${verbose} -eq 0 ]]; then
    echo
    echo "Renaming file ${printred}${orig}$(tput sgr0) to ${printgreen}${newname}"
    echo
    mv "${orig}" "${newname}"
elif [[ ${verbose} -eq 1 ]]; then
    echo "Dry run"
    echo "Original: ${printred}${orig}$(tput sgr0)"
    echo "New name: ${printgreen}${newname}"
fi
